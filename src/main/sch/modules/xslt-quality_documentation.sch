<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  id="xslt-quality_documentation">
  
  <xd:doc>
    <xd:desc>
      <xd:p>These rules are about XSLT documentation (based on Oxygen 'xd' namespace)</xd:p>
    </xd:desc>
  </xd:doc>
  
  <rule context="/xsl:stylesheet | xsl:transform">
    <xd:doc>
      <xd:desc xml:lang="en">Indicate what your XSLT is doing as a minimal documentation set. When your XSLT performs a transformation (not a library) you could also describe the data expected as input, and the data generated as output.</xd:desc>
      <xd:desc xml:lang="fr">Indiquer ce que votre XSLT fait comme documentation minimale. Si votre XSLT effectue une transformation (à l'opposé d'une librairie) vous pourriez indiquer les données attendues en entrée et celles qui seront générées en sortie.</xd:desc>
    </xd:doc>
    <assert test="not($xslq:use-oxygen-documentation) or xd:doc[@scope = 'stylesheet']" id="xslt-quality_documentation-stylesheet">
      [documentation] Please add a documentation block for the whole stylesheet: &lt;xd:doc scope="stylesheet">
    </assert>
  </rule>
  
</pattern>