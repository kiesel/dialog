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
      'Collection: ', 
      /formresult/collection/@title, ' @ ', 
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
    <xsl:apply-templates select="/formresult/collection" mode="og"/>
  </xsl:template>
  
  <!--
   ! Template for breadcrumb
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="breadcrumb">
    <h3>
      <a href="{func:linkPage(0)}">Home</a>
      <xsl:if test="/formresult/collection/@page &gt; 0">
        &#xbb;
        <a href="{func:linkPage(/formresult/collection/@page)}">
          Page #<xsl:value-of select="/formresult/collection/@page"/>
        </a>
      </xsl:if>
      &#xbb;
      <a href="{func:linkCollection(/formresult/collection/@name)}">
        <xsl:value-of select="/formresult/collection/@title"/> Collection
      </a>
    </h3>
  </xsl:template>

  <!--
   ! Template for albums
   !
   ! @purpose  Specialized entry template
   !-->
  <xsl:template match="entry[@type = 'de.thekid.dialog.Album']">
    <section class="teaser album">
      <h1>
        <a href="{func:linkAlbum(@name)}">
          <xsl:value-of select="@title"/>
        </a>
      </h1>
      <xsl:call-template name="entry-date"/>

      <div class="teaser-hl-text">
        <div class="highlightpane">
          <h2>Highlights</h2>
          <xsl:for-each select="highlights/highlight">
            <div>
              <a href="{func:linkImage(../../@name, 0, 'h', position()- 1)}">
                <img width="150" height="113" border="0" src="/albums/{../../@name}/thumb.{name}"/>
              </a>
            </div>
          </xsl:for-each>
        </div>
        <div class="text-padded">
          <p class="description main-description">
            <xsl:apply-templates select="description"/>
          </p>
          <p>
            This album contains <xsl:value-of select="@num_images"/> images in <xsl:value-of select="@num_chapters"/> chapters -
            <a href="{func:linkAlbum(@name)}">See more</a>
          </p>
        </div>
      </div>
      <div class="endsection"/>
    </section>
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
        <xsl:with-param name="date" select="/formresult/collection/created"/>
      </xsl:call-template>
      <h2>
        <xsl:value-of select="/formresult/collection/@title"/>
      </h2>
      <p class="description main-description">
        <xsl:apply-templates select="/formresult/collection/description"/>
      </p>
    </section>

    <xsl:for-each select="/formresult/entries/entry">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    
    <br clear="all"/>
  </xsl:template>
  
</xsl:stylesheet>
