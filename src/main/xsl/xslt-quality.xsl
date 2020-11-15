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
  
  <xd:doc>
    <xd:desc>
      <xd:p>Checks if an xsl:variable or an xsl:param is used within its scope</xd:p>
    </xd:desc>
    <xd:param name="var">xsl:variable or an xsl:param</xd:param>
    <xd:return>boolean</xd:return>
  </xd:doc>
   <xsl:function name="xslq:var-or-param-is-referenced-within-its-scope" as="xs:boolean">
      <xsl:param name="var" as="element()"/>
      <xsl:sequence select="xslq:expand-prefix($var/@name, $var) = 
         xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix($var/ancestor::xsl:*[1])"/>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Checks if an xsl:function is used within its scope</xd:p>
    </xd:desc>
    <xd:param name="function">xsl:function</xd:param>
    <xd:return>boolean</xd:return>
  </xd:doc>
   <xsl:function name="xslq:function-is-called-within-its-scope" as="xs:boolean">
      <xsl:param name="function" as="element()"/>
      <xsl:sequence select="xslq:expand-prefix($function/@name, $function) = 
         xslq:get-xslt-xpath-function-call-with-expanded-prefix($function/ancestor::xsl:*[last()])"/>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Get every call of any xsl:variable/xsl:param within an XSLT chunk</xd:p>
    </xd:desc>
    <xd:param name="scope">Chunk of XSLT to search in</xd:param>
    <xd:return>A sequence of "bracedURILiteral" variable/param references</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix" as="xs:string*">
      <xsl:param name="scope" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames--> 
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg" select="'(' || $NCNAME.reg || ':)?' || $NCNAME.reg" as="xs:string"/>
      <xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:analyze-string select="." regex="{'\$(' || $QName.reg || ')'}">
            <xsl:matching-substring>
               <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
            </xsl:matching-substring>
         </xsl:analyze-string>
      </xsl:for-each>
      <xsl:for-each select="xslq:get-xslt-xpath-value-template-nodes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:for-each select="xslq:extract-xpath-from-value-template(.)">
            <xsl:analyze-string select="." regex="{'\$(' || $QName.reg || ')'}">
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
      <xsl:param name="scope" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames-->
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg" select="'(' || $NCNAME.reg || ':)?' || $NCNAME.reg" as="xs:string"/>
      <xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <!--don't catch the closing parenthesis in the function call because it would hide nested functions call-->
         <xsl:analyze-string select="." regex="{'(' || $QName.reg || ')' || '\('}">
            <xsl:matching-substring>
               <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
            </xsl:matching-substring>
         </xsl:analyze-string>
      </xsl:for-each>
      <xsl:for-each select="xslq:get-xslt-xpath-value-template-nodes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:for-each select="xslq:extract-xpath-from-value-template(.)">
            <xsl:analyze-string select="." regex="{'(' || $QName.reg || ')' || '\('}">
               <xsl:matching-substring>
                  <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Get every attributes which allow xpath value in XSLT</xd:p>
    </xd:desc>
    <xd:param name="scope">XSLT fragment where to apply the function</xd:param>
    <xd:return>sequence of xsl attributes with xpath inside</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-evaluated-attributes" as="attribute()*">
      <xsl:param name="scope" as="element()"/>
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
         "/>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>In XSLT, xpath can also be embed within AVT or TVT, this function get each of these nodes</xd:p>
    </xd:desc>
    <xd:param name="scope">XSLT fragment where to apply the function</xd:param>
    <xd:return>Sequence of AVT or TVT nodes that contains xpath</xd:return>
  </xd:doc>
   <xsl:function name="xslq:get-xslt-xpath-value-template-nodes" as="node()*">
      <xsl:param name="scope" as="element()"/>
      <xsl:sequence select="
         (: === AVT : Attribute Value Template === :)
         $scope//@*[matches(., '\{.*?\}')]
         (: === TVT : Text Value Template === :)
         (: XSLT 3.0 only when expand-text is activated:)
         |$scope//text()[matches(., '\{.*?\}')]
         [not(ancestor::xsl:*[1] is /*)](:ignore text outside templates or function (e.g. text within 'xd:doc'):)
         [normalize-space(.)](:ignore white-space nodes:)
         [ancestor-or-self::*[@expand-text[parent::xsl:*] | @xsl:expand-text][1]/@*[local-name() = 'expand-text'] = ('1', 'true', 'yes')]
         "/>
   </xsl:function>
   
  <xd:doc>
    <xd:desc>
      <xd:p>Given a text node (as a string) which contains TVT, this function extract each of TVT xpath values</xd:p>
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
    <xd:return>"bracedURILitera"l form of $QNameString: "Q{ns}NCname"</xd:return>
  </xd:doc>
   <xsl:function name="xslq:expand-prefix" as="xs:string">
      <xsl:param name="QNameString" as="xs:string"/>
      <xsl:param name="context" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames-->
      <!--NCName = an XML Name, minus the ":"-->
      <!--cf. https://stackoverflow.com/questions/1631396/what-is-an-xsncname-type-and-when-should-it-be-used-->
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg" select="'(' || $NCNAME.reg || ':)?' || $NCNAME.reg" as="xs:string"/>
      <xsl:assert test="matches($QNameString, '^' || $QName.reg)"/>
      <!--<xsl:variable name="prefix" select="xs:string(prefix-from-QName(xs:QName(@name)))" as="xs:string"/>-->
      <xsl:variable name="prefix" select="substring-before($QNameString, ':')" as="xs:string"/>
      <!--<xsl:variable name="local-name" select="local-name-from-QName(xs:QName(@name))" as="xs:string"/>-->
      <xsl:variable name="local-name" select="if (contains($QNameString, ':')) then (substring-after($QNameString, ':')) else ($QNameString)" as="xs:string"/>
      <xsl:variable name="ns" select="if ($prefix != '') then (namespace-uri-for-prefix($prefix, $context)) else ('')" as="xs:string"/>
      <xsl:value-of select="'Q{' || $ns, '}' || $local-name" separator=""/>
   </xsl:function>
   
</xsl:stylesheet>