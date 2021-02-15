<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  xml:lang="en"
  id="xslt-quality_debug">
  
  <xd:doc>
    <xd:desc>
      <xd:p>These rules are about XSLT documentation (based on Oxygen 'xd' namespace)</xd:p>
    </xd:desc>
  </xd:doc>
  
  <rule context="/">
    <xd:doc>
      <xd:desc xml:lang="en">Show final xslq conf</xd:desc>
      <xd:desc xml:lang="fr">Affiche la conf xslq finale</xd:desc>
    </xd:doc>
    <report id="xslt-quality_serialize-conf"
      test="true()">
      <value-of select="serialize($xslq:conf-merged)"/>
    </report>
  </rule>
  
</pattern>