<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  version="3.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>XSLT library used by xslt-quality schematron framework</xd:p>
    </xd:desc>
  </xd:doc>
  
  <!--=============================================================-->
  <!--xslt-quality conf-->
  <!--=============================================================-->
 
  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <param name="xslt-quality_xslt-is-a-library">1</param>
    <item idref="xslqual-UsingNameOrLocalNameFunction" active="false"/>
    <item idref="xslqual-IncorrectUseOfBooleanConstants" active="false"/>
  </conf>
  
  
  <!--=============================================================-->
  <!--Import-->
  <!--=============================================================-->
  
  <xsl:import href="xslt-quality-conf.xsl"/>
  
  <!--=============================================================-->
  <!--param / var-->
  <!--=============================================================-->
  
  <xsl:variable name="xslq:NCNAME.reg" as="xs:string" select="'[\i-[:]][\c-[:]]*'"/>
  <xsl:variable name="xslq:QName.reg" as="xs:string" select="'(' || $xslq:NCNAME.reg || ':)?' || $xslq:NCNAME.reg"/>
  
  <xsl:variable name="xslq:self.resolved" select="xslq:resolve-xslt(/)" as="document-node()"/>
  
  <!--=============================================================-->
  <!--LIB-->
  <!--=============================================================-->
  
  <xd:doc>
    <xd:desc>
      <xd:p>See 2arity version of this function</xd:p>
    </xd:desc>
    <xd:param name="var">See 2arity version of this function</xd:param>
  </xd:doc>
  <xsl:function name="xslq:var-or-param-is-referenced-within-its-scope" as="xs:boolean">
    <xsl:param name="var" as="element()"/>
    <xsl:sequence
      select="xslq:var-or-param-is-referenced-within-its-scope($var, $var/ancestor::xsl:*[1])"/>
  </xsl:function>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Checks if an xsl:variable or an xsl:param is used within its scope</xd:p>
    </xd:desc>
    <xd:param name="var">xsl:variable or an xsl:param</xd:param>
    <xd:param name="scope">an element in which to look for use of the parameter or variable</xd:param>
    <xd:return>boolean</xd:return>
  </xd:doc>
  <xsl:function name="xslq:var-or-param-is-referenced-within-its-scope" as="xs:boolean">
    <xsl:param name="var" as="element()"/>
    <xsl:param name="scope" as="node()"/>
    <xsl:sequence
      select="
      xslq:expand-prefix($var/@name, $var) =
      xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix($scope)"
    />
  </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>See 2arity version of this function</xd:p>
    </xd:desc>
    <xd:param name="function">See 2arity version of this function</xd:param>
    <xd:return>boolean</xd:return>
  </xd:doc>
   <xsl:function name="xslq:function-is-called-within-its-scope" as="xs:boolean">
     <xsl:param name="function" as="element()"/>
     <xsl:sequence select="xslq:function-is-called-within-its-scope($function, $function/root())"/>
   </xsl:function>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Checks if an xsl:function is used within its scope</xd:p>
    </xd:desc>
    <xd:param name="var">xsl:function</xd:param>
    <xd:param name="scope">an element in which to look for use of the function</xd:param>
    <xd:return>boolean</xd:return>
  </xd:doc>
  <xsl:function name="xslq:function-is-called-within-its-scope" as="xs:boolean">
    <xsl:param name="function" as="element()"/>
    <xsl:param name="scope" as="node()"/>
    <xsl:sequence select="
      xslq:expand-prefix($function/@name, $function) = 
      xslq:get-xslt-xpath-function-call-with-expanded-prefix($scope)"/>
  </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Get every call of any xsl:variable/xsl:param within an XSLT chunk</xd:p>
    </xd:desc>
    <xd:param name="scope">Chunk of XSLT to search in</xd:param>
    <xd:return>A sequence of "bracedURILiteral" variable/param references</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix" as="xs:string*">
      <xsl:param name="scope" as="node()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames--> 
      <xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:analyze-string select="." regex="{'\$(' || $xslq:QName.reg || ')'}">
            <xsl:matching-substring>
               <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
            </xsl:matching-substring>
         </xsl:analyze-string>
      </xsl:for-each>
      <xsl:for-each select="xslq:get-xslt-xpath-value-template-nodes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:for-each select="xslq:extract-xpath-from-value-template(.)">
            <xsl:analyze-string select="." regex="{'\$(' || $xslq:QName.reg || ')'}">
               <xsl:matching-substring>
                  <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Get every call of any xpath/xslt function within an XSLT chunk</xd:p>
    </xd:desc>
    <xd:param name="scope">Chunk of XSLT to search in</xd:param>
    <xd:return>A sequence of "bracedURILiteral" functions call</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-function-call-with-expanded-prefix" as="xs:string*">
      <xsl:param name="scope" as="node()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames-->
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg" select="'(' || $xslq:NCNAME.reg || ':)?' || $xslq:NCNAME.reg" as="xs:string"/>
      <xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <!--don't catch the closing parenthesis in the function call because it would hide nested functions call-->
         <xsl:analyze-string select="." regex="{'(' || $xslq:QName.reg || ')' || '\('}">
            <xsl:matching-substring>
               <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
            </xsl:matching-substring>
         </xsl:analyze-string>
      </xsl:for-each>
      <xsl:for-each select="xslq:get-xslt-xpath-value-template-nodes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:for-each select="xslq:extract-xpath-from-value-template(.)">
            <xsl:analyze-string select="." regex="{'(' || $xslq:QName.reg || ')' || '\('}">
               <xsl:matching-substring>
                  <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Get every XSLT attribute that allows XPath values</xd:p>
    </xd:desc>
    <xd:param name="scope">XSLT fragment where to apply the function</xd:param>
    <xd:return>sequence of xsl attributes with xpath inside</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-evaluated-attributes" as="attribute()*">
      <xsl:param name="scope" as="node()"/>
      <xsl:sequence select="$scope//
         (
         xsl:accumulator/@initial-value | xsl:accumulator-rule/@select | xsl:accumulator-rule/@match |
         xsl:analyze-string/@select | xsl:apply-templates/@select | xsl:assert/@test | xsl:assert/@select |
         xsl:attribute/@select | xsl:break/@select | xsl:catch/@select | xsl:comment/@select |
         xsl:copy/@select | xsl:copy-of/@select | xsl:evaluate/@xpath | xsl:evaluate/@context-item |
         xsl:evaluate/@namespace-context | xsl:evaluate/@with-params | xsl:for-each/@select | 
         xsl:for-each-group/@select | xsl:for-each-group/@group-by | xsl:for-each-group/@group-adjacent | 
         xsl:for-each-group/@group-starting-with | xsl:for-each-group/@group-ending-with | 
         xsl:if/@test | xsl:iterate/@select | xsl:key/@match | xsl:key/@use | xsl:map-entry/@key |
         xsl:merge-key/@select | xsl:merge-source/@for-each-item | xsl:merge-source/@for-each-source | 
         xsl:merge-source/@select | xsl:message/@select | xsl:namespace/@select |
         xsl:number/@value | xsl:number/@select | xsl:number/@count | xsl:number/@from | 
         xsl:on-completion/@select | xsl:on-empty/@select | xsl:on-non-empty/@select |
         xsl:param/@select | xsl:perform-sort/@select | xsl:processing-instruction/@select | 
         xsl:sequence/@select | xsl:sort/@select | xsl:template/@match | xsl:try/@select | 
         xsl:value-of/@select | xsl:variable/@select | xsl:when/@test | xsl:with-param/@select
         )
         " xslq:ignore="xslqual-DontUseDoubleSlashOperator"/>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>In XSLT, xpath can also be embed within AVT or TVT, this function get each of these nodes</xd:p>
    </xd:desc>
    <xd:param name="scope">XSLT fragment where to apply the function</xd:param>
    <xd:return>Sequence of AVT or TVT nodes that contains xpath</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-value-template-nodes" as="node()*">
      <xsl:param name="scope" as="node()"/>
      <xsl:sequence select="
         (: === AVT : Attribute Value Template === :)
         $scope//@*[matches(., '\{.*?\}')]
         (: === TVT : Text Value Template === :)
         (: XSLT 3.0 only when expand-text is activated:)
         |$scope//text()[matches(., '\{.*?\}')]
         [not(ancestor::xsl:*[1] is /*)](:ignore text outside templates or function (e.g. text within 'xd:doc'):)
         [normalize-space(.)](:ignore white-space nodes:)
         [ancestor-or-self::*[@expand-text[parent::xsl:*] | @xsl:expand-text][1]/@*[local-name() = 'expand-text'] = ('1', 'true', 'yes')]
         " xslq:ignore="xslqual-DontUseDoubleSlashOperator"/>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Given a text node (as a string) which contains TVT (Text Value Template), this function extracts each of TVT xpath values</xd:p>
    </xd:desc>
    <xd:param name="string">String of the XSLT text node</xd:param>
    <xd:return>Sequence of xpath values strings</xd:return>
  </xd:doc>
   <xsl:function name="xslq:extract-xpath-from-value-template" as="xs:string*">
      <xsl:param name="string" as="xs:string"/>
      <xsl:analyze-string select="$string" regex="\{{.*?\}}">
         <xsl:matching-substring>
            <xsl:value-of select="."/>
         </xsl:matching-substring>
      </xsl:analyze-string>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Given a string in form "ns-prefix:NCname" this function return its "bracedURILitera"l form "Q{ns}NCname" using $context to resolve prefix uri</xd:p>
    </xd:desc>
    <xd:param name="QNameString">The "ns-prefix:NCname" form string</xd:param>
    <xd:param name="context">Element node reference to get prefixes and namespaces mapping</xd:param>
    <xd:return>"bracedURILiteral" form of $QNameString: "Q{ns}NCname"</xd:return>
  </xd:doc>
   <xsl:function name="xslq:expand-prefix" as="xs:string">
      <xsl:param name="QNameString" as="xs:string"/>
      <xsl:param name="context" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames-->
      <!--NCName = an XML Name, minus the ":"-->
      <!--cf. https://stackoverflow.com/questions/1631396/what-is-an-xsncname-type-and-when-should-it-be-used-->
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg" select="'(' || $xslq:NCNAME.reg || ':)?' || $xslq:NCNAME.reg" as="xs:string"/>
      <xsl:assert test="matches($QNameString, '^' || $xslq:QName.reg)"/>
      <!--<xsl:variable name="prefix" select="xs:string(prefix-from-QName(xs:QName(@name)))" as="xs:string"/>-->
      <xsl:variable name="prefix" select="substring-before($QNameString, ':')" as="xs:string"/>
      <!--<xsl:variable name="local-name" select="local-name-from-QName(xs:QName(@name))" as="xs:string"/>-->
      <xsl:variable name="local-name" select="if (contains($QNameString, ':')) then (substring-after($QNameString, ':')) else ($QNameString)" as="xs:string"/>
      <xsl:variable name="ns" select="if ($prefix != '') then (namespace-uri-for-prefix($prefix, $context)) else ('')" as="xs:string"/>
      <xsl:value-of select="'Q{' || $ns, '}' || $local-name" separator=""/>
   </xsl:function>
  
  <!--=============================================================-->
  <!--get-namespace-prefixes-->
  <!--=============================================================-->
  
  <xd:doc>
    <xd:desc>Retrieves all active prefixes used in a given element and its descendants.</xd:desc>
  </xd:doc>
  <xsl:function name="xslq:get-namespace-prefixes" as="xs:string*">
    <xsl:param name="element-to-check" as="element()?"/>
    <xsl:variable name="all-prefixes" as="xs:string*">
      <xsl:apply-templates select="$element-to-check" mode="xslq:get-namespace-prefixes"/>
    </xsl:variable>
    <xsl:sequence select="distinct-values($all-prefixes)"/>
  </xsl:function>
  
  <xsl:template match="* | @*" mode="xslq:get-namespace-prefixes">
    <xsl:analyze-string select="name(.)" regex="^({$xslq:NCNAME.reg}):">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
    <xsl:apply-templates select="node() | @*" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="xsl:*/@as | xsl:*/@name | xsl:*/@mode" mode="xslq:get-namespace-prefixes">
    <xsl:analyze-string select="." regex="^({$xslq:NCNAME.reg}):">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="xsl:*/@select" mode="xslq:get-namespace-prefixes">
    <xsl:analyze-string select="." regex="\s({$xslq:NCNAME.reg}):">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="text()" mode="xslq:get-namespace-prefixes"/>

  <!--=============================================================-->
  <!--plural-form-->
  <!--=============================================================-->
  
  <xd:doc>
    <xd:desc>See full xslq:plural-form(), 3-arity version</xd:desc>
    <xd:param name="count">See full xslq:plural-form(), 3-arity version</xd:param>
    <xd:param name="form-if-plural">See full xslq:plural-form(), 3-arity version</xd:param>
  </xd:doc>
  <xsl:function name="xslq:plural-form" as="xs:string?">
    <xsl:param name="count" as="xs:integer"/>
    <xsl:param name="form-if-plural" as="xs:string?"/>
    <xsl:if test="$count gt 1">
      <xsl:sequence select="xslq:plural-form($count, $form-if-plural, ())"/>
    </xsl:if>
  </xsl:function>
  
  <xd:doc>
    <xd:desc>Returns a possible plural form, if the count is greater than one.</xd:desc>
    <xd:param name="count">The number of items in question.</xd:param>
    <xd:param name="form-if-plural">The form of the suffix that should be returned.</xd:param>
    <xd:param name="form-if-singular">The form of the suffix that should be returned.</xd:param>
  </xd:doc>
  <xsl:function name="xslq:plural-form" as="xs:string?">
    <xsl:param name="count" as="xs:integer"/>
    <xsl:param name="form-if-plural" as="xs:string?"/>
    <xsl:param name="form-if-singular" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="$count gt 1">
        <xsl:sequence select="$form-if-plural"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$form-if-singular"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!--=============================================================-->
  <!--resolve-xslt-->
  <!--=============================================================-->
  
  <xd:doc>
    <xd:desc>Resolves an XSLT file by inserting all its dependencies, recursively. The result is a
      complete XSLT document whose resolved parts can be checked for lines of dependencies, errors,
      and so forth.</xd:desc>
    <xd:param name="input-xslt">An XSLT file</xd:param>
  </xd:doc>
  <xsl:function name="xslq:resolve-xslt" as="document-node()">
    <xsl:param name="input-xslt" as="document-node()?"/>
    <xsl:document>
      <xsl:apply-templates select="$input-xslt" mode="xslq:resolve-xslt">
        <xsl:with-param name="current-base-uri" select="base-uri($input-xslt)" tunnel="yes" as="xs:anyURI"/>
      </xsl:apply-templates>
    </xsl:document>
  </xsl:function>
  
  <xsl:mode name="xslq:resolve-xslt" on-no-match="shallow-copy"/>
  
  <xsl:template match="xsl:include | xsl:import" mode="xslq:resolve-xslt">
    <xsl:param name="uris-already-visited" as="xs:anyURI*" tunnel="yes"/>
    <xsl:param name="current-base-uri" as="xs:anyURI" tunnel="yes" select="base-uri(root(.))"/>
    <xsl:variable name="this-name" select="name(.)" as="xs:string"/>
    <xsl:variable name="target-uri" select="resolve-uri(@href, $current-base-uri)" as="xs:anyURI?"/>
    <xsl:variable name="target-xslt-available" select="doc-available($target-uri)" as="xs:boolean"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="$target-uri = $uris-already-visited">
          <xslq:error>
            <xsl:value-of select="'Circular dependency upon ' || $target-uri"/>
          </xslq:error>
        </xsl:when>
        <xsl:when test="not($target-xslt-available)">
          <xslq:error>
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
  
  
</xsl:stylesheet>