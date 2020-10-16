<?xml version="1.0" encoding="UTF-8"?>
<pattern   
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/" id="xslt-quality_xslt-3.0">
  <rule context="xsl:import[$xslt.version = '3.0']">
    <xd:doc>
      <xd:desc xml:lang="en">In XSLT 1.0 and 2.0 xsl:import must come first, even before documentation block. This has been corrected in XSLT 3.0, so you can now move these xsl:import after the documentation block which is dedicated to come firts.</xd:desc>
      <xd:desc xml:lang="fr">En XSLT 1.0 et 2.0, les xsl:import devaient venir en 1er, avant même le bloc de documentation. Cela a été corriger en XSLT 3.0, vous pouvez donc déplacer ces xsl:import après le bloc de documentation qui a vocation a être le 1er élément de votre XSLT.</xd:desc>
    </xd:doc>
    <report id="xslt-quality_xslt-3.0-import-first" 
      test="following-sibling::xd:doc[@scope = 'stylesheet']" role="info">
      [XSLT-3.0] When using XSLT 3.0 xsl:import may come after the xd:doc block
    </report>
  </rule>
</pattern>
  
