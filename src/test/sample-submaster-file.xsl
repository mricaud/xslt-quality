<?xml version="1.0" encoding="UTF-8"?>
<!--This PI will not work under Oxygen unless you change the file extension to ".xml"-->
<?xml-model href="../main/sch/xslt-quality.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:local="local"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>This is sub module of master file XSLT</xd:p>
    </xd:desc>
  </xd:doc>
  
  <conf xmlns="https://github.com/mricaud/xsl-quality"/>
  
  <xsl:template match="/">
    <xsl:sequence select="$local:master-param"/>
    <xsl:sequence select="$local:master-var"/>
    <xsl:sequence select="local:master-function()"/>
    <xsl:call-template name="local:master-template"/>
  </xsl:template>
  
</xsl:stylesheet>