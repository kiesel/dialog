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
  
  <!--
   ! Template for page title
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="page-title">
    <xsl:choose>
      <xsl:when test="/formresult/selected/iptcData/title != ''">
        <xsl:value-of select="/formresult/selected/iptcData/title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('Image ', /formresult/selected/name)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="concat(
      ' / ',
      /formresult/album/@title, ' @ ', 
      /formresult/config/title
    )"/>
  </xsl:template>

  <!--
   ! Template for page header
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="page-head">
    <meta property="og:type" content="album" />
    <xsl:apply-templates select="/formresult/selected" mode="og"/>
  </xsl:template>

  <!--
   ! Template for breadcrumb
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="breadcrumb">
    <h2 id="breadcrumb">
      <a href="{func:linkPage(0)}">Home</a> &#xbb;

      <xsl:if test="/formresult/album/@page &gt; 0">
        <a href="{func:linkPage(/formresult/album/@page)}">
          Page #<xsl:value-of select="/formresult/album/@page"/>
        </a>
        &#xbb;
      </xsl:if>

      <xsl:if test="/formresult/album/collection">
        <a href="{func:linkCollection(/formresult/album/collection/@name)}">
          <xsl:value-of select="/formresult/album/collection/@title"/> Collection
        </a>
         &#xbb;
      </xsl:if>

      <a href="{func:linkAlbum(/formresult/album/@name)}">
        <xsl:value-of select="/formresult/album/@title"/>
      </a>
      &#xbb;
      <xsl:if test="/formresult/selected/@type = 'i'">
        <a href="{func:linkChapter(/formresult/album/@name, /formresult/selected/@chapter)}">
          Chapter #<xsl:value-of select="/formresult/selected/@chapter + 1"/>
        </a>
        &#xbb;
      </xsl:if>

      <xsl:choose>
        <xsl:when test="/formresult/selected/iptcData/title  != ''">
          <xsl:value-of select="/formresult/selected/iptcData/title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/formresult/selected/name"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
  </xsl:template>

  <!--
   ! Template for content
   !
   ! @see      ../../layout.xsl
   ! @purpose  Define main content
   !-->
  <xsl:template name="content">
    <xsl:call-template name="pager">
      <xsl:with-param name="link-prev" select="func:linkImage(
        /formresult/album/@name,
        /formresult/selected/prev/chapter,
        /formresult/selected/prev/type,
        /formresult/selected/prev/number
      )"/>
      <xsl:with-param name="link-next" select="func:linkImage(
        /formresult/album/@name,
        /formresult/selected/next/chapter,
        /formresult/selected/next/type,
        /formresult/selected/next/number
      )"/>
    </xsl:call-template>

    <section class="teaser image">
    
      <!-- Selected image -->
      <div class="image">
        <a>
          <xsl:if test="/formresult/selected/next != ''">
            <xsl:attribute name="href"><xsl:value-of select="func:linkImage(
              /formresult/album/@name,
              /formresult/selected/next/chapter,
              /formresult/selected/next/type,
              /formresult/selected/next/number
            )"/></xsl:attribute>
          </xsl:if>
          <img
           src="/albums/{/formresult/album/@name}/{/formresult/selected/name}"
           width="{/formresult/selected/width}"
           height="{/formresult/selected/height}"
          />
        </a>
      </div>

      <p class="description metadata">
        <xsl:variable name="exifData" select="/formresult/selected/exifData"/>
        Originally taken on <xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string($exifData/dateTime/value), 'D, d M, Y H:i')"/>
        with <xsl:value-of select="$exifData/make"/>'s
        <xsl:value-of select="$exifData/model"/>.

        (<small>
        <xsl:if test="$exifData/apertureFNumber != ''">
          <xsl:value-of select="$exifData/apertureFNumber"/>
        </xsl:if>
        <xsl:if test="$exifData/exposureTime != ''">
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$exifData/exposureTime"/> sec.
        </xsl:if>
        <xsl:if test="$exifData/isoSpeedRatings != ''">
          <xsl:text>, ISO </xsl:text>
          <xsl:value-of select="$exifData/isoSpeedRatings"/>
        </xsl:if>
        <xsl:if test="$exifData/focalLength != '0'">
          <xsl:text>, focal length: </xsl:text>
          <xsl:value-of select="$exifData/focalLength"/>
          <xsl:text> mm</xsl:text>
        </xsl:if>
        <xsl:if test="($exifData/flash mod 8) = 1">
          <xsl:text>, flash fired</xsl:text>
        </xsl:if>
        </small>)
      </p>
    </section>
  </xsl:template>
  
</xsl:stylesheet>
