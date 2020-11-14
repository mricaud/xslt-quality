<?xml version="1.0" encoding="UTF-8"?>
<pattern   
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/" id="xslt-quality_writing">
  <rule context="xsl:attribute | xsl:namespace | xsl:variable | xsl:param | xsl:with-param">
    <xd:doc>
      <xd:desc xml:lang="en">If you don't need special XSLT instruction to calculate a variable, a param (or any other attribute, namespace) then use the short "select=" syntax that make your code less verbose and easier to read.</xd:desc>
      <xd:desc xml:lang="fr">Si vous n'avez pas besoin d'instruction XSLT spécifiques pour calculer une variable, un paramètre (ou tout autre attribut, namespace) utilisez la syntaxe rapide "select=" qui rendra votre code moins verbeux et plus facile à lire.</xd:desc>
    </xd:doc>
    <report id="xslt-quality_writing-use-select-attribute-when-possible"
      test="not(@select) and (count(* | text()[normalize-space(.)]) = 1) and (count(xsl:value-of | xsl:sequence | text()[normalize-space(.)]) = 1)">
      [writing] Use @select to assign a value to <name/>
    </report>
  </rule>
</pattern>
