<?xml version="1.0" encoding="UTF-8"?>
<!--
CHANGELOG : 
  - 2018-05-11 : #xslqual-SettingValueOfVariableIncorrectly, #xslqual-SettingValueOfParamIncorrectly : take xsl:sequence into account in addition to xsl:value-of
     + check if there is no non-empty text-node under the variable/param, which would be an reason to not use @select
  - 2018-05-11 : rule "xslqual-RedundantNamespaceDeclarations" : take into account some xsl attributes (@select, @as, @name, @mode)
  - 2018-05-11 : reviewing roles
  - 2017-11-05 : rule "xslqual-SettingValueOfParamIncorrectly" : extend rule to xsl:sequence
  - 2017-11-05 : rule "xslqual-UnusedFunction" : extends xsl xpath attributes
  - 2017-11-05 : rule "xslqual-UnusedFunction" : extends to function call in Attribute Value Template
-->
<schema 
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  queryBinding="xslt2" 
  id="xsl-qual"
  >
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="saxon" uri="http://saxon.sf.net/"/>
  
  <!--
      This rules are an schematron implementation of Mukul Gandhi XSL QUALITY xslt 
      at http://gandhimukul.tripod.com/xslt/xslquality.html
      Some rules has not bee reproduced :
          - xslqual-NullOutputFromStylesheet
          - xslqual-DontUseNodeSetExtension
          - xslqual-ShortNames
          - xslqual-NameStartsWithNumeric
    -->
  
  <!--====================================-->
  <!--              MAIN                 -->
  <!--====================================-->
  
  <pattern id="xslqual">
    <rule context="xsl:stylesheet">
      <assert id="xslqual-RedundantNamespaceDeclarations"
        test="every $s in in-scope-prefixes(.)[not(. = ('xml', ''))] satisfies 
        exists(//(*[not(self::xsl:stylesheet)] | @*[not(parent::xsl:*)] | xsl:*/@select | xsl:*/@as | xsl:*/@name | xsl:*/@mode)
        [starts-with(name(), concat($s, ':')) or starts-with(., concat($s, ':'))])" 
        role="warning">
        <!--[xslqual] There are redundant namespace declarations in the xsl:stylesheet element-->
        [xslqual] There are namespace prefixes that are declared in the xsl:stylesheet element but never used anywhere 
      </assert>
      <report id="xslqual-TooManySmallTemplates"
        test="count(//xsl:template[@match and not(@name)][count(*) &lt; 3]) &gt;= 10"
        role="info">
        [xslqual] Too many low granular templates in the stylesheet (10 or more)
      </report>
      <report id="xslqual-MonolithicDesign" 
        test="count(//xsl:template | //xsl:function) = 1" 
        role="warning">
        [xslqual] Using a single template/function in the stylesheet. You can modularize the code.
      </report>
      <report id="xslqual-NotUsingSchemaTypes" 
        test="(@version = '2.0') and not(some $x in .//@* satisfies contains($x, 'xs:'))"
        role="info">
        [xslqual] The stylesheet is not using any of the built-in Schema types (xs:string etc.), when working in XSLT 2.0 mode
      </report>
    </rule>
    <rule context="xsl:output">
      <report id="xslqual-OutputMethodXml"
        test="(@method = 'xml') and starts-with(//xsl:template[.//html or .//HTML]/@match, '/')">
        [xslqual] Using the output method 'xml' when generating HTML code
      </report>
    </rule>
    <rule context="xsl:variable">
      <report id="xslqual-SettingValueOfVariableIncorrectly"
        test="(count(*) = 1) and (count(xsl:value-of | xsl:sequence) = 1) and (normalize-space(string-join(text(), '')) = '')">
        [xslqual] Assign value to a variable using the 'select' syntax if assigning a value with xsl:value-of (or xsl:sequence)
      </report>
      <let name="var.name" value="@name"/>
      <assert id="xslqual-UnusedVariable" role="warning"
        test="(some $att  in ancestor::xsl:*[1]//@* satisfies contains($att, concat('$', $var.name))) 
        or (some $text in ancestor::xsl:*[1]//text()[not(ancestor::xsl:*[1] is /*)][normalize-space(.)][ancestor-or-self::*[@expand-text[parent::xsl:*] | @xsl:expand-text][1]/@*[local-name() = 'expand-text'] = ('1', 'true', 'yes')]
                satisfies matches($text, concat('\{.*?', concat('\$', $var.name), '.*\}')))">
        [xslqual] Variable <value-of select="@name"/> is unused in the stylesheet
      </assert>
    </rule>
    <rule context="xsl:param">
      <report id="xslqual-SettingValueOfParamIncorrectly" role="warning"
        test="(count(*) = 1) and (count(xsl:value-of | xsl:sequence) = 1)  and (normalize-space(string-join(text(), '')) = '')">
        [xslqual] Assign value to a parameter using the 'select' syntax if assigning a value with xsl:value-of (or xsl:sequence)
      </report>
      <report id="xslqual-UnusedFunctionTemplateParameter" role="warning"
        test="(parent::xsl:function or parent::xsl:template) and not(some $x in ..//(node() | @*) satisfies contains($x, concat('$', @name)))">
        [xslqual] Function or template parameter is unused in the function/template body
      </report>
    </rule>
    <rule context="xsl:for-each | xsl:if | xsl:when | xsl:otherwise">
      <report id="xslqual-EmptyContentInInstructions" role="warning"
        test="(count(node()) = count(text())) and (normalize-space() = '')">
        [xslqual] Don't use empty content for instructions like 'xsl:for-each' 'xsl:if' 'xsl:when' etc.
      </report>
    </rule>
    <rule context="xsl:function[count(//xsl:template[@match][(@mode, '#default')[1] = '#default']) != 0]">
      <report id="xslqual-UnusedFunction" role="warning"
        test="not(some $x in //(xsl:template/@match | xsl:*/@select | xsl:when/@test) satisfies contains($x, @name)) 
        and not(some $x in //(*[not(self::xsl:*)]/@*) satisfies contains($x, concat('{', @name, '(')))">
        [xslqual] Stylesheet function is unused
      </report>
      <report id="xslqual-FunctionComplexity" role="info"
        test="count(.//xsl:*) &gt; 50">
        [xslqual] Function's size/complexity is high. There is need for refactoring the code.
      </report>
    </rule>
    <rule context="xsl:template">
      <report id="xslqual-UnusedNamedTemplate" role="warning"
        test="@name and not(@match) and not(//xsl:call-template/@name = @name)">
        [xslqual] Named template in stylesheet in unused
      </report>
      <report id="xslqual-TemplateComplexity" role="info"
        test="count(.//xsl:*) &gt; 50">
        [xslqual] Template's size/complexity is high. There is need for refactoring the code.
      </report>
    </rule>
    <rule context="xsl:element">
      <report id="xslqual-NotCreatingElementCorrectly"
        test="not(contains(@name, '$') or (contains(@name, '(') and contains(@name, ')')) or 
        (contains(@name, '{') and contains(@name, '}')))">
        [xslqual] Creating an element node using the xsl:element instruction when could have been possible directly
      </report>
    </rule>
    <rule context="xsl:apply-templates">
      <report id="xslqual-AreYouConfusingVariableAndNode"
        test="some $var in ancestor::xsl:template[1]//xsl:variable satisfies 
        (($var &lt;&lt; .) and starts-with(@select, $var/@name))">
        [xslqual] You might be confusing a variable reference with a node reference
      </report>
    </rule>
    <rule context="@*">
      <report id="xslqual-DontUseDoubleSlashOperatorNearRoot"
        test="local-name(.)= ('match', 'select') and (not(matches(., '^''.*''$')))
        and starts-with(., '//')" role="warning">
        [xslqual] Avoid using the operator // near the root of a large tree
      </report>
      <report id="xslqual-DontUseDoubleSlashOperator"
        test="local-name(.)= ('match', 'select') and (not(matches(., '^''.*''$')))
        and not(starts-with(., '//')) and contains(., '//')" role="info">
        [xslqual] Avoid using the operator // in XPath expressions
      </report>
      <report id="xslqual-UsingNameOrLocalNameFunction" 
        test="contains(., 'name(') or contains(., 'local-name(')" role="info">
        [xslqual] Using name() function when local-name() could be appropriate (and vice-versa)
      </report>
      <report id="xslqual-IncorrectUseOfBooleanConstants" role="info"
        test="local-name(.)= ('match', 'select') and not(parent::xsl:attribute)
        and ((contains(., 'true') and not(contains(., 'true()'))) or (contains(., 'false') and not(contains(., 'false()'))))">
        [xslqual] Incorrectly using the boolean constants as 'true' or 'false'
      </report>
      <report id="xslqual-UsingNamespaceAxis" 
        test="/xsl:stylesheet/@version = '2.0' and local-name(.)= ('match', 'select') and contains(., 'namespace::')">
        [xslqual] Using the deprecated namespace axis, when working in XSLT 2.0 mode
      </report>
      <report id="xslqual-CanUseAbbreviatedAxisSpecifier" 
        test="local-name(.) = ('match', 'select') and contains(., 'child::') or contains(., 'attribute::') or contains(., 'parent::node()')"
        role="info">
        [xslqual] Using the lengthy axis specifiers like child::, attribute:: or parent::node()
      </report>
      <report id="xslqual-UsingDisableOutputEscaping" 
        test="local-name(.) = 'disable-output-escaping' and . = 'yes'">
        [xslqual] Have set the disable-output-escaping attribute to 'yes'. Please relook at the stylesheet logic.
      </report>
    </rule>
  </pattern>
  
</schema>