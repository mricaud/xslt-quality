<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xmlns="http://relaxng.org/ns/structure/1.0"
  xml:lang="en"
  expand-text="true"
  version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>Utility XSLT to generate rng:values used in xslq:conf from xsl-quality.sch</xd:desc>
  </xd:doc>
  
  <xsl:output indent="true"/>
  
  <!--================================================-->
  <!--INIT-->
  <!--================================================-->
  
  <xsl:template match="/">
    <xsl:apply-templates select="." mode="xslq:generate-conf-rng-values.main"/>
  </xsl:template>
  
  <!--================================================-->
  <!--MAIN-->
  <!--================================================-->
  
  <xsl:template match="/" mode="xslq:generate-conf-rng-values.main">
    <xsl:variable name="step" select="." as="document-node()"/>
    <xsl:variable name="step" as="document-node()">
      <xsl:document>
        <xsl:apply-templates select="$step" mode="xslq:resolve-sch-dependencies">
          <xsl:with-param name="current-base-uri" select="base-uri(root())" tunnel="yes" as="xs:anyURI"/>
        </xsl:apply-templates>
      </xsl:document>
    </xsl:variable>
    <xsl:variable name="step" as="document-node()">
      <xsl:document>
        <xsl:apply-templates select="$step" mode="xslq:generate-conf-rng-values"/>
      </xsl:document>
    </xsl:variable>
    <xsl:sequence select="$step"/>
  </xsl:template>
  
  <!--================================================-->
  <!--Mode xslq:resolve-sch-dependencies-->
  <!--================================================-->
  
  <xsl:mode name="xslq:resolve-sch-dependencies" on-no-match="shallow-copy"/>
  
  <xsl:template match="sch:include" mode="xslq:resolve-sch-dependencies">
    <xsl:param name="uris-already-visited" as="xs:anyURI*" tunnel="yes"/>
    <xsl:param name="current-base-uri" as="xs:anyURI" tunnel="yes" select="base-uri(root(.))"/>
    <xsl:variable name="this-name" select="name(.)" as="xs:string"/>
    <xsl:variable name="target-uri" select="resolve-uri(@href, $current-base-uri)" as="xs:anyURI?"/>
    <xsl:variable name="target-available" select="doc-available($target-uri)" as="xs:boolean"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="$target-uri = $uris-already-visited">
          <xslq:error>
            <xsl:value-of select="'Circular dependency upon ' || $target-uri"/>
          </xslq:error>
        </xsl:when>
        <xsl:when test="not($target-available)">
          <xslq:error current-base-uri="{$current-base-uri}" href="{@href}">
            <xsl:value-of select="$this-name || ' at ' || $target-uri || ' is not available.'"/>
          </xslq:error>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="doc($target-uri)" mode="#current">
            <xsl:with-param name="uris-already-visited" select="$uris-already-visited, $current-base-uri" tunnel="yes" as="xs:anyURI*"/>
            <xsl:with-param name="current-base-uri" select="$target-uri" tunnel="yes" as="xs:anyURI"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <!--================================================-->
  <!--Mode xslq:generate-conf-rng-values-->
  <!--================================================-->
  
  <xsl:mode name="xslq:generate-conf-rng-values" on-no-match="shallow-skip"/>
  
  <xsl:template match="/sch:schema" mode="xslq:generate-conf-rng-values" priority="1">
    <grammar 
      xmlns="http://relaxng.org/ns/structure/1.0"
      xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
      datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes"
      ns="https://github.com/mricaud/xsl-quality"
      >
      <define name="param.attr.name">
        <attribute name="name">
          <choice>
            <xsl:apply-templates select="descendant::sch:*/@* | descendant::xsl:*/@*" mode="xslq:generate-conf-rng-values-parameters"/>
          </choice>
        </attribute>
      </define>
      <define name="sch-item.attr.idref">
        <attribute name="idref">
          <choice>
            <xsl:apply-templates select="descendant::*" mode="#current"/>
          </choice>
        </attribute>
      </define>
      <define name="sch-pattern.attr.idref">
        <attribute name="idref">
          <choice>
            <xsl:apply-templates select="descendant::sch:pattern" mode="#current"/>
          </choice>
        </attribute>
      </define>
      <define name="sch-rule.attr.idref">
        <attribute name="idref">
          <choice>
            <xsl:apply-templates select="descendant::sch:rule" mode="#current"/>
          </choice>
        </attribute>
      </define>
      <define name="sch-assert.attr.idref">
        <attribute name="idref">
          <choice>
            <xsl:apply-templates select="descendant::sch:assert" mode="#current"/>
          </choice>
        </attribute>
      </define>
      <define name="sch-report.attr.idref">
        <attribute name="idref">
          <choice>
            <xsl:apply-templates select="descendant::sch:report" mode="#current"/>
          </choice>
        </attribute>
      </define>
    </grammar>
  </xsl:template>
  
  <xsl:template match="(sch:pattern | sch:rule | sch:assert | sch:report)[@id]" mode="xslq:generate-conf-rng-values">
    <value><xsl:value-of select="@id"/></value>
  </xsl:template>
  
  <!--================================================-->
  <!--Mode xslq:generate-conf-rng-values-parameters-->
  <!--================================================-->
  
  <!--This mode is only called selecting @*, no need to match other nodes-->
  
  <xsl:template match="@*" mode="xslq:generate-conf-rng-values-parameters">
    <xsl:if test="contains(., 'xslq:get-param-value')">
      <!--example: xslq:get-param-value('xslqual-FunctionComplexity-maxSize', '50', 'xs:integer')-->
      <xsl:variable name="parameters" as="element(xslq:parameters)">
        <xslq:parameters>
          <xsl:analyze-string select="." regex="xslq:get-param-value\(\s*'(.*?)',\s*'(.*?)'(\s*,\s*'(.*?)')?\)" flags="m">
            <xsl:matching-substring>
              <xslq:param name="{regex-group(1)}" as="{regex-group(4)}">
                <xsl:value-of select="regex-group(2)"/>
              </xslq:param>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xslq:parameters>
      </xsl:variable>
      <!--In case the call to xslq:get-param-value appears several times in the same xpath expression-->
      <xsl:for-each select="$parameters/xslq:param">
        <xsl:if test="not(@name = preceding-sibling::xslq:param/@name)">
          <value><xsl:value-of select="@name"/></value>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>