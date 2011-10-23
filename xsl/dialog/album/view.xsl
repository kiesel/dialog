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
    <xsl:apply-templates select="/formresult/album" mode="og"/>
  </xsl:template>

  <!--
   ! Template for breadcrumb
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="breadcrumb">
    <h3 id="breadcrumb">
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
    </h3>
  </xsl:template>
  
  <!--
   ! Template for content
   !
   ! @see      ../layout.xsl
   ! @purpose  Define main content
   !-->
  <xsl:template name="content">
    <section class="teaser album">
      <xsl:call-template name="entry-date">
        <xsl:with-param name="date" select="/formresult/album/created"/>
      </xsl:call-template>
      <h2>
        <xsl:value-of select="/formresult/album/@title"/>
      </h2>
      <p class="description main-description">
        <xsl:apply-templates select="/formresult/album/description"/>
      </p>

      <h4>Highlights</h4>
      <div class="highlights">
        <xsl:for-each select="/formresult/album/highlights/highlight">
          <a href="{func:linkImage(../../@name, 0, 'h', position()- 1)}">
            <img width="150" height="113" border="0" src="/albums/{../../@name}/thumb.{name}"/>
          </a>
        </xsl:for-each>
      </div>
      <p class="description metadata endsection">
        This album contains <xsl:value-of select="/formresult/album/@num_images"/> images in <xsl:value-of select="/formresult/album/@num_chapters"/> chapters.
      </p>
    </section>

    <xsl:for-each select="/formresult/album/chapters/chapter">
      <xsl:variable name="total" select="count(images/image)"/>
      <xsl:variable name="oldest" select="images/image[1]"/>
      <xsl:variable name="newest" select="images/image[$total]"/>
      <xsl:variable name="chapter" select="position() - 1"/>

      <section class="teaser chapter">
        <h2>
          <a href="{func:linkChapter(../../@name, $chapter)}">
            Chapter #<xsl:value-of select="position()"/>
          </a>
        </h2>
        <xsl:call-template name="entry-date">
          <xsl:with-param name="date" select="$oldest/exifData/dateTime"/>
        </xsl:call-template>
        <p class="description">
          This chapter contains
          <xsl:choose>
            <xsl:when test="$total = 1">1 image</xsl:when>
            <xsl:otherwise><xsl:value-of select="$total"/> images</xsl:otherwise>
          </xsl:choose>
        </p>

        <div class="highlights">
          <xsl:for-each select="images/image">
            <xsl:variable name="pos" select="position()"/>
            <a href="{func:linkImage(../../../../@name, $chapter, 'i', position()- 1)}">
              <img width="150" height="113" border="0" src="/albums/{../../../../@name}/thumb.{name}"/>
            </a>
          </xsl:for-each>
        </div>
        <div class="endsection"/>
      </section>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
