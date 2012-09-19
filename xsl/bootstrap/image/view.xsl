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
    <div class="tabbable tabs-right">
      <ul class="nav nav-tabs">
        <li class="active"><a href="#photo" data-toggle="tab">Photo</a></li>
        <li><a href="#meta" data-toggle="tab">Metadata</a></li>
      </ul>
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
    </div>
    <xsl:apply-templates select="/formresult/config/disqus"/>
  </xsl:template>

  <xsl:template match="prev">
    <li class="previous"><a href="{func:linkImage(../../album/@name, chapter, type, number)}">&#8592; Prev</a></li>
  </xsl:template>

  <xsl:template match="next">
    <li class="next"><a href="{func:linkImage(../../album/@name, chapter, type, number)}">Next &#8594;</a></li>
  </xsl:template>

  <xsl:template name="metadata">
    <table class="table table-hover">
      <caption>Photo metadata</caption>
      <tbody>
        <xsl:apply-templates select="exifData/width"/>
        <xsl:apply-templates select="exifData/model"/>
        <xsl:apply-templates select="exifData/exposureTime"/>
        <xsl:apply-templates select="exifData/apertureFNumber"/>
        <xsl:apply-templates select="exifData/isoSpeedRatings"/>
        <xsl:apply-templates select="exifData/focalLength"/>
        <xsl:apply-templates select="exifData/dateTime"/>
        
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="exifData/width">
    <tr>
      <td>Dimension</td>
      <td><xsl:value-of select="concat(., ' * ', ../height, ' px')"/></td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/model">
    <tr>
      <td>Camera</td>
      <td><xsl:value-of select="concat(., ' by ', ../make)"/></td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/exposureTime">
    <tr>
      <td>Exposure time</td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/apertureFNumber">
    <tr>
      <td>Aperture</td>
      <td><xsl:value-of select="."/></td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/isoSpeedRatings">
    <tr>
      <td>ISO</td>
      <td><xsl:value-of select="."/></td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/focalLength">
    <tr>
      <td>Focal length</td>
      <td><xsl:value-of select="."/> mm</td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/dateTime">
    <tr>
      <td>Taken at</td>
      <td>
        <xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(exifData/dateCreated/value), 'Y-m-d H:i')"/>
      </td>
    </tr>
  </xsl:template>    

</xsl:stylesheet>
