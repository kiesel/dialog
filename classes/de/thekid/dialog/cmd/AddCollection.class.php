<?php
/* This file is part of the XP framework
 *
 * $Id$
 */

  uses(
    'de.thekid.dialog.cmd.ImportCommand',
    'de.thekid.dialog.GroupingStrategy',
    'de.thekid.dialog.Album',
    'de.thekid.dialog.EntryCollection'
  );

  /**
   * Adds collections to dialog
   *
   * @purpose  Command
   */
  class AddCollection extends ImportCommand {
    protected
      $origin            = NULL,
      $destination       = NULL,
      $collectionStorage = NULL,
      $collection        = NULL;

    /**
     * Set origin folder
     *
     * @param   string folder
     */
    #[@arg(position= 0)]
    public function setOrigin($folder) {
      $this->origin= new Folder($folder);
      if (!$this->origin->exists()) {
        throw new FileNotFoundException('Folder "'.$folder.'" does not exist');
      }
      
      // Normalize name
      $collectionName= $this->normalizeName($this->origin->dirname);
      $this->out->writeLine('===> Adding collection "', $collectionName, '" from ', $this->origin);
      
      // Create destination folder if not already existant
      $this->destination= new Folder(self::IMAGE_FOLDER.$collectionName);
      $this->processor->setOutputFolder($this->destination);
      
      // Check if the collection already exists
      $this->collectionStorage= new File(self::DATA_FOLDER.$collectionName.'.dat');
      if ($this->collectionStorage->exists()) {
        $this->out->writeLine('---> Found existing collection');
        $this->collection= unserialize(FileUtil::getContents($this->collectionStorage));

        // Entries will be regenated from scratch    
        $this->collection->entries= array();
     } else {
        $this->out->writeLine('---> Creating new collection');
        $this->collection= new EntryCollection();
        $this->collection->setName($collectionName);
      }
      

      // Read the introductory text from description.txt if existant
      if (is_file($df= $this->origin->getURI().'description.txt')) {
        $this->collection->setDescription(file_get_contents($df));
      }
    }
    
    /**
     * Set collection's title. If no title is given and the collection did not 
     * previously exist, uses the origin folder's directory name.
     *
     * @param   string title default NULL
     */
    #[@arg]
    public function setTitle($title= NULL) {
      if (!$title && !$this->collection->getTitle()) {
        $this->collection->setTitle($this->origin->dirname);
      } else {
        $this->collection->setTitle($title);
      }
      $this->out->writeLine('---> Title "', $this->collection->getTitle(), '"');
    }

    /**
     * Set collection's creation date. If no date is given and the collection did not 
     * previously exist, uses the origin folder's creation date.
     *
     * @param   string date default NULL
     */
    #[@arg]
    public function setCreatedAt($date= NULL) {
      if (!$date && !$this->collection->getCreatedAt()) {
        $this->collection->setCreatedAt(new Date($this->origin->createdAt()));
      } else {
        $this->collection->setCreatedAt(new Date($date));
      }
      $this->out->writeLine('---> Created ', $this->collection->getCreatedAt());
    }
    
    /**
     * Import
     *
     */
    protected function doImport() {
      $jpegs= new ExtensionEqualsFilter('.jpg');
      $this->topics= array();
      $this->groupingStrategy= GroupingStrategy::$HOURS;

      // Create destination directory if not existant
      $this->destination->exists() || $this->destination->create(0755);

      // Iterate on collection's origin folder
      while ($entry= $this->origin->getEntry()) {
        $qualified= $this->origin->getURI().$entry.DIRECTORY_SEPARATOR;
        if (!is_dir($qualified)) continue;
        
        // Create album
        $albumName= $this->normalizeName($entry);
        $this->out->writeLine('     >> Creating album "', $entry, '" (name= "', $albumName, '")');

        $album= $collection->addEntry(new Album());
        $album->setName($this->collection->getName().'/'.$albumName);

        // Read the title title.txt if existant, use the directory name otherwise
        if (is_file($tf= $qualified.TITLE_FILE)) {
          $album->setTitle(file_get_contents($tf));
        } else {
          $album->setTitle($entry);
        }

        // Read the introductory text from description.txt if existant
        if (is_file($df= $qualified.DESCRIPTION_FILE)) {
          $album->setDescription(file_get_contents($df));
        }

        // Create destination directory if not existant
        // Point processor at new destination
        $albumDestination= new Folder($destination->getURI().$albumname);
        $albumDestination->exists() || $albumDestination->create(0755);
        $this->processor->setOutputFolder($albumDestination);

        // Get highlights
        $highlights= new Folder($qualified.'highlights');
        if ($highlights->exists()) {
          for (
            $it= new FilteredIOCollectionIterator(new FileCollection($highlights->getURI()), $jpegs);
            $it->hasNext();
          ) {
            $highlight= $this->processor->albumImageFor($it->next()->getURI());
            $this->processMetaData($highlight, $album);

            $album->addHighlight($highlight);
            $this->out->writeLine('     >> Added highlight ', $highlight->getName(), ' to album ', $albumName);
          }
          $needsHighlights= self::HIGHLIGHTS_MAX - $album->numHighlights();
        }

        // Process all images
        for (
          $images= array(),
          $it= new FilteredIOCollectionIterator(new FileCollection($qualified), $jpegs);
          $it->hasNext();
        ) {
          $image= $this->processor->albumImageFor($it->next()->getURI());
          $this->processMetaData($image, $album);

          $images[]= $image;
          $this->out->writeLine('     >> Added image ', $image->getName(), ' to album ', $albumName);

          // Check if more highlights are needed
          if ($needsHighlights <= 0) continue;

          $this->out->writeLine('     >> Need ', $needsHighlights, ' more highlight(s) for album ', $albumName, ', using above image');
          $album->addHighlight($image);
          $needsHighlights--;
        }

        // Sort images by their creation date (from EXIF data)
        usort($images, create_function(
          '$a, $b', 
          'return $b->exifData->dateTime->compareTo($a->exifData->dateTime);'
        ));

        // Group images by strategy
        for ($i= 0, $chapter= array(), $s= sizeof($images); $i < $s; $i++) {
          $key= $this->groupingStrategy->groupFor($images[$i]);
          if (!isset($chapter[$key])) {
            $chapter[$key]= $album->addChapter(new AlbumChapter($key));
          }

          $chapter[$key]->addImage($images[$i]);
        }

        // Save album
        $base= dirname($this->destination->getURI()).DIRECTORY_SEPARATOR.$album->getName();
        FileUtil::setContents(new File($base.'.dat'), serialize($album));
        FileUtil::setContents(new File($base.'.idx'), serialize($this->collection->getName()));
      }
    
      // Save collection
      FileUtil::setContents($this->collectionStorage, serialize($this->collection));
    }
  }
?>
