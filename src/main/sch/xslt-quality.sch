<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  queryBinding="xslt3" 
  id="xslt-quality"
  >
  
  <xd:doc>
    <xd:desc>
      <xd:p>These is the main XSLT-Quality Schematron, it's aim to be applied to any XSLT to check its quality.</xd:p>
      <xd:p>This main file inlcudes modules and defines common elements</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:include href="../xsl/xslt-quality.xsl"/>
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="xslq" uri="https://github.com/mricaud/xsl-quality"/>
  <ns prefix="sqf" uri="http://www.schematron-quickfix.com/validator/process"/>
  
  <title>XSLT Quality Schematron</title>
  
  <let name="xslt.version" value="/*/@version"/>
  
  <!-- FIXME : it's not possible to have a default xpath value for xslq parameters
    <xsl:variable name="guess-xslt-is-a-library" select="count(//xsl:template[@match][(@mode, '#default')[1] = '#default']) = 0" as="xs:boolean"/>-->
  <!--<let name="xslt-is-a-library" value="xslq:get-param-value('xslt-is-a-library', $guess-xslt-is-a-library, 'xs:boolean')"/>-->
  
  <xsl:variable name="xslt-quality_xslt-is-a-library" select="xslq:get-param-value('xslt-quality_xslt-is-a-library', '0', 'xs:boolean')" as="item()?"/>
  
  <!--====================================-->
  <!--           INCLUSIONS               -->
  <!--====================================-->
  
  <include href="modules/xslt-quality_mukulgandhi-rules.sch"/>
  <include href="modules/xslt-quality_common.sch"/>
  <include href="modules/xslt-quality_documentation.sch"/>
  <include href="modules/xslt-quality_namespaces.sch"/>
  <include href="modules/xslt-quality_typing.sch"/>
  <include href="modules/xslt-quality_writing.sch"/>
  <include href="modules/xslt-quality_xslt-3.0.sch"/>
  
  <!--A debugger (see current xsltq conf for instance)-->
  <include href="modules/xslt-quality_debug.sch"/>
</schema>