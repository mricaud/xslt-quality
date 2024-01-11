<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xmlns="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  expand-text="true"
  version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>Utility XSLT to update schematron files and add specific XSLT-Quality configuration xpath conditions</xd:desc>
  </xd:doc>

  <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
  
  <!--================================================-->
  <!--INIT-->
  <!--================================================-->
  
  <xsl:template match="/">
    <xsl:apply-templates select="." mode="xslq:precompile-schematron.main"/>
  </xsl:template>
  
  <!--================================================-->
  <!--MAIN-->
  <!--================================================-->
  
  <xsl:mode name="xslq:precompile-schematron.main" on-no-match="shallow-copy"/>
  
  <xd:p>Adding xmlns declaration for xslq + xslt-quality-conf.xsl inclusion</xd:p>
  <xsl:template match="/sch:schema" mode="xslq:precompile-schematron.main">
    <xsl:copy copy-namespaces="yes">
      <xsl:namespace name="xslq" select="'https://github.com/mricaud/xsl-quality'"/>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:apply-templates select="sch:title" mode="#current"/>
      <xsl:if test="not(ns[@prefix = 'xslq'])">
        <ns prefix="xslq" uri="https://github.com/mricaud/xsl-quality" xmlns="http://purl.oclc.org/dsdl/schematron"/>
      </xsl:if>
      <xsl:if test="not(xsl:include[contains(@href, 'xslt-quality-conf.xsl')])">
        <axsl:import href="xslt-quality-conf.xsl"/>
      </xsl:if>
      <axsl:param name="current-sch.filename" select="'{tokenize(base-uri(), '/')[last()]}'"/>
      <xsl:apply-templates select="node() except sch:title" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:p>Adding prefix + info to messages</xd:p>
  <xsl:template match="sch:report[@id] | sch:assert[@id]" mode="xslq:precompile-schematron.main">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:sequence select="'[' || @id || '] '"/>
      <xsl:apply-templates mode="#current"/>
      <sch:value-of select="xslq:add-info(.)"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:p>Add sch:assert conditions to take xslq:conf into account</xd:p>
  <xsl:template match="sch:assert[@id]/@test" mode="xslq:precompile-schematron.main">
    <xsl:attribute name="test">
      <xsl:text>if(not(xslq:is-active(., '</xsl:text>
      <xsl:value-of select="../@id"/>
      <xsl:text>'))) then (true()) else(</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>)</xsl:text>
    </xsl:attribute>
  </xsl:template>
  
  <xd:p>Add sch:report conditions to take xslq:conf into account</xd:p>
  <xsl:template match="sch:report[@id]/@test" mode="xslq:precompile-schematron.main">
    <xsl:attribute name="test">
      <xsl:text>if(not(xslq:is-active(., '</xsl:text>
      <xsl:value-of select="../@id"/>
      <xsl:text>'))) then (false()) else(</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>)</xsl:text>
    </xsl:attribute>
  </xsl:template>
  
</xsl:stylesheet>