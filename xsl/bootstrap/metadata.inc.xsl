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

  <xsl:template name="metadata">
    <table class="table table-hover">
      <caption>Photo metadata</caption>
      <tbody>
        <xsl:apply-templates select="exifData/width"/>
        <xsl:apply-templates select="exifData/model"/>
        <xsl:apply-templates select="exifData/exposureTime"/>
        <xsl:apply-templates select="exifData/apertureFNumber"/>
        <xsl:apply-templates select="exifData/focalLength"/>
        <xsl:apply-templates select="exifData/isoSpeedRatings"/>
        <xsl:apply-templates select="exifData/dateTime"/>
        <xsl:apply-templates select="iptcData/keywords"/>
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
      <td>
        <xsl:choose>
          <xsl:when test="contains(., '/')">
            <xsl:value-of select="concat(
              number(substring-before(., '/')) div number(substring-after(., '/')),
              ' mm'
            )"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/> mm
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>    

  <xsl:template match="exifData/dateTime">
    <tr>
      <td>Taken at</td>
      <td>
        <xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(value), 'Y-m-d H:i')"/>
      </td>
    </tr>
  </xsl:template>    

  <xsl:template match="iptcData/keywords[count(keyword) &gt; 0]">
    <tr>
      <td>Keywords:</td>
      <td>
        <xsl:apply-templates select="keyword"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="iptcData/keywords/keyword">
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>

</xsl:stylesheet>
