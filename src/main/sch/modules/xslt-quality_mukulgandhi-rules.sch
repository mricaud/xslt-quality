<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xslq="https://github.com/mricaud/xsl-quality"
  xml:lang="en"
  id="xslqual_mukulgandhi">
  
  <xd:doc>
    <xd:desc>
      <xd:p>These rules are a schematron implementation of Mukul Gandhi XSL QUALITY xslt at <xd:a href="http://gandhimukul.tripod.com/xslt/xslquality.html">http://gandhimukul.tripod.com/xslt/xslquality.html</xd:a>
      </xd:p>
      <xd:p>Some rules have not bee reproduced:</xd:p>
      <xd:ul>
        <xd:li>xslqual-NullOutputFromStylesheet</xd:li>
        <xd:li>xslqual-DontUseNodeSetExtension</xd:li>
        <xd:li>xslqual-ShortNames</xd:li>
        <xd:li>xslqual-NameStartsWithNumeric</xd:li>
      </xd:ul>
    </xd:desc>
  </xd:doc>
  
  <rule context="xsl:stylesheet" id="xslqual_stylesheet">
    
    <xd:doc>
      <xd:desc xml:lang="en">Consider it's not usefull to keep unused prefix declaration. Delete them will make the xslt lighter and easier to read.</xd:desc>
      <xd:desc xml:lang="fr">On considère qu'il n'est pas nécessaire de conserver les déclarations de préfixe qui ne sont pas utilisé. Les supprimer rendra la XSLT moins lourde et plus lisible.</xd:desc>
    </xd:doc>
    <assert id="xslqual-RedundantNamespaceDeclarations" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-RedundantNamespaceDeclarations'))) then (true()) else(
      every $s in in-scope-prefixes(.)[not(. = ('xml', ''))] satisfies 
      exists(//(*[not(self::xsl:stylesheet)] | @*[not(parent::xsl:*)] | xsl:*/@select | xsl:*/@as | xsl:*/@name | xsl:*/@mode)
      [starts-with(name(), concat($s, ':')) or starts-with(., concat($s, ':'))])
      )">
      <!--[xslqual] There are redundant namespace declarations in the xsl:stylesheet element-->
      [xslqual-RedundantNamespaceDeclarations] There are namespace prefixes that are declared in the xsl:stylesheet element but never used anywhere 
    </assert>
    
    <xd:doc>
      <xd:desc xml:lang="en">Consider using too much template in the same XSLT make it difficult to read, maybe the code might be split in several modules.</xd:desc>
      <xd:desc xml:lang="fr">On considère qu'utiliser trop de template rend la XSLT difficile à lire, peut-être que le code devrait être découpé en modules</xd:desc>
    </xd:doc>
    <report id="xslqual-TooManySmallTemplates" role="info"
      test="if(not(xslq:is-active(., 'xslqual-TooManySmallTemplates'))) then (false()) else(
      count(//xsl:template[@match and not(@name)][count(*) &lt; 3]) &gt;= 10
      )">
      [xslqual-TooManySmallTemplates] Too many low granular templates in the stylesheet (10 or more)
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">It looks suspicious to have only one template or function in an XSL. If it contains one single template with xsl:for-each inside it could be a non-declarative XSL which is not recommended</xd:desc>
      <xd:desc xml:lang="fr">N'avoir qu'un seul template (ou fonction) dans une XSL est suspect. Si elle ne contient qu'un template avec des xsl:for-each à l'intérieur, alors ça peut être signe d'une XSL non-déclarative ce qui n'es pas recommandé</xd:desc>
    </xd:doc>
    <report id="xslqual-MonolithicDesign" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-MonolithicDesign'))) then (false()) else(
      count(//xsl:template | //xsl:function) = 1
      )">
      [xslqual-MonolithicDesign] Using a single template/function in the stylesheet. You can modularize the code.
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Not declarating the xs prefix probably mean you will probably not be typing your code (variable, param, functions, etc.)</xd:desc>
      <xd:desc xml:lang="fr">Ne pas déclarer le préfixe xs signifie que vous n'allez probablement pas typé votre code (variable, paramètre, fonctions, etc.)</xd:desc>
    </xd:doc>
    <report id="xslqual-NotUsingSchemaTypes" role="info"
      test="if(not(xslq:is-active(., 'xslqual-NotUsingSchemaTypes'))) then (false()) else(
      (@version = ('2.0', '3.0')) and not(some $x in .//@* satisfies contains($x, 'xs:'))
      )">
      [xslqual-NotUsingSchemaTypes] The stylesheet is not using any of the built-in Schema types (xs:string etc.), when working in XSLT <value-of select="@version"/> mode
    </report>
  </rule>
  
  <rule context="xsl:output" id="xslqual_output">
    <xd:doc>
      <xd:desc xml:lang="en">XSLT has the ability to produce a real HTML output serialisation: it will for instance not auto-unclose script tag making it works. It's really recommended to use this serialisation when generating HTML output.</xd:desc>
      <xd:desc xml:lang="fr">XSLT permet de produire une vraie sérialisation HTML : cela va par exemple ne pas auto-fermer les balise script, ce qui les fera fonctionner. Il est vivement recommandé d'utiliser cette sérialisation quand vous générez du HTML.</xd:desc>
    </xd:doc>
    <report id="xslqual-OutputMethodXml"
      test="if(not(xslq:is-active(., 'xslqual-OutputMethodXml'))) then (false()) else(
      (@method = 'xml') and starts-with(//xsl:template[.//html or .//HTML]/@match, '/')
      )">
      [xslqual_output] Using the output method 'xml' when generating HTML code
    </report>
  </rule>
  
  <rule context="xsl:variable" id="xslqual_variable">
    
    <xd:doc>
      <xd:desc xml:lang="en">XSLT doesn't need to be more verbose than it is. Using xsl:value-of has a really special meaning, it make flat string from a tree, which cost a few operations for the processor. Don't use it if you don't need it.</xd:desc>
      <xd:desc xml:lang="fr">XSLT ne doit pas être plus verbeux qu'il l'est déjà. L'utilisation de xsl:value-of a une signification très spéciale, cela aplatit un arbre ce qui coûte quelques opérations au processeur. Ne l'utilisez pas si vous n'en avez pas besoin.</xd:desc>
    </xd:doc>
    <report id="xslqual-SettingValueOfVariableIncorrectly"
      test="if(not(xslq:is-active(., 'xslqual-SettingValueOfVariableIncorrectly'))) then (false()) else(
      (count(*) = 1) and (count(xsl:value-of | xsl:sequence) = 1) and (normalize-space(string-join(text(), '')) = '')
      )">
      [xslqual-SettingValueOfVariableIncorrectly] Assign value to a variable using the 'select' syntax if assigning a value with xsl:value-of (or xsl:sequence)
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Is it really usefull to declare a variable if you don't use it? Sometime yes because it will be used out of the current scope, but sometimes it's just a forgotten line.</xd:desc>
      <xd:desc xml:lang="fr">Est-il vraiment utile de déclarer une variable sans jamais l'utiliser ? Parfois oui, car elles sera utilisé en dehors de son contexte, mais d'autres fois c'est juste un oubli.</xd:desc>
    </xd:doc>
    <assert id="xslqual-UnusedVariable" role="warning" 
      test="if(not(xslq:is-active(., 'xslqual-UnusedVariable'))) then (true()) else(
      xslq:var-or-param-is-referenced-within-its-scope(.)
      )">
      [xslqual-UnusedVariable] Variable $<value-of select="@name"/> is unused within its scope
    </assert>
    
  </rule>
  
  <rule context="xsl:param" id="xslqual_param">
    
    <xd:doc>
      <xd:desc xml:lang="en">XSLT doesn't need to be more verbose than it is. Using xsl:value-of has a really special meaning, it make flat string from a tree, which cost a few operations for the processor. Don't use it if you don't need it.</xd:desc>
      <xd:desc xml:lang="fr">XSLT ne doit pas être plus verbeux qu'il l'est déjà. L'utilisation de xsl:value-of a une signification très spéciale, cela aplatit un arbre ce qui coûte quelques opérations au processeur. Ne l'utilisez pas si vous n'en avez pas besoin.</xd:desc>
    </xd:doc>
    <report id="xslqual-SettingValueOfParamIncorrectly" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-SettingValueOfParamIncorrectly'))) then (false()) else(
      (count(*) = 1) and (count(xsl:value-of | xsl:sequence) = 1)  and (normalize-space(string-join(text(), '')) = '')
      )">
      [xslqual-SettingValueOfParamIncorrectly] Assign value to a parameter using the 'select' syntax if assigning a value with xsl:value-of (or xsl:sequence)
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Is it really usefull to declare a variable if you don't use it? Sometime yes because it will be used out of the current scope, but sometimes it's just a forgotten line.</xd:desc>
      <xd:desc xml:lang="fr">Est-il vraiment utile de déclarer une variable sans jamais l'utiliser ? Parfois oui, car elles sera utilisé en dehors de son contexte, mais d'autres fois c'est juste un oubli.</xd:desc>
    </xd:doc>
    <assert id="xslqual-UnusedParameter" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-UnusedParameter'))) then (true()) else(
      xslq:var-or-param-is-referenced-within-its-scope(.)
      )">
      [xslqual-UnusedParameter] Parameter $<value-of select="@name"/> is unused within its scope
    </assert>
    
  </rule>
  
  <rule context="xsl:for-each | xsl:if | xsl:when | xsl:otherwise" id="xslqual_instructions">
    <xd:doc>
      <xd:desc xml:lang="en">Using empty instruction is not wrong but it make the code unclear</xd:desc>
      <xd:desc xml:lang="fr">L'utilisation d'instructions vides n'est pas faux mais rend le code pas clair</xd:desc>
    </xd:doc>
    <report id="xslqual-EmptyContentInInstructions" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-EmptyContentInInstructions'))) then (false()) else(
      (count(node()) = count(text())) and (normalize-space() = '')
      )">
      [xslqual-EmptyContentInInstructions] Don't use empty content for instructions like 'xsl:for-each' 'xsl:if' 'xsl:when' etc.
    </report>
  </rule>
  
  <rule context="xsl:function[(:ignore function library stylesheet:)
    count(//xsl:template[@match][(@mode, '#default')[1] = '#default']) != 0]"
    id="xslqual-functions">
    
    <xd:doc>
      <xd:desc xml:lang="en">Unless the XSLT is a function library (which look not to be the case here), declaring a function which is never used in the stylesheet is unusefull</xd:desc>
      <xd:desc xml:lang="fr">A moins que la XSLT soit une librairie de fonctions (ce qui n'a pas l'air d'être le cas ici), déclarer une fonction sans l'utiliser est inutile</xd:desc>
    </xd:doc>
    <assert id="xslqual-UnusedFunction" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-UnusedFunction'))) then (true()) else(
      xslq:function-is-called-within-its-scope(.)
      )">
      [xslqual-UnusedFunction] Function <value-of select="@name"/> is unused in the stylesheet
    </assert>
    
    <xd:doc>
      <xd:desc xml:lang="en">When a function is too big maybe it's good to wonder if one could split it</xd:desc>
      <xd:desc xml:lang="fr">Quand une fonction est trop longue, peut-être que l'on peut s'interroger sur un autre découpage</xd:desc>
    </xd:doc>
    <report id="xslqual-FunctionComplexity" role="info"
      test="if(not(xslq:is-active(., 'xslqual-FunctionComplexity'))) then (false()) else(
      count(.//xsl:*) gt xslq:get-param-value('xslqual-FunctionComplexity', 'maxSize', '50', 'xs:integer')
      )">
      [xslqual-FunctionComplexity] Function's size/complexity is high. There is need for refactoring the code.
    </report>
  </rule>
  
  <rule context="xsl:template" id="xslqual-template">
    
    <xd:doc>
      <xd:desc xml:lang="en">Unless the XSLT is a function library (which look not to be the case here), declaring a named template which is never used in the stylesheet is unusefull</xd:desc>
      <xd:desc xml:lang="fr">A moins que la XSLT soit une librairie de fonctions (ce qui n'a pas l'air d'être le cas ici), déclarer un template nommé sans l'utiliser est inutile</xd:desc>
    </xd:doc>
    <report id="xslqual-UnusedNamedTemplate" role="warning"
      test="if(not(xslq:is-active(., 'xslqual-UnusedNamedTemplate'))) then (false()) else(
      @name and not(@match) and not(//xsl:call-template/@name = @name)
      )">
      [xslqual-UnusedNamedTemplate] Named template in unused the stylesheet
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">When a named template is too big maybe it's good to wonder if one could split it</xd:desc>
      <xd:desc xml:lang="fr">Quand un template nommé est trop long, peut-être que l'on peut s'interroger sur un autre découpage</xd:desc>
    </xd:doc>
    <report id="xslqual-TemplateComplexity" role="info"
      test="if(not(xslq:is-active(., 'xslqual-TemplateComplexity'))) then (false()) else(
      count(.//xsl:*) &gt; 50
      )">
      [xslqual-TemplateComplexity] Template's size/complexity is high. There is need for refactoring the code.
    </report>
  </rule>
  
  <rule context="xsl:element" id="xslqual-element">
    <xd:doc>
      <xd:desc xml:lang="en">XSLT is XML ! when creating a output element, it's more readable to write it directly rather than creating a special instruction for this, unless you have to calculate the name of this element</xd:desc>
      <xd:desc xml:lang="fr">XSLT c'est du XML ! Quand vous créé un élément en sortie, il est plus lisible de l'écrire directement plutôt que de d'utiliser une instruction spécifique, à moins que vous ne deviez calculer le nom de cet élément</xd:desc>
    </xd:doc>
    <report id="xslqual-NotCreatingElementCorrectly"
      test="if(not(xslq:is-active(., 'xslqual-NotCreatingElementCorrectly'))) then (false()) else(
      not(contains(@name, '$') or (contains(@name, '(') and contains(@name, ')')) or 
      (contains(@name, '{') and contains(@name, '}')))
      )">
      [xslqual-NotCreatingElementCorrectly] Creating an element node using the xsl:element instruction when could have been possible directly
    </report>
  </rule>
  
  <rule context="xsl:apply-templates" id="xslqual-apply-templates">
    <xd:doc>
      <xd:desc xml:lang="en">Common typo is to forget the $ before a variable name. It's not syntactically wrong but the processor will try to process a node whose name is the variable's one. It might lead to unexpected behaviour</xd:desc>
      <xd:desc xml:lang="fr">Faute de frappe classique : oublier le $ devant le nom d'une variable. Ce n'est pas syntaxiquement faux mais le processeur va alors s'attendre à un noeud dans le document source dont le nom est celui de la variable. Ceci peut donner des comportement inattendus</xd:desc>
    </xd:doc>
    <report id="xslqual-ConfusingVariableAndNode"
      test="if(not(xslq:is-active(., 'xslqual-ConfusingVariableAndNode'))) then (false()) else(
      some $var in ancestor::xsl:template[1]//xsl:variable satisfies 
      (($var &lt;&lt; .) and starts-with(@select, $var/@name))
      )">
      [xslqual-ConfusingVariableAndNode] You might be confusing a variable reference with a node reference
    </report>
  </rule>
  
  <rule context="@*" id="xslqual-attributes">
    
    <xd:doc>
      <xd:desc xml:lang="en">Double slash operator is really gready : it means "look every node in the source document". If you're using // while processing every one node than you will process each node N*N times! You will face performance problem while processing big documents! Tip: use a xsl:key instead</xd:desc>
      <xd:desc xml:lang="fr">L'opérateur double slash est très gourmand : il signifie "regarde chaque nœud dans le document source". Si vous utilisez // pendant le traitement de chacun des nœuds vous allez alors parcourir chaque nœud NxN fois ! Vous aurez des problème de performance sur des gros documents. Conseil : utilisez une xsl:key à la place.</xd:desc>
    </xd:doc>
    <report id="xslqual-DontUseDoubleSlashOperatorNearRoot"
      test="if(not(xslq:is-active(., 'xslqual-DontUseDoubleSlashOperatorNearRoot'))) then (false()) else(
      local-name(.)= ('match', 'select') and (not(matches(., '^''.*''$')))
      and starts-with(., '//')
      )" role="warning">
      [xslqual-DontUseDoubleSlashOperatorNearRoot] Avoid using the operator // near the root of a large tree
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Avoid using double double slash operator even to request nodes in a subtree structure, it's gready.</xd:desc>
      <xd:desc xml:lang="fr">Même dans une sous-structure il vaut mieux éviter d'utiliser // qui est gourmand et pourrait poser des problème de performance</xd:desc>
    </xd:doc>
    <report id="xslqual-DontUseDoubleSlashOperator"
      test="if(not(xslq:is-active(., 'xslqual-DontUseDoubleSlashOperator'))) then (false()) else(
      local-name(.)= ('match', 'select') and (not(matches(., '^''.*''$')))
      and not(starts-with(., '//')) and contains(., '//')
      )" role="info">
      [xslqual-DontUseDoubleSlashOperator] Avoid using the operator // in XPath expressions
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">name() is for getting qualified name of a node, local-name() is the local part of the qualified name. It's not the same and sometimes you should be carefull about this</xd:desc>
      <xd:desc xml:lang="fr">name() indique le nom qualifié d'un noeud, local-name() correspond à la partie locale du nom qualifié. Ce n'est pas la même chose, et parfois il faut y faire attention</xd:desc>
    </xd:doc>
    <report id="xslqual-UsingNameOrLocalNameFunction" role="info"
      test="if(not(xslq:is-active(., 'xslqual-UsingNameOrLocalNameFunction'))) then (false()) else(
      contains(., 'name(') or contains(., 'local-name(')
      )">
      [xslqual-UsingNameOrLocalNameFunction] Using name() function when local-name() could be appropriate (and vice-versa)
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">boolean true() or false() is not the same a string 'true' and 'false', you should be carefull about this</xd:desc>
      <xd:desc xml:lang="fr">Les booléens true() et false() ne sont pas la même chose que les string 'true' et 'false', il faut y faire attention</xd:desc>
    </xd:doc>
    <report id="xslqual-IncorrectUseOfBooleanConstants" role="info"
      test="if(not(xslq:is-active(., 'xslqual-IncorrectUseOfBooleanConstants'))) then (false()) else(
      local-name(.)= ('match', 'select') and not(parent::xsl:attribute)
      and ((contains(., 'true') and not(contains(., 'true()'))) or (contains(., 'false') and not(contains(., 'false()'))))
      )">
      [xslqual-IncorrectUseOfBooleanConstants] Incorrectly using the boolean constants as 'true' or 'false'
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Namespace axes has been deprecated in XSLT 2+, see https://www.w3.org/TR/xslt20/#backwards-compatibility-feature</xd:desc>
      <xd:desc xml:lang="fr">L'axe "namepace" est déprécié en XSLT2+, cf. https://www.w3.org/TR/xslt20/#backwards-compatibility-feature</xd:desc>
    </xd:doc>
    <report id="xslqual-UsingNamespaceAxis" 
      test="if(not(xslq:is-active(., 'xslqual-UsingNamespaceAxis'))) then (false()) else(
      /xsl:stylesheet/@version = ('2.0', '3.0') and local-name(.)= ('match', 'select') and contains(., 'namespace::')
      )">
      [xslqual-UsingNamespaceAxis] Using the deprecated namespace axis, when working in XSLT <value-of select="/*/@version"/> mode
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Simple child, parent or attribute axis make xpath expression verbose, one suggest to use the short syntax instead (@, /, ../) </xd:desc>
      <xd:desc xml:lang="fr">Les axes simple comme child, parent or attribute rendes les expressions xpath verbeuse, on suggère ici d'utiliser la syntaxe abrégée à la place ( @, /, ../)</xd:desc>
    </xd:doc>
    <report id="xslqual-CanUseAbbreviatedAxisSpecifier" 
      test="if(not(xslq:is-active(., 'xslqual-CanUseAbbreviatedAxisSpecifier'))) then (false()) else(
      local-name(.) = ('match', 'select') and contains(., 'child::') or contains(., 'attribute::') or contains(., 'parent::node()')
      )"
      role="info">
      [xslqual-CanUseAbbreviatedAxisSpecifier] Using the lengthy axis specifiers like child::, attribute:: or parent::node()
    </report>
    
    <xd:doc>
      <xd:desc xml:lang="en">Using disable-output-escaping is never a good idea, there must be other ways to do it </xd:desc>
      <xd:desc xml:lang="fr">L'utilisation de disable-output-escaping n'est jamais une bonne idée, il doit y avoir un autre moyen de faire</xd:desc>
    </xd:doc>
    <report id="xslqual-UsingDisableOutputEscaping" 
      test="if(not(xslq:is-active(., 'xslqual-UsingDisableOutputEscaping'))) then (false()) else(
      local-name(.) = 'disable-output-escaping' and . = ('yes', 'true', '1')
      )">
      [xslqual-UsingDisableOutputEscaping] Have set the disable-output-escaping attribute to 'yes'. Please relook at the stylesheet logic.
    </report>
    
  </rule>
  
</pattern>