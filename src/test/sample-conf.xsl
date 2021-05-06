<?xml version="1.0" encoding="UTF-8"?>
<!--This PI will not work under Oxygen unless you change the file extension to ".xml"-->
<?xml-model href="../main/sch/xslt-quality.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xmlns:unused="unused"
  xmlns:local="local"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace=""
  exclude-result-prefixes="#all"
  >
  
  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <include href="conf/my-xslq-conf.xml"/>
    <param name="xslqual-FunctionComplexity-maxSize">10</param>
    <param name="xslqual-TemplateComplexity-maxSize">10</param>
    <param name="xslqual-TooManySmallTemplates-maxSmallTemplates">2</param>
    <pattern idref="xslt-quality_documentation" active="false"/>
    <pattern idref="xslt-quality_debug" active="true"/>
    <report idref="xslqual-UnusedFunction" active="false"/>
    <alias idref="check-namespace" active="true"/>
    <alias idref="unimportant-rules" active="false"/>
  </conf>
  
  <xsl:import href="sample-lib.xsl"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:for-each select="test-xslt-quality_avoid-for-each">
      <xsl:message>xslqual-IncorrectUseOfBooleanConstants = <xsl:value-of select="'true'"/></xsl:message>
      <xsl:apply-templates mode="#current"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:function name="local:unusedFunction" as="xs:boolean">
    <xsl:sequence select="true()"/>
  </xsl:function>
  
  <xsl:template name="unUsedTemplate">
    <xsl:call-template name="local:largeSizeTemplate"/>
  </xsl:template>
  
  <xsl:function name="local:largeSizeFunction" as="item()*">
    <xsl:param name="s"/>
    <xsl:param name="e" as="element()*"/>
    <xsl:variable name="unused" as="xs:string" xslq:ignore="xslqual-UnusedVariable xslt-quality_use-select-attribute-when-possible">unused</xsl:variable>
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
  
  <xsl:template name="local:largeSizeTemplate">
    <xsl:param name="s" as="xs:string"/>
    <xsl:param name="e" as="element()*"/>
    <xsl:variable name="unused" as="xs:string" xslq:ignore="xslqual-UnusedVariable xslt-quality_use-select-attribute-when-possible">unused</xsl:variable>
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
  </xsl:template>
  
</xsl:stylesheet>