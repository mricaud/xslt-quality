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
      <xd:p>This is a main XSLT file that include xslt modules : 
        without the xsl:import, xslq should raise 4 errors here, and none with it.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <conf xmlns="https://github.com/mricaud/xsl-quality"/>
  
  <xsl:import href="sample-submaster-file.xsl"/>
  
  <xsl:param name="local:master-param" select="'test'" as="xs:string"/>
  
  <xsl:variable name="local:master-var" select="'test'" as="xs:string"/>
  
  <xsl:function name="local:master-function" as="xs:boolean">
    <xsl:sequence select="true()"/>
  </xsl:function>
  
  <xsl:template name="local:master-template"/>
  
</xsl:stylesheet>