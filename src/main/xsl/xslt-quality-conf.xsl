<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  version="3.0">
  
  <conf xmlns="https://github.com/mricaud/xsl-quality" ignore-roles="info warning">
    <include href="../conf/my-xslq-conf.xml"/>
    <pattern idref="xslt-quality_documentation" active="false"/>
    <pattern idref="xslqual" active="false"/>
    <assert idref="xslqual-UnusedFunction" active="true"/>
    <assert idref="xslqual-UnusedParameter" active="false"/>
    <report idref="xslqual-FunctionComplexity">
      <param name="maxSize">5</param>
    </report>
    <alias idref="check-namespace" active="false"/>
  </conf>
  
  <!--================================================-->
  <!--Parameters/Variables-->
  <!--================================================-->
  
  <xsl:param name="xslq:conf.uri" as="xs:anyURI" select="resolve-uri('../conf/xsl-quality.conf.xml', static-base-uri())"/>
  
  <xsl:variable name="xslq:conf-default" as="document-node()" select="doc($xslq:conf.uri)"/>
  <xsl:variable name="xslq:conf-default-resolved" as="document-node()" select="xslq:resolve-conf($xslq:conf-default)"/>
  <xsl:variable name="xslq:conf-local" as="document-node()">
    <xsl:document>
      <xsl:sequence select="/xsl:*/xslq:conf[1]"/>
    </xsl:document>
  </xsl:variable>
  <xsl:variable name="xslq:conf-local-resolved" as="document-node()" select="xslq:resolve-conf($xslq:conf-local)"/>
  <xsl:variable name="xslq:conf-merged" as="document-node()">
    <xsl:apply-templates select="$xslq:conf-default-resolved" mode="xslq:merge-conf"/>
    <!--no need to pass xslq:conf-local as parameter, it's a global variable-->
  </xsl:variable>
  
  <xsl:key name="getConfElementByIdref" match="xslq:*" use="@idref"/>
  
  <!--================================================-->
  <!--Functions-->
  <!--================================================-->
  
  <!--Resolve conf inclusions-->
  <xsl:function name="xslq:resolve-conf" as="document-node()">
    <xsl:param name="conf" as="document-node()"/>
    <xsl:document>
      <xsl:apply-templates select="$conf" mode="xslq:resolve-conf">
        <xsl:with-param name="current-base-uri" select="base-uri($conf)" tunnel="yes" as="xs:anyURI"/>
      </xsl:apply-templates>
    </xsl:document>
  </xsl:function>
  
  <xsl:function name="xslq:get-conf-element" as="element()?">
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:sequence select="key('getConfElementByIdref', $sch-idref, $xslq:conf-merged)[last()]"/>
  </xsl:function>
  
  <xsl:function name="xslq:is-active" as="xs:boolean" xslq:ignore="xslqual-FunctionComplexity">
    
    <xsl:param name="node" as="node()"/>
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:variable name="element" select="$node/ancestor-or-self::*[1]" as="element()"/>
    <xsl:variable name="conf-element" as="element()?" select="xslq:get-conf-element($sch-idref)"/>
    <xsl:choose>
      <xsl:when test="$element/@xslq:ignore => tokenize('\s+') = $sch-idref">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:when test="empty($conf-element)">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="every $e in $conf-element/ancestor-or-self::xslq:* satisfies ($e/@active, 'true')[1] = 'true'"
          xslq:ignore="xslqual-IncorrectUseOfBooleanConstants"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!--2 arity version of xslq:get-param-value-->
  <xsl:function name="xslq:get-param-value" as="item()*">
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:param name="param-name" as="xs:string"/>
    <xsl:sequence select="xslq:get-param-value($sch-idref, $param-name, 'xs:string')"/>
  </xsl:function>
  
  <xsl:function name="xslq:get-param-value" as="item()">
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:param name="param-name" as="xs:string"/>
    <xsl:param name="cast-param-as" as="xs:string"/>
    <xsl:variable name="conf.element" as="element()" select="xslq:get-conf-element($sch-idref)"/>
    <xsl:variable name="param-value" as="element()" select="$conf.element/xslq:param[@name = $param-name]"/>
    <xsl:try>
      <xsl:evaluate xpath="$param-value ||  ' cast as ' || $cast-param-as"/>
      <xsl:catch>
        <xsl:variable as="xs:string" name="error-context" select="' [error ' || $err:code || ' at ' || $err:module || ' l. ' || $err:line-number || ' col. ' || $err:column-number || ']'"/>
        <xsl:variable as="xs:string" name="error-desc" select="'[xslq:get-param-value] Unable to cast ' || $param-name || ' as ' || $cast-param-as  || ' in ' || $sch-idref 
          || $err:description || $error-context"/>
        <xsl:message terminate="yes" select="$error-desc"/>
      </xsl:catch>
    </xsl:try>
  </xsl:function>
  
  <!--================================================-->
  <!--Mode xslq:merge-conf-->
  <!--================================================-->
  
  <xsl:mode name="xslq:resolve-conf" on-no-match="shallow-copy"/>
  
  <xsl:template match="xslq:include" mode="xslq:resolve-conf">
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
  <!--Mode xslq:merge-conf-->
  <!--================================================-->
  
  <xsl:mode name="xslq:merge-conf" on-no-match="shallow-copy"/>
  
  <xsl:template match="xslq:conf" mode="xslq:merge-conf">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:sequence select="$xslq:conf-local-resolved/xslq:conf/@*"/>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xslq:*[@idref]" mode="xslq:merge-conf">
    <xsl:variable name="idref" as="xs:string" select="@idref"/>
    <!--there should not be multiple override of the same element in the local conf, choose the last one if so-->
    <xsl:variable name="conf-local-override-element" as="element()?" select="$xslq:conf-local-resolved/descendant-or-self::*[@idref][@idref = $idref][last()]"/>
    <xsl:choose>
      <xsl:when test="exists($conf-local-override-element)">
        <!--don't replace the whole subtree of the element, but only the element itself without children-->
        <xsl:variable name="node" as="node()*" select="node()"/>
        <xsl:copy select="$conf-local-override-element">
          <xsl:sequence select="$conf-local-override-element/@*"/>
          <xsl:apply-templates select="$node" mode="#current"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="/" name="test"/>
  
  
  <xsl:template match="/"/>
    
  
</xsl:stylesheet>