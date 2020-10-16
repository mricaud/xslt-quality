<?xml version="1.0" encoding="UTF-8"?>
<pattern  
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/" id="xslt-quality_common">
  <rule context="xsl:for-each">
    <xd:doc>
      <xd:desc xml:lang="en">Using xsl:for-each on nodes may be a clue of procedural programming. XSLT is rather a rule-programming language, data-driven. You should maybe consider using xsl:apply-templates instead</xd:desc>
      <xd:desc xml:lang="fr">l'utilisation de xsl:for-each sur des nœuds peut être un indice de programmation procedural. XSLT est un langage de règles dirigé par les données. Vous devriez peut-être considéré l'utilisation de xsl:apply-templates à la place.</xd:desc>
    </xd:doc>
    <report test="ancestor::xsl:template 
      and not(starts-with(@select, '$'))
      and not(starts-with(@select, 'tokenize('))
      and not(starts-with(@select, 'distinct-values('))
      and not(starts-with(@select, 'string-to-codepoints('))
      and not(matches(@select, '\d'))" 
      role="warning" id="xslt-quality_avoid-for-each">
      [common] Should you use xsl:apply-template instead of xsl:for-each 
    </report>
  </rule>
  <rule context="xsl:template/@match | xsl:*/@select | xsl:when/@test">
    <xd:doc>
      <xd:desc xml:lang="en">Using concatenation to resolve URI is not generic (windows and linux path are not the same) - Consider unsing the on-purpose resolve-uri() function instead</xd:desc>
      <xd:desc xml:lang="fr">la concaténation de chaînes de caractère pour résoudre une URI n'est pas générique (les chemins sous Windows et Linux ne sont pas les mêmes) - Considérez plutôt l'utilisation de la fonction dédiée resolve-uri()</xd:desc>
    </xd:doc>
    <report test="contains(., 'document(concat(') or contains(., 'doc(concat(')" id="xslt-quality_use-resolve-uri-instead-of-concat">
      [common] Avoid using concat within document() or doc() function, use resolve-uri() instead (you may use static-base-uri() or base-uri())
    </report>
  </rule>
</pattern>  
