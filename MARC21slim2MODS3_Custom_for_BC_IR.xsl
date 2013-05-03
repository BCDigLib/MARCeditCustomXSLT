<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xlink marc">
	<xsl:include href="MARC21slimUtils.xsl"/>
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<!--
Revision 1.9 subfield $y was added to field 242 2004/09/02 10:57 jrad

Revision 1.8 Subject chopPunctuation expanded and attribute fixes 2004/08/12 jrad

Revision 1.7 2004/03/25 08:29 jrad

Revision 1.6 various validation fixes 2004/02/20 ntra

Revision 1.5  2003/10/02 16:18:58  ntra
MODS2 to MODS3 updates, language unstacking and 
de-duping, chopPunctuation expanded

Revision 1.3  2003/04/03 00:07:19  ntra
Revision 1.3 Additional Changes not related to MODS Version 2.0 by ntra

Revision 1.2  2003/03/24 19:37:42  ckeith
Added Log Comment

-->
	<xsl:template match="/">


				<mods:modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd">
					<xsl:for-each select="marc:collection/marc:record">
						<mods:mods version="3.3">
							<xsl:call-template name="marcRecord"/>
						</mods:mods>
					</xsl:for-each>
				</mods:modsCollection>

	</xsl:template>

	<xsl:template name="marcRecord">
		<xsl:variable name="leader" select="marc:leader"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>
		<xsl:variable name="typeOf008">
			<xsl:choose>
				<xsl:when test="$leader6='a'">
					<xsl:choose>
						<xsl:when test="$leader7='a' or $leader7='c' or $leader7='d' or $leader7='m'">BK</xsl:when>
						<xsl:when test="$leader7='b' or $leader7='i' or $leader7='s'">SE</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$leader6='t'">BK</xsl:when>
				<xsl:when test="$leader6='p'">MM</xsl:when>
				<xsl:when test="$leader6='m'">CF</xsl:when>
				<xsl:when test="$leader6='e' or $leader6='f'">MP</xsl:when>
				<xsl:when test="$leader6='g' or $leader6='k' or $leader6='o' or $leader6='r'">VM</xsl:when>
				<xsl:when test="$leader6='c' or $leader6='d' or $leader6='i' or $leader6='j'">MU</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each select="marc:datafield[@tag=245]">
			<mods:titleInfo>
				<xsl:variable name="title">
					<xsl:choose>
						<xsl:when test="marc:subfield[@code='b']">
							<xsl:call-template name="specialSubfieldSelect">
								<xsl:with-param name="axis">b</xsl:with-param>
								<xsl:with-param name="beforeCodes">afghk</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">abfgk</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="titleChop">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:value-of select="$title"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="@ind2&gt;0">
						<mods:nonSort>
							<xsl:value-of select="substring($titleChop,1,@ind2)"/>
						</mods:nonSort>
						<mods:title>
							<xsl:value-of select="substring($titleChop,@ind2+1)"/>
						</mods:title>
					</xsl:when>
					<xsl:otherwise>
						<mods:title>
							<xsl:value-of select="$titleChop"/>
						</mods:title>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="marc:subfield[@code='b']">
					<mods:subTitle>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="axis">b</xsl:with-param>
									<xsl:with-param name="anyCodes">b</xsl:with-param>
									<xsl:with-param name="afterCodes">afghk</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:subTitle>
				</xsl:if>
				<xsl:call-template name="part"/>
			</mods:titleInfo>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=210]">
			<mods:titleInfo type="abbreviated">
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">a</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:call-template name="subtitle"/>
			</mods:titleInfo>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=242]">
			<mods:titleInfo type="translated">
			<!--09/01/04 Added subfield $y-->
			<xsl:for-each select="marc:subfield[@code='y']">
					<xsl:attribute name="lang">
						<xsl:value-of select="text()"/>
					</xsl:attribute>
					</xsl:for-each>
			<mods:title>
			
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:call-template name="subfieldSelect">
								<!-- 1/04 removed $h, b -->
								<xsl:with-param name="codes">a</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					
				</mods:title>
				
				
				<!-- 1/04 fix -->
				<xsl:call-template name="subtitle"/>
				<xsl:call-template name="part"/>
			</mods:titleInfo>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=246]">
			<mods:titleInfo type="alternative">
				<xsl:for-each select="marc:subfield[@code='i']">
					<xsl:attribute name="displayLabel">
						<xsl:value-of select="text()"/>
					</xsl:attribute>
				</xsl:for-each>
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:call-template name="subfieldSelect">
								<!-- 1/04 removed $h, $b -->
								<xsl:with-param name="codes">af</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:call-template name="subtitle"/>
				<xsl:call-template name="part"/>
			</mods:titleInfo>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=130]|marc:datafield[@tag=240]|marc:datafield[@tag=730][@ind2!=2]">
			<mods:titleInfo type="uniform">
				<mods:title>
					<xsl:variable name="str">
						<xsl:for-each select="marc:subfield">
							<xsl:if test="(contains('adfklmor',@code) and (not(../marc:subfield[@code='n' or @code='p']) or (following-sibling::marc:subfield[@code='n' or @code='p'])))">
								<xsl:value-of select="text()"/>
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>

					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:call-template name="part"/>
			</mods:titleInfo>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=740][@ind2!=2]">
			<mods:titleInfo type="alternative">
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">ah</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:call-template name="part"/>
			</mods:titleInfo>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=100]">
			<mods:name type="personal">
				<xsl:call-template name="nameABCDQ"/>
				<xsl:call-template name="affiliation"/>
				<mods:role>
					<mods:roleTerm authority="marcrelator" type="text">creator</mods:roleTerm>
				</mods:role>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=110]">
			<mods:name type="corporate">
				<xsl:call-template name="nameABCDN"/>
				<mods:role>
					<mods:roleTerm authority="marcrelator" type="text">creator</mods:roleTerm>
				</mods:role>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=111]">
			<mods:name type="conference">
				<xsl:call-template name="nameACDEQ"/>
				<mods:role>
					<mods:roleTerm authority="marcrelator" type="text">creator</mods:roleTerm>
				</mods:role>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=700][not(marc:subfield[@code='t'])]">
			<mods:name type="personal">
				<xsl:call-template name="nameABCDQ"/>
				<xsl:call-template name="affiliation"/>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=710][not(marc:subfield[@code='t'])]">
			<mods:name type="corporate">
				<xsl:call-template name="nameABCDN"/>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=711][not(marc:subfield[@code='t'])]">
			<mods:name type="conference">
				<xsl:call-template name="nameACDEQ"/>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=720][not(marc:subfield[@code='t'])]">
			<mods:name>
				<xsl:if test="@ind1=1">
					<xsl:attribute name="type">
						<xsl:text>personal</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<mods:namePart>
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</mods:namePart>
				<xsl:call-template name="role"/>
			</mods:name>
		</xsl:for-each>

		<mods:typeOfResource>
			<xsl:if test="$leader7='c'">
				<xsl:attribute name="collection">yes</xsl:attribute>
			</xsl:if>
			<xsl:if test="$leader6='d' or $leader6='f' or $leader6='p' or $leader6='t'">
				<xsl:attribute name="manuscript">yes</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
				<xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
				<xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
				<xsl:when test="$leader6='i'">sound recording-nonmusical</xsl:when>
				<xsl:when test="$leader6='j'">sound recording-musical</xsl:when>
				<xsl:when test="$leader6='k'">still image</xsl:when>
				<xsl:when test="$leader6='g'">moving image</xsl:when>
				<xsl:when test="$leader6='r'">three dimensional object</xsl:when>
				<xsl:when test="$leader6='m'">software, multimedia</xsl:when>
				<xsl:when test="$leader6='p'">mixed material</xsl:when>
			</xsl:choose>
		</mods:typeOfResource>

		<xsl:if test="substring($controlField008,26,1)='d'">
			<mods:genre authority="marcgt" type="workType">globe</mods:genre>
		</xsl:if>

		<xsl:if test="marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='r']">
			<mods:genre authority="marcgt" type="workType">remote sensing image</mods:genre>
		</xsl:if>

		<xsl:if test="$typeOf008='MP'">
			<xsl:variable name="controlField008-25" select="substring($controlField008,26,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-25='a' or $controlField008-25='b' or $controlField008-25='c' or marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='j']">
					<mods:genre authority="marcgt" type="workType">map</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-25='e' or marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='d']">
					<mods:genre authority="marcgt" type="workType">atlas</mods:genre>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="$typeOf008='SE'">
			<xsl:variable name="controlField008-21" select="substring($controlField008,22,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-21='d'">
					<mods:genre authority="marcgt" type="workType">database</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-21='l'">
					<mods:genre authority="marcgt" type="workType">loose-leaf</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-21='m'">
					<mods:genre authority="marcgt" type="workType">series</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-21='n'">
					<mods:genre authority="marcgt" type="workType">newspaper</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-21='p'">
					<mods:genre authority="marcgt" type="workType">periodical</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-21='w'">
					<mods:genre authority="marcgt" type="workType">web site</mods:genre>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		
		<xsl:if test="(($typeOf008='BK') and ($leader6='a' ))">
					<mods:genre authority="marcgt" type="workType">book</mods:genre>
		</xsl:if>

		<xsl:if test="$typeOf008='BK' or $typeOf008='SE'">
			<xsl:variable name="controlField008-24" select="substring($controlField008,25,4)"/>
			<xsl:choose>
				<xsl:when test="contains($controlField008-24,'a')">
					<mods:genre authority="marcgt" type="workType">abstract or summary</mods:genre>
				</xsl:when>
				<!--<xsl:when test="contains($controlField008-24,'b')">
					<mods:genre authority="marcgt" type="workType">bibliography</mods:genre>
				</xsl:when>-->
				<xsl:when test="contains($controlField008-24,'c')">
					<mods:genre authority="marcgt" type="workType">catalog</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'d')">
					<mods:genre authority="marcgt" type="workType">dictionary</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'e')">
					<mods:genre authority="marcgt" type="workType">encyclopedia</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'f')">
					<mods:genre authority="marcgt" type="workType">handbook</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'g')">
					<mods:genre authority="marcgt" type="workType">legal article</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'i')">
					<mods:genre authority="marcgt" type="workType">index</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'k')">
					<mods:genre authority="marcgt" type="workType">discography</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'l')">
					<mods:genre authority="marcgt" type="workType">legislation</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'m')">
					<mods:genre authority="marcgt" type="workType">theses</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'n')">
					<mods:genre authority="marcgt" type="workType">survey of literature</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'o')">
					<mods:genre authority="marcgt" type="workType">review</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'p')">
					<mods:genre authority="marcgt" type="workType">programmed text</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'q')">
					<mods:genre authority="marcgt" type="workType">filmography</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'r')">
					<mods:genre authority="marcgt" type="workType">directory</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'s')">
					<mods:genre authority="marcgt" type="workType">statistics</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'t')">
					<mods:genre authority="marcgt" type="workType">technical report</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'v')">
					<mods:genre authority="marcgt" type="workType">legal case and case notes</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'w')">
					<mods:genre authority="marcgt" type="workType">law report or digest</mods:genre>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'z')">
					<mods:genre authority="marcgt" type="workType">treaty</mods:genre>
				</xsl:when>
			</xsl:choose>
			<xsl:variable name="controlField008-29" select="substring($controlField008,30,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-29='1'">
					<mods:genre authority="marcgt" type="workType">conference publication</mods:genre>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="$typeOf008='CF'">
			<xsl:variable name="controlField008-26" select="substring($controlField008,27,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-26='a'">
					<mods:genre authority="marcgt" type="workType">numeric data</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-26='e'">
					<mods:genre authority="marcgt" type="workType">database</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-26='f'">
					<mods:genre authority="marcgt" type="workType">font</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-26='g'">
					<mods:genre authority="marcgt" type="workType">game</mods:genre>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="$typeOf008='BK'">
			<xsl:if test="substring($controlField008,25,1)='j'">
				<mods:genre authority="marcgt" type="workType">patent</mods:genre>
			</xsl:if>
			<xsl:if test="substring($controlField008,31,1)='1'">
				<mods:genre authority="marcgt" type="workType">festschrift</mods:genre>
			</xsl:if>

			<xsl:variable name="controlField008-34" select="substring($controlField008,35,1)"/>
			<xsl:if test="$controlField008-34='a' or $controlField008-34='b' or $controlField008-34='c' or $controlField008-34='d'">
				<mods:genre authority="marcgt" type="workType">biography</mods:genre>
			</xsl:if>

			<xsl:variable name="controlField008-33" select="substring($controlField008,34,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-33='e'">
					<mods:genre authority="marcgt" type="workType">essay</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='d'">
					<mods:genre authority="marcgt" type="workType">drama</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='c'">
					<mods:genre authority="marcgt" type="workType">comic strip</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='l'">
					<mods:genre authority="marcgt" type="workType">fiction</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='h'">
					<mods:genre authority="marcgt" type="workType">humor, satire</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='i'">
					<mods:genre authority="marcgt" type="workType">letter</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='f'">
					<mods:genre authority="marcgt" type="workType">novel</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='j'">
					<mods:genre authority="marcgt" type="workType">short story</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='s'">
					<mods:genre authority="marcgt" type="workType">speech</mods:genre>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="$typeOf008='MU'">
			<xsl:variable name="controlField008-30-31" select="substring($controlField008,31,2)"/>
			<xsl:if test="contains($controlField008-30-31,'b')">
				<mods:genre authority="marcgt" type="workType">biography</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'c')">
				<mods:genre authority="marcgt" type="workType">conference publication</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'d')">
				<mods:genre authority="marcgt" type="workType">drama</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'e')">
				<mods:genre authority="marcgt" type="workType">essay</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'f')">
				<mods:genre authority="marcgt" type="workType">fiction</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'o')">
				<mods:genre authority="marcgt" type="workType">folktale</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'h')">
				<mods:genre authority="marcgt" type="workType">history</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'k')">
				<mods:genre authority="marcgt" type="workType">humor, satire</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'m')">
				<mods:genre authority="marcgt" type="workType">memoir</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'p')">
				<mods:genre authority="marcgt" type="workType">poetry</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'r')">
				<mods:genre authority="marcgt" type="workType">rehearsal</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'g')">
				<mods:genre authority="marcgt" type="workType">reporting</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'s')">
				<mods:genre authority="marcgt" type="workType">sound</mods:genre>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'l')">
				<mods:genre authority="marcgt" type="workType">speech</mods:genre>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$typeOf008='VM'">
			<xsl:variable name="controlField008-33" select="substring($controlField008,34,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-33='a'">
					<mods:genre authority="marcgt" type="workType">art original</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='b'">
					<mods:genre authority="marcgt" type="workType">kit</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='c'">
					<mods:genre authority="marcgt" type="workType">art reproduction</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='d'">
					<mods:genre authority="marcgt" type="workType">diorama</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='f'">
					<mods:genre authority="marcgt" type="workType">filmstrip</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='g'">
					<mods:genre authority="marcgt" type="workType">legal article</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='i'">
					<mods:genre authority="marcgt" type="workType">picture</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='k'">
					<mods:genre authority="marcgt" type="workType">graphic</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='l'">
					<mods:genre authority="marcgt" type="workType">technical drawing</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='m'">
					<mods:genre authority="marcgt" type="workType">motion picture</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='n'">
					<mods:genre authority="marcgt" type="workType">chart</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='o'">
					<mods:genre authority="marcgt" type="workType">flash card</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='p'">
					<mods:genre authority="marcgt" type="workType">microscope slide</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='q' or marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='q']">
					<mods:genre authority="marcgt" type="workType">model</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='r'">
					<mods:genre authority="marcgt" type="workType">realia</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='s'">
					<mods:genre authority="marcgt" type="workType">slide</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='t'">
					<mods:genre authority="marcgt" type="workType">transparency</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='v'">
					<mods:genre authority="marcgt" type="workType">videorecording</mods:genre>
				</xsl:when>
				<xsl:when test="$controlField008-33='w'">
					<mods:genre authority="marcgt" type="workType">toy</mods:genre>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:for-each select="marc:datafield[@tag=655]">
			<mods:genre authority="marcgt" type="workType">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abvxyz</xsl:with-param>
					<xsl:with-param name="delimeter">-</xsl:with-param>
				</xsl:call-template>
			</mods:genre>
		</xsl:for-each>

		<mods:originInfo>
			<xsl:variable name="MARCpublicationCode" select="normalize-space(substring($controlField008,16,3))"/>

			<xsl:if test="translate($MARCpublicationCode,'|','')">
				<mods:place>
					<mods:placeTerm>
						<xsl:attribute name="type">code</xsl:attribute>
						<xsl:attribute name="authority">marccountry</xsl:attribute>
						<xsl:value-of select="$MARCpublicationCode"/>
					</mods:placeTerm>
				</mods:place>
			</xsl:if>

			<xsl:for-each select="marc:datafield[@tag=044]/marc:subfield[@code='c']">
				<mods:place>
					<mods:placeTerm>
						<xsl:attribute name="type">code</xsl:attribute>
						<xsl:attribute name="authority">iso3166</xsl:attribute>
						<xsl:value-of select="."/>
					</mods:placeTerm>
				</mods:place>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='a']">
				<mods:place>
					<mods:placeTerm>
						<xsl:attribute name="type">text</xsl:attribute>
						<xsl:call-template name="chopPunctuationFront">
							<xsl:with-param name="chopString">
								<xsl:call-template name="chopPunctuation2">
									<xsl:with-param name="chopString" select="."/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:placeTerm>
				</mods:place>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=046]/marc:subfield[@code='m']">
				<mods:dateValid point="start">
					<xsl:value-of select="."/>
				</mods:dateValid>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag=046]/marc:subfield[@code='n']">
				<mods:dateValid point="end">
					<xsl:value-of select="."/>
				</mods:dateValid>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag=046]/marc:subfield[@code='j']">
				<mods:dateModified>
					<xsl:value-of select="."/>
				</mods:dateModified>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='b' or @code='c' or @code='g']">
				<xsl:choose>
					<xsl:when test="@code='b'">
						<mods:publisher>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString" select="."/>
								<xsl:with-param name="punctuation">
									<xsl:text>:,;/ </xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</mods:publisher>
					</xsl:when>
					<xsl:when test="@code='c'">
						<mods:dateIssued>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString" select="."/>
							</xsl:call-template>
						</mods:dateIssued>
					</xsl:when>
					<xsl:when test="@code='g'">
						<mods:dateCreated>
							<xsl:value-of select="."/>
						</mods:dateCreated>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

			<xsl:variable name="dataField260c">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="marc:datafield[@tag=260]/marc:subfield[@code='c']"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="controlField008-7-10" select="normalize-space(substring($controlField008, 8, 4))"/>
			<xsl:variable name="controlField008-11-14" select="normalize-space(substring($controlField008, 12, 4))"/>
			<xsl:variable name="controlField008-6" select="normalize-space(substring($controlField008, 7, 1))"/>

			<xsl:if test="$controlField008-6='e' or $controlField008-6='p' or $controlField008-6='r' or $controlField008-6='t' or $controlField008-6='s'">
				<xsl:if test="$controlField008-7-10 and ($controlField008-7-10 != $dataField260c)">
					<mods:dateIssued encoding="w3cdtf" keyDate="yes">
						<xsl:value-of select="$controlField008-7-10"/>
					</mods:dateIssued>
				</xsl:if>
			</xsl:if>

			<xsl:if test="$controlField008-6='c' or $controlField008-6='d' or $controlField008-6='i' or $controlField008-6='k' or $controlField008-6='m' or $controlField008-6='q' or $controlField008-6='u'">
				<xsl:if test="$controlField008-7-10">
					<mods:dateIssued encoding="marc" point="start">
						<xsl:value-of select="$controlField008-7-10"/>
					</mods:dateIssued>
				</xsl:if>
			</xsl:if>

			<xsl:if test="$controlField008-6='c' or $controlField008-6='d' or $controlField008-6='i' or $controlField008-6='k' or $controlField008-6='m' or $controlField008-6='q' or $controlField008-6='u'">
				<xsl:if test="$controlField008-11-14">
					<mods:dateIssued encoding="marc" point="end">
						<xsl:value-of select="$controlField008-11-14"/>
					</mods:dateIssued>
				</xsl:if>
			</xsl:if>

			<xsl:if test="$controlField008-6='q'">
				<xsl:if test="$controlField008-7-10">
					<mods:dateIssued encoding="marc" point="start" qualifier="questionable">
						<xsl:value-of select="$controlField008-7-10"/>
					</mods:dateIssued>
				</xsl:if>
			</xsl:if>

			<xsl:if test="$controlField008-6='q'">
				<xsl:if test="$controlField008-11-14">
					<mods:dateIssued encoding="w3cdtf" keyDate="yes" point="end" qualifier="questionable">
						<xsl:value-of select="$controlField008-11-14"/>
					</mods:dateIssued>
				</xsl:if>
			</xsl:if>

			<xsl:if test="$controlField008-6='t'">
				<xsl:if test="$controlField008-11-14">
					<mods:copyrightDate encoding="w3cdtf" keyDate="yes">
						<xsl:value-of select="$controlField008-11-14"/>
					</mods:copyrightDate>
				</xsl:if>
			</xsl:if>

			<xsl:for-each select="marc:datafield[@tag=033][@ind1=0 or @ind1=1]/marc:subfield[@code='a']">
				<mods:dateCaptured encoding="iso8601">
					<xsl:value-of select="."/>
				</mods:dateCaptured>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=033][@ind1=2]/marc:subfield[@code='a'][1]">
				<mods:dateCaptured encoding="iso8601" point="start">
					<xsl:value-of select="."/>
				</mods:dateCaptured>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=033][@ind1=2]/marc:subfield[@code='a'][2]">
				<mods:dateCaptured encoding="iso8601" point="end">
					<xsl:value-of select="."/>
				</mods:dateCaptured>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=250]/marc:subfield[@code='a']">
				<mods:edition>
					<xsl:value-of select="."/>
				</mods:edition>
			</xsl:for-each>

			<xsl:for-each select="marc:leader">
				<mods:issuance>
					<xsl:choose>
						<xsl:when test="$leader7='a' or $leader7='c' or $leader7='d' or $leader7='m'">monographic</xsl:when>
						<xsl:when test="$leader7='b' or $leader7='i' or $leader7='s'">continuing</xsl:when>
					</xsl:choose>
				</mods:issuance>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=310]|marc:datafield[@tag=321]">
				<frequency>
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">ab</xsl:with-param>
					</xsl:call-template>
				</frequency>
			</xsl:for-each>
		</mods:originInfo>
		<xsl:variable name="controlField008-35-37" select="normalize-space(translate(substring($controlField008,36,3),'|#',''))"/>
		<xsl:if test="$controlField008-35-37">
			<mods:language>
				<mods:languageTerm authority="iso639-2b" type="code">
					<xsl:value-of select="substring($controlField008,36,3)"/>
				</mods:languageTerm>
			</mods:language>
		</xsl:if>

		<xsl:for-each select="marc:datafield[@tag=041]">

			<!--			<xsl:variable name="langCodes">			
				<xsl:copy-of select="marc:subfield[@code='a'or @code='d' or @code='e' or @code='2']"/>
			</xsl:variable>
			-->
			<xsl:variable name="langCodes" select="marc:subfield[@code='a'or @code='d' or @code='e' or @code='2']"/>

			<xsl:choose>
				<xsl:when test="marc:subfield[@code='2']='rfc3066'">
					<!-- not stacked but could be repeated -->
					<xsl:call-template name="rfcLanguages">
						<xsl:with-param name="nodeNum">
							<xsl:value-of select="1"/>
						</xsl:with-param>
						<xsl:with-param name="usedLanguages">
							<xsl:text></xsl:text>
						</xsl:with-param>
						<xsl:with-param name="controlField008-35-37">
							<xsl:value-of select="$controlField008-35-37"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- iso -->
					<xsl:variable name="allLanguages">
						<xsl:copy-of select="$langCodes"/>
					</xsl:variable>
					<xsl:variable name="currentLanguage">
						<xsl:value-of select="substring($allLanguages,1,3)"/>
					</xsl:variable>
					<xsl:call-template name="isoLanguage">
						<xsl:with-param name="currentLanguage">
							<xsl:value-of select="substring($allLanguages,1,3)"/>
						</xsl:with-param>
						<xsl:with-param name="remainingLanguages">
							<xsl:value-of select="substring($allLanguages,4,string-length($allLanguages)-3)"/>
						</xsl:with-param>
						<xsl:with-param name="usedLanguages">
							<xsl:if test="$controlField008-35-37">
								<xsl:value-of select="$controlField008-35-37"/>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<xsl:variable name="physicalDescription">
			<xsl:if test="$typeOf008='CF' and marc:controlfield[@tag=007][substring(.,12,1)='a' or substring(.,12,1)='b']">
				<mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
			</xsl:if>

			<xsl:variable name="controlField008-23" select="substring($controlField008,24,1)"/>
			<xsl:variable name="controlField008-29" select="substring($controlField008,30,1)"/>

			<xsl:variable name="check008-23">
				<xsl:if test="$typeOf008='BK' or $typeOf008='MU' or $typeOf008='SE' or $typeOf008='MM'">
					<xsl:value-of select="true()"/>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="check008-29">
				<xsl:if test="$typeOf008='MP' or $typeOf008='VM'">
					<xsl:value-of select="true()"/>
				</xsl:if>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="($check008-23 and $controlField008-23='f') or ($check008-29 and $controlField008-29='f')">
					<mods:form authority="marcform">braille</mods:form>
				</xsl:when>
				<xsl:when test="($controlField008-23=' ' and ($leader6='c' or $leader6='d')) or (($typeOf008='BK' or $typeOf008='SE') and ($controlField008-23=' ' or $controlField008='r'))">
					<mods:form authority="marcform">print</mods:form>
				</xsl:when>
				<xsl:when test="$leader6 = 'm' or ($check008-23 and $controlField008-23='s') or ($check008-29 and $controlField008-29='s')">
					<mods:form authority="marcform">electronic</mods:form>
				</xsl:when>
				<xsl:when test="($check008-23 and $controlField008-23='b') or ($check008-29 and $controlField008-29='b')">
					<mods:form authority="marcform">microfiche</mods:form>
				</xsl:when>
				<xsl:when test="($check008-23 and $controlField008-23='a') or ($check008-29 and $controlField008-29='a')">
					<mods:form authority="marcform">microfilm</mods:form>
				</xsl:when>
			</xsl:choose>
			<!-- 1/04 fix -->
			<xsl:if test="marc:datafield[@tag=130]/marc:subfield[@code='h']">
				<mods:form authority="gmd">
					<xsl:call-template name="chopBrackets">
						<xsl:with-param name="chopString">
							<xsl:value-of select="marc:datafield[@tag=130]/marc:subfield[@code='h']"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:form>
			</xsl:if>

			<xsl:if test="marc:datafield[@tag=240]/marc:subfield[@code='h']">
				<mods:form authority="gmd">
					<xsl:call-template name="chopBrackets">
						<xsl:with-param name="chopString">
							<xsl:value-of select="marc:datafield[@tag=240]/marc:subfield[@code='h']"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:form>
			</xsl:if>
			<xsl:if test="marc:datafield[@tag=242]/marc:subfield[@code='h']">
				<mods:form authority="gmd">
					<xsl:call-template name="chopBrackets">
						<xsl:with-param name="chopString">
							<xsl:value-of select="marc:datafield[@tag=242]/marc:subfield[@code='h']"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:form>
			</xsl:if>
			<xsl:if test="marc:datafield[@tag=245]/marc:subfield[@code='h']">
				<mods:form authority="gmd">
					<xsl:call-template name="chopBrackets">
						<xsl:with-param name="chopString">
							<xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='h']"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:form>
			</xsl:if>
			<xsl:if test="marc:datafield[@tag=246]/marc:subfield[@code='h']">
				<mods:form authority="gmd">
					<xsl:call-template name="chopBrackets">
						<xsl:with-param name="chopString">
							<xsl:value-of select="marc:datafield[@tag=246]/marc:subfield[@code='h']"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:form>
			</xsl:if>
			<xsl:if test="marc:datafield[@tag=730]/marc:subfield[@code='h']">
				<mods:form authority="gmd">
					<xsl:call-template name="chopBrackets">
						<xsl:with-param name="chopString">
							<xsl:value-of select="marc:datafield[@tag=730]/marc:subfield[@code='h']"/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:form>
			</xsl:if>
			<xsl:for-each select="marc:datafield[@tag=256]/marc:subfield[@code='a']">
				<mods:form>
					<xsl:value-of select="."/>
				</mods:form>
			</xsl:for-each>

			<xsl:for-each select="marc:controlfield[@tag=007][substring(text(),1,1)='c']">
				<xsl:choose>
					<xsl:when test="substring(text(),14,1)='a'">
						<mods:reformattingQuality>access</mods:reformattingQuality>
					</xsl:when>
					<xsl:when test="substring(text(),14,1)='p'">
						<mods:reformattingQuality>preservation</mods:reformattingQuality>
					</xsl:when>
					<xsl:when test="substring(text(),14,1)='r'">
						<mods:reformattingQuality>replacement</mods:reformattingQuality>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='q'][string-length(.)&gt;1]">
				<mods:internetMediaType>
					<xsl:value-of select="."/>
				</mods:internetMediaType>
			</xsl:for-each>

			<xsl:for-each select="marc:datafield[@tag=300]">
				<mods:extent>
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">abce</xsl:with-param>
					</xsl:call-template>
				</mods:extent>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length(normalize-space($physicalDescription))">
			<mods:physicalDescription>
				<xsl:copy-of select="$physicalDescription"/>
			</mods:physicalDescription>
		</xsl:if>

		<xsl:for-each select="marc:datafield[@tag=520]">
			<abstract>
				<xsl:call-template name="uri"/>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</abstract>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=505]">
			<mods:tableOfContents>
				<xsl:call-template name="uri"/>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">agrt</xsl:with-param>
				</xsl:call-template>
			</mods:tableOfContents>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=521]">
			<mods:targetAudience>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</mods:targetAudience>
		</xsl:for-each>

		<xsl:if test="$typeOf008='BK' or $typeOf008='CF' or $typeOf008='MU' or $typeOf008='VM'">
			<xsl:variable name="controlField008-22" select="substring($controlField008,23,1)"/>
			<xsl:choose>
				<!-- 01/04 fix -->
				<xsl:when test="$controlField008-22='d'">
					<mods:targetAudience authority="marctarget">adolescent</mods:targetAudience>
				</xsl:when>
				<xsl:when test="$controlField008-22='e'">
					<mods:targetAudience authority="marctarget">adult</mods:targetAudience>
				</xsl:when>
				<xsl:when test="$controlField008-22='g'">
					<mods:targetAudience authority="marctarget">general</mods:targetAudience>
				</xsl:when>
				<xsl:when test="$controlField008-22='b' or $controlField008-22='c' or $controlField008-22='j'">
					<mods:targetAudience authority="marctarget">juvenile</mods:targetAudience>
				</xsl:when>
				<xsl:when test="$controlField008-22='a'">
					<mods:targetAudience authority="marctarget">preschool</mods:targetAudience>
				</xsl:when>
				<xsl:when test="$controlField008-22='f'">
					<mods:targetAudience authority="marctarget">specialized</mods:targetAudience>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:for-each select="marc:datafield[@tag=245]/marc:subfield[@code='c']">
			<mods:note type="statement of responsibility">
				<xsl:value-of select="."/>
			</mods:note>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=500]">
			<mods:note>
				<xsl:value-of select="marc:subfield[@code='a']"/>
				<xsl:call-template name="uri"/>
			</mods:note>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=511]">
			<mods:note type="performers">
				<xsl:call-template name="uri"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:note>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=518]">
			<mods:note type="venue">
				<xsl:call-template name="uri"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:note>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=501 or @tag=502 or @tag=504 or @tag=506 or @tag=507 or @tag=508 or  @tag=513 or @tag=514 or @tag=515 or @tag=516 or @tag=522 or @tag=524 or @tag=525 or @tag=526 or @tag=530 or @tag=533 or @tag=534 or @tag=535 or @tag=536 or @tag=538 or @tag=540 or @tag=541 or @tag=544 or @tag=545 or @tag=546 or @tag=547 or @tag=550 or @tag=552 or @tag=555 or @tag=556 or @tag=561 or @tag=562 or @tag=565 or @tag=567 or @tag=580 or @tag=581 or @tag=583 or @tag=584 or @tag=585 or @tag=586]">
			<mods:note>
				<xsl:call-template name="uri"/>
				<xsl:variable name="str">
					<xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
						<xsl:value-of select="."/>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
			</mods:note>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=034][marc:subfield[@code='d' or @code='e' or @code='f' or @code='g']]">
			<mods:subject>
				<cartographics>
					<coordinates>
						<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">defg</xsl:with-param>
						</xsl:call-template>
					</coordinates>
				</cartographics>
			</mods:subject>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=043]">
			<mods:subject>
				<xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c']">
					<mods:geographicCode>
						<xsl:attribute name="authority">
							<xsl:if test="@code='a'">
								<xsl:text>marcgac</xsl:text>
							</xsl:if>
							<xsl:if test="@code='b'">
								<xsl:value-of select="following-sibling::marc:subfield[@code=2]"/>
							</xsl:if>
							<xsl:if test="@code='c'">
								<xsl:text>iso3166</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<xsl:value-of select="self::marc:subfield"/>
					</mods:geographicCode>
				</xsl:for-each>
			</mods:subject>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=255]">
			<mods:subject>
				<cartographics>
					<xsl:for-each select="marc:subfield[@code='c']">
						<coordinates>
							<xsl:value-of select="."/>
						</coordinates>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='a']">
						<scale>
							<xsl:value-of select="."/>
						</scale>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='b']">
						<projection>
							<xsl:value-of select="."/>
						</projection>
					</xsl:for-each>
				</cartographics>
			</mods:subject>
		</xsl:for-each>

		<xsl:apply-templates select="marc:datafield[653 &gt;= @tag and @tag &gt;= 600]"/>

		<xsl:apply-templates select="marc:datafield[@tag=656]"/>

		<xsl:for-each select="marc:datafield[@tag=752]">
			<mods:subject>
				<mods:hierarchicalGeographic>
					<xsl:for-each select="marc:subfield[@code='a']">
						<mods:country>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString" select="."/>
							</xsl:call-template>
						</mods:country>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='b']">
						<mods:state>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString" select="."/>
							</xsl:call-template>
						</mods:state>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='c']">
						<mods:county>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString" select="."/>
							</xsl:call-template>
						</mods:county>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='d']">
						<mods:city>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString" select="."/>
							</xsl:call-template>
						</mods:city>
					</xsl:for-each>
				</mods:hierarchicalGeographic>
			</mods:subject>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=045][marc:subfield[@code='b']]">
			<mods:subject>

				<xsl:choose>

					<xsl:when test="@ind1=2">

						<mods:temporal encoding="iso8601" point="start">
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString">
									<xsl:value-of select="marc:subfield[@code='b'][1]"/>
								</xsl:with-param>
							</xsl:call-template>
						</mods:temporal>
						<mods:temporal encoding="iso8601" point="end">
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString">


									<xsl:value-of select="marc:subfield[@code='b'][2]"/>
								</xsl:with-param>
							</xsl:call-template>
						</mods:temporal>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="marc:subfield[@code='b']">
							<mods:temporal encoding="iso8601">
								<xsl:call-template name="chopPunctuation">
									<xsl:with-param name="chopString" select="."/>
								</xsl:call-template>
							</mods:temporal>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</mods:subject>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=050]">
			<xsl:for-each select="marc:subfield[@code='b']">
				<mods:classification authority="lcc">
					<xsl:value-of select="preceding-sibling::marc:subfield[@code='a'][1]"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="text()"/>
				</mods:classification>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='a'][not(following-sibling::marc:subfield[@code='b'])]">
				<mods:classification authority="lcc">
					<xsl:value-of select="text()"/>
				</mods:classification>
			</xsl:for-each>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=082]">
			<mods:classification authority="ddc">
				<xsl:if test="marc:subfield[@code='2']">
					<xsl:attribute name="edition">
						<xsl:value-of select="marc:subfield[@code='2']"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=080]">
			<mods:classification authority="udc">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abx</xsl:with-param>
				</xsl:call-template>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=060]">
			<mods:classification authority="nlm">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=086][@ind1=0]">
			<mods:classification authority="sudocs">
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=086][@ind1=1]">
			<mods:classification authority="candoc">
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=086]">
			<mods:classification>
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=084]">
			<mods:classification>
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</mods:classification>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=440]">
			<mods:relatedItem type="series">
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="subfieldSelect">
									<xsl:with-param name="codes">av</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=490][@ind1=0]">
			<mods:relatedItem type="series">
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="subfieldSelect">
									<xsl:with-param name="codes">av</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=510]">
			<mods:relatedItem type="isReferencedBy">
				<mods:note>
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">abcx3</xsl:with-param>
					</xsl:call-template>
				</mods:note>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=534]">
			<mods:relatedItem type="original">
				<xsl:call-template name="relatedTitle"/>
				<xsl:call-template name="relatedName"/>
				<xsl:if test="marc:subfield[@code='b' or @code='c']">
					<mods:originInfo>
						<xsl:for-each select="marc:subfield[@code='c']">
							<mods:publisher>
								<xsl:value-of select="."/>
							</mods:publisher>
						</xsl:for-each>
						<xsl:for-each select="marc:subfield[@code='b']">
							<mods:edition>
								<xsl:value-of select="."/>
							</mods:edition>
						</xsl:for-each>
					</mods:originInfo>
				</xsl:if>
				<xsl:call-template name="relatedIdentifierISSN"/>
				<xsl:for-each select="marc:subfield[@code='z']">
					<mods:identifier type="isbn">
						<xsl:value-of select="."/>
					</mods:identifier>
				</xsl:for-each>
				<xsl:call-template name="relatedNote"/>
			</mods:relatedItem>
		</xsl:for-each>
		<xsl:if test="marc:datafield[@tag=590]">
			<mods:note><xsl:value-of select="marc:datafield[@tag=590]"/></mods:note>
			
		</xsl:if>

		<xsl:for-each select="marc:datafield[@tag=700][marc:subfield[@code='t']]">
			<mods:relatedItem>
				<xsl:call-template name="constituentOrRelatedType"/>
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="afterCodes">g</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
				<mods:name type="personal">
					<mods:namePart>
						<xsl:call-template name="specialSubfieldSelect">
							<xsl:with-param name="anyCodes">aq</xsl:with-param>
							<xsl:with-param name="axis">t</xsl:with-param>
							<xsl:with-param name="beforeCodes">g</xsl:with-param>
						</xsl:call-template>
					</mods:namePart>
					<xsl:call-template name="termsOfAddress"/>
					<xsl:call-template name="nameDate"/>
					<xsl:call-template name="role"/>
				</mods:name>
				<xsl:call-template name="relatedForm"/>
				<xsl:call-template name="relatedIdentifierISSN"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=710][marc:subfield[@code='t']]">
			<mods:relatedItem>
				<xsl:call-template name="constituentOrRelatedType"/>
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="afterCodes">dg</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="relatedPartNumName"/>
				</mods:titleInfo>
				<mods:name type="corporate">
					<xsl:for-each select="marc:subfield[@code='a']">
						<mods:namePart>
							<xsl:value-of select="."/>
						</mods:namePart>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='b']">
						<mods:namePart>
							<xsl:value-of select="."/>
						</mods:namePart>
					</xsl:for-each>
					<xsl:variable name="tempNamePart">
						<xsl:call-template name="specialSubfieldSelect">
							<xsl:with-param name="anyCodes">c</xsl:with-param>
							<xsl:with-param name="axis">t</xsl:with-param>
							<xsl:with-param name="beforeCodes">dgn</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="normalize-space($tempNamePart)">
						<mods:namePart>
							<xsl:value-of select="$tempNamePart"/>
						</mods:namePart>
					</xsl:if>
					<xsl:call-template name="role"/>
				</mods:name>
				<xsl:call-template name="relatedForm"/>
				<xsl:call-template name="relatedIdentifierISSN"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=711][marc:subfield[@code='t']]">
			<mods:relatedItem>
				<xsl:call-template name="constituentOrRelatedType"/>
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">tfklsv</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="afterCodes">g</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="relatedPartNumName"/>
				</mods:titleInfo>
				<mods:name type="conference">
					<mods:namePart>
						<xsl:call-template name="specialSubfieldSelect">
							<xsl:with-param name="anyCodes">aqdc</xsl:with-param>
							<xsl:with-param name="axis">t</xsl:with-param>
							<xsl:with-param name="beforeCodes">gn</xsl:with-param>
						</xsl:call-template>
					</mods:namePart>
				</mods:name>
				<xsl:call-template name="relatedForm"/>
				<xsl:call-template name="relatedIdentifierISSN"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=730][@ind2=2]">
			<mods:relatedItem>
				<xsl:call-template name="constituentOrRelatedType"/>
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="subfieldSelect">
									<xsl:with-param name="codes">adfgklmorsv</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
				<xsl:call-template name="relatedForm"/>
				<xsl:call-template name="relatedIdentifierISSN"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=740][@ind2=2]">
			<mods:relatedItem>
				<xsl:call-template name="constituentOrRelatedType"/>
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:value-of select="marc:subfield[@code='a']"/>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
				<xsl:call-template name="relatedForm"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=760]|marc:datafield[@tag=762]">
			<mods:relatedItem type="series">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=777]|marc:datafield[@tag=787]">
			<mods:relatedItem>
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=775]">
			<mods:relatedItem type="otherVersion">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=770]|marc:datafield[@tag=774]">
			<mods:relatedItem type="constituent">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=772]|marc:datafield[@tag=773]">
			<mods:relatedItem type="host">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=776]">
			<mods:relatedItem type="otherFormat">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=780]">
			<mods:relatedItem type="preceding">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=785]">
			<mods:relatedItem type="succeeding">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=786]">
			<mods:relatedItem type="original">
				<xsl:call-template name="relatedItem76X-78X"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=800]">
			<mods:relatedItem type="series">
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="afterCodes">g</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
				<mods:name type="personal">
					<mods:namePart>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">aq</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="beforeCodes">g</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:namePart>
					<xsl:call-template name="termsOfAddress"/>
					<xsl:call-template name="nameDate"/>
					<xsl:call-template name="role"/>
				</mods:name>
				<xsl:call-template name="relatedForm"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=810]">
			<mods:relatedItem type="series">
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="afterCodes">dg</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="relatedPartNumName"/>
				</mods:titleInfo>
				<mods:name type="corporate">
					<xsl:for-each select="marc:subfield[@code='a']">
						<mods:namePart>
							<xsl:value-of select="."/>
						</mods:namePart>
					</xsl:for-each>
					<xsl:for-each select="marc:subfield[@code='b']">

						<mods:namePart>
							<xsl:value-of select="."/>
						</mods:namePart>
					</xsl:for-each>
					<mods:namePart>
						<xsl:call-template name="specialSubfieldSelect">
							<xsl:with-param name="anyCodes">c</xsl:with-param>
							<xsl:with-param name="axis">t</xsl:with-param>
							<xsl:with-param name="beforeCodes">dgn</xsl:with-param>
						</xsl:call-template>
					</mods:namePart>
					<xsl:call-template name="role"/>
				</mods:name>
				<xsl:call-template name="relatedForm"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=811]">
			<mods:relatedItem type="series">
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="specialSubfieldSelect">
									<xsl:with-param name="anyCodes">tfklsv</xsl:with-param>
									<xsl:with-param name="axis">t</xsl:with-param>
									<xsl:with-param name="afterCodes">g</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="relatedPartNumName"/>
				</mods:titleInfo>
				<mods:name type="conference">
					<mods:namePart>
						<xsl:call-template name="specialSubfieldSelect">
							<xsl:with-param name="anyCodes">aqdc</xsl:with-param>
							<xsl:with-param name="axis">t</xsl:with-param>
							<xsl:with-param name="beforeCodes">gn</xsl:with-param>
						</xsl:call-template>
					</mods:namePart>
					<xsl:call-template name="role"/>
				</mods:name>
				<xsl:call-template name="relatedForm"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=830]">
			<mods:relatedItem type="series">
				<mods:titleInfo>
					<mods:title>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:call-template name="subfieldSelect">
									<xsl:with-param name="codes">adfgklmorsv</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</mods:title>
					<xsl:call-template name="part"/>
				</mods:titleInfo>
				<xsl:call-template name="relatedForm"/>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=856][@ind2=2]/marc:subfield[@code='q']">
			<mods:relatedItem>
				<mods:internetMediaType>
					<xsl:value-of select="."/>
				</mods:internetMediaType>
			</mods:relatedItem>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=020]">
			<mods:identifier type="isbn">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=024][@ind1=0]">
			<mods:identifier type="isrc">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=024][@ind1=2]">
			<mods:identifier type="ismn">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=022]">
			<mods:identifier type="issn">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=010]">
			<mods:identifier type="lccn">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=028]">
			<mods:identifier>
				<xsl:call-template name="isInvalid"/>
				<xsl:attribute name="type">
					<xsl:choose>
						<xsl:when test="@ind1=0">issue number</xsl:when>
						<xsl:when test="@ind1=1">matrix number</xsl:when>
						<xsl:when test="@ind1=2">music plate</xsl:when>
						<xsl:when test="@ind1=3">music publisher</xsl:when>
						<xsl:when test="@ind1=4">videorecording identifier</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">
						<xsl:choose>
							<xsl:when test="@ind1=0">ba</xsl:when>
							<xsl:otherwise>ab</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=024][@ind1='4']">
			<mods:identifier type="sici">
				<xsl:call-template name="isInvalid"/>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=037]">
			<mods:identifier type="stock number">
				<xsl:call-template name="isInvalid"/>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</mods:identifier>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=856][marc:subfield[@code='u']]">
			<mods:identifier>
				<xsl:attribute name="type">
					<xsl:choose>
						<xsl:when test="starts-with(marc:subfield[@code='u'],'urn:doi') or starts-with(marc:subfield[@code='u'],'doi')">doi</xsl:when>
						<xsl:when test="starts-with(marc:subfield[@code='u'],'urn:hdl') or starts-with(marc:subfield[@code='u'],'hdl') or starts-with(marc:subfield[@code='u'],'http://hdl.loc.gov')">hdl</xsl:when>
						<xsl:otherwise>uri</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="starts-with(marc:subfield[@code='u'],'urn:hdl') or starts-with(marc:subfield[@code='u'],'hdl') or starts-with(marc:subfield[@code='u'],'http://hdl.loc.gov') ">
						<xsl:value-of select="concat('hdl:',substring-after(marc:subfield[@code='u'],'http://hdl.loc.gov/'))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="marc:subfield[@code='u']"/>
					</xsl:otherwise>
				</xsl:choose>
			</mods:identifier>
			<xsl:if test="starts-with(marc:subfield[@code='u'],'urn:hdl') or starts-with(marc:subfield[@code='u'],'hdl')">
				<mods:identifier type="hdl">
					<xsl:if test="marc:subfield[@code='y' or @code='3' or @code='z']">
						<xsl:attribute name="displayLabel">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">y3z</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="concat('hdl:',substring-after(marc:subfield[@code='u'],'http://hdl.loc.gov/'))"/>
				</mods:identifier>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=024][@ind1=1]">
			<mods:identifier type="upc">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mods:identifier>
		</xsl:for-each>
		<!-- 1/04 fix added $y -->
		<xsl:for-each select="marc:datafield[@tag=856][marc:subfield[@code='u']]">
			<mods:location>
				<mods:url>
					<xsl:if test="marc:subfield[@code='y' or @code='3']">
						<xsl:attribute name="displayLabel">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">y3</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="marc:subfield[@code='u']"/>
				</mods:url>
			</mods:location>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=852]">
			<mods:location>
				<mods:physicalLocation>
					<xsl:call-template name="displayLabel"/>
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">abje</xsl:with-param>
					</xsl:call-template>
				</mods:physicalLocation>
			</mods:location>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=506]">
			<accessCondition type="restrictionOnAccess">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcd35</xsl:with-param>
				</xsl:call-template>
			</accessCondition>
		</xsl:for-each>

		<xsl:for-each select="marc:datafield[@tag=540]">
			<accessCondition type="useAndReproduction">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcde35</xsl:with-param>
				</xsl:call-template>
			</accessCondition>
		</xsl:for-each>
		
		<xsl:if test="marc:datafield[@tag=956]">
			<mods:extension>
				<ingestFile><xsl:value-of select="marc:datafield[@tag=956]"/></ingestFile>
			</mods:extension>
			
		</xsl:if>
		<mods:extension>
			<xsl:for-each select="marc:datafield[@tag=940]">
				<localCollectionName><xsl:value-of select="."/></localCollectionName>	
			</xsl:for-each>
		</mods:extension>

		<mods:recordInfo>
			<xsl:for-each select="marc:datafield[@tag=040]">
				<mods:recordContentSource authority="marcorg">
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</mods:recordContentSource>
			</xsl:for-each>

			<xsl:for-each select="marc:controlfield[@tag=008]">
				<mods:recordCreationDate encoding="marc">
					<xsl:value-of select="substring(.,1,6)"/>
				</mods:recordCreationDate>
			</xsl:for-each>

			<xsl:for-each select="marc:controlfield[@tag=005]">
				<mods:recordChangeDate encoding="iso8601">
					<xsl:value-of select="."/>
				</mods:recordChangeDate>
			</xsl:for-each>

			<xsl:for-each select="marc:controlfield[@tag=001]">
				<mods:recordIdentifier>
					<xsl:if test="../marc:controlfield[@tag=003]">
						<xsl:attribute name="source">
							<xsl:value-of select="../marc:controlfield[@tag=003]"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="."/>
				</mods:recordIdentifier>
			</xsl:for-each>
			


			<xsl:for-each select="marc:datafield[@tag=040]/marc:subfield[@code='b']">
				<languageOfCataloging>
					<mods:languageTerm authority="iso639-2b" type="code">
						<xsl:value-of select="."/>
					</mods:languageTerm>
				</languageOfCataloging>
			</xsl:for-each>
		</mods:recordInfo>
	</xsl:template>

	<xsl:template name="displayForm">
		<xsl:for-each select="marc:subfield[@code='c']">
			<displayForm>
				<xsl:value-of select="."/>
			</displayForm>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="affiliation">
		<xsl:for-each select="marc:subfield[@code='u']">
			<affiliation>
				<xsl:value-of select="."/>
			</affiliation>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="uri">
		<xsl:for-each select="marc:subfield[@code='u']">
			<xsl:attribute name="xlink:href">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="role">
		<xsl:for-each select="marc:subfield[@code='e']">
			<mods:role>
				<mods:roleTerm type="text">
					<xsl:value-of select="."/>
				</mods:roleTerm>
			</mods:role>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code='4']">
			<mods:role>
				<mods:roleTerm authority="marcrelator" type="code">
					<xsl:value-of select="."/>
				</mods:roleTerm>
			</mods:role>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="part">
		<xsl:variable name="partNumber">
			<xsl:call-template name="specialSubfieldSelect">
				<xsl:with-param name="axis">n</xsl:with-param>
				<xsl:with-param name="anyCodes">n</xsl:with-param>
				<xsl:with-param name="afterCodes">fghkdlmor</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="partName">
			<xsl:call-template name="specialSubfieldSelect">
				<xsl:with-param name="axis">p</xsl:with-param>
				<xsl:with-param name="anyCodes">p</xsl:with-param>
				<xsl:with-param name="afterCodes">fghkdlmor</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($partNumber))">
			<mods:partNumber>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="$partNumber"/>
				</xsl:call-template>
			</mods:partNumber>
		</xsl:if>
		<xsl:if test="string-length(normalize-space($partName))">
			<mods:partName>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="$partName"/>
				</xsl:call-template>
			</mods:partName>
		</xsl:if>
	</xsl:template>

	<xsl:template name="relatedPart">
		<xsl:if test="@tag=773">
			<xsl:for-each select="marc:subfield[@code='g']">
				<mods:part>
					<text>
						<xsl:value-of select="."/>
					</text>
				</mods:part>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='q']">
				<mods:part>
					<xsl:call-template name="parsePart"/>
				</mods:part>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="relatedPartNumName">
		<xsl:variable name="partNumber">
			<xsl:call-template name="specialSubfieldSelect">
				<xsl:with-param name="axis">g</xsl:with-param>
				<xsl:with-param name="anyCodes">g</xsl:with-param>
				<xsl:with-param name="afterCodes">pst</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="partName">
			<xsl:call-template name="specialSubfieldSelect">
				<xsl:with-param name="axis">p</xsl:with-param>
				<xsl:with-param name="anyCodes">p</xsl:with-param>
				<xsl:with-param name="afterCodes">fghkdlmor</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($partNumber))">
			<mods:partNumber>
				<xsl:value-of select="$partNumber"/>
			</mods:partNumber>
		</xsl:if>
		<xsl:if test="string-length(normalize-space($partName))">
			<mods:partName>
				<xsl:value-of select="$partName"/>
			</mods:partName>
		</xsl:if>
	</xsl:template>

	<xsl:template name="relatedName">
		<xsl:for-each select="marc:subfield[@code='a']">
			<mods:name>
				<mods:namePart>
					<xsl:value-of select="."/>
				</mods:namePart>
			</mods:name>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedForm">
		<xsl:for-each select="marc:subfield[@code='h']">
			<mods:physicalDescription>
				<mods:form>
					<xsl:value-of select="."/>
				</mods:form>
			</mods:physicalDescription>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedExtent">
		<xsl:for-each select="marc:subfield[@code='h']">
			<mods:physicalDescription>
				<mods:extent>
					<xsl:value-of select="."/>
				</mods:extent>
			</mods:physicalDescription>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedNote">
		<xsl:for-each select="marc:subfield[@code='n']">
			<mods:note>
				<xsl:value-of select="."/>
			</mods:note>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedSubject">
		<xsl:for-each select="marc:subfield[@code='j']">
			<mods:subject>
				<mods:temporal encoding="iso8601">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString" select="."/>
					</xsl:call-template>
				</mods:temporal>
			</mods:subject>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedIdentifierISSN">
		<xsl:for-each select="marc:subfield[@code='x']">
			<mods:identifier type="issn">
				<xsl:value-of select="."/>
			</mods:identifier>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedIdentifierLocal">
		<xsl:for-each select="marc:subfield[@code='w']">
			<mods:identifier type="local">
				<xsl:value-of select="."/>
			</mods:identifier>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedIdentifier">
		<xsl:for-each select="marc:subfield[@code='o']">
			<mods:identifier>
				<xsl:value-of select="."/>
			</mods:identifier>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedItem76X-78X">
		<xsl:call-template name="displayLabel"/>
		<xsl:call-template name="relatedTitle76X-78X"/>
		<xsl:call-template name="relatedName"/>
		<xsl:call-template name="relatedOriginInfo"/>
		<xsl:call-template name="relatedLanguage"/>
		<xsl:call-template name="relatedExtent"/>
		<xsl:call-template name="relatedNote"/>
		<xsl:call-template name="relatedSubject"/>
		<xsl:call-template name="relatedIdentifier"/>
		<xsl:call-template name="relatedIdentifierISSN"/>
		<xsl:call-template name="relatedIdentifierLocal"/>
		<xsl:call-template name="relatedPart"/>
	</xsl:template>

	<xsl:template name="subjectGeographicZ">
		<mods:geographic>


			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString" select="."/>
			</xsl:call-template>
		</mods:geographic>
	</xsl:template>

	<xsl:template name="subjectTemporalY">
		<mods:temporal>
			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString" select="."/>
			</xsl:call-template>
		</mods:temporal>
	</xsl:template>

	<xsl:template name="subjectTopic">
		<mods:topic>
			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString" select="."/>
			</xsl:call-template>
		</mods:topic>
	</xsl:template>

	<xsl:template name="nameABCDN">
		<xsl:for-each select="marc:subfield[@code='a']">
			<mods:namePart>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="."/>
				</xsl:call-template>
			</mods:namePart>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code='b']">
			<mods:namePart>
				<xsl:value-of select="."/>
			</mods:namePart>
		</xsl:for-each>
		<xsl:if test="marc:subfield[@code='c'] or marc:subfield[@code='d'] or marc:subfield[@code='n']">
			<mods:namePart>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">cdn</xsl:with-param>
				</xsl:call-template>
			</mods:namePart>
		</xsl:if>
	</xsl:template>

	<xsl:template name="nameABCDQ">
		<mods:namePart>
			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString">
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">aq</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="punctuation">
					<xsl:text>:,;/ </xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</mods:namePart>
		<xsl:call-template name="termsOfAddress"/>
		<xsl:call-template name="nameDate"/>
	</xsl:template>

	<xsl:template name="nameACDEQ">
		<mods:namePart>
			<xsl:call-template name="subfieldSelect">
				<xsl:with-param name="codes">acdeq</xsl:with-param>
			</xsl:call-template>
		</mods:namePart>
	</xsl:template>

	<xsl:template name="constituentOrRelatedType">
		<xsl:if test="@ind2=2">
			<xsl:attribute name="type">constituent</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="relatedTitle">
		<xsl:for-each select="marc:subfield[@code='t']">
			<mods:titleInfo>
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
			</mods:titleInfo>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedTitle76X-78X">
		<xsl:for-each select="marc:subfield[@code='t']">
			<mods:titleInfo>
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:if test="marc:datafield[@tag!=773]and marc:subfield[@code='g']">
					<xsl:call-template name="relatedPartNumName"/>
				</xsl:if>
			</mods:titleInfo>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code='p']">
			<mods:titleInfo type="abbreviated">
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:if test="marc:datafield[@tag!=773]and marc:subfield[@code='g']">
					<xsl:call-template name="relatedPartNumName"/>
				</xsl:if>
			</mods:titleInfo>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code='s']">
			<mods:titleInfo type="uniform">
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</mods:title>
				<xsl:if test="marc:datafield[@tag!=773]and marc:subfield[@code='g']">
					<xsl:call-template name="relatedPartNumName"/>
				</xsl:if>
			</mods:titleInfo>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="relatedOriginInfo">
		<xsl:if test="marc:subfield[@code='b' or @code='d'] or marc:subfield[@code='f']">
			<mods:originInfo>
				<xsl:if test="@tag=775">
					<xsl:for-each select="marc:subfield[@code='f']">
						<mods:place>
							<mods:placeTerm>
								<xsl:attribute name="type">code</xsl:attribute>
								<xsl:attribute name="authority">marcgac</xsl:attribute>
								<xsl:value-of select="."/>
							</mods:placeTerm>
						</mods:place>
					</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="marc:subfield[@code='d']">
					<mods:publisher>
						<xsl:value-of select="."/>
					</mods:publisher>
				</xsl:for-each>
				<xsl:for-each select="marc:subfield[@code='b']">
					<mods:edition>
						<xsl:value-of select="."/>
					</mods:edition>
				</xsl:for-each>
			</mods:originInfo>
		</xsl:if>
	</xsl:template>

	<xsl:template name="relatedLanguage">
		<xsl:for-each select="marc:subfield[@code='e']">
			<xsl:call-template name="getLanguage">
				<xsl:with-param name="langString">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="nameDate">
		<xsl:for-each select="marc:subfield[@code='d']">
			<mods:namePart type="date">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="."/>
				</xsl:call-template>
			</mods:namePart>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="subjectAuthority">

		<xsl:if test="@ind2!=4">
			<xsl:if test="@ind2!=' '">
				<xsl:if test="@ind2!=8">
					<xsl:if test="@ind2!=9">
						<xsl:attribute name="authority">
							<xsl:choose>

								<xsl:when test="@ind2=0">lcsh</xsl:when>
								<xsl:when test="@ind2=1">lcshac</xsl:when>
								<xsl:when test="@ind2=2">mesh</xsl:when>
								<!-- 1/04 fix -->
								<xsl:when test="@ind2=3">nal</xsl:when>
								<xsl:when test="@ind2=5">csh</xsl:when>
								<xsl:when test="@ind2=6">rvm</xsl:when>
								<xsl:when test="@ind2=7">
									<xsl:value-of select="marc:subfield[@code='2']"/>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subjectAnyOrder">
		<xsl:for-each select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">
			<xsl:choose>
				<xsl:when test="@code='v'">
					<xsl:call-template name="subjectTopic"/>
				</xsl:when>
				<xsl:when test="@code='x'">
					<xsl:call-template name="subjectTopic"/>
				</xsl:when>
				<xsl:when test="@code='y'">
					<xsl:call-template name="subjectTemporalY"/>
				</xsl:when>
				<xsl:when test="@code='z'">
					<xsl:call-template name="subjectGeographicZ"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="specialSubfieldSelect">
		<xsl:param name="anyCodes"/>
		<xsl:param name="axis"/>
		<xsl:param name="beforeCodes"/>
		<xsl:param name="afterCodes"/>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($anyCodes, @code)      or (contains($beforeCodes,@code) and following-sibling::marc:subfield[@code=$axis])      or (contains($afterCodes,@code) and preceding-sibling::marc:subfield[@code=$axis])">
					<xsl:value-of select="text()"/>
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=600]">
		<mods:subject>
			<xsl:call-template name="subjectAuthority"/>
			<mods:name type="personal">
				<xsl:call-template name="termsOfAddress"/>
				<mods:namePart>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">aq</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</mods:namePart>
				<xsl:call-template name="nameDate"/>
				<xsl:call-template name="affiliation"/>
				<xsl:call-template name="role"/>
			</mods:name>
			<xsl:call-template name="subjectAnyOrder"/>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=610]">
		<mods:subject>
			<xsl:call-template name="subjectAuthority"/>
			<mods:name type="corporate">
				<xsl:for-each select="marc:subfield[@code='a']">
					<mods:namePart>
						<xsl:value-of select="."/>
					</mods:namePart>
				</xsl:for-each>
				<xsl:for-each select="marc:subfield[@code='b']">
					<mods:namePart>
						<xsl:value-of select="."/>
					</mods:namePart>
				</xsl:for-each>
				<xsl:if test="marc:subfield[@code='c' or @code='d' or @code='n' or @code='p']">
					<mods:namePart>
						<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">cdnp</xsl:with-param>
						</xsl:call-template>
					</mods:namePart>
				</xsl:if>
				<xsl:call-template name="role"/>
			</mods:name>
			<xsl:call-template name="subjectAnyOrder"/>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=611]">
		<mods:subject>
			<xsl:call-template name="subjectAuthority"/>
			<mods:name type="conference">
				<mods:namePart>
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">abcdeqnp</xsl:with-param>
					</xsl:call-template>
				</mods:namePart>
				<xsl:for-each select="marc:subfield[@code='4']">
					<mods:role>
						<mods:roleTerm authority="marcrelator" type="code">
							<xsl:value-of select="."/>
						</mods:roleTerm>
					</mods:role>
				</xsl:for-each>
			</mods:name>
			<xsl:call-template name="subjectAnyOrder"/>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=630]">
		<mods:subject>
			<xsl:call-template name="subjectAuthority"/>
			<mods:titleInfo>
				<mods:title>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">adfhklor</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="part"/>
				</mods:title>
			</mods:titleInfo>
			<xsl:call-template name="subjectAnyOrder"/>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=650]">
		<mods:subject>
			<xsl:call-template name="subjectAuthority"/>
			<mods:topic>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString">
						<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">abcd</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</mods:topic>
			<xsl:call-template name="subjectAnyOrder"/>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=651]">
		<mods:subject>
			<xsl:call-template name="subjectAuthority"/>
			<xsl:for-each select="marc:subfield[@code='a']">

				<mods:geographic>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString" select="."/>
					</xsl:call-template>
				</mods:geographic>
			</xsl:for-each>

			<xsl:call-template name="subjectAnyOrder"/>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=653]">
		<mods:subject>
			<xsl:for-each select="marc:subfield[@code='a']">
				<mods:topic>
					<xsl:value-of select="."/>
				</mods:topic>
			</xsl:for-each>
		</mods:subject>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=656]">
		<mods:subject>
			<xsl:if test="marc:subfield[@code=2]">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code=2]"/>
				</xsl:attribute>
			</xsl:if>
			<occupation>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString">
						<xsl:value-of select="marc:subfield[@code='a']"/>
					</xsl:with-param>
				</xsl:call-template>
			</occupation>
		</mods:subject>
	</xsl:template>

	<xsl:template name="termsOfAddress">
		<xsl:if test="marc:subfield[@code='b' or @code='c']">
			<mods:namePart type="termsOfAddress">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString">
						<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">bc</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</mods:namePart>
		</xsl:if>
	</xsl:template>

	<xsl:template name="displayLabel">
		<xsl:if test="marc:subfield[@code='i']">
			<xsl:attribute name="displayLabel">
				<xsl:value-of select="marc:subfield[@code='i']"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="marc:subfield[@code='3']">
			<xsl:attribute name="displayLabel">
				<xsl:value-of select="marc:subfield[@code='3']"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="isInvalid">
		<xsl:if test="marc:subfield[@code='z']">
			<xsl:attribute name="invalid">yes</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subtitle">
		<xsl:if test="marc:subfield[@code='b']">
			<mods:subTitle>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString">
						<!-- facp: instead of outputting  marc:subfield[@code='b'] added some XSLT 1.0 to uppercase the first letter of the subtitle-->
						<xsl:variable name="str"><xsl:value-of select="marc:subfield[@code='b']"/></xsl:variable>
						<xsl:variable name="str1"><xsl:value-of select="substring($str,1,1)"></xsl:value-of></xsl:variable>
						<xsl:variable name="str2"><xsl:value-of select="substring($str,2,string-length($str)-1)"></xsl:value-of></xsl:variable>
						<xsl:value-of select="translate($str1, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"></xsl:value-of><xsl:value-of select="$str2"></xsl:value-of>
						<!--<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">b</xsl:with-param>									
						</xsl:call-template>-->
					</xsl:with-param>
				</xsl:call-template>
			</mods:subTitle>
		</xsl:if>
	</xsl:template>

	<xsl:template name="script">
		<xsl:param name="scriptCode"/>
		<xsl:attribute name="script">
			<xsl:choose>
				<xsl:when test="$scriptCode='(3'">Arabic</xsl:when>
				<xsl:when test="$scriptCode='(B'">Latin</xsl:when>
				<xsl:when test="$scriptCode='$1'">Chinese, Japanese, Korean</xsl:when>
				<xsl:when test="$scriptCode='(N'">Cyrillic</xsl:when>
				<xsl:when test="$scriptCode='(2'">Hebrew</xsl:when>
				<xsl:when test="$scriptCode='(S'">Greek</xsl:when>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="parsePart">
		<!-- assumes 773$q= 1:2:3<4
		     with up to 3 levels and one optional start page
		-->
		<xsl:variable name="level1">
			<xsl:choose>
				<xsl:when test="contains(text(),':')">
					<!-- 1:2 -->
					<xsl:value-of select="substring-before(text(),':')"/>
				</xsl:when>
				<xsl:when test="not(contains(text(),':'))">
					<!-- 1 or 1<3 -->
					<xsl:if test="contains(text(),'&lt;')">
						<!-- 1<3 -->
						<xsl:value-of select="substring-before(text(),'&lt;')"/>
					</xsl:if>
					<xsl:if test="not(contains(text(),'&lt;'))">
						<!-- 1 -->
						<xsl:value-of select="text()"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="sici2">
			<xsl:choose>
				<xsl:when test="starts-with(substring-after(text(),$level1),':')">
					<xsl:value-of select="substring(substring-after(text(),$level1),2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after(text(),$level1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="level2">
			<xsl:choose>
				<xsl:when test="contains($sici2,':')">
					<!--  2:3<4  -->
					<xsl:value-of select="substring-before($sici2,':')"/>
				</xsl:when>
				<xsl:when test="contains($sici2,'&lt;')">
					<!-- 1: 2<4 -->
					<xsl:value-of select="substring-before($sici2,'&lt;')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sici2"/>
					<!-- 1:2 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="sici3">
			<xsl:choose>
				<xsl:when test="starts-with(substring-after($sici2,$level2),':')">
					<xsl:value-of select="substring(substring-after($sici2,$level2),2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after($sici2,$level2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="level3">
			<xsl:choose>
				<xsl:when test="contains($sici3,'&lt;')">
					<!-- 2<4 -->
					<xsl:value-of select="substring-before($sici3,'&lt;')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sici3"/>
					<!-- 3 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="page">
			<xsl:if test="contains(text(),'&lt;')">
				<xsl:value-of select="substring-after(text(),'&lt;')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$level1">
			<mods:detail level="1">
				<mods:number>
					<xsl:value-of select="$level1"/>
				</mods:number>
			</mods:detail>
		</xsl:if>
		<xsl:if test="$level2">
			<mods:detail level="2">
				<mods:number>
					<xsl:value-of select="$level2"/>
				</mods:number>
			</mods:detail>
		</xsl:if>
		<xsl:if test="$level3">
			<mods:detail level="3">
				<mods:number>
					<xsl:value-of select="$level3"/>
				</mods:number>
			</mods:detail>
		</xsl:if>
		<xsl:if test="$page">
			<mods:extent unit="page">
				<mods:start>
					<xsl:value-of select="$page"/>
				</mods:start>
			</mods:extent>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLanguage">
		<xsl:param name="langString"/>
		<xsl:param name="controlField008-35-37"/>
		<xsl:variable name="length" select="string-length($langString)"/>
		<xsl:choose>
			<xsl:when test="$length=0"/>
			<xsl:when test="$controlField008-35-37=substring($langString,1,3)">
				<xsl:call-template name="getLanguage">
					<xsl:with-param name="langString" select="substring($langString,4,$length)"/>
					<xsl:with-param name="controlField008-35-37" select="$controlField008-35-37"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<mods:language>
					<mods:languageTerm authority="iso639-2b" type="code">
						<xsl:value-of select="substring($langString,1,3)"/>
					</mods:languageTerm>
				</mods:language>
				<xsl:call-template name="getLanguage">
					<xsl:with-param name="langString" select="substring($langString,4,$length)"/>
					<xsl:with-param name="controlField008-35-37" select="$controlField008-35-37"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="isoLanguage">
		<xsl:param name="currentLanguage"/>
		<xsl:param name="usedLanguages"/>
		<xsl:param name="remainingLanguages"/>
		<xsl:choose>
			<xsl:when test="string-length($currentLanguage)=0"/>
			<xsl:when test="not(contains($usedLanguages, $currentLanguage))">
				<mods:language>
					<mods:languageTerm authority="iso639-2b" type="code">
						<xsl:value-of select="$currentLanguage"/>
					</mods:languageTerm>
				</mods:language>
				<xsl:call-template name="isoLanguage">
					<xsl:with-param name="currentLanguage">
						<xsl:value-of select="substring($remainingLanguages,1,3)"/>
					</xsl:with-param>
					<xsl:with-param name="usedLanguages">
						<xsl:value-of select="concat($usedLanguages,$currentLanguage)"/>
					</xsl:with-param>
					<xsl:with-param name="remainingLanguages">
						<xsl:value-of select="substring($remainingLanguages,4,string-length($remainingLanguages))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="isoLanguage">
					<xsl:with-param name="currentLanguage">
						<xsl:value-of select="substring($remainingLanguages,1,3)"/>
					</xsl:with-param>
					<xsl:with-param name="usedLanguages">
						<xsl:value-of select="concat($usedLanguages,$currentLanguage)"/>
					</xsl:with-param>
					<xsl:with-param name="remainingLanguages">
						<xsl:value-of select="substring($remainingLanguages,4,string-length($remainingLanguages))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="chopBrackets">
		<xsl:param name="chopString"/>
		<xsl:variable name="string">
			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString" select="$chopString"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="substring($string, 1,1)='['">
			<xsl:value-of select="substring($string,2, string-length($string)-2)"/>
		</xsl:if>
		<xsl:if test="substring($string, 1,1)!='['">
			<xsl:value-of select="$string"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="rfcLanguages">
		<xsl:param name="nodeNum"/>
		<xsl:param name="usedLanguages"/>
		<xsl:param name="controlField008-35-37"/>
		<!-- ??? xalan -->

		<xsl:variable name="currentLanguage" select="marc:subfield[position()=$nodeNum]/text()"/>
		<xsl:choose>
			<xsl:when test="not($currentLanguage)"/>
			<xsl:when test="$currentLanguage!=$controlField008-35-37 and $currentLanguage!='rfc3066'">
				<xsl:if test="not(contains($usedLanguages,$currentLanguage))">
					<mods:language>
						<mods:languageTerm authority="rfc3066" type="code">
							<xsl:value-of select="$currentLanguage"/>
						</mods:languageTerm>
					</mods:language>
				</xsl:if>
				<xsl:call-template name="rfcLanguages">
					<!-- ??? xalan -->
					<xsl:with-param name="nodeNum">
						<xsl:value-of select="$nodeNum+1"/>
					</xsl:with-param>
					<xsl:with-param name="usedLanguages">
						<xsl:value-of select="concat($usedLanguages,'|',$currentLanguage)"/>
					</xsl:with-param>
					<xsl:with-param name="controlField008-35-37">
						<xsl:value-of select="$controlField008-35-37"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="rfcLanguages">
					<xsl:with-param name="nodeNum">
						<xsl:value-of select="$nodeNum+1"/>
					</xsl:with-param>
					<xsl:with-param name="usedLanguages">
						<xsl:value-of select="concat($usedLanguages,$currentLanguage)"/>
					</xsl:with-param>
					<xsl:with-param name="controlField008-35-37">
						<xsl:value-of select="$controlField008-35-37"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="Apr 02 Test" userelativepaths="yes" externalpreview="no" url="file://n:\jackie\test_files\v3.xml" htmlbaseurl="" outputurl="file://n:\temp\x.xml" processortype="xalan" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="v3Test1" userelativepaths="yes" externalpreview="no" url="file://n:\jackie\test_files\v3.xml" htmlbaseurl="" outputurl="file://n:\jackie\test_files\modsv3Converted.xml" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="file://n:\ckeith\DESKTOP\test.xml" htmlbaseurl="" outputurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="Test" userelativepaths="yes" externalpreview="no" url="file://n:\jackie\MARCXML\marcxmlfile.xml" htmlbaseurl="" outputurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->