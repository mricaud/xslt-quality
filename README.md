# XSLT Quality

This repo is about testing your XSLT quality.
It contains a main schematron to be applied to your XSLT :

- `checkXSLTstyle.sch` : it doesn't contains any rules, it's only a wrapper to extends rules of each modules : 

    - `xsl-quality.sch` : an iso-schematron implementation of [Mukul Gandhi XSL QUALITY xslt](http://gandhimukul.tripod.com/xslt/xslquality.html)
    - `xsl-common.sch` : common schematron rules for good XSLT practice

You may use the main schematron wrapper or only the module you wish.

## Using XSLT schematron with oXygen 19+ 

OXygen v19 has a default schematron which is automaticaly applied to any edited XSLT, aiming at checking code quality :

`[INSTALL.DIR]/Oxygen XML Developer 19/frameworks/xslt/sch/xsltCustomRules.sch`

You can customize this schematron by adding : 

```xml
<sch:extends href="[path.to.local.clone]/xslt-quality/src/main/sch/checkXSLTstyle.sch"/>
```

- one can not use `<sch:include>` as explain [here](https://www.oxygenxml.com/forum/topic6804.html)
- You also may only load one (or more) modules independantly like `xsl-quality.sch`

In this way, both xsltCustomRules.sch and checkXSLTstyle.sch will be applied to your XSLT.

Later I intend to make this repo available on Maven Central, you should be able to load `checkXSLTstyle.sch` (or any module) from a jar distribution with a catalog.xml, using "artefactId:/" as protocol and/or using the 
[cp protocol](https://github.com/cmarchand/cp-protocol) by [cmarchand](https://github.com/cmarchand)

## TODO

- Move rule "use-resolve-uri-in-loading-function" elsewhere cause it's too specific ?
- Use [quickFix](http://www.schematron-quickfix.com/quickFix/guide.html) / diagnostic ?
- Check for conventions : 
    - https://google.github.io/styleguide/xmlstyle.html
    - http://blog.xml.rocks/xslt-naming-conventions
    - http://blog.xml.rocks/structuring-xslt-code
- xsl-qual : have a look at comments on http://markmail.org/message/y5cunpvfpy54wqe6
- Named template for generating XML elements VS functions to return atomic values as a good practice
- Should the template ordering be watched by the schematron (copy template at the end, templates with @mode together)
- Unused template or functions might not be an error (when the xsl is a library)
- Check that XSLT default templates are not used like :

    ```xml 
    <xsl:template match="/">
      <xsl:apply-template>
    </xsl:template>
    ```

- Using `<xsl:value-of>` where `<xsl:sequence>` is enough
- Writing : 
    - indent with spaces 
    - No break line inside templates
    - Space around operators ( =, +, > etc)
