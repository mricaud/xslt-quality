<?xml version="1.0" encoding="UTF-8"?>
<!--This PI will not work under Oxygen unless you change the file extension to ".xml"-->
<?xml-model href="../main/sch/xslt-quality.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:unused="unused"
  xmlns:local="local"
  xmlns:local2="local2"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace=""
  exclude-result-prefixes="#all"
  >
  
  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <include href="../main/conf/my-xslq-conf.xml"/>
    <param name="xslqual-FunctionComplexity-maxSize">10</param>
    <pattern idref="xslt-quality_documentation" active="false"/>
    <!--<assert idref="xslqual-UnusedParameter" active="false"/>-->
    <!--<alias idref="check-namespace"/>-->
    <!--<assert idref="xslqual-RedundantNamespaceDeclarations" active="true"/>-->
    <pattern idref="xslt-quality_debug" active="true"/>
    <rule idref="xslqual-UnusedFunction" active="false"/>
    <!--<xslqual-UnusedFunction active="true/false"/>-->
  </conf>
  
  <xsl:import href="sample-lib.xsl"/>
  
  <xsl:function name="local:largeSizeFunction" as="item()*">
    <xsl:param name="s"/>
    <xsl:param name="e" as="element()*"/>
    <xsl:variable name="unused" as="xs:string">unused</xsl:variable>
    <xsl:choose>
      <xsl:when test="count($e) = 1 and local-name($e) = 'e'">
        <xsl:analyze-string select="$s" regex="\s+">
          <xsl:matching-substring>
            <xsl:value-of select="'SPACE'"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:analyze-string select="$s" regex="\s+">
          <xsl:matching-substring>
            <xsl:value-of select="'SPACE'"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  
  
  
  
  
<!--  <xsl:template match="/*">
    <xsl:variable name="foo" select="'bar'" as="xs:string"/>
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
  
  <xsl:variable name="local:var4" select="'string'" as="xs:string"/>
  
  <xsl:param name="param4">
    <xsl:sequence select="/toto"/>
  </xsl:param>
  
  <xsl:template match="/">
    <xsl:variable name="foo" select="'bar'" as="xs:string"/>
    <xsl:sequence select="$local2:var4" xmlns:local2="local"/>
    <xsl:apply-templates>
      <xsl:with-param name="foo" select="$foo" as="xs:string"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template name="main">
    <xsl:for-each select="//*:toto">
      <xsl:value-of select="toto"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="test" mode="local:test test"/>
  
  <xsl:function name="local:makeLink" as="element()*">
    <xsl:sequence select="local:makeLink()" xmlns:local="local2"/>
  </xsl:function>
  
  <xsl:function name="local2:makeLink" as="element()*">
    <xsl:for-each select="1 to 10">
      <link/>
    </xsl:for-each>
  </xsl:function>
  -->
  
  
</xsl:stylesheet>