<?xml version="1.0" encoding="UTF-8"?>
<!--This PI will work in Oxygen if you change the file extension to ".xml"-->
<?xml-model href="../main/sch/checkXSLTstyle.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:local="local"
  xmlns:local2="local2"
  xmlns="local"
  xpath-default-namespace="local"
  exclude-result-prefixes="#all"
  expand-text="true"
  >
  
  <xsl:import href="sample-lib.xsl"/>  
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>This is a XSLT 3.0 sample so we can focus on schematron rules adapted to XSLT 3.0 with checkXSLTstyle.sch</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:variable name="local:var1" select="'var1'" as="xs:string"/>
  <xsl:variable name="local:var2" select="'var2'" as="xs:string"/>
  <xsl:variable name="local:var3" select="'var3'" as="xs:string"/>
  <xsl:variable name="local:var4" select="'var4'" as="xs:string"/>
  <xsl:variable name="local:var5" select="'var5'" as="xs:string" xmlns:local="local2"/>
  <xsl:variable name="local:var6" select="'var6'" as="xs:string"/>
  
  <xd:doc>
    <xd:desc>Template using defined variables. on may write her "{$local:var3}" whitout incidence</xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <xsl:variable name="foo" select="'bar'" as="xs:string"/>
    <xsl:text expand-text="1">{concat('var1=', $local:var1)}&#10;</xsl:text>
    <xsl:text expand-text="0">{concat('var2=', $local:var2)}&#10;</xsl:text>
    <?pi {$local:var2} needs to be within an expand-text=true element?>
    <xsl:text expand-text="yes">concat('var3=', $local:var3)&#10;</xsl:text>
    <xsl:message expand-text="true">Missing brackets, should be : <!--{concat('var3=', $local:var3)}--></xsl:message>
    <xsl:text xmlns:ns0="local">expand-text is true here by inheritance : {concat('var4=', $ns0:var4)}&#10;</xsl:text>
    <xsl:element name="{'div'}" expand-text="false">
      <span xsl:expand-text="true">{$local2:var5}</span>
      <span expand-text="true">{$local:var6}</span>
      <!--When @expand-text is used on an non xsl element, it should be prefixed "xsl:" or it won't have any effect-->
    </xsl:element>
    <!--This is an XSLT error to call a prefixed variable without a prefix, even if the default namespace is mapped on the variable prefix-->
    <!--<div xsl:xpath-default-namespace="local">{$var6}</div>-->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Template matching root element</xd:desc>
  </xd:doc>
  <xsl:template match="/*">
    <xsl:variable name="foo" select="'bar'" as="xs:string"/>
    <xsl:text>&#10;expand-text is true here by inheritance {concat('foo=', $foo)}</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>