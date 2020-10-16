<?xml version="1.0" encoding="UTF-8"?>
<!--
CHANGELOG : 
  - 2020-10-16 : Restructured to conform to ISO practices; included core XSLT module
  - 2018-05-13 : Take into account Text Value Template with XSLT 3.0 and namespaced variables and its scope
  - 2018-05-11 : #xslqual-SettingValueOfVariableIncorrectly, #xslqual-SettingValueOfParamIncorrectly : take xsl:sequence into account in addition to xsl:value-of
     + check if there is no non-empty text-node under the variable/param, which would be an reason to not use @select
  - 2018-05-11 : rule "xslqual-RedundantNamespaceDeclarations" : take into account some xsl attributes (@select, @as, @name, @mode)
  - 2018-05-11 : reviewing roles
  - 2017-11-05 : rule "xslqual-SettingValueOfParamIncorrectly" : extend rule to xsl:sequence
  - 2017-11-05 : rule "xslqual-UnusedFunction" : extends xsl xpath attributes
  - 2017-11-05 : rule "xslqual-UnusedFunction" : extends to function call in Attribute Value Template
-->
<schema 
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  queryBinding="xslt3" 
  id="checkXSLTstyle.sch"
  >
  <xsl:include href="modules/xslt-quality.xsl"/>
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="xslq" uri="https://github.com/mricaud/xsl-quality"/>
  
  <!--
      These rules are a schematron implementation of Mukul Gandhi XSL QUALITY xslt 
      at http://gandhimukul.tripod.com/xslt/xslquality.html
      Some rules have not bee reproduced :
          - xslqual-NullOutputFromStylesheet
          - xslqual-DontUseNodeSetExtension
          - xslqual-ShortNames
          - xslqual-NameStartsWithNumeric
    -->
  
  <title>XSL qualification Schematron</title>
  
  
  <let name="NCNAME.reg" value="'[\i-[:]][\c-[:]]*'"/>
  <let name="xslt.version" value="/*/@version"/>
  
  <!--====================================-->
  <!--            DIAGNOSTICS             -->
  <!--====================================-->
  
  <diagnostics>
    <diagnostic id="addType">Add @as attribute</diagnostic>
  </diagnostics>
  
  <!--====================================-->
  <!--              PHASE                 -->
  <!--====================================-->
  
  <!--<phase id="test">
    <active pattern="xslqual"/>
    <active pattern="common"/>
    <active pattern="documentation"/>
    <active pattern="typing"/>
    <active pattern="namespaces"/>
    <active pattern="writing"/>
	</phase>-->

  <include href="modules/xslt-quality.sch"/>
  <include href="modules/xslt-quality_common.sch"/>
  <include href="modules/xslt-quality_documentation.sch"/>
  <include href="modules/xslt-quality_namespaces.sch"/>
  <include href="modules/xslt-quality_typing.sch"/>
  <include href="modules/xslt-quality_writing.sch"/>
  <include href="modules/xslt-quality_xslt-3.0.sch"/>
  
</schema>