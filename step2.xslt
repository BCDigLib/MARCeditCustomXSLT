<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3">
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:template match="/">

<xsl:choose>
 <xsl:when test="records">

 
 <records>
    
            <xsl:for-each select="//records/record">
              <record>                
                 <xsl:attribute name="oclcNo">
    <xsl:value-of select="@oclcNo" />
                 </xsl:attribute> 
               <xsl:for-each select="mods:titleInfo">
                    <mods:titleInfo>
                     
                     <xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@ID"><xsl:attribute name="ID"><xsl:value-of select="@ID"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@xlink"><xsl:attribute name="xlink"><xsl:value-of select="@xlink"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@lang"><xsl:attribute name="lang"><xsl:value-of select="@lang"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"></xsl:value-of></xsl:attribute></xsl:if>      
                     <xsl:if test="@script"><xsl:attribute name="script"><xsl:value-of select="@script"></xsl:value-of></xsl:attribute></xsl:if>
                          <xsl:if test="@transliteration"> <xsl:attribute name="transliteration"><xsl:value-of select="@transliteration"></xsl:value-of></xsl:attribute></xsl:if>
       <xsl:copy-of select="mods:nonSort"></xsl:copy-of>
                     <xsl:copy-of select="mods:title"></xsl:copy-of>    
                     <xsl:if test="mods:subTitle">
                     <xsl:variable name="subtitle" select="mods:subTitle"/>

                     <xsl:variable name="str1"><xsl:value-of select="substring($subtitle,1,1)"></xsl:value-of></xsl:variable>
						<xsl:variable name="str2"><xsl:value-of select="substring($subtitle,2,string-length($subtitle)-1)"></xsl:value-of></xsl:variable>
						<mods:subTitle><xsl:value-of select="translate($str1, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"></xsl:value-of><xsl:value-of select="$str2"></xsl:value-of></mods:subTitle>
  	  	</xsl:if>
        <xsl:copy-of select="mods:partNumber"></xsl:copy-of>
                     <xsl:copy-of select="mods:partName"></xsl:copy-of>
                     

                     
                    </mods:titleInfo>
 
  </xsl:for-each>


               
               
                 

      <xsl:apply-templates select="mods:name"/> 
           
                 
                   
                                 
                    <xsl:copy-of select="mods:typeOfResource"/>
                    <xsl:copy-of select="mods:genre"/>
                    <xsl:copy-of select="mods:originInfo"/>
                    <xsl:copy-of select="mods:language"/>
                    <xsl:copy-of select="mods:physicalDescription"/>
                    <xsl:copy-of select="mods:abstract"/>
                    <xsl:copy-of select="mods:tableOfContents"/>
                    <xsl:copy-of select="mods:targetAudience"/>
                    <xsl:copy-of select="mods:note"/>
               <xsl:copy-of select="mods:subject"/>
                    <xsl:copy-of select="mods:classification"/>
                   <xsl:copy-of select="mods:relatedItem"/>
                     
                    <xsl:copy-of select="mods:identifier"/>
                    <xsl:copy-of select="mods:location"/>
                    <xsl:copy-of select="mods:accessCondition"/>
                    <xsl:copy-of select="mods:part"/>
                    <xsl:copy-of select="mods:extension"/>
               <mods:recordInfo>
                
                <xsl:copy-of select="mods:recordInfo/mods:recordIdentifier"/>
               </mods:recordInfo>

                </record>
            </xsl:for-each>
 </records>
 </xsl:when>
 <xsl:otherwise>
  
   <mods:modsCollection xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mods="http://www.loc.gov/mods/v3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd">
    
            <xsl:for-each select="//mods:modsCollection/mods:mods">
              <mods:mods>                
          <xsl:for-each select="mods:titleInfo">
                    <mods:titleInfo>
                     
                     <xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@ID"><xsl:attribute name="ID"><xsl:value-of select="@ID"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@xlink"><xsl:attribute name="xlink"><xsl:value-of select="@xlink"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@lang"><xsl:attribute name="lang"><xsl:value-of select="@lang"></xsl:value-of></xsl:attribute></xsl:if>
                     <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"></xsl:value-of></xsl:attribute></xsl:if>      
                     <xsl:if test="@script"><xsl:attribute name="script"><xsl:value-of select="@script"></xsl:value-of></xsl:attribute></xsl:if>
                          <xsl:if test="@transliteration"> <xsl:attribute name="transliteration"><xsl:value-of select="@transliteration"></xsl:value-of></xsl:attribute></xsl:if>
       <xsl:copy-of select="mods:nonSort"></xsl:copy-of>
                     <xsl:copy-of select="mods:title"></xsl:copy-of>    
                     <xsl:if test="mods:subTitle">
                     <xsl:variable name="subtitle" select="mods:subTitle"/>

                     <xsl:variable name="str1"><xsl:value-of select="substring($subtitle,1,1)"></xsl:value-of></xsl:variable>
						<xsl:variable name="str2"><xsl:value-of select="substring($subtitle,2,string-length($subtitle)-1)"></xsl:value-of></xsl:variable>
						<mods:subTitle><xsl:value-of select="translate($str1, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"></xsl:value-of><xsl:value-of select="$str2"></xsl:value-of></mods:subTitle>
  	  	</xsl:if>
        <xsl:copy-of select="mods:partNumber"></xsl:copy-of>
                     <xsl:copy-of select="mods:partName"></xsl:copy-of>
                     

                     
                    </mods:titleInfo>
 
  </xsl:for-each>
 
  


               
               
                 

      <xsl:apply-templates select="mods:name"/> 
           
                 
                   
                                 
                    <xsl:copy-of select="mods:typeOfResource"/>
                    <xsl:copy-of select="mods:genre"/>
                    <xsl:copy-of select="mods:originInfo"/>
                    <xsl:copy-of select="mods:language"/>
                    <xsl:copy-of select="mods:physicalDescription"/>
                    <xsl:copy-of select="mods:abstract"/>
                    <xsl:copy-of select="mods:tableOfContents"/>
                    <xsl:copy-of select="mods:targetAudience"/>
                    <xsl:copy-of select="mods:note"/>
               <xsl:copy-of select="mods:subject"/>
                    <xsl:copy-of select="mods:classification"/>
                   <xsl:copy-of select="mods:relatedItem"/>
                     
                    <xsl:copy-of select="mods:identifier"/>
                    <xsl:copy-of select="mods:location"/>
                    <xsl:copy-of select="mods:accessCondition"/>
                    <xsl:copy-of select="mods:part"/>
                    <xsl:copy-of select="mods:extension"/>
                 
                
                <xsl:copy-of select="mods:recordInfo"/>

                </mods:mods>
            </xsl:for-each>
        </mods:modsCollection>
 </xsl:otherwise>
