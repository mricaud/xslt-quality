<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/" 
  xml:lang="en"
  id="xslt-quality_namespaces">
  
  <xd:doc>
    <xd:desc>
      <xd:p>These rules are about namespaces usage in XSLT</xd:p>
    </xd:desc>
  </xd:doc>
  
  <rule context="xsl:template/@name | /*/xsl:variable/@name | /*/xsl:param/@name"
    id="xslt-quality_namespaces_name">
    <xd:doc>
      <xd:desc xml:lang="en">Adding a namespace prefix at your global variables and parameters will make your XSLT more portable: it will avoid name conflict with other XSLT importing yours and vice versa.</xd:desc>
      <xd:desc xml:lang="fr">Ajouter un préfixe de namespace sur vos variables et paramètres globaux rendra votre XSLT plus portable : cela évitera les conflit de nommage avec d'autres XSLT qui importerait la votre et vice versa</xd:desc>
    </xd:doc>
    <assert id="xslt-quality_ns-global-statements-need-prefix"
      test="every $name in tokenize(., '\s+') satisfies matches($name, concat('^', $NCNAME.reg, ':'))" 
      role="warning">
      <value-of select="local-name(parent::*)"/> <name/>="<value-of select="tokenize(., '\s+')[not(matches(., concat('^', $NCNAME.reg, ':')))]"/>" should be namespaces prefixed, so they don't generate conflict with imported XSLT (or when this xslt is imported)
    </assert>
  </rule>
  
  <rule context="xsl:template/@mode"
    id="xslt-quality_namespaces_mode">
    <xd:doc>
      <xd:desc xml:lang="en">Adding a namespace prefix at your template's mode will make your XSLT more portable: it will avoid name conflict with other XSLT importing yours and vice versa.</xd:desc>
      <xd:desc xml:lang="fr">Ajouter un préfixe de namespace sur vos mode de template rendra votre XSLT plus portable : cela évitera les conflit de nommage avec d'autres XSLT qui importerait la votre et vice versa</xd:desc>
    </xd:doc>
    <assert id="xslt-quality_ns-mode-statements-need-prefix"
      test="every $name in tokenize(., '\s+') satisfies matches($name, concat('^', $NCNAME.reg, ':'))"
      role="warning">
      <value-of select="local-name(parent::*)"/> @<name/> value "<value-of select="tokenize(., '\s+')[not(matches(., concat('^', $NCNAME.reg, ':')))]"/>" should be namespaces prefixed, so they don't generate conflict with imported XSLT (or when this xslt is imported)
    </assert>
  </rule>
  
  <rule context="@match | @select"
    id="xslt-quality_namespaces_xpath">
    <xd:doc>
      <xd:desc xml:lang="en">Avoid using "*:" in your xpath: it will slow your XSLT processor that will be obliged to check every local-names instead of just manipulating XML nodes.</xd:desc>
      <xd:desc xml:lang="fr">Évitez d'utiliser "*:" dans vos xpath : cela va ralentir votre processeur XSLT qui sera forcé de vérifier le nom local des balises au lieur de manipuler des nœuds XML.</xd:desc>
    </xd:doc>
    <report id="xslt-quality_ns-do-not-use-wildcard-prefix"
      test="contains(., '*:')">
      Use a namespace prefix instead of *:
    </report>
  </rule>
  
</pattern>