<?xml version="1.0" encoding="UTF-8"?>
<!--This PI will not work under Oxygen unless you change the file extension to ".xml"-->
<?xml-model href="../main/sch/xslt-quality.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xslt="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
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
  
  <xsl:output omit-xml-declaration="true"/>
  
  <xsl:param name="local:param1" select="'param1'" as="xs:string"/>
  <xsl:param name="local:param2" select="'param2'" as="xs:string"/>
  
  <xsl:variable name="test" select="0" as="xs:integer"/>
  <xsl:variable name="local:var1" select="'var1'" as="xs:string"/>
  <xsl:variable name="local:var2" select="'var2'" as="xs:string"/>
  <xsl:variable name="local:var3" select="'var3'" as="xs:string"/>
  <xsl:variable name="local:var4" select="'var4'" as="xs:string"/>
  <xsl:variable name="local:var5" select="'var5'" as="xs:string" xmlns:local="local2"/>
  <xsl:variable name="local:var6" select="'var6'" as="xs:string"/>
  
  <xsl:template name="xslt:initial-template">
    <xsl:message>This is the default initial template</xsl:message>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Template using defined variables. one may write here "{$local:var3}" whitout incidence</xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <xsl:variable name="test" select="$test + 1" as="xs:integer"/>
    <xsl:value-of select="$test"/>
    <xsl:variable name="foo" select="'bar'" as="xs:string"/>
    <xsl:text expand-text="1">{concat('var1=', $local:var1)}; {concat('param1=', $local:param1)}&#10;</xsl:text>
    <xsl:text expand-text="0">{concat('var2=', $local:var2)}&#10;</xsl:text>
    <?pi {$local:var2} needs to be within an expand-text=true element?>
    <xsl:text expand-text="yes">concat('var3=', $local:var3)&#10;</xsl:text>
    <xsl:message expand-text="true">Missing surrounding curly braces, should be : <!--{concat('var3=', $local:var3)} this comment should not be taken into account--></xsl:message>
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
    <xsl:text>&#10;expand-text is true here by inheritance {concat('foo=', local:capFirstThenLowerCase($foo, ''))}</xsl:text>
    <xsl:value-of select="concat('foo=', local:capFirstThenLowerCase($foo, ''))"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>A function to capitalize the first letter and force the others to be lower-case</xd:desc>
    <xd:param name="s">The string</xd:param>
    <xd:param name="unusedParam">A param which is not used</xd:param>
  </xd:doc>
  <xsl:function name="local:capFirstThenLowerCase" as="xs:string">
    <xsl:param name="s" as="xs:string"/>
    <xsl:param name="unusedParam" as="xs:string"/>
    <xsl:value-of select="concat(upper-case(substring($s,1,1)), lower-case(substring($s,2))) "/>
  </xsl:function>
  
  <!--<xsl:template match="/" priority="1">
    <xsl:text>TEST</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="*/xsl:function" mode="test"/>
  </xsl:template>-->
  
  <!--<xsl:template match="text()" mode="test"/>-->
  
  <!--<xsl:template match="xsl:function[@name = 'local:capFirstThenLowerCase']" mode="test">
    <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
    <xsl:text>VARIABLE REF</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <!-\-<xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes(.)">
      <xsl:value-of select="concat('\$(', $NCNAME.reg, ':?', $NCNAME.reg, ')')"/>
      <xsl:analyze-string select="." regex="{concat('\$(', $NCNAME.reg, ':?', $NCNAME.reg, ')')}">
        <xsl:matching-substring>
          <xsl:value-of select="."/>
        </xsl:matching-substring>
      </xsl:analyze-string>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>-\->
    <xsl:for-each select="xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix(.)">
      <xsl:value-of select="."/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>FUNCTIONS CALL</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="xslq:get-xslt-xpath-function-call-with-expanded-prefix(/xsl:stylesheet)">
      <xsl:value-of select="."/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>-->

</xsl:stylesheet>