</xsl:choose>

 </xsl:template>
 <!--name template-->

   <xsl:template match="mods:name">
    
    <!--Test to see if Faculty Name-->
                  <xsl:variable name="shortname" select="mods:namePart[not(@type)]"></xsl:variable>
    <xsl:choose>
    <xsl:when test="document('facultyNames.xml')/shortNameLookup/snToName[@shortname=$shortname] != ''"> 
     <xsl:call-template name="facultyName">
      <xsl:with-param name="shortname" select="mods:namePart[not(@type)]"></xsl:with-param>
     </xsl:call-template>
     </xsl:when>

         <xsl:otherwise>
<!-- Test to see if personal name-->
    
<xsl:variable name="test"/>
     <xsl:if test="@type='personal'">
                   <xsl:call-template name="personalName"></xsl:call-template>
                  
     </xsl:if>
          <xsl:if test="@type='corporate' or @type='conference'">
               <xsl:call-template name="corpConfName"></xsl:call-template>
          </xsl:if>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:template>
 
 <!--faculty Name Template-->
 <!--eventuallly add a authority attribute test here-->
 <xsl:template name="facultyName">
  <xsl:param name="shortname"/>
     <mods:name type="personal" authority="naf">
                     <xsl:copy-of select="document('facultyNames.xml')/shortNameLookup/snToName[@shortname=$shortname]/mods:namePart"/>
                        <xsl:copy-of select="document('facultyNames.xml')/shortNameLookup/snToName[@shortname=$shortname]/mods:displayForm"/>
                        <xsl:copy-of select="document('facultyNames.xml')/shortNameLookup/snToName[@shortname=$shortname]/mods:affiliation"/>
 <mods:role>
  <mods:roleTerm type="text" authority="marcrelator"><xsl:value-of select="mods:role/mods:roleTerm"/></mods:roleTerm>
 </mods:role>                
                           <xsl:copy-of select="document('facultyNames.xml')/shortNameLookup/snToName[@shortname=$shortname]/mods:description"/>
                    </mods:name>
  
 </xsl:template>
 <!-- personalName template-->
 <xsl:template name="personalName">
     <!--Test for presence of first and last name-->
         <xsl:choose>
          <xsl:when test="substring-before(mods:namePart[not(@type)],',')">
           <xsl:call-template name="compoundPersonalName">
            <xsl:with-param name="familyName" select="substring-before(mods:namePart[not(@type)],',')"></xsl:with-param>
           </xsl:call-template>
          </xsl:when>
 
  
                  </xsl:choose>

	 
  
 </xsl:template>
 <!--compoundPersonalName-->
 <xsl:template name="compoundPersonalName">
 <xsl:param name="familyName"/> 
  <xsl:variable name="givenName" select="substring-after(mods:namePart[not(@type)],', ')"></xsl:variable>
        <mods:name type="personal">
         <xsl:choose>

                 <xsl:when test="substring-before($givenName,' (')">
                  <mods:namePart type="family"><xsl:value-of select="$familyName"/></mods:namePart>

                   <mods:namePart type="given"><xsl:value-of select="substring-before($givenName,' (')"/></mods:namePart>
                   <mods:namePart type="given"><xsl:value-of select="substring($givenName,string-length(substring-before($givenName,' ('))+2)"/></mods:namePart>
                  
                  </xsl:when>
   <xsl:otherwise>
                  <xsl:variable name="givenPunc" select="concat($givenName,'eon')"></xsl:variable>
                  <mods:namePart type="family"><xsl:value-of select="$familyName"/></mods:namePart>
                  <xsl:analyze-string select="$givenPunc" regex="(\s[A-Z].eon)">
                            <xsl:matching-substring>

                       
                             
                             
                             <xsl:if test="string-length(regex-group(1))=6">
                             <mods:namePart type="given"><xsl:value-of select="$givenName"/></mods:namePart>
                              </xsl:if>
                     


                            </xsl:matching-substring>


                  </xsl:analyze-string> 
             <xsl:analyze-string select="$givenPunc" regex="([a-z]\.eon)">
                            <xsl:matching-substring>


                             
                             
                       
                             <mods:namePart type="given"><xsl:value-of select="substring($givenPunc,1,string-length($givenPunc)-4)"/></mods:namePart>
       



                            </xsl:matching-substring>


             </xsl:analyze-string> 

 <xsl:analyze-string select="$givenPunc" regex="([A-Z]\.eon)">
                            <xsl:matching-substring>

                               <xsl:if test="string-length($givenPunc)=5">
                                <mods:namePart type="given"><xsl:value-of select="$givenName"/></mods:namePart>
                               </xsl:if>
                             
                             
              
       



                            </xsl:matching-substring>


 </xsl:analyze-string> 
        <xsl:analyze-string select="$givenPunc" regex="([a-z]eon)">
                            <xsl:matching-substring>

           
                             
                             <mods:namePart type="given"><xsl:value-of select="$givenName"/></mods:namePart>
                             
                     


                            </xsl:matching-substring>


                  </xsl:analyze-string> 
   </xsl:otherwise>
     </xsl:choose>

   
           <xsl:if test="mods:namePart[@type='date']"> <mods:namePart type="date"><xsl:value-of select="mods:namePart[@type='date']"/></mods:namePart></xsl:if>


             <xsl:call-template name="personalNameDisplayForm"></xsl:call-template>

	         <mods:role>
  <mods:roleTerm type="text" authority="marcrelator"><xsl:value-of select="mods:role/mods:roleTerm"/></mods:roleTerm>
 </mods:role>        

	 

	 
