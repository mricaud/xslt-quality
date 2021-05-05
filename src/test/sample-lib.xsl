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
      <xd:p>This is a library XSLT : unused component should not through any errors here</xd:p>
    </xd:desc>
  </xd:doc>
  
  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <param name="xslt-quality_xslt-is-a-library">1</param>
    <pattern idref="xslt-quality_debug" active="false"/>
    <pattern idref="xslt-quality_documentation" active="false"/>
  </conf>
  
  <xsl:param name="local:unused-param" select="'test'" as="xs:string"/>
  
  <xsl:variable name="local:unused-var" select="'test'" as="xs:string"/>
  
  <xsl:function name="local:unusedFunction" as="xs:boolean">
    <xsl:sequence select="true()"/>
  </xsl:function>
  
  <xsl:template name="local:unUsedTemplate"/>
  
</xsl:stylesheet>