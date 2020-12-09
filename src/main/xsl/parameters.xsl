<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:xslq="https://github.com/mricaud/xsl-quality"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">
   
   <xslq:parameters>
      <!-- We avoid checking for used global parameters, because this stylesheet exists only to be imported. -->
      <xslq:check-global-parameters-and-variables>false</xslq:check-global-parameters-and-variables>
   </xslq:parameters>
   
   <xd:doc scope="stylesheet">
      <xd:desc>This XSLT file is exclusively for users to be able to calibrate the way XSLT-quality
         assesses their stylesheets. Please note, the select attribute for each parameter is set up so that the
         default value is at the end of an if-then-else construction. This position is important, because it is
         used by Schematron Quick Fixes to populate a user's parameter with the default value.
      </xd:desc>
   </xd:doc>
   
   <xd:doc>
      <xd:desc>At what point should a template be regarded as a granular template? The integer is
         interpreted as the maximum number of elements allowed in an xsl:template before it is not
         considered granular any more.</xd:desc>
   </xd:doc>
   <xsl:param name="xslq:granular-template-threshold" as="xs:integer"
      select="
         if ($xslq:local.xslq.parameters.resolved/xslq:granular-template-threshold castable as xs:integer) then
            xs:integer($xslq:local.xslq.parameters.resolved/xslq:granular-template-threshold)
         else
            3"
   />
   
   <xd:doc>
      <xd:desc>In a given XSLT file, how many granular templates should be considered too many
         before the file becomes difficult to read?</xd:desc>
   </xd:doc>
   <xsl:param name="xslq:max-granular-templates-per-file" as="xs:integer"
      select="
         if ($xslq:local.xslq.parameters.resolved/xslq:max-granular-templates-per-file castable as xs:integer) then
            xs:integer($xslq:local.xslq.parameters.resolved/xslq:max-granular-templates-per-file)
         else
            10"
   />
   
   <xd:doc>
      <xd:desc>Should XSLT files use Oxygen documentation?</xd:desc>
   </xd:doc>
   <xsl:param name="xslq:use-oxygen-documentation" as="xs:boolean"
      select="
         if ($xslq:local.xslq.parameters.resolved/xslq:use-oxygen-documentation castable as xs:boolean) then
            xs:boolean($xslq:local.xslq.parameters.resolved/xslq:use-oxygen-documentation)
         else
            true()"
   />

   <xd:doc>
      <xd:desc>Should global parameters and variables be checked for use? If the stylesheet declares
         parameters or variables intended to be used by including/importing components, then this should 
         be set to false.</xd:desc>
   </xd:doc>
   <xsl:param name="xslq:check-global-parameters-and-variables" as="xs:boolean"
      select="
         if ($xslq:local.xslq.parameters.resolved/xslq:check-global-parameters-and-variables castable as xs:boolean) then
            xs:boolean($xslq:local.xslq.parameters.resolved/xslq:check-global-parameters-and-variables)
         else
            true()"
   />

   <xd:doc>
      <xd:desc>Should global parameters and variables, and should template modes, be allowed to inhabit
      no namespace?</xd:desc>
   </xd:doc>
   <xsl:param name="xslq:allow-no-namespace" as="xs:boolean"
      select="
         if ($xslq:local.xslq.parameters.resolved/xslq:allow-no-namespace castable as xs:boolean) then
            xs:boolean($xslq:local.xslq.parameters.resolved/xslq:allow-no-namespace)
         else
            false()"
   />
</xsl:stylesheet>