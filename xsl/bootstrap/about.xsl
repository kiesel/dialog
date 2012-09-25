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

  <xsl:template name="page-title">
    <xsl:value-of select="/formresult/config/title"/>
  </xsl:template>

  <xsl:template name="breadcrumb">
    <ul class="breadcrumb">
      <li><a href="/">Home</a><xsl:text> </xsl:text><span class="divider">/</span></li>
      <li><a href="/about/">About</a></li>
    </ul>
  </xsl:template>

  <xsl:template name="content">
    <div class="hero-unit">
      <h1><xsl:value-of select="/formresult/config/title"/><br/>
      <small>The Best Camera is the One That's With You</small></h1>
    </div>

    <h4><i class="icon-info-sign"/> about me</h4>
    <p>Being a software developer in my job, I am also a passionate photographer who takes
      photographs every now and then. This site shows a collection of photographs from the
      time I bought my first camera until today.

      I hope some progress in photographic skills
      is visible when seeking through the archives :-).
    </p>
    <hr/>

    <h4><i class="icon-info-sign"/> about the cameras</h4>
    <p>
      This is my private photographic blog which I maintain since 2004. Most of the
      pictures have been taken by one of my cameras - which have changed over the time:
      <ul>
        <li>Casio Exilim Z40 (consumer-grade camera, built-in lens)
        </li>
        <li>Konica-Minolta Dynax 7D
          <ul>
            <li>D7D kit lens 28-100mm f/3,5-5,6</li>
            <li>Minolta 70-300mm f/3,5-5,6</li>
            <li>Minolta 24mm f/2,8</li>
            <li>100mm f/3,5</li>
          </ul>
        </li>
        <li>Nikon D7000
          <ul>
            <li>Sigma 18-250mm f/3,5-5,6</li>
            <li>Nikkor 50mm f/1,8</li>
          </ul>
        </li>
      </ul>
    </p>
    <hr/>

    <h4><i class="icon-info-sign"/> about the software</h4>
    <p>
      The software used to render these photographs is called Dialog and was initially written (and still is maintained) by Timm Friebe. This website runs a modified version of his original software, keeping the main functionality.<br/>
      Web software running here include:
      <ul>
        <li><a href="http://github.com/thekid/dialog">dialog</a></li>
        <li><a href="http://github.com/xp-framework/xp-framework">XP Framework</a></li>
        <li><a href="http://bootstrap.com/">Twitter Bootstrap</a></li>
        <li><a href="http://fortawesome.github.com/Font-Awesome/">Font Awesome</a></li>
      </ul>
    </p>
  </xsl:template>
</xsl:stylesheet>