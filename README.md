# XSLT Quality

XSLT Quality checks your XSLT to see if it adheres to good or best practices.

[xslt-quality.sch](src/main/sch/xslt-quality.sch): the master Schematron file. This is the one (and only) Schematron file you need to point to. It has a number of submodules for groups of tests:

- [xslt-quality.sch](src/main/sch/modules/xslt-quality_mukulgandhi-rules.sch): Mukul Gandhi XSL QUALITY [rules](http://gandhimukul.tripod.com/xslt/xslquality.html)
- [xslt-quality_common.sch](src/main/sch/modules/xslt-quality_common.sch): a few common tests without specific category
- [xslt-quality_documentation.sch](src/main/sch/modules/xslt-quality_documentation.sch): tests on documentation
- [xslt-quality_namespaces.sch](src/main/sch/modules/xslt-quality_namespaces.sch): tests regarding namespaces
- [xslt-quality_typing.sch](src/main/sch/modules/xslt-quality_typing.sch): tests on variable / parameter types 
- [xslt-quality_writing.sch](src/main/sch/modules/xslt-quality_writing.sch): tests on writing
- [xslt-quality_xslt-3.0.sch](src/main/sch/modules/xslt-quality_xslt-3.0.sch): tests on specific XSLT 3.0 features

The modules listed above are subject to change in number, name, and contents, but the master Schematron file will not (from XSLT Quality 1.0.0)

The Schematron suite depends upon an XSLT library whose master file is here: 
[xslt-quality.xslt](src/main/xsl/xslt-quality.xsl).

> Beware : the links above point to the source code, but xslt-quality is a compiled project, please read the section "How to install xslt-quality" for more information.  

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

## Xslt-quality configuration 

Not every XSLT programmer or organization has the same needs or styles. If you need more business specific rules, you can add your own schematron with Oxygen XSLT validation scenario. And if you find some common rules are missing in  xslt-quality, please open an issue here.

Xslt-quality is also highly configurable, you can easily control and calibrate xslt-quality thanks to an XML configuration.

### xslt-quality default conf file 

Xslt-quality is using its default internal configuration file, there are multiple manner to override this file, see next sections.

Let's see how this conf file works: it represents a hierarchic view of the architecture of [xslt-quality.sch](src/main/sch/xslt-quality.sch) with its pattern, rules, assertions and reports, with and `@idref` attribute  (pointing to the corresponding schematron element). An extra `@activate` attribute allows to deactivate any of these elements. This means deactivating the whole sub-elements. That's why it's important that elements are nested to exactly reflect the real schematron hierarchy.

> Note : The internal xslt-quality default configuration file is not available from sources because it's generated. You can find the generated from source version within the distribution under `conf/xslt-quality.conf.xml`.

Some parameters value might also be defined to refine some rules behaviour.

Extract from this conf:

```
<conf xmlns="https://github.com/mricaud/xsl-quality">
  <param name="xslqual-FunctionComplexity-maxSize">50</param>
  <pattern idref="xslt-quality_writing" active="true"/>
  <pattern idref="xslt-quality_namespaces" active="true"/>
  <pattern idref="xslt-quality_mukulgandhi-rules" active="true">
    <rule idref="xslqual-attributes" active="true">
      <report idref="xslqual-UsingNameOrLocalNameFunction" active="true"/>
      <report idref="xslqual-IncorrectUseOfBooleanConstants" active="true"/>
    </rule>
    <rule idref="xslqual-functions" active="true">
      <assert idref="xslqual-UnusedFunction" active="true"/>
      <assert idref="xslqual-UnusedParameter" active="true"/>
      <report idref="xslqual-FunctionComplexity" active="true"/>
    </rule>
  </module>
</conf>
```

### Override the default full conf

Oxygen doesn't allow to send parameters to schematron, but if your schematron processor allows it, you can override the parameter `$xslq:conf.uri` to use another file. Be careful, this file has to be full (declare every xslt-quality components: asssert/report at least).

### Overide conf at stylesheet level

adding `{https://github.com/mricaud/xsl-quality}conf` as a 2nd-level element in the stylesheet to be tested, with children referencing any modules/pattern/rule/assert/report by `idref` to activate it or not. You can also override parameters value used in some component (use oxygen conf.rng completion to see all parameters)

For example:

```
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <param name="xslqual-FunctionComplexity-maxSize">100</param>
    <assert idref="xslqual-UnusedParameter" active="false"/>
  </conf>

  <xsl:template match="some-elements">
    <!--do something-->
  </xsl:template>
  
</xsl:stylesheet>
```

This conf doesn't need to be full neither nested as the default conf. It's a local conf aiming at overriding the defaut full conf file. You can deactivate any rules here, or change the value of a param.

> Note : if you deactivate one level, its subcomponents will be deactivated as well according to the full conf hierarchy.

#### Importing a shared conf

If some of you XSLT shares the same conf settings, you can define it in a single file and import this file from your XSLT.

For example:

```
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <include href="my-custom-conf.xml"/>
    <!-- You can also add extra settings here -->   
    <assert idref="xslqual-RedundantNamespaceDeclarations"/>
  </conf>

  <xsl:template match="some-elements">
    <!--do something-->
  </xsl:template>
  
</xsl:stylesheet>
```

With the following conf file next to your XSLT `my-custom-conf.xml`:

```
<conf xmlns="https://github.com/mricaud/xsl-quality">
  <param name="xslqual-FunctionComplexity-maxSize">100</param>
  <assert idref="xslqual-UnusedParameter" active="false"/>
</conf>
```

> Conf files might be imported reccursively. When 2 settings rules are defined twice (or more), the last one value from the XSLT file is used, like CSS rules.

### Defining and using aliases

In any conf setting you can define aliases id so you can reference it later.

```
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <conf xmlns="https://github.com/mricaud/xsl-quality">
    <include href="my-alias-def.xml"/>
    <!-- calling an custom alias to deactivate multiple rules at once -->   
    <assert idref="my-alias-for-checking-namespace" active="false" />
  </conf>

  <xsl:template match="some-elements">
    <!--do something-->
  </xsl:template>
  
</xsl:stylesheet>
```

```
<conf xmlns="https://github.com/mricaud/xsl-quality">
  <aliasdef id="my-alias-for-checking-namespace">
    <assert idref="xslt-quality_ns-global-statements-need-prefix"/>
    <assert idref="xslqual-RedundantNamespaceDeclarations"/>
  </aliasdef>  
</conf>
```

### Override conf at stylesheet component level

You can add an attribute `xslq:ignore` on any element of your stylesheet. The value is a list of schematron component id references (space separated values).

For example:

```
<xsl:variable name="unused" as="xs:string" xslq:ignore="xslqual-UnusedVariable xslt-quality_use-select-attribute-when-possible">unused</xsl:variable>
```

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
1. Click `Use custom schema`, and use the URL bar to point to `xslt-quality.sch` within the distribution, it should look like this: 

    `jar:file:C:\path\to\xslt-quality-1.0.0-RC1.jar!/sch/xslt-quality.sch`

1. Click OK (Three times)

In this way, both Oxygen default schematron and xslt-quality schematron are applied to your XSLT.

### Configuration setting validation and completion with Oxygen

#### Conf completion

This section describle how to allow Oxygen to suggest schema aware completion on xsl-quality conf fragment within your XSLT.

1. Go to Options > Preferences > Editor > Content Completion > XSLT
1. Check *Custom Schema* and fill in the field with:

    `jar:file:C:\path\to\xslt-quality-1.0.0-RC1.jar!/grammars/xslt-embeded-xslq-conf.rng`

Once this is done, you now have code completion from you XSLT for any elements or attribute. This is realy helpfull for `<param name="..."/>` or any other elements like `<pattern idref="...">`, `<rule idref="...">`, `<assert idref="...">` or `<report idref="...">`.

> Note: `<aliases idref="..."/>` won't be listed in the content completion, cause it depends on you own aliases definition.

#### Conf validation

This section describe how to set the xslt-quality configuration fragment validation from within your XSLT.

1. Go to Options > Preferences > Document type association
1. Select "XSLT" and click Edit
1. Go to "Validation" tab
1. Double click on the single scenario "XSLT"
1. Click Add
1. In the new entry click "XML Document" under File type.
1. Double-click on the Schema column.
1. Click `Use custom schema`, and use the URL bar to point to `xslt-embeded-xslq-conf.rng` within the distribution, it should look like this: 

    `jar:file:C:\path\to\xslt-quality-1.0.0-RC1.jar!/grammars/xslt-embeded-xslq-conf.rng`

1. Click OK (Three times)

Once this is done, you will be able to see any validation errors on xslt-quality configuration fragment from within your XSLT.

## How to install xslt-quality

### Downloading the distribution


### Using Maven

Later, I intend to make XSLT-quality available on Maven Central, then you should be able to load `xslt-quality.sch` (or any module) from a jar distribution with a catalog.xml, using "artefactId:/" as protocol and/or using the 
[cp protocol](https://github.com/cmarchand/cp-protocol) by [cmarchand](https://github.com/cmarchand)

# TODO Release

## 1.0.0-RC1

- TU sur les schematron avec conf notamment
- default conf : schéma spécifique car c'est différent (imbrication comme aliasdef mais infini)
- ~~namespace + nom éléments : conf-override + conf-structure ? non tant pis~~
- Packaging zip avec assembly (generate-source ok ?)
  - https://xnopre.blogspot.com/2012/11/maven-generer-un-zip-contenant-un-autre.html
  - https://stackoverflow.com/questions/7837778/maven-best-practice-for-creating-ad-hoc-zip-artifact
- ~~update README : install oxygen zip + réglage completion + validation~~ 
- voir si on peut mettre fichier de conf en paramètre dans oxy (ou conf à côté de la xsl ? bof)
- Intégrer schematron quick fix de Joël
- publication maven central et/ou ajouter release dans github ?

## 1.0.0-RC2

- TU xsl : pas obligé
- ajouter ignore-role="info/warning/error"
- Dependance vers xut pour résolution des includes - rendre xut plus parametrable
- Dépendance xslLib (à publier sur mv central) : pas obligé
- Renommer globalement les id, mettre xslq comme préfixe partout puis le nom de l'assert/report simple
  - le nom du pattern pourra être ajouté en préfixe automatiquement au build [XSLQ][{pattern/@id}]