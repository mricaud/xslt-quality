# XSLT Quality

This repo is about testing your XSLT quality.
At this point, it contains 2 schematron aiming at being applied to your XSLT :

- `xsl-quality.sch` : an iso-schematron implementation of [Mukul Gandhi XSL QUALITY xslt]      (http://gandhimukul.tripod.com/xslt/xslquality.html)
- `checkXSLTstyle.sch` : it extends xsl-quality.sch by adding specific rules

## Using `checkXSLTstyle.sch` with oXygen 19+ 

OXygen v19 has a default schematron which is automaticaly applied to any edited XSLT, aiming at checking code quality :

`[INSTALL.DIR]\Oxygen XML Developer 19\frameworks\xslt\sch\xsltCustomRules.sch`

You can customize this schematron by adding : 

```xml
<sch:extends href="https://github.com/mricaud/xslt-quality/tree/master/src/main/sch/checkXSLTstyle.sch"/>
```

In this way, both xsltCustomRules.sch and checkXSLTstyle.sch will be applied to your XSLT.

NB : one can not use <sch:include> as explain here : (https://www.oxygenxml.com/forum/topic6804.html)