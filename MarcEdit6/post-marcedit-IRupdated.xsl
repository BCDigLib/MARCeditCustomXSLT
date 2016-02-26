<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/">
    
<!-- XSLT for processing MODS record after running through MARC21slim2MODS3_IRupdated.xsl in MarcEdit; maps to Boston College's standard MODS implementation -->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" media-type="application/xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()[normalize-space()]|@*[normalize-space()]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:name[@type='personal']">
          <xsl:element name="mods:name">
                <xsl:attribute name='type'>personal</xsl:attribute>
                <xsl:if test="@usage='primary'">
                    <xsl:attribute name='usage'>primary</xsl:attribute>
                </xsl:if>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name='type'>family</xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before(mods:namePart,','))"/>
                </xsl:element>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name='type'>given</xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-after(mods:namePart,','))"/>
                </xsl:element> 
                <xsl:element name="mods:displayForm">
                    <xsl:value-of select="normalize-space(mods:namePart)"/>
                </xsl:element>
                <xsl:copy-of select="mods:role"/>                    
            </xsl:element>
    </xsl:template>
    <xsl:template match="mods:name[@type='corporate']">
        <xsl:element name="mods:name">
            <xsl:attribute name='type'>corporate</xsl:attribute>
            <xsl:if test="@usage='primary'">
                <xsl:attribute name='usage'>primary</xsl:attribute>
            </xsl:if>
            <xsl:element name="mods:namePart">
                <xsl:value-of select="normalize-space(mods:namePart)"/>
            </xsl:element>
            <xsl:element name="mods:displayForm">
                <xsl:value-of select="normalize-space(mods:namePart)"/>
            </xsl:element>
            <xsl:copy-of select="mods:role"/>                    
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:originInfo">
        <xsl:element name="mods:originInfo"> 
            <xsl:copy-of select="mods:place"/>
            <xsl:copy-of select="mods:publisher"/>
            <xsl:choose>
            <xsl:when test="mods:dateIssued[not(@encoding)]">
                <xsl:choose>
                    <xsl:when test="mods:dateIssued[not(@encoding) and contains(., '[')]">
                        <xsl:element name="mods:dateIssued">
                            <xsl:attribute name="qualifier">inferred</xsl:attribute>
                            <xsl:value-of select="normalize-space(translate(mods:dateIssued[not(@encoding) and contains(., '[')], '[]', ''))"/>
                        </xsl:element>  
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:element name="mods:dateIssued"><xsl:value-of select="normalize-space(mods:dateIssued[not(@encoding)])"/></xsl:element>
                        </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:dateIssued"><xsl:value-of select="normalize-space(mods:dateIssued[(@encoding)])"/></xsl:element>  
            </xsl:otherwise>
            </xsl:choose>        
            <xsl:element name="mods:dateIssued">
                <xsl:attribute name="encoding">w3cdtf</xsl:attribute>        
                <xsl:attribute name="keyDate">yes</xsl:attribute> 
                <xsl:value-of select="normalize-space(mods:dateIssued[@encoding='marc'])"/>
            </xsl:element>
            <xsl:if test="mods:copyrightDate">
                <xsl:element name="mods:copyrightDate">
                    <xsl:attribute name="encoding">w3cdtf</xsl:attribute>        
                    <xsl:value-of select="normalize-space(mods:copyrightDate[@encoding='marc'])"/>
                </xsl:element>
            </xsl:if>
            <xsl:copy-of select="mods:issuance"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:language">
        <xsl:element name="mods:language">
            <xsl:copy-of select="mods:languageTerm[@type='code']"/>
            <xsl:element name="mods:languageTerm">
                <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:if test="mods:languageTerm[@type='code']='ara'">Arabic</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='eng'">English</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='fre'">French</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='ger'">German</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='ita'">Italian</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='lat'">Latin</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='spa'">Spanish</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='tur'">Turkish</xsl:if> 
            </xsl:element>
        </xsl:element>      
    </xsl:template>
    <xsl:template match="mods:physicalDescription">
        <xsl:element name="mods:physicalDescription">
            <xsl:element name="mods:form">
                <xsl:attribute name='authority'>marcform</xsl:attribute>
                <xsl:text>electronic</xsl:text>
            </xsl:element>
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
            <xsl:copy-of select="mods:extent"/>
            <xsl:element name="mods:digitalOrigin">
                <xsl:text>born digital</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:recordContentSource[@authority='marcorg' and .='BXM']">
        <xsl:element name="mods:recordContentSource">
            <xsl:attribute name="authority">marcorg</xsl:attribute> 
            <xsl:text>MChB</xsl:text>            
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>