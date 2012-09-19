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
  <xsl:include href="../entries.inc.xsl"/>
  <xsl:include href="../breadcrumb.inc.xsl"/>

  <xsl:template name="page-title">
    <xsl:value-of select="concat(
      /formresult/collection/@title,
      ' @ ', /formresult/config/title
    )"/>
  </xsl:template>

  <xsl:template name="content">
    <xsl:apply-templates select="/formresult/collection"/>
  </xsl:template>

  <xsl:template match="collection">
    <div class="static-entry entrycollection">
      <div class="hero-unit">
        <h2>
          <i class="icon-pushpin"/><xsl:text> </xsl:text><xsl:value-of select="@title"/>
          <small class="pull-right"><i class="icon-time"/><xsl:text> </xsl:text><xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(created/value), 'Y-m-d')"/></small>
        </h2>

        <p><xsl:apply-templates select="description"/></p>
      </div>

      <xsl:apply-templates select="../entries/entry"/>
    </div>
  </xsl:template>

  <xsl:template match="collection" mode="describe-collection">
    <xsl:text> </xsl:text><span class="label label-info"><i class="icon-pushpin"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></span>
  </xsl:template>
</xsl:stylesheet>
