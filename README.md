# XSLT Quality

XSLT Quality checks your XSLT to see if it adheres to good or best practices.

[xslt-quality.sch](src/main/sch/xslt-quality.sch): the master Schematron file. This is the one (and only) Schematron file you need to point to. It has a number of submodules for groups of tests:

- [xslt-quality.sch](src/main/sch/module/xslt-quality_mukulgandhi-rules.sch): Mukul Gandhi XSL QUALITY [rules](http://gandhimukul.tripod.com/xslt/xslquality.html)
- [xslt-quality_common.sch](src/main/sch/module/xslt-quality_common.sch): a few common tests without specific category
- [xslt-quality_documentation.sch](src/main/sch/module/xslt-quality_documentation.sch): tests on documentation
- [xslt-quality_namespaces.sch](src/main/sch/module/xslt-quality_namespaces.sch): tests regarding namespaces
- [xslt-quality_typing.sch](src/main/sch/module/xslt-quality_typing.sch): tests on variable / parameter types 
- [xslt-quality_writing.sch](src/main/sch/module/xslt-quality_writing.sch): tests on writing
- [xslt-quality_xslt-3.0.sch](src/main/sch/module/xslt-quality_xslt-3.0.sch): tests on specific XSLT 3.0 features

The modules listed above are subject to change in number, name, and contents, but the master Schematron file will not (from XSLT Quality 1.0.0)

The Schematron suite depends upon an XSLT library whose master file is here: 
[xslt-quality.xslt](src/main/xsl/xslt-quality.xsl).

## License

A subset of this code is a revision of code written by [Mukul Gandhi in his XSL QUALITY project](http://gandhimukul.tripod.com/xslt/xslquality.html). Special thanks to him for allowing me to implement his rules under Apache License Version 2.0.

All other code is released under Apache License Version 2.0

## Technical notes

### Modularization 

XSLT Quality uses schematron `sch:include` to load each sub-module. Unlike `xsl:include` that allow to load a full XSLT, `sch:include` works like replacing the call by the content of the module.

For this reason, submodule only contain `sch:pattern`, and every other sch elements (`sch:ns`, `sch:let`, `sch:diagnostic`, etc.) has to be declared in the main schematron [xslt-quality.sch](src/main/sch/xslt-quality.sch)

Some submodules might not be valid (missing variable, dignostic, etc.), but opening the Oxygen project ([xslt-quality.xpr](xslt-quality.xpr)) will show them valid as `xslt-quality.sch` has been added as "Master file" in the project.  

### role attribute
XSLT Quality is using Schematron applied on any XSLT and generates errors, warning and info. At this end we use the `@role` attribute.

### XSLT library : allow foreign

The main schematron imports [xslt-quality.xslt](src/main/xsl/xslt-quality.xsl) with `xsl:include` which is not a schematron element.
The Schematron engine you are using must support this extension, typically by setting `allow-foreign` parameter to true.

## Using XSLT Quality with Oxygen

First make sure "*Allow foreign elements (allow-foreign)*" is activated here:

1. Go to Options > Preferences > XML > XML Parser > Schematron
1. Check the box "Allow foreign elements (allow-foreign)" if it's not
1. Click OK

### Validating a single XSLT

You can use XSLT Quality in Oxygen by creating a validation scenario that you apply to the XSLT you want to valid.

### Automatic validation of each XSLT

It's also possible to get any XSLT in Oxygen to be validated with XSLT quality without applying any specific scenario. Do the following:

1. Go to Options > Preferences > Document type association
1. Select "XSLT" and click Edit
1. Go to "Validation" tab
1. Double click on the single scenario "XSLT"
1. Click Add
1. In the new entry click "XML Document" under File type.
1. Double-click on the Schema column.
1. Click Use custom schema, and use the URL bar to point to `xslt-quality.sch`
1. Click OK (Three times)

In this way, both Oxygen schematron and xslt-quality schematron will be applied to your XSLT.

## Configure xslt-quality

Not every XSLT programmer or organization has the same needs or styles. If you need more business specific rules, you can add your own schematron with Oxygen XSLT validation scenario. And if you find some common rules are missing in  xslt-quality, please open an issue here.

Xslt-quality is also highly configurable, you can easily control and calibrate xslt-quality thanks to an XML configuration.

### xslt-quality default conf file 

Xslt-quality is using its default configuration file at [xslt-quality.conf.xml](src/main/conf/xslt-quality.conf.xml), there are multiple manner to override this file, see next sections.

Let's see how this conf file works: it represents a hierarchic view of the architecture of [xslt-quality.sch](src/main/sch/xslt-quality.sch) with its modules (pattern), rules, assertions and reports, with and `@idref` attribute  (pointing to the corresponding schematron element). An extra `@activate` attribute allows to desactivate any of these elements. This mean desactivating the whole sub-elements.
That's why it's important that elements are nested to exactly reflect the real schematron hierarchy.

> Note : this file might generated automatically

Some parameters value might also be defined to refine some rules behaviour.

Extract from this conf:

```
<conf xmlns="https://github.com/mricaud/xsl-quality"
  ignore-roles="info">
  <module idref="xslt-quality_writing" active="true"/>
  <module idref="xslt-quality_namespaces" active="false"/>
  <module idref="xslt-quality_mukulgandhi-rules" active="true">
    <rule idref="xslqual-attributes">
      <report idref="xslqual-UsingNameOrLocalNameFunction"/>
      <report idref="xslqual-IncorrectUseOfBooleanConstants"/>
    </rule>
    <rule idref="xslqual-functions">
      <assert idref="xslqual-UnusedFunction" active="false"/>
      <assert idref="xslqual-UnusedParameter"/>
      <report idref="xslqual-FunctionComplexity">
        <param name="maxSize" as="xs:integer">50</param>
      </report>
    </rule>
  </module>
</conf>
```

### Override the default full conf

Oxygen doesn't allow to send parameters to schematron, but if your schematron processor allows it, you can override the parameter `$xslq:conf.uri` to use another file. Be careful, this file has to be full (declare every xslt-quality components: asssert/report at least).

### Overide conf at stylesheet level

adding `{https://github.com/mricaud/xsl-quality}conf` as a 2nd-level element in the stylesheet to be tested, with children referencing any module/pattern/rule/assert/report by `idref` to activate it or not. An example:

```
<conf xmlns="https://github.com/mricaud/xsl-quality" ignore-roles="info warning">
  <assert idref="xslqual-UnusedFunction" active="true"/>
  <assert idref="xslqual-UnusedParameter" active="false"/>
  <report idref="xslqual-FunctionComplexity">
    <param name="maxSize">5</param>
  </report>
</conf>
```

This conf doesn't need to be full neither nested a the default conf. It's a local conf aiming at overriding the full conf file at [xslt-quality.conf.xml](src/main/conf/xslt-quality.conf.xml). You can desactivate any rules here, or change the value of a param.

> Note : the hierarchy impact the full conf : if you desactivate one level, every subcomponent will be desactivated as well.

As you can see in the exemple you can also override parameters value used in some component (see [xslt-quality.conf.xml](src/main/conf/xslt-quality.conf.xml) to get them all)

You may place that element anywhere in the stylesheet being tested, at the beginning, the end, or the middle, but it must be a child of the root element `xsl:transform` or `xsl:stylesheet`.

### Override conf at stylesheet component level

You can add an attribute `xslq:ignore` on any element of your stylesheet. The value is a list of assert/="xslqual-FunctionComplexity"

## MAVEN

Later, I intend to make XSLT-quality available on Maven Central, then you should be able to load `xslt-quality.sch` (or any module) from a jar distribution with a catalog.xml, using "artefactId:/" as protocol and/or using the 
[cp protocol](https://github.com/cmarchand/cp-protocol) by [cmarchand](https://github.com/cmarchand)

## TODO

- [#4](https://github.com/mricaud/xslt-quality/issues/4) Move rule "use-resolve-uri-in-loading-function" elsewhere cause it's too specific?
- [#5](https://github.com/mricaud/xslt-quality/issues/5) Use [quickFix](http://www.schematron-quickfix.com/quickFix/guide.html) / diagnostic?
- [#6](https://github.com/mricaud/xslt-quality/issues/6) Check for conventions: 
    - https://google.github.io/styleguide/xmlstyle.html
    - http://blog.xml.rocks/xslt-naming-conventions
    - http://blog.xml.rocks/structuring-xslt-code
- [#7](https://github.com/mricaud/xslt-quality/issues/7) xsl-qual : have a look at comments on http://markmail.org/message/y5cunpvfpy54wqe6
- [#8](https://github.com/mricaud/xslt-quality/issues/8) Named template for generating XML elements VS functions to return atomic values as a good practice?
- [#9](https://github.com/mricaud/xslt-quality/issues/9) Should the template ordering be watched by the schematron (copy template at the end, templates with @mode together, etc.)
- [#10](https://github.com/mricaud/xslt-quality/issues/10) Unused templates, functions, global variables/parameters might not be an error (when the xsl is a library)
- [#11](https://github.com/mricaud/xslt-quality/issues/11) Check that XSLT default templates are not used like:

    ```xml 
    <xsl:template match="/">
      <xsl:apply-template>
    </xsl:template>
    ```

- [#12](https://github.com/mricaud/xslt-quality/issues/12) Using `<xsl:value-of>` where `<xsl:sequence>` is enough
- [#13](https://github.com/mricaud/xslt-quality/issues/13) Writing:

   That means parsing the xsl as text here, something like:
   
    ```xml 
    <sch:let name="xslt.txt" select="unparse-text(base-uri(/))"/>
    ```
   
    - indent with spaces 
    - No break line inside templates
    - Space around operators ( =, +, > etc)
