# XSLT Quality

XSLT Quality checks your XSLT to see if it adheres to good or best practices.

[checkXSLTstyle.sch](src/main/sch/checkXSLTstyle.sch): the master Schematron file. This is the one (and only) Schematron file you need to point to. It has a number of submodules for groups of tests:
- [xslt-quality.sch](src/main/sch/module/xslt-quality.sch): general-purpose tests
- [xslt-quality_common.sch](src/main/sch/module/xslt-quality_common.sch): a few common tests
- [xslt-quality_documentation.sch](src/main/sch/module/xslt-quality_documentation.sch): tests on documentation
- [xslt-quality_namespaces.sch](src/main/sch/module/xslt-quality_namespaces.sch): tests regarding namespaces
- [xslt-quality_typing.sch](src/main/sch/module/xslt-quality_typing.sch): tests on variable / parameter types 
- [xslt-quality_writing.sch](src/main/sch/module/xslt-quality_writing.sch): tests on writing
- [xslt-quality_writing.sch](src/main/sch/module/xslt-quality_writing.sch): tests on XSLT 3.0

The modules listed above are subject to change in number, name, and contents, but the master Schematron file will not.

The Schematron suite depends upon an XSLT library whose master file is here: 
[xslt-quality.xslt](src/main/xsl/xslt-quality.xsl).

## License

A subset of this code is a revision of code written by [Mukul Gandhi in his XSL QUALITY project](http://gandhimukul.tripod.com/xslt/xslquality.html). Special thanks to him for allowing me to implement his rules under Apache License Version 2.0.

All other code is released under....

## Using XSLT Quality with Oxygen

To use XSLT Quality in Oxygen do the following:

1. Open up an XSLT file.
1. Click Configure Validation Scenario(s)... (picture of a wrench over a red check mark)
1. Select the XSLT option and click "Duplicate," and give the new option a name such as XSLT Quality.
1. Delete the items there (they will get applied in parallel)
1. Click Add.
1. In the new entry click "XML Document" under File type.
1. Double-click on the Schema column.
1. Click Use custom schema, and use the URL bar to point to `checkXSLTstyle.sch`.
1. Click OK (twice).
1. Back in the Configure Validation Scenario(s) menu, click the checkboxes for both the XSLT and the new scenario you have created.
1. Click Save and Close.

That may seem like a lot of steps, but each one is pretty straightforward. If you are uncertain, open up the [XSLT Quality project file](xslt-quality.xpr) and then open up [xslt-quality.xslt](src/main/xsl/xslt-quality.xsl). If you click on the Configure Validation Scenario(s)... menu you will see the result of the above steps.

Here is another method. From version 19, Oxygen has a default schematron automaticaly applied to any edited XSLT, aiming at checking code quality:

`[INSTALL.DIR]/Oxygen XML Developer [version]/frameworks/xslt/sch/xsltCustomRules.sch`

(or `xsltDocCheck.sch` for Oxygen 19.1+)

To apply xslt-quality schematron you have to customize Oxygen's schematron like this:

- Be sure you have the rights privileges to write this file
 
- Change the query binding to xslt3 : `queryBinding="xslt3"`
 
    Because the xslt-quality schematron is using xslt 3.0 functions, it is necessary to harmonize every schematron.

- Add this line after the namespaces declarations (<sch:ns>): 

    ```xml
    <sch:extends href="[path.to.local.clone]/xslt-quality/src/main/sch/checkXSLTstyle.sch"/>
    ```
    
> - one cannot use `<sch:include>` as explained [here](https://www.oxygenxml.com/forum/topic6804.html);
> - You also could load only one (or more) module(s) independently like `xsl-quality.sch`.

- **Finally** make sure "*Allow foreign elements (allow-foreign)*" is activated here: 
    
    `Options > Preferences > XML > XML Parser > Schematron` 

    Because xslt-quality schematron embeds xslt functions, to construct XPath expressions in the tests.

In this way, both Oxygen schematron (`xsltCustomRules.sch` or `xsltDocCheck.sch`) and xslt-quality schematron (`checkXSLTstyle.sch`) will be applied to your XSLT.

Later, I intend to make this repo available on Maven Central, then you should be able to load `checkXSLTstyle.sch` (or any module) from a jar distribution with a catalog.xml, using "artefactId:/" as protocol and/or using the 
[cp protocol](https://github.com/cmarchand/cp-protocol) by [cmarchand](https://github.com/cmarchand)

## TODO

1. [#4](https://github.com/mricaud/xslt-quality/issues/4) Move rule "use-resolve-uri-in-loading-function" elsewhere cause it's too specific?
1. [#5](https://github.com/mricaud/xslt-quality/issues/5) Use [quickFix](http://www.schematron-quickfix.com/quickFix/guide.html) / diagnostic?
1. [#6](https://github.com/mricaud/xslt-quality/issues/6) Check for conventions: 
    - https://google.github.io/styleguide/xmlstyle.html
    - http://blog.xml.rocks/xslt-naming-conventions
    - http://blog.xml.rocks/structuring-xslt-code
1. [#7](https://github.com/mricaud/xslt-quality/issues/7) xsl-qual : have a look at comments on http://markmail.org/message/y5cunpvfpy54wqe6
1. [#8](https://github.com/mricaud/xslt-quality/issues/8) Named template for generating XML elements VS functions to return atomic values as a good practice?
1. [#9](https://github.com/mricaud/xslt-quality/issues/9) Should the template ordering be watched by the schematron (copy template at the end, templates with @mode together, etc.)
1. [#10](https://github.com/mricaud/xslt-quality/issues/10) Unused templates, functions, global variables/parameters might not be an error (when the xsl is a library)
1. [#11](https://github.com/mricaud/xslt-quality/issues/11) Check that XSLT default templates are not used like:

    ```xml 
    <xsl:template match="/">
      <xsl:apply-template>
    </xsl:template>
    ```

1. [#12](https://github.com/mricaud/xslt-quality/issues/12) Using `<xsl:value-of>` where `<xsl:sequence>` is enough
1. [#13](https://github.com/mricaud/xslt-quality/issues/13) Writing:

   That means parsing the xsl as text here, something like:
   
    ```xml 
    <sch:let name="xslt.txt" select="unparse-text(base-uri(/))"/>
    ```
   
    1. indent with spaces 
    1. No break line inside templates
    1. Space around operators ( =, +, > etc)
