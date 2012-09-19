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

  <xsl:template name="breadcrumb">
    <xsl:apply-templates select="/" mode="breadcrumb"/>
  </xsl:template>

  <xsl:template match="/" mode="breadcrumb">
    <ul class="breadcrumb">
      <li><a href="/">Home</a></li>
      <xsl:apply-templates select="/formresult/collection" mode="breadcrumb"/>
      <xsl:apply-templates select="/formresult/album" mode="breadcrumb"/>
      <xsl:apply-templates select="/formresult/selected" mode="breadcrumb"/>
    </ul>
  </xsl:template>

  <xsl:template match="@page" mode="breadcrumb">
    <li><span class="divider">/</span><a href="{func:linkPage(.)}">Page #<xsl:value-of select=". + 1"/></a></li>
  </xsl:template>

  <xsl:template match="collection" mode="breadcrumb">
    <xsl:apply-templates select="@page" mode="breadcrumb"/>    
    <li><span class="divider">/</span><a href="{func:linkCollection(@name)}">Collection <xsl:value-of select="@title"/></a></li>
  </xsl:template>

  <xsl:template match="album" mode="breadcrumb">
    <xsl:apply-templates select="@page" mode="breadcrumb"/>
    <xsl:apply-templates select="collection" mode="breadcrumb"/>
    <li><span class="divider">/</span><a href="{func:linkAlbum(/formresult/album/@name)}"><xsl:value-of select="/formresult/album/@title"/></a></li>
  </xsl:template>

  <!-- Match AlbumImages -->
  <xsl:template match="selected[@chapter != '']" mode="breadcrumb">
    <li><span class="divider">/</span><a href="#"><xsl:value-of select="name"/></a></li>
  </xsl:template>

  <!-- Match SingleShots -->
  <xsl:template match="selected[@mode != '']" mode="breadcrumb">
    <xsl:apply-templates select="@page" mode="breadcrumb"/>
    <li><span class="divider">/</span><a href="#"><xsl:value-of select="title"/></a></li>
  </xsl:template>
</xsl:stylesheet>