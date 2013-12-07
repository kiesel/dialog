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
  <xsl:include href="highlights.inc.xsl"/>
  <xsl:include href="entries.inc.xsl"/>

  <xsl:template name="page-title">
    <xsl:value-of select="/formresult/config/title"/>
  </xsl:template>

  <xsl:template name="content">
    <xsl:apply-templates select="/formresult/pager"/>
    <xsl:apply-templates select="/formresult/entries/entry"/>
    <xsl:apply-templates select="/formresult/pager"/>    
  </xsl:template>

  <xsl:template name="breadcrumb">
    <ul class="breadcrumb">
      <li><a href="/">Home</a><xsl:text> </xsl:text><span class="divider">/</span></li>
      <li><a href="{func:linkPage(/formresult/album/@page)}">Page #<xsl:value-of select="/formresult/pager/@offset+ 1"/></a></li>
    </ul>
  </xsl:template>

  <xsl:template match="pager">
    <ul class="pagination pagination-sm pull-right">
      <li>
        <xsl:if test="@offset = 0"><xsl:attribute name="class">disabled</xsl:attribute></xsl:if>
        <a href="{func:linkPage(@offset - 1)}">&#xab;</a>
      </li>

      <xsl:call-template name="pager-page">
        <xsl:with-param name="position" select="0"/>
        <xsl:with-param name="last" select="@total div @perpage"/>
        <xsl:with-param name="current" select="@offset"/>
      </xsl:call-template>

      <li>
        <xsl:if test="@total div @perpage &lt; @offset + 1"><xsl:attribute name="class">disabled</xsl:attribute></xsl:if>
        <a href="{func:linkPage(@offset + 1)}">&#xbb;</a>
      </li>
    </ul>
  </xsl:template>

  <xsl:template name="pager-page">
    <xsl:param name="position"/>
    <xsl:param name="last"/>
    <xsl:param name="current"/>
    <xsl:param name="count" select="0"/>

    <xsl:choose>
      <xsl:when test="$last &lt; $position">
        <!-- NOOP -->
      </xsl:when>

      <xsl:when test="$count &gt; 5">
        <!-- NOOP -->
      </xsl:when>

      <xsl:when test="$current - $position &gt; 2">

        <!-- Just proceed to next loop -->
        <xsl:call-template name="pager-page">
          <xsl:with-param name="position" select="$position+ 1"/>
          <xsl:with-param name="last" select="$last"/>
          <xsl:with-param name="current" select="$current"/>
          <xsl:with-param name="count" select="$count"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$position - $current &gt; 2">
        <!-- ??? -->
      </xsl:when>

      <xsl:otherwise>
        <li>
          <xsl:if test="$position = $current">
            <xsl:attribute name="class">active</xsl:attribute>
          </xsl:if>
          <a href="{func:linkPage($position)}"><xsl:value-of select="$position+ 1"/></a>
        </li>
        <xsl:call-template name="pager-page">
          <xsl:with-param name="position" select="$position + 1"/>
          <xsl:with-param name="last" select="$last"/>
          <xsl:with-param name="current" select="$current"/>
          <xsl:with-param name="count" select="$count + 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>