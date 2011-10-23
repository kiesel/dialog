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
  <xsl:import href="layout.xsl"/>
  
  <!--
   ! Template for page title
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="page-title">
    <xsl:choose>
      <xsl:when test="/formresult/pager/@offset &gt; 0">
        <xsl:value-of select="concat('Page #', /formresult/pager/@offset)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Home</xsl:text>       
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> @ </xsl:text>
    <xsl:value-of select="/formresult/config/title"/>
  </xsl:template>

  <!--
   ! Template for page header
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="page-head">
    <meta property="og:type" content="album" />
    <xsl:apply-templates select="/formresult/entries/entry[1]" mode="og"/>
  </xsl:template>

  <!--
   ! Template for pager
   !
   ! @purpose  Links to previous and next
   !-->
  <xsl:template name="pager">
    <nav>
      <a title="Newer entries" class="pager{/formresult/pager/@offset &gt; 0}" id="previous">
        <xsl:if test="/formresult/pager/@offset &gt; 0">
          <xsl:attribute name="href"><xsl:value-of select="func:linkPage(/formresult/pager/@offset - 1)"/></xsl:attribute>
        </xsl:if>
        <img alt="&#xab;" src="/image/prev.gif" border="0" width="19" height="15"/>
      </a>
      <a title="Older entries" class="pager{(/formresult/pager/@offset + 1) * /formresult/pager/@perpage &lt; /formresult/pager/@total}" id="next">
        <xsl:if test="(/formresult/pager/@offset + 1) * /formresult/pager/@perpage &lt; /formresult/pager/@total">
          <xsl:attribute name="href"><xsl:value-of select="func:linkPage(/formresult/pager/@offset + 1)"/></xsl:attribute>
        </xsl:if>
        <img alt="&#xbb;" src="/image/next.gif" border="0" width="19" height="15"/>
      </a>
    </nav>
  </xsl:template>

  <xsl:template name="entry-date">
    <time>
      <xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(created/value), 'l, F dS Y')"/>
    </time>
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

      <div class="textcontainer">
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
        <p class="description">
          <xsl:apply-templates select="description"/>
        </p>
        <p>
          This album contains <xsl:value-of select="@num_images"/> images in <xsl:value-of select="@num_chapters"/> chapters -
          <a href="{func:linkAlbum(@name)}">See more</a>
        </p>
        </div>
      <div class="endsection"/>
    </section>
  </xsl:template>

  <!--
   ! Template for updates
   !
   ! @purpose  Specialized entry template
   !-->
  <xsl:template match="entry[@type = 'de.thekid.dialog.Update']">
    <section>
      <xsl:call-template name="entry-date"/>
      <h1>
        Updated: <xsl:value-of select="@title"/>
      </h1>
      <p>
        <xsl:apply-templates select="description"/>
        - <a href="{func:linkAlbum(@album)}">Go to album</a>
        <br clear="all"/>
      </p>
    </section>
  </xsl:template>

  <!--
   ! Template for single shots
   !
   ! @purpose  Specialized entry template
   !-->
  <xsl:template match="entry[@type = 'de.thekid.dialog.SingleShot']">
    <section>
      <xsl:call-template name="entry-date"/>
      <h1>
        Featured image: <xsl:value-of select="@title"/>
      </h1>
      <p>
        <xsl:apply-templates select="description"/>
      </p>
      <div>
        <div class="display" style="background-image: url(/shots/detail.{@filename}); width: 619px; height: 347px">
          <div class="opaqueborder"/>
        </div>
        <a href="{func:linkShot(@name, 0)}">
          <img class="singleshot_thumb" border="0" src="/shots/thumb.color.{@filename}" width="150" height="113"/>
        </a>
        <a href="{func:linkShot(@name, 1)}">
          <img class="singleshot_thumb" border="0" src="/shots/thumb.gray.{@filename}" width="150" height="113"/>
        </a>
      </div>
    </section>
  </xsl:template>

  <!--
   ! Function that draws the image strip images, max. 5 in a row
   !
   !-->
  <func:function name="func:stripimages">
    <xsl:param name="entries"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="max" select="5"/>
    
    <func:result>
      <xsl:for-each select="exsl:node-set($entries)[position() &gt;= $i and position() &lt; $i + $max]">
        <a href="{func:linkImageStrip(../../@name)}#{$i - 1 + position() - 1}">
          <img width="150" height="113" border="0" src="/albums/{../../@name}/thumb.{name}"/>
        </a>
      </xsl:for-each>
      <xsl:if test="$i &lt; count(exsl:node-set($entries))">
        <xsl:copy-of select="func:stripimages(exsl:node-set($entries), $i + $max)"/>
      </xsl:if>
    </func:result>  
  </func:function>

  <!--
   ! Template for image strips
   !
   ! @purpose  Specialized entry template
   !-->
  <xsl:template match="entry[@type = 'de.thekid.dialog.ImageStrip']">
    <section>
      <xsl:call-template name="entry-date"/>
      <h1>
        <a href="{func:linkImageStrip(@name)}">
          <xsl:value-of select="@title"/>
        </a>
      </h1>
      <p>
        <xsl:apply-templates select="description"/>
      </p>

      <h2>Images</h2>
      <div>
        <xsl:copy-of select="func:stripimages(exsl:node-set(images/image))"/>
      </div>
      <p>
        This image strip contains <xsl:value-of select="@num_images"/> images -
        <a href="{func:linkImageStrip(@name)}">See more</a>
      </p>
    </section>
  </xsl:template>

  <!--
   ! Template for collections 
   !
   ! @purpose  Specialized entry template
   !-->
  <xsl:template match="entry[@type = 'de.thekid.dialog.EntryCollection']">
    <section class="teaser entrycollection">
      <h1>
        <a href="{func:linkCollection(@name)}">
          Collection: <xsl:value-of select="@title"/>
        </a>
      </h1>
      <xsl:call-template name="entry-date"/>

      <div class="textcontainer">
        <p>
          <xsl:apply-templates select="description"/>
        </p>

        <h2>Albums</h2>
        <div>
          <xsl:for-each select="entry[@type='de.thekid.dialog.Album']">
            <div>
              <a href="{func:linkAlbum(@name)}">
                <img width="150" height="113" border="0" src="/albums/{@name}/thumb.{./highlights/highlight[1]/name}"/>
              </a>
              <h3>
                <xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(created/value), 'd M')"/>:
                <a href="{func:linkAlbum(@name)}">
                  <xsl:value-of select="@title"/>
                </a>
                (<xsl:value-of select="@num_images"/> images in <xsl:value-of select="@num_chapters"/> chapters)
              </h3>
              <p>
                <xsl:apply-templates select="description"/>
              </p>
            </div>
          </xsl:for-each>
        </div>
      </div>
    </section>
  </xsl:template>

  <!--
   ! Template for content
   !
   ! @see      ../layout.xsl
   ! @purpose  Define main content
   !-->
  <xsl:template name="content">
    <h1 id="breadcrumb">
      <a href="/">Home</a>
      <xsl:if test="/formresult/pager/@offset &gt; 0">
        &#xbb;
        <a href="{func:linkPage(/formresult/pager/@offset)}">
          Page #<xsl:value-of select="/formresult/pager/@offset"/>
        </a>
      </xsl:if>
    </h1>
    <xsl:call-template name="pager"/>

    <xsl:for-each select="/formresult/entries/entry">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    
    <br clear="all"/>
    <xsl:call-template name="pager"/>
  </xsl:template>
  
</xsl:stylesheet>
