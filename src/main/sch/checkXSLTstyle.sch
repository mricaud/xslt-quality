<?xml version="1.0" encoding="UTF-8"?>
<schema 
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  queryBinding="xslt3" 
  id="checkXSLTstyle.sch"
  >
  
  <extends href="modules/xsl-quality.sch"/>
  <extends href="modules/xsl-common.sch"/>
  
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

</schema>