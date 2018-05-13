<?xml version="1.0" encoding="UTF-8"?>
<!--This PI will work in Oxygen if you change the file extension to ".xml"-->
<?xml-model href="../main/sch/checkXSLTstyle.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
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
  
  <xsl:variable name="test" select="0" as="xs:integer"/>
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
    <xsl:variable name="test" select="$test + 1" as="xs:integer"/>
    <xsl:value-of select="$test"/>
    <xsl:variable name="foo" select="'bar'" as="xs:string"/>
    <xsl:text expand-text="1">{concat('var1=', $local:var1)}&#10;</xsl:text>
    <xsl:text expand-text="0">{concat('var2=', $local:var2)}&#10;</xsl:text>
    <?pi {$local:var2} needs to be within an expand-text=true element?>
    <xsl:text expand-text="yes">concat('var3=', $local:var3)&#10;</xsl:text>
    <xsl:message expand-text="true">Missing brackets, should be : <!--{concat('var3=', $local:var3)} this comment should not be taken into account--></xsl:message>
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
  
  
  <!--<xsl:template match="/" priority="1">
    <xsl:apply-templates select="//xsl:variable"/>
  </xsl:template>-->
  
  <!--<xsl:template match="xsl:variable[@name = 'foo']">
    <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
    <xsl:variable name="var.name" select="@name"/>
    <xsl:variable name="var.local-name" select="if (contains(@name, ':')) then (substring-after(@name, ':')) else (@name)"/>
    <xsl:variable name="var.prefix" select="substring-before(@name, ':')"/>
    <xsl:variable name="var.ns" select="if (contains(@name, ':')) then (namespace-uri-for-prefix($var.prefix, .)) else ('')"/>
    $var.local-name=<xsl:value-of select="$var.local-name"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="ancestor::xsl:*[1]//text()[not(ancestor::xsl:*[1] is /*)][normalize-space(.)][ancestor-or-self::*[@expand-text[parent::xsl:*] | @xsl:expand-text][1]/@*[local-name() = 'expand-text'] = ('1', 'true', 'yes')]">
      <xsl:variable name="text" select="." as="item()"/>
      <!-\-<xsl:value-of select="name()"/>="<xsl:value-of select="."/>" : <xsl:value-of select="exists(analyze-string($att, concat('\$((', $NCNAME.reg,'):)?', $var.local-name))//fn:match[namespace-uri-for-prefix(fn:group[1], $att/parent::*) = $var.ns])"/>-\->
      <!-\-regex: <xsl:value-of select="concat('\$(.*?:)?', $var.local-name)"/><xsl:text>&#10;</xsl:text>-\->
      <xsl:variable name="analizeString" select="analyze-string($text, concat('\{.*?\$(.*?):?', $var.local-name, '.*\}'))" as="element()"/>
      <xsl:copy-of select="$analizeString"/>
      <!-\-<xsl:text>&#10;</xsl:text>-\->
      count= <xsl:value-of select="count($analizeString//fn:match[not(fn:group) or namespace-uri-for-prefix(substring-before(fn:group[1], ':'), $text/parent::*) = $var.ns])"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <!-\-<xsl:value-of select="(some $att  in ancestor::xsl:*[1]//@* satisfies 
      exists(analyze-string($att, concat('\$(', $NCNAME.reg,')?', $var.local-name))//fn:match[namespace-uri-for-prefix(fn:group[1], $att/parent::*) = $var.ns]))
      "/>-\->
  </xsl:template>-->
</xsl:stylesheet>