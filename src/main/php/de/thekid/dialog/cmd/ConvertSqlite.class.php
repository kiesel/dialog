<?php namespace de\thekid\dialog\cmd;

use xp;
use io\File;
use io\FileUtil;
use lang\XPClass;
use de\thekid\dialog\IEntry;
use de\thekid\dialog\Album;
use de\thekid\dialog\AlbumChapter;
use de\thekid\dialog\AlbumImage;
use de\thekid\dialog\SingleShot;
use de\thekid\dialog\EntryCollection;
use de\thekid\dialog\ImageStrip;
use de\thekid\dialog\Topic;
use de\thekid\dialog\Update;
use img\util\ExifData;

class ConvertSqlite extends \util\cmd\Command {
  private $dataLocation= null;
  private $conn= null;

  private $progress = 0;

  #[@arg(name= 'data')]
  public function setDataLocation($data= 'data/') {
    $this->dataLocation= $data;
  }

  public function run() {
    $this->out->writeLine('===> Converting dialog installation to sqlite ...');
    $this->aliasClasses();
    $this->conn= new \rdbms\sqlite3\SQLite3Connection(new \rdbms\DSN('sqlite3://./'.$this->dataLocation.'dialog.sqlite3?autoconnect=1'));
    $this->conn->connect();
    $this->createSchema();

    $i= 0;
    while (true) {
      try {
        if ($i % 5 == 0) {
          $this->out->writeLine('---> Loading page #'.$i);
        }

        $page= $this->getPage($i++);
      } catch (\io\IOException $e) {
        break;
      }

      $this->out->writeLine('---> Importing page '.$i);
      $this->importPage($page);
    }
  }

  /**
   * Alias classes for unserialize() to work ...
   * 
   */
  private function aliasClasses() {
    class_alias('\\de\\thekid\dialog\\Album', 'Album');
    class_alias('\\de\\thekid\dialog\\AlbumChapter', 'AlbumChapter');
    class_alias('\\de\\thekid\dialog\\AlbumImage', 'AlbumImage');
    class_alias('\\de\\thekid\dialog\\EntryCollection', 'EntryCollection');
    class_alias('\\de\\thekid\dialog\\ImageStrip', 'ImageStrip');
    class_alias('\\de\\thekid\dialog\\SingleShot', 'SingleShot');
    class_alias('\\de\\thekid\dialog\\Topic', 'Topic');
    class_alias('\\de\\thekid\dialog\\Update', 'Update');
    class_alias('\\img\\util\\ExifData', 'ExifData');
  }

  private function createSchema() {
    $this->conn->query('create table indextype (
      type_id integer primary key,
      desc text
    )');
    $this->conn->query('create table masterindex (
      index_id integer primary key autoincrement,
      type_id integer not null,
      parent_id integer null,
      name text not null,
      created_at integer not null,

      foreign key (type_id) references indextype(type_id),
      foreign key (parent_id) references masterindex(index_id)
    )');

    $this->conn->query('create table album (
      album_id integer primary key,
      name text,
      title text,
      description text,
      created_at integer
    )');

    $this->conn->query('create table album_chapter (
      chapter_id integer primary key autoincrement,
      album_id integer,
      name text not null,

      foreign key (album_id) references album(album_id)
    )');
    $this->conn->query('create index i1 on album_chapter(album_id)');

    $this->conn->query('create table image (
      image_id integer primary key autoincrement,
      name text not null,
      width integer,
      height integer,
      exifData text,
      iptcData text      
    )');

    $this->conn->query('create table chapter_image (
      chapter_id integer,
      image_id integer,
      seq integer,
      highlight integer,

      foreign key (chapter_id) references album_chapter(chapter_id),
      foreign key (image_id) references image(image_id)
    )');
    $this->conn->query('create index i2 on chapter_image(chapter_id)');
    $this->conn->query('create index i3 on chapter_image(highlight)');

    $this->conn->query('create table singleshot (
      singleshot_id integer primary key,
      name text,
      filename text,
      title text,
      description text,
      created_at integer,
      image_id integer,

      foreign key (image_id) references image(image_id)
    )');

    $this->conn->query('create table collection (
      collection_id integer primary key,
      name text,
      title text,
      description text,
      created_at integer
    )');

    $this->conn->insert('into indextype values (1, "Album")');
    $this->conn->insert('into indextype values (2, "Singleshot")');
    $this->conn->insert('into indextype values (3, "Collection")');

    $this->repo= new \de\thekid\dialog\DialogRepository($this->conn);
  }

