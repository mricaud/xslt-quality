<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  version="3.0">
  
  <conf xmlns="https://github.com/mricaud/xsl-quality" ignore-roles="info warning">
    <assert idref="xslqual-UnusedFunction" active="true"/>
    <assert idref="xslqual-UnusedParameter" active="false"/>
    <report idref="xslqual-FunctionComplexity">
      <param name="maxSize">5</param>
    </report>
  </conf>
  
  <!--================================================-->
  <!--Parameters/Variables-->
  <!--================================================-->
  
  <xsl:param name="xslq:conf.uri" as="xs:anyURI" select="resolve-uri('../conf/xsl-quality.conf.xml', static-base-uri())"/>
  
  <xsl:variable name="xslq:conf-default" as="document-node()" select="doc($xslq:conf.uri)"/>
  <xsl:variable name="xslq:conf-local" as="element(xslq:conf)?" select="/xsl:*/xslq:conf"/>
  <xsl:variable name="xslq:conf-merged" as="document-node()">
    <xsl:apply-templates select="$xslq:conf-default" mode="xslq:merge-conf"/>
    <!--no need to pass xslq:conf-local as parameter, it's a global variable-->
  </xsl:variable>
  
  <xsl:key name="getConfElementByIdref" match="xslq:*" use="@idref"/>
  
  <!--================================================-->
  <!--Functions-->
  <!--================================================-->
  
  <xsl:function name="xslq:get-conf-element" as="element()">
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:sequence select="key('getConfElementByIdref', $sch-idref, $xslq:conf-merged)"/>
  </xsl:function>
  
  <xsl:function name="xslq:is-active" as="xs:boolean" xslq:ignore="xslqual-FunctionComplexity">
    <xsl:param name="node" as="node()"/>
    <xsl:param name="sch-idref" as="xs:string"/>
    <xsl:variable name="element" select="$node/ancestor-or-self::*[1]" as="element()"/>
    <xsl:choose>
      <xsl:when test="$element/@xslq:ignore => tokenize('\s+') = $sch-idref">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="conf-element" as="element()" select="xslq:get-conf-element($sch-idref)"/>
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
  
  <xsl:mode name="xslq:merge-conf" on-no-match="shallow-copy"/>
  
  <xsl:template match="xslq:conf" mode="xslq:merge-conf">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:sequence select="$xslq:conf-local/@*"/>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xslq:*[@idref]" mode="xslq:merge-conf">
    <xsl:variable name="idref" as="xs:string" select="@idref"/>
    <!--there should not be multiple override of the same element in the local conf, choose the last one if so-->
    <xsl:variable name="conf-local-override-element" as="element()?" select="$xslq:conf-local/descendant-or-self::*[@idref][@idref = $idref][last()]"/>
    <xsl:choose>
      <xsl:when test="exists($conf-local-override-element)">
        <!--don't replace the whole subtree of the element, but only the element itself without children-->
        <xsl:copy select="$conf-local-override-element">
          <xsl:sequence select="$conf-local-override-element/@*"/>
          <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  
  
  <xsl:template match="/"/>
    
  
</xsl:stylesheet>