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
 xmlns:str="http://exslt.org/strings"
 xmlns:php="http://php.net/xsl"
 extension-element-prefixes="func"
 exclude-result-prefixes="exsl func php"
>
  <xsl:import href="layout.xsl"/>

  <xsl:template name="breadcrumb">
    <h3>
      <a href="/">Home</a>
      &#xbb;
      <a href="/bytopic">
        By Topic
      </a>
      <xsl:if test="/formresult/pager/@offset &gt; 0">
        &#xbb;
        <a href="{func:linkPage(/formresult/pager/@offset)}">
          Page #<xsl:value-of select="/formresult/pager/@offset"/>
        </a>
      </xsl:if>
    </h3>
  </xsl:template>
  
  <!--
   ! Template for page title
   !
   ! @see       ../layout.xsl
   !-->
  <xsl:template name="page-title">
    <xsl:text>By Topic</xsl:text>       
    <xsl:text> @ </xsl:text>
    <xsl:value-of select="/formresult/config/title"/>
  </xsl:template>

  <!--
   ! Template for pager
   !
   ! @purpose  Links to previous and next
   !-->
  <xsl:template name="pager">
    <center>
      <a title="Newer entries" class="pager{/formresult/pager/@offset &gt; 0}" id="previous">
        <xsl:if test="/formresult/pager/@offset &gt; 0">
          <xsl:attribute name="href"><xsl:value-of select="func:linkByTopic(/formresult/pager/@offset - 1)"/></xsl:attribute>
        </xsl:if>
        <xsl:text>&#xab;</xsl:text>
      </a>
      <a title="Older entries" class="pager{(/formresult/pager/@offset + 1) * /formresult/pager/@perpage &lt; /formresult/pager/@total}" id="next">
        <xsl:if test="(/formresult/pager/@offset + 1) * /formresult/pager/@perpage &lt; /formresult/pager/@total">
          <xsl:attribute name="href"><xsl:value-of select="func:linkByTopic(/formresult/pager/@offset + 1)"/></xsl:attribute>
        </xsl:if>
        <xsl:text>&#xbb;</xsl:text>
      </a>
    </center>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.Album']">
    <img width="150" height="113" border="0" src="/albums/{@origin-name}/thumb.{str:encode-uri(@name, false())}"/>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.Album']" mode="full">
    <div class="viewport" style="background-image: url(/albums/{@origin-name}/{str:encode-uri(@name, false())});">
      <div class="opaqueborder"/>
    </div>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.EntryCollection']">
    <img width="150" height="113" border="0" src="/albums/{@origin-name}/thumb.{str:encode-uri(@name, false())}"/>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.EntryCollection']" mode="full">
    <div class="viewport" style="background-image: url(/albums/{@origin-name}/{str:encode-uri(@name, false())});">
      <div class="opaqueborder"/>
    </div>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.SingleShot']">
    <img width="150" height="113" border="0" src="/shots/thumb.color.{str:encode-uri(@name, false())}"/>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.SingleShot']" mode="full">
    <div class="viewport" style="background-image: url(/shots/detail.{str:encode-uri(@name, false())});">
      <div class="opaqueborder"/>
    </div>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.ImageStrip']">
    <img width="150" height="113" border="0" src="/albums/{@origin-name}/thumb.{str:encode-uri(@name, false())}"/>
  </xsl:template>

  <xsl:template match="image[@origin-class = 'de.thekid.dialog.ImageStrip']" mode="full">
    <div class="viewport" style="background-image: url(/albums/{@origin-name}/{str:encode-uri(@name, false())});">
      <div class="opaqueborder"/>
    </div>
  </xsl:template>

  <!--
   ! Template for content
   !
   ! @see      ../layout.xsl
   ! @purpose  Define main content
   !-->
  <xsl:template name="content">
    <h3>
      <a href="/">Home</a>
      &#xbb;
      <a href="{func:linkByTopic()}">
        By Topic
      </a>
      <xsl:if test="/formresult/pager/@offset &gt; 0">
        &#xbb;
        <a href="{func:linkByTopic(/formresult/pager/@offset)}">
          Page #<xsl:value-of select="/formresult/pager/@offset"/>
        </a>
      </xsl:if>
    </h3>
    <br clear="all"/>

    <xsl:call-template name="pager"/>
    
    <xsl:for-each select="/formresult/topics/topic">
      <h2><a href="{func:linkTopic(@name)}"><xsl:value-of select="@title"/></a></h2>
      <div class="highlights">
        <div style="float: left; margin-top: 1px; margin-right: 1px">
          <a href="{func:linkTopic(@name)}/{featured/image[1]/@origin-name},0">
            <xsl:apply-templates select="featured/image[1]" mode="full"/>
          </a>
        </div>
        <xsl:for-each select="featured/image[position() &gt; 1]">
          <div style="float: left">
            <a href="{func:linkTopic(../../@name)}/{@origin-name},0">
              <xsl:apply-templates select="."/>
            </a>
          </div>
        </xsl:for-each>
        <br clear="all"/>
      </div>
      <p>
        This topic contains a total of <xsl:value-of select="featured/@total"/> images -
        <a href="{func:linkTopic(@name)}">See more</a>
      </p>
      <br clear="all"/><hr/>
    </xsl:for-each>

    <xsl:call-template name="pager"/>
    <br clear="all"/>
  </xsl:template>
</xsl:stylesheet>