  private function getPage($i) {
    return unserialize(FileUtil::getContents(new File($this->dataLocation.'page_'.$i.'.idx')));
  }

  private function importPage($page) {
    foreach ($page['entries'] as $name) {
      $this->importEntry($this->getEntryFor($name));
    }

    $this->out->writeLine();
  }

  private function importEntry(IEntry $entry, $parent_id= null) {
    try {
      $method= $this->getClass()->getMethod(sprintf('import%s', $entry->getClass()->getSimpleName()));
    } catch (\lang\ElementNotFoundException $e) {
      $this->err->writeLine('!--> Skipping import of type '.$entry->getClassName());
      return;
    }

    try {
      $transaction= null;
      if (null === $parent_id) {
        $transaction= $this->repo->beginTransaction();
      }

      $method->invoke($this, [$entry, $parent_id]);

      if ($transaction instanceof \rdbms\Transaction) {
        $transaction->commit();
      }
    } catch (\lang\reflect\TargetInvocationException $e) {
      if ($transaction instanceof \rdbms\Transaction) {
        $transaction->rollback();
      }
      throw $e->getCause();
    }
  }

  public function importAlbum(Album $album, $parent_id= null) {
    $this->out->writeLine('---> Importing album '.$album->getTitle());
    $this->repo->createAlbum($album, $parent_id);

    foreach ($album->chapters as $chapter) {
      $this->importAlbumChapter($album, $chapter);
    }
  }

  public function importAlbumChapter(Album $album, AlbumChapter $chapter) {
    $this->out->write(' --> Processing chapter '.$chapter->getName());
    $this->repo->createChapter($album, $chapter);

    $seq= 0;
    foreach ($chapter->images as $image) {
      $this->showProgress();
      $this->repo->createAlbumImage($chapter, $image, $seq++, false);
    }
    $this->showEndProgress();
  }

  public function importSingleShot(SingleShot $singleshot, $parent_id= null) {
    $this->out->writeLine('---> Importing singleshot '.$singleshot->getTitle());
    $this->repo->createSingleShot($singleshot, $parent_id);
  }

  public function importEntryCollection(EntryCollection $collection, $parent_id= null) {
    $this->out->writeLine('---> Importing collection '.$collection->getTitle());
    $this->repo->createCollection($collection, $parent_id);

    foreach ($collection->entries as $entry) {
      $this->importEntry($entry, $collection->getId());
    }
  }

  /**
   * Returns entry for a specified name
   *
   */
  public function getEntryFor($name) {
    return $this->_getEntryFor($name, XPClass::forName('de.thekid.dialog.IEntry'));
  }

  /**
   * Helper method
   *
   * @param   name
   * @param   expect expected type
   * @throws  IllegalArgumentException if found entry is not of expected type
   */
  protected function _getEntryFor($name, XPClass $expect) {
    $entry= unserialize(FileUtil::getContents(new File($this->dataLocation.$name.'.dat')));

    // Check expectancy
    if (!$expect->isInstance($entry)) {
      var_dump($entry);
      throw new \lang\IllegalArgumentException(sprintf(
        'Entry of type %s found, %s expected',
        xp::typeOf($entry),
        $expect->getName() 
      ));
    }

    return $entry;
  }

  private function showProgress() {
    if ($this->progress == 0) { 
      $this->out->write('     ');
    }

    $this->out->write('.');

    $this->progress++;

    if ($this->progress > 80) {
      $this->out->writeLine();
      $this->progress= 0;
    }
  }

  private function showEndProgress() {
    if (0 != $this->progress) {
      $this->out->writeLine();
    }
    $this->progress= 0;
  }
}