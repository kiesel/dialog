<?xml version="1.0" encoding="iso-8859-1"?>
<!--
 ! Layout stylesheet
 !
 ! $Id$
 !-->
<xsl:stylesheet
 version="1.0"
 xmlns:exsl="http://exslt.org/common"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:func="http://exslt.org/functions"
 xmlns:php="http://php.net/xsl"
 extension-element-prefixes="func"
 exclude-result-prefixes="exsl func php"
>

  <xsl:template match="highlights">
    <ul class="thumbnails">
      <xsl:apply-templates select="highlight"/>
    </ul>
  </xsl:template>

  <xsl:template match="highlight[position()= 1]">
    <li class="span6">
      <a class="thumbnail" href="{func:linkImage(../../@name, 0, 'h', position()- 1)}">
        <div class="dialog-image-crop">
          <xsl:copy-of select="func:imageResized(concat('/albums/', ../../@name, '/', name), 560, 370)"/>
        </div>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="highlight[position() &gt; 1]">
    <li class="span3">
      <a class="thumbnail" href="{func:linkImage(../../@name, 0, 'h', position()- 1)}">
        <xsl:copy-of select="func:imageResized(concat('/albums/', ../../@name, '/', name), 260, 170)"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="highlight">
    <!-- do not show more -->
  </xsl:template>
</xsl:stylesheet>