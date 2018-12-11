<?xml version="1.0" encoding="UTF-8"?>
<schema 
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  queryBinding="xslt3" 
  id="xsl-common.sch"
  >
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="saxon" uri="http://saxon.sf.net/"/>
  
  <xsl:key name="getElementById" match="*" use="@id"/>
  
  <let name="NCNAME.reg" value="'[\i-[:]][\c-[:]]*'"/>
  <let name="xslt.version" value="/*/@version"/>
  
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
    <active pattern="xslt-quality_common"/>
    <active pattern="xslt-quality_documentation"/>
    <active pattern="xslt-quality_typing"/>
    <active pattern="xslt-quality_namespaces"/>
    <active pattern="xslt-quality_writing"/>
	</phase>-->

  <!--====================================-->
  <!--              MAIN                 -->
  <!--====================================-->
  
  <pattern id="xslt-quality_common">
    <rule context="xsl:for-each">
      <xd:doc>
        <xd:desc xml:lang="en">Using xsl:for-each on nodes may be a clue of procedural programming. XSLT is rather a rule-programming language, data-driven. You should maybe consider using xsl:apply-templates instead</xd:desc>
        <xd:desc xml:lang="fr">l'utilisation de xsl:for-each sur des nœuds peut être un indice de programmation procedural. XSLT est un langage de règles dirigé par les données. Vous devriez peut-être considéré l'utilisation de xsl:apply-templates à la place.</xd:desc>
      </xd:doc>
      <report test="ancestor::xsl:template 
        and not(starts-with(@select, '$'))
        and not(starts-with(@select, 'tokenize('))
        and not(starts-with(@select, 'distinct-values('))
        and not(matches(@select, '\d'))" 
        role="warning" id="xslt-quality_avoid-for-each">
        [common] Should you use xsl:apply-template instead of xsl:for-each 
      </report>
    </rule>
    <rule context="xsl:template/@match | xsl:*/@select | xsl:when/@test">
      <xd:doc>
        <xd:desc xml:lang="en">Using concatenation to resolve URI is not generic (windows and linux path are not the same) - Consider unsing the on-purpose resolve-uri() function instead</xd:desc>
        <xd:desc xml:lang="fr">la concaténation de chaînes de caractère pour résoudre une URI n'est pas générique (les chemins sous Windows et Linux ne sont pas les mêmes) - Considérez plutôt l'utilisation de la fonction dédiée resolve-uri()</xd:desc>
      </xd:doc>
      <report test="contains(., 'document(concat(') or contains(., 'doc(concat(')" id="xslt-quality_use-resolve-uri-instead-of-concat">
        [common] Avoid using concat within document() or doc() function, use resolve-uri() instead (you may use static-base-uri() or base-uri())
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_documentation">
    <rule context="/xsl:stylesheet">
      <xd:doc>
        <xd:desc xml:lang="en">Indicate what your XSLT is doing as a minimal documentation set. When your XSLT performs a transformation (not a library) you could also describe the data expected as input, and the data generated as output.</xd:desc>
        <xd:desc xml:lang="fr">Indiquer ce que votre XSLT fait comme documentation minimale. Si votre XSLT effectue une transformation (à l'opposé d'une librairie) vous pourriez indiquer les données attendues en entrée et celles qui seront générées en sortie.</xd:desc>
      </xd:doc>
      <assert test="xd:doc[@scope = 'stylesheet']" id="xslt-quality_documentation-stylesheet">
        [documentation] Please add a documentation block for the whole stylesheet : &lt;xd:doc scope="stylesheet">
      </assert>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_typing">
    <rule context="xsl:variable | xsl:param  | xsl:with-param | xsl:function">
      <xd:doc>
        <xd:desc xml:lang="en">Typing your variables, parameters and function makes your XSLT much more efficient: you will be warn with inconsistency at compilation time (when writing in Oxygen). Bad type errors from your data will be detected sooner at run-time, which will make debuging much easier.</xd:desc>
        <xd:desc xml:lang="fr">Typer vos variables, paramètres et fonctions rendra votre XSLT beaucoup plus robuste : vous serez avertis à la compalation (pendant que vous codez sous Oxygen) des inconsistence éventuelles. Pendant l'exécution, les erreurs de types liées à vos données seront détectée bien plus tôt ce qui facilitera grandement le débogage.</xd:desc>
      </xd:doc>
      <report test="$xslt.version = ('2.0', '3.0') and not(@as)" diagnostics="addType" id="xslt-quality_typing-with-as-attribute">
        [typing] <name/> is not typed
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_namespaces">
    <rule context="xsl:template/@name | /*/xsl:variable/@name | /*/xsl:param/@name">
      <xd:doc>
        <xd:desc xml:lang="en">Adding a namespace prefix at your global variables and parameters will make your XSLT more portable: it will avoid name conflict with other XSLT importing yours and vice versa.</xd:desc>
        <xd:desc xml:lang="fr">Ajouter un préfixe de namespace sur vos variables et paramètres globaux rendra votre XSLT plus portable : cela évitera les conflit de nommage avec d'autres XSLT qui importerait la votre et vice versa</xd:desc>
      </xd:doc>
      <assert test="every $name in tokenize(., '\s+') satisfies matches($name, concat('^', $NCNAME.reg, ':'))" role="warning" id="xslt-quality_ns-global-statements-need-prefix">
        [namespaces] <value-of select="local-name(parent::*)"/> <name/>="<value-of select="tokenize(., '\s+')[not(matches(., concat('^', $NCNAME.reg, ':')))]"/>" should be namespaces prefixed, so they don't generate conflict with imported XSLT (or when this xslt is imported)
      </assert>
    </rule>
    <rule context="xsl:template/@mode">
      <xd:doc>
        <xd:desc xml:lang="en">Adding a namespace prefix at your template's mode will make your XSLT more portable: it will avoid name conflict with other XSLT importing yours and vice versa.</xd:desc>
        <xd:desc xml:lang="fr">Ajouter un préfixe de namespace sur vos mode de template rendra votre XSLT plus portable : cela évitera les conflit de nommage avec d'autres XSLT qui importerait la votre et vice versa</xd:desc>
      </xd:doc>
      <assert test="every $name in tokenize(., '\s+') satisfies matches($name, concat('^', $NCNAME.reg, ':'))" role="warning" id="xslt-quality_ns-mode-statements-need-prefix">
        [namespaces] <value-of select="local-name(parent::*)"/> @<name/> value "<value-of select="tokenize(., '\s+')[not(matches(., concat('^', $NCNAME.reg, ':')))]"/>" should be namespaces prefixed, so they don't generate conflict with imported XSLT (or when this xslt is imported)
      </assert>
    </rule>
    <rule context="@match | @select">
      <xd:doc>
        <xd:desc xml:lang="en">Avoid using "*:" in your xpath: it will slow your XSLT processor that will be obliged to check every local-names instead of just manipulating XML nodes.</xd:desc>
        <xd:desc xml:lang="fr">Évitez d'utiliser "*:" dans vos xpath : cela va ralentir votre processeur XSLT qui sera forcé de vérifier le nom local des balises au lieur de manipuler des nœuds XML.</xd:desc>
      </xd:doc>
      <report test="contains(., '*:')" id="xslt-quality_ns-do-not-use-wildcard-prefix">
        [namespaces] Use a namespace prefix instead of *:
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_writing">
    <rule context="xsl:attribute | xsl:namespace | xsl:variable | xsl:param | xsl:with-param">
      <xd:doc>
        <xd:desc xml:lang="en">If you don't need special XSLT instruction to calculate a variable, a param (or any other attribute, namespace) then use the short "select=" syntax that make your code less verbose and easier to read.</xd:desc>
        <xd:desc xml:lang="fr">Si vous n'avez pas besoin d'instruction XSLT spécifiques pour calculer une variable, un paramètre (ou tout autre attribut, namespace) utilisez la syntaxe rapide "select=" qui rendra votre code moins verbeux et plus facile à lire.</xd:desc>
      </xd:doc>
      <report id="xslt-quality_writing-use-select-attribute-when-possible"
        test="not(@select) and (count(* | text()[normalize-space(.)]) = 1) and (count(xsl:value-of | xsl:sequence | text()[normalize-space(.)]) = 1)">
        [writing] Use @select to assign a value to <name/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_xslt-3.0">
    <rule context="xsl:import[$xslt.version = '3.0']">
      <xd:doc>
        <xd:desc xml:lang="en">In XSLT 1.0 and 2.0 xsl:import must come first, even before documentation block. This has been corrected in XSLT 3.0, so you can now move these xsl:import after the documentation block which is dedicated to come firts.</xd:desc>
        <xd:desc xml:lang="fr">En XSLT 1.0 et 2.0, les xsl:import devaient venir en 1er, avant même le bloc de documentation. Cela a été corriger en XSLT 3.0, vous pouvez donc déplacer ces xsl:import après le bloc de documentation qui a vocation a être le 1er élément de votre XSLT.</xd:desc>
      </xd:doc>
      <report id="xslt-quality_xslt-3.0-import-first" 
        test="following-sibling::xd:doc[@scope = 'stylesheet']" role="info">
        [XSLT-3.0] When using XSLT 3.0 xsl:import may come after the xd:doc block
      </report>
    </rule>
  </pattern>
  
</schema>