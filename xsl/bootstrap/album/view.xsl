<?xml version="1.0" encoding="iso-8859-1"?>
<!--
 ! Stylesheet for home page
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

  <xsl:import href="../layout.xsl"/>
  <xsl:include href="../highlights.inc.xsl"/>
  <xsl:include href="../breadcrumb.inc.xsl"/>

  <xsl:template name="page-title">
    <xsl:value-of select="concat(
      /formresult/album/@title,
      ' @ ', /formresult/config/title
    )"/>
  </xsl:template>

  <xsl:template name="content">
    <xsl:apply-templates select="/formresult/album"/>
  </xsl:template>

  <xsl:template match="album">
    <h2>
      <span><i class="icon-camera"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></span>
      <span class="pull-right"><small><i class="icon-time"/><xsl:text> </xsl:text><xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(created/value), 'Y-m-d')"/></small></span>
    </h2>

    <xsl:apply-templates select="highlights"/>
    <xsl:apply-templates select="description"/>
    <xsl:apply-templates select="chapters"/>
  </xsl:template>

  <xsl:template match="description">
    <blockquote><p><xsl:apply-templates/></p></blockquote>
  </xsl:template>

  <xsl:template match="chapters">
    <xsl:apply-templates select="chapter"/>
  </xsl:template>

  <xsl:template match="chapter">
    <div>
      <h4><xsl:value-of select="concat('Chapter #', position())"/></h4>
      <xsl:apply-templates select="images">
        <xsl:with-param name="chapter" select="position()- 1"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="images">
    <xsl:param name="chapter"/>

    <div class="row">
      <xsl:apply-templates select="image">
        <xsl:with-param name="chapter" select="$chapter"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="image">
    <xsl:param name="chapter"/>

    <div class="col-md-3">
      <a href="{func:linkImage(../../../../@name, $chapter, 'i', position()- 1)}" class="thumbnail" rel="tooltip" title="Click thumbnail to view album">
        <xsl:copy-of select="func:imageResized(concat('/albums/', ../../../../@name, '/', name), 260, 170)"/>
      </a>
    </div>
  </xsl:template>

</xsl:stylesheet>
