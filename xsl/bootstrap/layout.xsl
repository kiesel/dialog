<?xml version="1.0" encoding="iso-8859-1"?>
<!--
 ! Layout stylesheet
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
  <xsl:include href="../master.xsl"/>
  <xsl:include href="../dialog/links.inc.xsl"/>
  <xsl:include href="../dialog/opengraph.inc.xsl"/>
  <xsl:include href="helper.inc.xsl"/>
  
  <!--
   ! Template that matches on the root node and defines the site layout
   !-->
  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html xmlns:og="http://ogp.me/ns#">
      <head>
        <title>
          <xsl:call-template name="page-title"/>
        </title>

        <link rel="stylesheet" href="/{/formresult/config/style}.css"/>
        <link rel="stylesheet" href="/bootstrap/css/bootstrap.css"/>
        <link rel="stylesheet" href="/font-awesome/css/font-awesome.css"/>

        <!-- Enable bootstrap responsive -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link href="/bootstrap/css/bootstrap-responsive.css" rel="stylesheet"/>

      	<link rel="alternate" type="application/rss+xml" title="RSS - {/formresult/config/title}" href="/rss/"/>
        <link href="/favicon.ico" rel="icon" type="image/x-icon" />

        <xsl:call-template name="page-head"/>

        <xsl:call-template name="google-analytics"/>
      </head>

      <body>
        <!-- main content -->
        <div id="screen">
          <header>
            <div class="navbar">
              <div class="navbar-inner">
                <a class="brand" href="/">
                  <xsl:value-of select="/formresult/config/title"/>
                </a>
                <ul class="nav">
                  <li class="active"><a href="{func:linkPage(0)}"><i class="icon-home"/> Home</a></li>
                  <li><a href="#"><i class="icon-time"/> By Date</a></li>
                  <li><a href="#"><i class="icon-tag"/> By Topic</a></li>
                  <li class="divider-vertical"/>
                  <li><a href="/rss/"><i class="icon-rss"/> RSS</a></li>
                  <li class="divider-vertical"/>
                  <li><a href="/about/"><i class="icon-info-sign"/> About</a></li>
                </ul>
              </div>
            </div>

            <xsl:call-template name="breadcrumb"/>
          </header>

          <div class="content container">
            <xsl:call-template name="content"/>

            <p>
              <xsl:apply-templates select="/formresult/config/copyright"/>
              <xsl:apply-templates select="/formresult/links"/>
            </p>
          </div>
          <div class="push"/>
        </div>

        <hr/>

        <script type="text/javascript" src="/js/jquery-1.8.1.min.js"></script>
        <script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="copyright">
    <small class="pull-left"><i class="icon-cloud"/><xsl:value-of select="concat(' ', .)"/></small>
  </xsl:template>

  <xsl:template match="links">
    <span class="pull-right">
      <xsl:apply-templates select="link"/>
    </span>
  </xsl:template>

  <xsl:template match="link">
    <small class="{concat('link_', @id)}">
      <i class="icon-external-link"/><xsl:text> </xsl:text>
      <a href="{@href}"><xsl:value-of select="@href"/></a>
    </small>
  </xsl:template>

  <xsl:template match="link[@id= 'dialog']">
    <a class="btn btn-mini btn-info {concat('link_', @id)}" href="{@href}">
      <i class="icon-github-sign"/> Dialog on GitHub
    </a>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="link[@id= 'xp']">
    <small>We <i class="icon-heart"/><xsl:text> </xsl:text><a href="{@href}">XP Framework!</a></small>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template name="google-analytics">
    <xsl:if test="/formresult/config/analyticscode">
      <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      try {
        var pageTracker = _gat._getTracker("<xsl:value-of select="/formresult/config/analyticscode"/>");
        pageTracker._trackPageview();
      } catch(err) {}
      </script>      
      </xsl:if>
  </xsl:template>

  <!-- Overwriteables -->
  <xsl:template name="page-title">
    <xsl:value-of select="$__state"/> - 
    <xsl:value-of select="/formresult/config/title"/>
  </xsl:template>

  <xsl:template name="page-head">
    <!-- No default implementation -->
  </xsl:template>

  <xsl:template name="breadcrumb">
    <!-- No default implementation -->
  </xsl:template>
</xsl:stylesheet>