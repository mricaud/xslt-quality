<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  xml:lang="en"
  id="xslt-quality_typing">
  
  <xd:doc>
    <xd:desc>
      <xd:p>These rules are about XSLT typing usage</xd:p>
    </xd:desc>
  </xd:doc>
  
  <rule context="xsl:variable | xsl:param  | xsl:with-param | xsl:function">
    <xd:doc>
      <xd:desc xml:lang="en">Typing your variables, parameters and function makes your XSLT much more efficient: you will be warn with inconsistency at compilation time (when writing in Oxygen). Bad type errors from your data will be detected sooner at run-time, which will make debuging much easier.</xd:desc>
      <xd:desc xml:lang="fr">Typer vos variables, paramètres et fonctions rendra votre XSLT beaucoup plus robuste : vous serez avertis à la compalation (pendant que vous codez sous Oxygen) des inconsistence éventuelles. Pendant l'exécution, les erreurs de types liées à vos données seront détectée bien plus tôt ce qui facilitera grandement le débogage.</xd:desc>
    </xd:doc>
    <report test="$xslt.version = ('2.0', '3.0') and not(@as)" diagnostics="addType" id="xslt-quality_typing-with-as-attribute">
      [typing] <name/> is not typed
    </report>
  </rule>
  
</pattern>