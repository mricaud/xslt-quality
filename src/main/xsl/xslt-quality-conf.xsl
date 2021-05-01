<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  version="3.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>This XSLT implements xsl-quality customizations which allows user to set a conf and ignore any pattern/rules/report/assert</xd:p>
      <xd:p>This XSLT defines functions that are directly called from xslt-quality.sch (xslq:is-active and xslq:get-param-value)</xd:p>
    </xd:desc>
  </xd:doc>
  
  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <pattern idref="xslt-quality_documentation" active="false"/>
    <item idref="xslqual-DontUseDoubleSlashOperator" active="false"/>
    <item idref="xslqual-UsingNameOrLocalNameFunction" active="false"/>
  </conf>
  
  <!--================================================-->
  <!--Parameters/Variables-->
  <!--================================================-->
  
  <!--The default conf must be full so local conf can override it properly-->
  <xsl:param name="xslq:conf-default.uri" as="xs:anyURI" select="resolve-uri('../conf/xslt-quality.default-conf.xml', static-base-uri())"/>
  
  <xsl:variable name="xslq:conf-default" as="document-node()" select="doc($xslq:conf-default.uri)"/>
  <xsl:variable name="xslq:conf-default-resolved" as="document-node()" select="xslq:resolve-conf($xslq:conf-default)"/>
  <xsl:variable name="xslq:conf-local" as="document-node()">
    <xsl:document>
      <xslq:conf>
        <xsl:attribute name="xml:base" select="base-uri()"/>
        <xsl:sequence select="/xsl:*/xslq:conf[1]/node()"/>
      </xslq:conf>
    </xsl:document>
  </xsl:variable>
  <xsl:variable name="xslq:conf-local-resolved" as="document-node()" select="xslq:resolve-conf($xslq:conf-local)"/>
  <xsl:variable name="xslq:conf-merged" as="document-node()">
    <xsl:document>
      <xsl:apply-templates select="$xslq:conf-default-resolved" mode="xslq:merge-conf"/>
      <!--no need to pass xslq:conf-local as parameter, it's a global variable-->
    </xsl:document>
  </xsl:variable>
  
  <xsl:key name="getConfElementByIdref" match="xslq:*" use="@idref"/>
  <xsl:key name="getConfParamByName" match="xslq:param" use="@name"/>
  
  <!--================================================-->
  <!--Template xslq:conf-debug-->
  <!--================================================-->
  
  <xd:doc>Call this XSLT on your xsl input with initial template Q{https://github.com/mricaud/xsl-quality}conf-debug
    to have debug information</xd:doc>
  <xsl:template name="xslq:conf-debug" xslq:ignore="xslqual-UnusedNamedTemplate">
    <xslq:conf-debug>
      <xslq:conf-default-resolved>
        <xsl:sequence select="$xslq:conf-default-resolved"/>
      </xslq:conf-default-resolved>
      <xslq:conf-local-resolved>
        <xsl:sequence select="$xslq:conf-local-resolved"/>
      </xslq:conf-local-resolved>
    </xslq:conf-debug>
  </xsl:template>
  
  <!--================================================-->
  <!--Functions-->
  <!--================================================-->
  
  <xd:doc>Resolve conf inclusions</xd:doc>
  <xsl:function name="xslq:resolve-conf" as="document-node()">
    <xsl:param name="conf" as="document-node()"/>
    <xsl:document>
      <xsl:apply-templates select="$conf" mode="xslq:resolve-conf">
        <xsl:with-param name="current-base-uri" select="base-uri($conf/*)" tunnel="yes" as="xs:anyURI"/>
      </xsl:apply-templates>
    </xsl:document>
  </xsl:function>
  
  <xd:doc>Get conf element by idref</xd:doc>
  <xsl:function name="xslq:get-conf-element" as="element()?">
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:sequence select="key('getConfElementByIdref', $sch-idref, $xslq:conf-merged)[last()]"/>
  </xsl:function>
  
  <xd:doc>Get conf param element by name (if exist)</xd:doc>
  <xsl:function name="xslq:get-conf-param" as="element()*">
    <xsl:param name="name" as="xs:string"/>
    <xsl:sequence select="key('getConfParamByName', $name, $xslq:conf-merged)"/>
  </xsl:function>
  
  <xsl:function name="xslq:is-active" as="xs:boolean" xslq:ignore="xslqual-FunctionComplexity">
    <xsl:param name="node" as="node()"/>
    <xsl:param name="sch-idref" as="xs:string"/>
    <!--a node that has no ancestor-or-self is the root node-->
    <xsl:variable name="element" select="($node/ancestor-or-self::*[1], $node/*[1])[1]" as="element()"/>
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
  
  <xd:doc>2 arity version of xslq:get-param-value</xd:doc>
  <xsl:function name="xslq:get-param-value" as="item()*">
    <xsl:param name="param-name" as="xs:string"/>
    <xsl:param name="default-value" as="xs:string"/>
    <xsl:sequence select="xslq:get-param-value($param-name, $default-value, 'xs:string')"/>
  </xsl:function>
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>This function is called from schematron to define allow changing schematron variable from the conf</xd:p>
    </xd:desc>
    <xd:param name="param-name">Name of the parameter</xd:param>
    <xd:param name="default-value">default atomic value of the parameter (setted in the schematron within the call to this function)</xd:param>
    <xd:param name="cast-param-as">xs type of the param value (default is xs:string)</xd:param>
    <xd:return>The typed value of the parameter after checking for conf overriding</xd:return>
  </xd:doc>
  <xsl:function name="xslq:get-param-value" as="item()?">
    <xsl:param name="param-name" as="xs:string"/>
    <xsl:param name="default-value" as="xs:string"/>
    <xsl:param name="cast-param-as" as="xs:string"/>
    <xsl:variable name="conf-param" as="element()?" select="(xslq:get-conf-param($param-name))[last()]"/>
    <xsl:variable name="param-value" as="xs:string" select="($conf-param, $default-value)[1] => normalize-space()"/>
    <xsl:try>
      <xsl:evaluate xpath="$param-value ||  ' cast as ' || $cast-param-as"/>
      <xsl:catch>
        <xsl:variable as="xs:string" name="error-context" select="' [error ' || $err:code || ' at ' || $err:module || ' l. ' || $err:line-number || ' col. ' || $err:column-number || ']'"/>
        <xsl:variable as="xs:string" name="error-desc" select="'[xslq:get-param-value] Unable to cast ' || $param-name || ' as ' || $cast-param-as  
          || $err:description || $error-context"/>
        <xsl:message terminate="yes" select="$error-desc"/>
      </xsl:catch>
    </xsl:try>
  </xsl:function>
  
  <!--================================================-->
  <!--Mode xslq:resolve-conf-->
  <!--================================================-->
  
  <xsl:mode name="xslq:resolve-conf" on-no-match="shallow-copy"/>
  
  <xd:doc>Resolve xslq:include within xslq:conf element</xd:doc>
  <xsl:template match="xslq:include" mode="xslq:resolve-conf">
    <xsl:param name="uris-already-visited" as="xs:anyURI*" tunnel="yes"/>
    <xsl:param name="current-base-uri" as="xs:anyURI" tunnel="yes" select="base-uri(.)"/>
    <xsl:variable name="this-name" select="name(.)" as="xs:string"/>
    <xsl:variable name="target-uri" select="resolve-uri(@href, $current-base-uri)" as="xs:anyURI?"/>
    <xsl:variable name="target-available" select="doc-available($target-uri)" as="xs:boolean"/>
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
  </xsl:template>
  
  <!--================================================-->
  <!--Mode xslq:merge-conf-->
  <!--================================================-->
  
  <xsl:mode name="xslq:merge-conf" on-no-match="shallow-copy"/>
  
  <xd:doc>Merge conf: matching nodes are from $xslq:conf-default-resolved"</xd:doc>
  <xsl:template match="xslq:conf" mode="xslq:merge-conf">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:sequence select="$xslq:conf-local-resolved/xslq:conf/@*"/>
      <xsl:apply-templates select="node()" mode="#current"/>
      <!--Deal with aliases-->
      <xsl:for-each select="distinct-values($xslq:conf-local-resolved//xslq:aliasdef/@id)">
        <xsl:variable name="idref" as="xs:string" select="."/>
        <xsl:variable name="alias-def" as="element()" select="($xslq:conf-local-resolved//xslq:aliasdef[@id = $idref])[last()]"/>
        <xsl:variable name="alias-override" as="element()?" select="($xslq:conf-local-resolved//xslq:alias[@idref = $idref])[last()]"/>
        <!--<alias-def><xsl:sequence select="$alias-def"/></alias-def>
        <alias-override><xsl:sequence select="$alias-override"/></alias-override>-->
        <xsl:copy select="$alias-def" copy-namespaces="false">
          <xsl:copy-of select="$alias-def/@* except $alias-def/@id"/>
          <xsl:attribute name="idref" select="$alias-def/@id"/>
          <xsl:if test="not(empty($alias-override))">
            <xsl:attribute name="active" select="($alias-override/@active, 'true')[1]"/>
          </xsl:if>
          <xsl:apply-templates select="$alias-def/node()" mode="xslq:merge-conf-expand-alias"/>
          <!--<xsl:copy-of select="$alias-def/node()" copy-namespaces="false"/>-->
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="node() | @*" mode="xslq:merge-conf-expand-alias">
    <xsl:copy copy-namespaces="false">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <!--Aliases need to be expanded so inheritance on active attribute works-->
  <xsl:template match="xslq:aliasdef/*[self::xslq:pattern or self::xslq:rule]" mode="xslq:merge-conf-expand-alias">
    <xsl:copy copy-namespaces="false">
      <xsl:copy-of select="@*"/>
      <xsl:sequence select="$xslq:conf-default-resolved//xslq:pattern[not(parent::xslq:aliasdef)][@idref = current()/@idref]/node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>Merge conf: merge schematron component references (matching nodes are from $xslq:conf-default-resolved")</xd:doc>
  <xsl:template match="xslq:*[@idref]" mode="xslq:merge-conf">
    <xsl:variable name="idref" as="xs:string" select="@idref"/>
    <!--there could not be multiple override of the same element in the local conf, choose the last one if so-->
    <xsl:variable name="conf-local-override-element" as="element()?" 
      select="$xslq:conf-local-resolved/descendant-or-self::*[@idref][@idref = $idref][last()]"/>
    <xsl:choose>
      <xsl:when test="exists($conf-local-override-element)">
        <!--don't replace the whole subtree of the element, but only the element itself without children-->
        <xsl:variable name="node" as="node()*" select="node()"/>
        <xsl:copy select="$conf-local-override-element" copy-namespaces="false">
          <xsl:sequence select="$conf-local-override-element/@*"/>
          <xsl:attribute name="overrided" select="'true'"/>
          <xsl:apply-templates select="$node" mode="#current"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>Merge conf: merge parameters (matching nodes are from $xslq:conf-default-resolved")</xd:doc>
  <xsl:template match="xslq:param[@name]" mode="xslq:merge-conf">
    <xsl:variable name="name" as="xs:string" select="@name"/>
    <!--there could not be multiple override of the same element in the local conf, choose the last one if so-->
    <xsl:variable name="conf-local-override-param" as="element()?" select="$xslq:conf-local-resolved/descendant-or-self::xslq:param[@name][@name = $name][last()]"/>
    <xsl:choose>
      <xsl:when test="exists($conf-local-override-param)">
        <xsl:copy-of select="$conf-local-override-param" copy-namespaces="false"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>