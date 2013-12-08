<?php
/* This class is part of the XP framework
 *
 * $Id$
 */
 
  uses(
    'scriptlet.xml.OutputDocument',
    'xml.IXSLProcessor',
    'peer.http.HttpConstants',
    'scriptlet.xml.XMLScriptletResponse'
  );
  
  /**
   * Wraps XML response
   *
   * Instead of writing directly to the client, use the addFormValue,
   * addFormResult or addFormError methods to access the resulting
   * XML document tree.
   *
   * @see      xp://scriptlet.xml.OutputDocument
   * @see      xp://scriptlet.HttpScriptletResponse  
   * @purpose  Scriptlet response wrapper
   */
  class JsondXMLScriptletResponse extends XMLScriptletResponse {
    const MUSTACHE_BUFFER = XMLScriptletResponse::XSLT_BUFFER;
    const MUSTACHE_FILE   = XMLScriptletResponse::XSLT_FILE;
    const MUSTACHE_TREE   = XMLScriptletResponse::XSLT_TREE;

    private $base = NULL;

    public function setBase($base) {
      $this->base= $base;
    }
    
    /**
     * Transforms the OutputDocument's XML and the stylesheet
     *
     * @throws  lang.IllegalStateException if no stylesheet is set
     * @throws  scriptlet.ScriptletException if the transformation fails
     * @see     xp://scriptlet.HttpScriptletResponse#process
     */
    public function process() {
      if (!$this->_processed) return FALSE;

      // Transform XML document to JSON
      $data= $this->toJson($this->document->root);
      Logger::getInstance()->getCategory()->debug($data);

      $engine= new \com\github\mustache\MustacheEngine();
      $engine->withTemplates(new \com\github\mustache\FilesIn(new Folder($this->base)));

      switch ($this->_stylesheet[0]) {
        case self::MUSTACHE_FILE: {
          $this->content= $engine->transform($this->_stylesheet[1], $data);
          break;
        }

        default: {
          throw new IllegalArgumentException('Only MUSTACHE_FILE supported ATM.');
        }
      }
      
      $this->setContentType('text/html; charset='.xp::ENCODING);
      return TRUE;
    }
    
    private function toJson(Node $node) {

      // Skip well-known attribute
      if ('__id' == $node->getName()) return NULL;
      $data= [];

      if (0 == sizeof($node->getAttributes()) && 0 == sizeof($node->getChildren())) {
        if (is_string(($ret= $node->getContent()))) {
          return $ret;
        }

        return NULL;
      }

      foreach ($node->getAttributes() as $name => $value) {
        if (!isset($data['attr'])) $data['attr']= [];
        $data['attr'][$name]= $value;
      }

      if (is_string($node->getContent())) {
        $data['data']= $node->getContent();
        return $data;
      }

      foreach ($node->getChildren() as $child) {
        $add= $this->toJson($child);
        if (NULL === $add) continue;

        $lname= $this->nameFor($child);
        if (isset($data[$lname][0])) {
          $data[$lname][]= $add;
        } else if (isset($data[$lname])) {
          $data[$lname]= array($data[$lname], $add);
        } else {
          $data[$lname]= $add;
        }
      }

      return $data;
    }

    private function nameFor(Node $node) {
      if ($node->getName() == 'attr') {
        return 'name:'.$node->getName();
      }

      return $node->getName();
    }
  }
?>
