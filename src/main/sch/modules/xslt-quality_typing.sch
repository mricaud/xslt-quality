<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
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
    <report id="xslt-quality_typing-with-as-attribute"
      test="$xslt.version = ('2.0', '3.0') and not(@as)"
      sqf:fix="sqf_add-empty-as-attribute sqf_add-xsString-as-attribute">
      <name/> is not typed
    </report>
  </rule>
  
  <sqf:fixes>
    <sqf:fix id="sqf_add-empty-as-attribute">
      <sqf:description>
        <sqf:title xml:lang="en">Add "as" attribute</sqf:title>
        <!--<sqf:title xml:lang="fr">Ajouter un attribut "as"</sqf:title>-->
      </sqf:description>
      <sqf:user-entry name="type">
        <sqf:description>
          <sqf:title>Enter a type for "as" attribute:</sqf:title>
        </sqf:description>
      </sqf:user-entry>
      <sqf:add match="." target="as" node-type="attribute">
        <value-of select="$type"/>
      </sqf:add>
    </sqf:fix>
    <sqf:fix id="sqf_add-xsString-as-attribute">
      <sqf:description>
        <sqf:title xml:lang="en">Add "as" attribute with value "xs:string"</sqf:title>
        <!--<sqf:title xml:lang="fr">Ajouter un attribut "as"</sqf:title>-->
      </sqf:description>
      <sqf:add match="." target="as" node-type="attribute">xs:string</sqf:add>
    </sqf:fix>
  </sqf:fixes>
  
</pattern>