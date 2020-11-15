# XSLT Quality

XSLT Quality checks your XSLT to see if it adheres to good or best practices.

[xslt-quality.sch](src/main/sch/xslt-quality.sch): the master Schematron file. This is the one (and only) Schematron file you need to point to. It has a number of submodules for groups of tests:

- [xslt-quality.sch](src/main/sch/module/xslt-quality_mukulgandhi-rules.sch): Mukul Gandhi XSL QUALITY [rules](http://gandhimukul.tripod.com/xslt/xslquality.html)
- [xslt-quality_common.sch](src/main/sch/module/xslt-quality_common.sch): a few common tests
- [xslt-quality_documentation.sch](src/main/sch/module/xslt-quality_documentation.sch): tests on documentation
- [xslt-quality_namespaces.sch](src/main/sch/module/xslt-quality_namespaces.sch): tests regarding namespaces
- [xslt-quality_typing.sch](src/main/sch/module/xslt-quality_typing.sch): tests on variable / parameter types 
- [xslt-quality_writing.sch](src/main/sch/module/xslt-quality_writing.sch): tests on writing
- [xslt-quality_writing.sch](src/main/sch/module/xslt-quality_writing.sch): tests on XSLT 3.0

The modules listed above are subject to change in number, name, and contents, but the master Schematron file will not (from XSLT Quality 1.0.0)

The Schematron suite depends upon an XSLT library whose master file is here: 
[xslt-quality.xslt](src/main/xsl/xslt-quality.xsl).

## License

A subset of this code is a revision of code written by [Mukul Gandhi in his XSL QUALITY project](http://gandhimukul.tripod.com/xslt/xslquality.html). Special thanks to him for allowing me to implement his rules under Apache License Version 2.0.

All other code is released under Apache License Version 2.0

## Technical notes

XSLT Quality is using Schematron applied on any XSLT and generates errors, warning and info. At this end we use the `@role` attribute.

The main schematron imports [xslt-quality.xslt](src/main/xsl/xslt-quality.xsl) with `xsl:include` which is not a schematron element.
The Schematron engine you are using must then this extension, typically by setting `allow-foreign` parameter to true.

Later, I intend to make this repo available on Maven Central, then you should be able to load `xslt-quality.sch` (or any module) from a jar distribution with a catalog.xml, using "artefactId:/" as protocol and/or using the 
[cp protocol](https://github.com/cmarchand/cp-protocol) by [cmarchand](https://github.com/cmarchand)

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
