<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xmlns="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  expand-text="true"
  version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>Utility XSLT to generate the full default conf from xsl-quality.sch</xd:desc>
  </xd:doc>
  
  <xsl:output indent="true"/>
  
  <!--================================================-->
  <!--INIT-->
  <!--================================================-->
  
  <xsl:template match="/">
    <xsl:apply-templates select="." mode="xslq:generate-default-conf.main"/>
  </xsl:template>
  
  <!--================================================-->
  <!--MAIN-->
  <!--================================================-->
  
  <xsl:template match="/" mode="xslq:generate-default-conf.main">
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
        <xsl:apply-templates select="$step" mode="xslq:generate-default-conf"/>
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
  <!--Mode xslq:generate-default-conf-->
  <!--================================================-->
  
  <xsl:mode name="xslq:generate-default-conf" on-no-match="shallow-skip"/>
  
  <xsl:template match="/sch:schema" mode="xslq:generate-default-conf" priority="1">
    <conf>
      <xsl:apply-templates select="descendant::sch:*/@*" mode="xslq:generate-default-conf-parameters"/>
      <xsl:apply-templates mode="#current"/>
    </conf>
  </xsl:template>
  
  <xsl:template match="(sch:pattern | sch:rule | sch:assert | sch:report)[@id]" mode="xslq:generate-default-conf">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="idref" select="@id"/>
      <xsl:attribute name="active">
        <xsl:choose>
          <xsl:when test="@id = 'xslt-quality_debug'">
            <xsl:text>false</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>true</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <!--================================================-->
  <!--Mode xslq:generate-default-conf-parameters-->
  <!--================================================-->
  
  <!--This mode is only called selecting @*, no need to match other nodes-->
  
  <xsl:template match="@*" mode="xslq:generate-default-conf-parameters">
    <xsl:if test="contains(., 'xslq:get-param-value')">
      <!--example: xslq:get-param-value('xslqual-FunctionComplexity-maxSize', '50', 'xs:integer')-->
      <xsl:variable name="parameters" as="element(xslq:parameters)">
        <parameters>
          <xsl:analyze-string select="." regex="xslq:get-param-value\(\s*'(.*?)',\s*'(.*?)'(\s*,\s*'(.*?)')?\)" flags="m">
            <xsl:matching-substring>
              <param name="{regex-group(1)}" as="{regex-group(4)}">
                <xsl:value-of select="regex-group(2)"/>
              </param>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </parameters>
      </xsl:variable>
      <!--In case the call to xslq:get-param-value appears several times in the same xpath expression-->
      <xsl:for-each select="$parameters/xslq:param">
        <xsl:if test="not(@name = preceding-sibling::xslq:param/@name)">
          <param name="{@name}"><xsl:value-of select="."/></param>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>