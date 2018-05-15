# XSLT Quality

This repo is about testing your XSLT quality.
It contains a main schematron to be applied to your XSLT:

- `checkXSLTstyle.sch`: it doesn't contain any rules, it's only a wrapper to extend rules of each modules:
  - `xsl-quality.sch`: an iso-schematron implementation of [Mukul Gandhi XSL QUALITY xslt](http://gandhimukul.tripod.com/xslt/xslquality.html). 
     Special thanks to him for allowing me implementing his rules under Apache License Version 2.0.
  - `xsl-common.sch`: common schematron rules for good XSLT practice

You may use the main schematron wrapper or only the module you wish.

## Using XSLT schematron with Oxygen 19+ 

From version 19, Oxygen has a default schematron which is automaticaly applied to any edited XSLT, aiming at checking code quality:

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

    Because xslt-quality schematron embeds xslt function to make xpath rules easier to write.

In this way, both Oxygen schematron (`xsltCustomRules.sch` or `xsltDocCheck.sch`) and xslt-quality schematron (`checkXSLTstyle.sch`) will be applied to your XSLT.

Later, I intend to make this repo available on Maven Central, then you should be able to load `checkXSLTstyle.sch` (or any module) from a jar distribution with a catalog.xml, using "artefactId:/" as protocol and/or using the 
[cp protocol](https://github.com/cmarchand/cp-protocol) by [cmarchand](https://github.com/cmarchand)

## TODO

1. #4 Move rule "use-resolve-uri-in-loading-function" elsewhere cause it's too specific?
1. #5 Use [quickFix](http://www.schematron-quickfix.com/quickFix/guide.html) / diagnostic?
1. #6 Check for conventions: 
    - https://google.github.io/styleguide/xmlstyle.html
    - http://blog.xml.rocks/xslt-naming-conventions
    - http://blog.xml.rocks/structuring-xslt-code
1. #7 xsl-qual : have a look at comments on http://markmail.org/message/y5cunpvfpy54wqe6
1. #8 Named template for generating XML elements VS functions to return atomic values as a good practice?
1. #9 Should the template ordering be watched by the schematron (copy template at the end, templates with @mode together, etc.)
1. #10 Unused templates, functions, global variables/parameters might not be an error (when the xsl is a library)
1. #11 Check that XSLT default templates are not used like:

    ```xml 
    <xsl:template match="/">
      <xsl:apply-template>
    </xsl:template>
    ```

1. #12 Using `<xsl:value-of>` where `<xsl:sequence>` is enough
1. #13 Writing:

   That mean parsing the xsl as text here, something like:
   
    ```xml 
    <sch:let name="xslt.txt" select="unparse-text(base-uri(/))"/>
    ```
   
    1. indent with spaces 
    1. No break line inside templates
    1. Space around operators ( =, +, > etc)
