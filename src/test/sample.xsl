<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:efl="http://www.lefebvre-sarrut.eu/ns/efl"
  xmlns:local="local"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace=""
  exclude-result-prefixes="#all"
  >
  
  <xsl:import href="lib.xsl"/>
  
  <!--<xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>Sample XSLT to test validatation with checkXSLTstyle.sch</xd:p>
    </xd:desc>
  </xd:doc>-->
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
      <xd:p>My variables</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="/*">
    <xsl:variable name="children" as="element()*">
      <xsl:sequence select="*"/>
    </xsl:variable>
    <xsl:for-each select="*"><?sch-ignore rule-id="xsl_for-each"?>
      <xsl:message><xsl:value-of select="name()"/></xsl:message>
    </xsl:for-each>
    <xsl:for-each select="1 to 10">
      <xsl:message>OK</xsl:message>
    </xsl:for-each>
    <xsl:for-each select="$children">
      <xsl:message>OK</xsl:message>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:variable name="var1">
    <xsl:value-of select="'string'"/>
  </xsl:variable>
  
  <xsl:variable name="var2" as="xs:string">
    <xsl:value-of select="'string'"/>
  </xsl:variable>
  
  <xsl:variable name="var3" select="'string'" as="xs:string"/>
    
  <xsl:param name="var4">
    <xsl:sequence select="/toto"/>
  </xsl:param>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="main">
    <xsl:for-each select="//*:toto">
      <xsl:value-of select="toto"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:function name="local:makeLink" as="element()*">
    <xsl:for-each select="1 to 10">
      <link/>
    </xsl:for-each>
  </xsl:function>
  
</xsl:stylesheet>