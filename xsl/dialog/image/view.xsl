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
    <xsl:if test="/formresult/config/facebook/appid != ''">
      <meta property="fb:app_id" content="{/formresult/config/facebook/appid}"/>
    </xsl:if>
    <xsl:if test="/formresult/config/facebook/admins != ''">
      <meta property="fb:admins" content="{/formresult/config/facebook/admins}"/>
    </xsl:if>
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
    <div id="fb-root"></div>
    <script>(function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));</script>

    <nav class="pager">
      <a id="previous" class="pager previous pager{/formresult/selected/prev != ''}" href="{func:linkImage(
        /formresult/album/@name,
        /formresult/selected/prev/chapter,
        /formresult/selected/prev/type,
        /formresult/selected/prev/number
      )}">
        &#8592; previous
      </a>
      <xsl:if test="/formresult/selected/next != ''">
        <a id="next" class="pager next pager1" href="{func:linkImage(
          /formresult/album/@name,
          /formresult/selected/next/chapter,
          /formresult/selected/next/type,
          /formresult/selected/next/number
        )}">
          next &#8594;
        </a>
      </xsl:if>
    </nav>

    <section class="teaser image">
    
      <!-- Selected image -->
        <a>
          <xsl:if test="/formresult/selected/next != ''">
            <xsl:attribute name="href"><xsl:value-of select="func:linkImage(
              /formresult/album/@name,
              /formresult/selected/next/chapter,
              /formresult/selected/next/type,
              /formresult/selected/next/number
            )"/></xsl:attribute>
          </xsl:if>
<!--              <div class="image" style="
                /* background: url(/albums/{/formresult/album/@name}/{/formresult/selected/name}) center top no-repeat; */
                width: 100%
                height: 100%
                left: 50%;
              ">-->
                <img
                 src="/albums/{/formresult/album/@name}/{/formresult/selected/name}"
                 class="main-image"
                 style="
                  height: {/formresult/selected/height}px
                  width: {/formresult/selected/width}px
                "/>
<!--              </div>-->
        </a>

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
      <div id="fb-container">
        <xsl:if test="/formresult/config/facebook/enable_like = 'true'">
          <div class="fb-like" data-send="false" data-width="250" data-show-faces="true" data-colorscheme="dark" data-font="segoe ui"></div>
        </xsl:if>

        <xsl:if test="/formresult/config/facebook/enable_comments = 'true'">
          <div class="fb-comments" data-href="{func:linkImage(
            /formresult/album/@name,
            /formresult/selected/@chapter,
            /formresult/selected/@type,
            /formresult/selected/@number
          )}" data-num-posts="5" data-width="500" data-colorscheme="dark"></div>
        </xsl:if>
        <div class="endsection"></div>
      </div>
    </section>
  </xsl:template>
  
</xsl:stylesheet>
