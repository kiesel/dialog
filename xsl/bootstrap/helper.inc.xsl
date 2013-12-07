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

  <func:function name="func:imageResized">
    <xsl:param name="path"/>
    <xsl:param name="width"/>
    <xsl:param name="height"/>

    <func:result>
      <img class="img-responsive" src="{concat('/resize/?p=', $path, '&amp;w=', $width, '&amp;h=', $height)}" alt=""/>
    </func:result>
  </func:function>

  <xsl:template match="config/disqus">
    <div id="disqus_thread"></div>
    <script type="text/javascript"><![CDATA[
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = ']]><xsl:value-of select="site_name"/><![CDATA['; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    ]]></script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
  </xsl:template>

</xsl:stylesheet>