</mods:name>	 
 
 </xsl:template>
 <!--template to facilitate display form of personal name-->
 <xsl:template name="personalNameDisplayForm">
  <mods:displayForm>
  <xsl:variable name="displayForm"><xsl:value-of select="mods:namePart[not(@type)]"></xsl:value-of></xsl:variable>
                     <xsl:variable name="givenPunc" select="concat($displayForm,'eon')"></xsl:variable>
                      
                            <xsl:if test="string-length($displayForm)=2">
                            <xsl:value-of select="$displayForm"/></xsl:if>

                  <xsl:analyze-string select="$givenPunc" regex="(\s[A-Z].eon)">
                            <xsl:matching-substring>

                       
                             
                             
                             <xsl:if test="string-length(regex-group(1))=6">
                            <xsl:value-of select="$displayForm"/></xsl:if>
                     


                            </xsl:matching-substring>


                  </xsl:analyze-string> 
   <!--punc missing from Marc field-->
    <xsl:analyze-string select="$givenPunc" regex="([a-z]eon)">
                            <xsl:matching-substring>

                       
                             
                             

                            <xsl:value-of select="$displayForm"/>
                     


                            </xsl:matching-substring>


                  </xsl:analyze-string> 
             <xsl:analyze-string select="$givenPunc" regex="([a-z]\.eon)">
                            <xsl:matching-substring>
                             <xsl:value-of select="substring($givenPunc,1,string-length($givenPunc)-4)"/>
                            </xsl:matching-substring>
             </xsl:analyze-string>
                <xsl:analyze-string select="$givenPunc" regex="\)eon">
                            <xsl:matching-substring>
                             <xsl:value-of select="substring($givenPunc,1,string-length($givenPunc)-3)"/>
                            </xsl:matching-substring>
             </xsl:analyze-string>
           <xsl:if test="mods:namePart[@type='date']">, <xsl:value-of select="mods:namePart[@type='date']"></xsl:value-of></xsl:if>

   </mods:displayForm>
 </xsl:template>
 
 <!-- corpNameTemplate-->
 <xsl:template name="corpConfName">

<mods:name>
  <xsl:attribute name="type"><xsl:value-of select="@type"></xsl:value-of></xsl:attribute>
   <mods:namePart><xsl:value-of select="mods:namePart"/></mods:namePart>
      <mods:displayForm><xsl:value-of select="mods:namePart"/></mods:displayForm>
  <mods:role>
  <mods:roleTerm type="text" authority="marcrelator"><xsl:value-of select="mods:role/mods:roleTerm"/></mods:roleTerm>
 </mods:role>        
   
  </mods:name>
  
 </xsl:template>
 
</xsl:stylesheet>
