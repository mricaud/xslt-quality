<?xml version="1.0" encoding="UTF-8"?>
<schema 
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  queryBinding="xslt2" 
  id="xsl-common.sch"
  >
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="saxon" uri="http://saxon.sf.net/"/>
  
  <xsl:key name="getElementById" match="*" use="@id"/>
  
  <!--====================================-->
  <!--            DIAGNOSTICS             -->
  <!--====================================-->
  
  <diagnostics>
    <diagnostic id="addType">Add @as attribute</diagnostic>
  </diagnostics>
  
  <!--====================================-->
  <!--              PHASE                 -->
  <!--====================================-->
  
  <!--<phase id="test">
    <active pattern="common"/>
    <active pattern="documentation"/>
    <active pattern="typing"/>
    <active pattern="namespaces"/>
    <active pattern="writing"/>
	</phase>-->

  <!--====================================-->
  <!--              MAIN                 -->
  <!--====================================-->
  
  <pattern id="common">
    <rule context="xsl:for-each" id="xsl_for-each">
      <report test="ancestor::xsl:template 
        and not(starts-with(@select, '$'))
        and not(starts-with(@select, 'tokenize('))
        and not(starts-with(@select, 'distinct-values('))
        and not(matches(@select, '\d'))" 
        role="warning">
        [common] Should you use xsl:apply-template instead of xsl:for-each 
      </report>
    </rule>
    <rule context="xsl:template/@match | xsl:*/@select | xsl:when/@test" id="use-resolve-uri-in-loading-function">
      <report test="contains(., 'document(concat(') or contains(., 'doc(concat(')">
        [common] Don't use concat within document() or doc() function, use resolve-uri instead (you may use static-base-uri() or base-uri())
      </report>
    </rule>
  </pattern>
  
  <pattern id="documentation">
    <rule context="/xsl:stylesheet">
      <assert test="xd:doc[@scope = 'stylesheet']">
        [documentation] Please add a documentation block for the whole stylesheet : &lt;xd:doc scope="stylesheet">
      </assert>
    </rule>
  </pattern>
  
  <pattern id="typing">
    <rule context="xsl:variable | xsl:param">
      <assert test="@as" diagnostics="addType">
        [typing] <name/> is not typed
      </assert>
    </rule>
  </pattern>
  
  <pattern id="namespaces">
    <rule context="xsl:template/@name | xsl:template/@mode | /*/xsl:variable/@name | /*/xsl:param/@name">
      <assert test="matches(., '^\w+:.*')" role="warning">
        [namespaces] <value-of select="local-name(parent::*)"/> @<name/> should be namespaces prefixed, so they don't generate conflict with imported XSLT (or when this xslt is imported)
      </assert>
    </rule>
    <rule context="@match | @select">
      <report test="contains(., '*:')">
        [namespaces] Use a namespace prefix instead of *:
      </report>
    </rule>
  </pattern>
  
  <pattern id="writing">
    <rule context="xsl:attribute | xsl:namespace | xsl:variable | xsl:param | xsl:with-param">
      <report id="useSelectWhenPossible"
        test="not(@select) and (count(* | text()[normalize-space(.)]) = 1) and (count(xsl:value-of | xsl:sequence | text()[normalize-space(.)]) = 1)">
        [writing] Use @select to assign a value to <name/>
      </report>
    </rule>
  </pattern>
  
</schema>
