<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xml:lang="en"
  id="xslt-quality_parameters">
  
  <xd:doc>
    <xd:desc>
      <xd:p>These rules are about parameters to calibrate the rules applied by XSLQ</xd:p>
    </xd:desc>
  </xd:doc>
  
  
  
  <rule context="/*/xslq:parameters">
    <xd:doc>
      <xd:desc xml:lang="en">Add parameter values.</xd:desc>
    </xd:doc>
    <report test="not(*)" id="xslt-quality_empty-parameters" sqf:fix="sqf_parameters">
      [parameters] Add children elements specifying parameters, with their value as text nodes
      inside. </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">See if the user needs help.</xd:desc>
    </xd:doc>
    <report test="exists(help) or exists(xslq:help)" sqf:fix="sqf_parameters">
      [parameters] [help] Try one of the following parameters: 
      <value-of select="string-join($xslq:xslq.parameters.unused/@name, ', ')"/>
    </report>
    
    
    <sqf:group id="sqf_parameters">
      <sqf:fix id="sqf_add-parameters" use-for-each="1 to count($xslq:xslq.parameters.unused)">
        <sqf:description>
          <sqf:title>Add parameter <sch:value-of select="$xslq:xslq.parameters.unused[$sqf:current]/@name"/>
          </sqf:title>
        </sqf:description>
        <!-- Move the final white space to after the new element -->
        <sqf:delete match="text()[last()][not(matches(., '\S'))]"/>
        <sqf:add match="." position="last-child">
          <!-- Imitate the indentation of the document -->
          <xsl:value-of select="$xslq:self.indentations.typical[2]"/>
          <xsl:element name="{$xslq:xslq.parameters.unused[$sqf:current]/@name}">
            <xsl:value-of
              select="replace(tokenize($xslq:xslq.parameters.unused[$sqf:current]/@select, ' +')[last()], '\(\)', '')"/>
          </xsl:element>
          <xsl:value-of select="text()[last()][not(matches(., '\S'))]"/>
        </sqf:add>
      </sqf:fix>
    </sqf:group>
  </rule>
  
  <rule context="/*/xslq:parameters/*">
    <let name="this-name" value="name(.)"/>
    <let name="this-corresponding-xslq-param"
      value="$xslq:xslq-parameter-file/*/xsl:param[@name eq $this-name]"/>
    <let name="expected-data-type" value="$this-corresponding-xslq-param/@as"/>
    <let name="this-value-is-castable" value="xslq:data-type-check(., $expected-data-type)"/>
    <xd:doc>
      <xd:desc xml:lang="en">Check for parameters with the wrong name.</xd:desc>
    </xd:doc>
    <assert test="exists($this-corresponding-xslq-param)" sqf:fix="sqf_del_element">
      [parameters] Children elements of xslq:parameters must have a name that matches
      a global parameter.
    </assert>
    <assert test="$this-value-is-castable" sqf:fix="sqf_del_element">
      [parameters] <value-of select="name(.)"/> must be castable as <value-of select="$expected-data-type"/>
    </assert>
    
    <sqf:fix id="sqf_del_element">
      <sqf:description>
        <sqf:title>Delete current element</sqf:title>
      </sqf:description>
      <sqf:delete/>
    </sqf:fix>
  </rule>
  
  
</pattern>