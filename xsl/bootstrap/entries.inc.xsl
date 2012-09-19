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

  <xsl:template match="entry">
    <div class="alert">
      <strong>Sorry!</strong> There's an element we're unable to display: "<xsl:value-of select="@title"/>" (it is a "<xsl:value-of select="@type"/>")
    </div>
  </xsl:template>

  <xsl:template match="entry[@type= 'de.thekid.dialog.Album']">
    <div class="static-entry album">
      <h2>
        <span><i class="icon-camera"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></span>

        <span class="pull-right"><small><i class="icon-time"/><xsl:text> </xsl:text><xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(created/value), 'Y-m-d')"/></small></span>

        <xsl:apply-templates select="../../entry" mode="describe-collection"/>
      </h2>

      <xsl:apply-templates select="highlights"/>

      <blockquote><p><xsl:apply-templates select="description"/></p></blockquote>

      <p>
        <a href="{concat('/album/', @name)}" class="btn btn-primary pull-right"><i class="icon-play icon-white"/><xsl:text> </xsl:text>View full album here</a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="entry[@type= 'de.thekid.dialog.EntryCollection']" mode="describe-collection">
    <xsl:text> </xsl:text><span class="label label-info"><i class="icon-pushpin"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></span>
  </xsl:template>

  <xsl:template match="entry" mode="describe-collection">
    <!-- NOOP -->
  </xsl:template>

  <xsl:template match="entry[@type= 'de.thekid.dialog.EntryCollection']">
    <div class="static-entry entrycollection">
      <div class="hero-unit">
        <h2>
          <i class="icon-pushpin"/><xsl:text> </xsl:text><xsl:value-of select="@title"/>
          <small class="pull-right"><i class="icon-time"/><xsl:text> </xsl:text><xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(created/value), 'Y-m-d')"/></small>
        </h2>

        <p><xsl:apply-templates select="description"/></p>

        <hr/>
        <p>
          <small><i class="icon-info-sign"/> Elements part of this collection will be marked like this: 
          <xsl:apply-templates select="." mode="describe-collection"/></small>
        </p>

        <p>
          <a href="{concat('/collection/', @name)}" class="btn btn-primary pull-right"><i class="icon-play icon-white"/><xsl:text> </xsl:text>View collection here</a>
        </p>
      </div>

      <xsl:apply-templates select="entry"/>
    </div>
  </xsl:template>

  <xsl:template match="entry[@type= 'de.thekid.dialog.SingleShot']">
    <div class="static-entry singleshot">
      <h2>
        <span><i class="icon-picture"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></span>
        <small class="pull-right"><i class="icon-time"/><xsl:text> </xsl:text><xsl:value-of select="php:function('XSLCallback::invoke', 'xp.date', 'format', string(date/value), 'Y-m-d')"/></small>
        <xsl:apply-templates select="../../entry" mode="describe-collection"/>        
      </h2>

      <ul class="thumbnails">
        <li class="span6">
          <a class="thumbnail" href="{func:linkShot(@name, 0)}">
            <xsl:copy-of select="func:imageResized(concat('/shots/color.', @filename), 560, 370)"/>
          </a>
        </li>
        <li class="span6">
          <a class="thumbnail" href="{func:linkShot(@name, 1)}">
            <xsl:copy-of select="func:imageResized(concat('/shots/gray.', @filename), 560, 370)"/>
          </a>
        </li>
      </ul>

      <blockquote><p><xsl:apply-templates select="description"/></p></blockquote>

      <p><a class="btn btn-primary pull-right" href="{func:linkShot(@name, 0)}">View shots here</a></p>

    </div>
  </xsl:template>
</xsl:stylesheet>