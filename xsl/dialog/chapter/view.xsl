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
    <xsl:value-of select="concat(
      'Chapter #', /formresult/chapter/@id, ' of ',
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
    <xsl:apply-templates select="/formresult/chapter" mode="og"/>
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
      <a href="{func:linkChapter(/formresult/album/@name, /formresult/chapter/@id - 1)}">
        Chapter #<xsl:value-of select="/formresult/chapter/@id"/>
      </a>
    </h2>
  </xsl:template>
  
  <!--
   ! Function that draws the images of a chapter
   !
   ! @see      ../layout.xsl
   ! @purpose  Define main content
   !-->
  <func:function name="func:chapter-images">
    <xsl:param name="album"/>
    <xsl:param name="chapter"/>
    <xsl:param name="images"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="max" select="5"/>
    
    <func:result>
      <xsl:for-each select="exsl:node-set($images)/image[position() &gt;= $i and position() &lt; $i + $max]">
        <a href="{func:linkImage($album, $chapter, 'i', $i - 2 + position())}">
          <img width="150" height="113" border="0" src="/albums/{$album}/thumb.{name}"/>
        </a>
      </xsl:for-each>
      <xsl:if test="$i &lt; count(exsl:node-set($images)/image)">
        <xsl:copy-of select="func:chapter-images($album, $chapter, exsl:node-set($images), $i + $max)"/>
      </xsl:if>
    </func:result>  
  </func:function>

  <!--
   ! Template for content
   !
   ! @see      ../layout.xsl
   ! @purpose  Define main content
   !-->
  <xsl:template name="content">
    <xsl:variable name="total" select="count(/formresult/chapter/images/image)"/>
    <xsl:variable name="oldest" select="/formresult/chapter/images/image[1]"/>

    <xsl:call-template name="pager">
      <xsl:with-param name="link-prev" select="func:linkChapter(/formresult/album/@name, /formresult/chapter/@previous)"/>
      <xsl:with-param name="link-next" select="func:linkChapter(/formresult/album/@name, /formresult/chapter/@next)"/>
    </xsl:call-template>

    <section class="teaser chapter">
      <xsl:call-template name="entry-date">
        <xsl:with-param name="date" select="$oldest/exifData/dateTime"/>
      </xsl:call-template>

      <h2>Chapter #<xsl:value-of select="/formresult/chapter/@id"/></h2>
      <div class="highlights">
        <xsl:copy-of select="func:chapter-images(
          /formresult/album/@name,
          /formresult/chapter/@id - 1,
          /formresult/chapter/images
        )"/>
      </div>

      <p class="description metadata endsection">
        This chapter contains
        <xsl:choose>
          <xsl:when test="$total = 1">1 image</xsl:when>
          <xsl:otherwise><xsl:value-of select="$total"/> images</xsl:otherwise>
        </xsl:choose>
      </p>
    </section>
  </xsl:template>
  
</xsl:stylesheet>
