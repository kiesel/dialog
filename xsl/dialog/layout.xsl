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
  <xsl:include href="links.inc.xsl"/>
  <xsl:include href="opengraph.inc.xsl"/>
  
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
      	<link rel="alternate" type="application/rss+xml" title="RSS - {/formresult/config/title}" href="/rss/"/>
        <xsl:call-template name="page-head"/>
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
        <script type="text/javascript"><![CDATA[
          function handleKey(event) {
            if (event.ctrlKey || event.altKey || event.shiftKey) return false;

            switch (event.keyCode) {
              case 37:  // Left arrow
                if (
                  (element= document.getElementById('previous')) &&
                  (element.href)
                ) {
                  document.location.href= element.href;
                  return false;
                }
                break;
              
              case 39:  // Right arrow
                if (
                  (element= document.getElementById('next')) &&
                  (element.href)
                ) {
                  document.location.href= element.href;
                  return false;
                }
                break;
              
            }
            
            return true;
          }
        ]]></script>
      </head>
      <body onKeyUp="handleKey(event)">
        <!-- main content -->
        <div id="screen">
          <header>
            <xsl:call-template name="gutter"/>
            <ul>
              <li><a id="active" href="{func:linkPage(0)}">Home</a></li>
              <li><a href="{func:link('bydate')}">By Date</a></li>
              <li><a href="{func:link('bytopic')}">By Topic</a></li>
            </ul>
          </header>
          <div class="content">
            <xsl:call-template name="content"/>
          </div>
          
          <!-- footer -->
          <footer>
            <span>&#169; <xsl:value-of select="/formresult/config/copyright"/></span>
            <ul>
              <xsl:for-each select="/formresult/links/link">
                <li>
                  <a href="{@href}">
                    <img border="0" src="/image/{@id}.png" hspace="1" width="80" height="15" alt="{@id}"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="gutter">
    <xsl:param name="current" select="0"/>
    <xsl:param name="max" select="/formresult/config/gutters"/>
    
    <xsl:if test="$current &lt; $max">
      <div class="gutter" id="gutter{$current+ 1}">&#160;</div>
      <xsl:call-template name="gutter">
        <xsl:with-param name="current" select="$current+ 1"/>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
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
</xsl:stylesheet>
