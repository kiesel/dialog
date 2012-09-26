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
  <xsl:import href="../breadcrumb.inc.xsl"/>
  <xsl:import href="../metadata.inc.xsl"/>

  <xsl:template name="page-title">
    <xsl:value-of select="concat(
      'Image ', /formresult/selected/name,
      ' / ', /formresult/album/@title,
      ' @ ', /formresult/config/title
    )"/>
  </xsl:template>

  <xsl:template name="content">
    <ul class="pager">
      <xsl:apply-templates select="/formresult/selected/prev"/>
      <xsl:apply-templates select="/formresult/selected/next"/>
    </ul>
    <xsl:apply-templates select="/formresult/selected"/>
  </xsl:template>

  <xsl:template match="selected">
    <div class="tabbable tabs-below">
      <div class="tab-content">
        <div class="tab-pane active" id="photo">
          <div class="photo-center">
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="next">
                  <xsl:value-of select="func:linkImage(../album/@name, next/chapter, next/type, next/number)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="func:linkAlbum(../album/@name)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img src="{concat('/albums/', ../album/@name, '/', name)}" width="{width}" height="{height}" class="img-polaroid dialog-photo"/>
          </a>
          </div>
        </div>
        <div class="tab-pane" id="meta">
          <xsl:call-template name="metadata"/>
        </div>
      </div>
      <ul class="nav nav-tabs">
        <li class="active"><a href="#photo" data-toggle="tab">Photo</a></li>
        <li><a href="#meta" data-toggle="tab">Metadata</a></li>
      </ul>
    </div>
    <xsl:apply-templates select="/formresult/config/disqus"/>
  </xsl:template>

  <xsl:template match="prev">
    <li class="previous"><a href="{func:linkImage(../../album/@name, chapter, type, number)}">&#8592; Prev</a></li>
  </xsl:template>

  <xsl:template match="next">
    <li class="next"><a href="{func:linkImage(../../album/@name, chapter, type, number)}">Next &#8594;</a></li>
  </xsl:template>
</xsl:stylesheet>
