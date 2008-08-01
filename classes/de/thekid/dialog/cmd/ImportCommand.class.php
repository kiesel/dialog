<?php
/* This file is part of the XP framework
 *
 * $Id$
 */

  uses(
    'util.cmd.Command',
    'util.Date',
    'io.Folder',
    'io.File',
    'io.FileUtil',
    'io.collections.FileCollection',
    'io.collections.iterate.FilteredIOCollectionIterator',
    'io.collections.iterate.ExtensionEqualsFilter',
    'io.collections.iterate.AnyOfFilter',
    'img.filter.ConvolveFilter',
    'de.thekid.dialog.Topic',
    'de.thekid.dialog.IEntry',
    'de.thekid.dialog.AlbumImage',
    'de.thekid.dialog.io.ImageProcessor',
    'de.thekid.dialog.io.IndexCreator'
  );

  /**
   * Base class for importing entries into dialog.
   *
   * @see      xp://de.thekid.dialog.cmd.AddAlbum
   * @see      xp://de.thekid.dialog.cmd.AddSingleShot
   * @see      xp://de.thekid.dialog.cmd.AddCollection
   * @purpose  Command
   */
  abstract class ImportCommand extends Command {
    protected
      $imageFolder      = NULL,
      $shotsFolder      = NULL,
      $dataFolder       = NULL,
      $topicsFolder     = NULL;
    
    const
      HIGHLIGHTS_MAX    = 5,
      ENTRIES_PER_PAGE  = 5;
      
    protected
      $processor        = NULL,
      $topics           = array();

    /**
     * Constructor - initializes image processor.
     *
     */
    public function __construct() {
      $this->processor= $this->getProcessor();
      $this->processor->fullDimensions= array(800, 600);
      $this->processor->addFilter(new ConvolveFilter(
        new Kernel('[[-1, -1, -1], [-1, 16, -1], [-1, -1, -1]]'),
        8,
        0
      ));
    }
    
    /**
     * Return a folder object composed of a given a base and name.
     *
     * @param   io.Folder base
     * @param   string name
     * @return  io.Folder
     * @throws  io.FileNotFoundException
     */
    protected function folder(Folder $base, $name) {
      $composed= $base->getURI().$name;
      $f= new Folder($composed);
      if (!$f->exists()) throw new FileNotFoundException('Folder "'.$composed.'" does not exist');
      return $f;
    }
    
    /**
     * Set base folder (the folder the dialog software is installed at).
     *
     * @param   string base default '.'
     */
    #[@arg]
    public function setBase($base= '.') {
      with ($b= new Folder($base)); {
        $this->out->writeLine('---> Using base folder ', $b);
        $this->imageFolder= $this->folder($b, 'doc_root/albums');
        $this->shotsFolder= $this->folder($b, 'doc_root/shots');
        $this->dataFolder= $this->folder($b, 'data');
        $this->topicsFolder= $this->folder($b, 'data/topics');
      }
    }
    
    /**
     * Returns processor
     *
     * @return  de.thekid.dialog.io.ImageProcessor
     */
    protected function getProcessor() {
      return new ImageProcessor();
    }

    /**
     * Normalize name to create a URL-friendly representation
     *
     * @param   string name
     * @return  string normalized
     */
    protected function normalizeName($name) {
      return preg_replace('/[^a-z0-9-]/', '_', strtolower($name));
    }

    /**
     * Process meta data
     *
     * @param   de.thekid.dialog.AlbumImage image
     * @param   de.thekid.dialog.IEntry origin
     */
    protected function processMetaData(AlbumImage $image, IEntry $origin) {
    
      // Ensure image date is always present, fall back to origin's date
      // if necessary
      if (!$image->exifData->dateTime) {
        $image->exifData->dateTime= $origin->getDate();
      }

      // Extract topics form IPTC keywords if available
      if (!($iptc= $image->getIptcData())) return;
      
      foreach ($iptc->getKeywords() as $keyword) {
        $normalized= $this->normalizeName($keyword);
        if (!isset($this->topics[$normalized])) {
          $topic= new File($this->dataFolder, 'topics/'.$normalized.'.dat');
          if ($topic->exists()) {
            $this->topics[$normalized]= unserialize(FileUtil::getContents($topic));
            $this->out->writeLine('     >> Found existing topic for ', $keyword);
          } else {
            $this->out->writeLine('     >> Creating new topic for ', $keyword);
            $this->topics[$normalized]= new Topic();
            $this->topics[$normalized]->setName($normalized);
            $this->topics[$normalized]->setTitle($keyword);
            $this->topics[$normalized]->setCreatedAt($origin->getDate());
          }
        }
        $this->topics[$normalized]->addImage($image, $origin->getName());
      }
    }
    
    /**
     * Import
     *
     */
    protected abstract function doImport();
    
    /**
     * Main runner method
     *
     */
    public function run() {
      $this->out->writeLine('===> Starting import at ', date('r'));
      $this->doImport();
      
      // Save topics
      foreach ($this->topics as $normalized => $t) {
        FileUtil::setContents(new File($this->topicsFolder, $normalized.'.dat'), serialize($t));
      }

      // Regenerate indexes
      $index= IndexCreator::forFolder($this->dataFolder);
      $index->setEntriesPerPage(self::ENTRIES_PER_PAGE);
      $index->regenerate();

      // Generate topics
      for (
        $it= new FilteredIOCollectionIterator(new FileCollection($this->topicsFolder->getURI()), new ExtensionEqualsFilter('.dat'));
        $it->hasNext();
      ) {
        $entry= basename($it->next()->getURI());
        $entries[$entry]= 'topics/'.basename($entry, '.dat');
      }
      ksort($entries);
      for ($i= 0, $s= sizeof($entries); $i < $s; $i+= self::ENTRIES_PER_PAGE) {
        FileUtil::setContents(
          new File($this->dataFolder, 'topics_'.($i / self::ENTRIES_PER_PAGE).'.idx'), 
          serialize(array(
            'total'   => $s, 
            'perpage' => self::ENTRIES_PER_PAGE,
            'entries' => array_slice($entries, $i, self::ENTRIES_PER_PAGE)
          ))
        );
      }

      $this->out->writeLine('===> Finished at ', date('r'));
    }
  }
?>
