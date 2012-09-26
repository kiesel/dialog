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
      'Image ', /formresult/selected/title,
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

  <xsl:template match="prev">
    <li class="previous"><a href="{func:linkShot(../name, 0)}">&#8592; Prev</a></li>
  </xsl:template>

  <xsl:template match="next">
    <li class="next"><a href="{func:linkShot(../name, 1)}">Next &#8594;</a></li>
  </xsl:template>

  <xsl:template match="selected">
    <div class="tabbable tabs-below">
      <div class="tab-content">
        <div class="tab-pane active" id="photo">
          <div class="photo-center">
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="@mode = 'color'">
                  <xsl:value-of select="func:linkShot(name, 1)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="func:linkPage(@page)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img src="{concat('/shots/', @mode, '.', fileName)}" width="{image/width}" height="{image/height}" class="img-polaroid dialog-photo"/>
          </a>

          <blockquote><p><xsl:apply-templates select="description"/></p></blockquote>
          </div>
        </div>
        <div class="tab-pane" id="meta">
          <xsl:apply-templates select="image"/>
        </div>
      </div>
      <ul class="nav nav-tabs">
        <li class="active"><a href="#photo" data-toggle="tab">Photo</a></li>
        <li><a href="#meta" data-toggle="tab">Metadata</a></li>
      </ul>
    </div>
    <xsl:apply-templates select="/formresult/config/disqus"/>
  </xsl:template>

  <xsl:template match="image">
    <xsl:call-template name="metadata"/>
  </xsl:template>
</xsl:stylesheet>
