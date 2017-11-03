<?xml version="1.0" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:wsp="http://schemas.microsoft.com/office/word/2003/wordml/sp2"
xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word"  xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"  xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core" w:macrosPresent="no" w:embeddedObjPresent="no" w:ocxPresent="no" xml:space="preserve">
  <xsl:param name="DateFrom" />
  <xsl:param name="DateTo" />
  <xsl:param name="IsSalesMenFiltered"/>
  <xsl:param name="IsCustomersFiltered"/>
  <xsl:param name="IsExpertsFiltered"/>
  <xsl:param name="ExecutionState"/>
  <xsl:param name="DocumentLink"/>
   <xsl:param name="LinkThickClient"/>
   <xsl:param name="TaskLink"/>
  <xsl:output indent="no" omit-xml-declaration="yes" encoding="UTF-8"/>
  <xsl:template name="replace" match="text()" mode="replace"><xsl:param name="str" select="."/><xsl:param name="search-for" select="'#TPFS#'"/><xsl:param name="replace-with"><w:br /></xsl:param><xsl:choose><xsl:when test="contains($str, $search-for)"><xsl:value-of select="substring-before($str, $search-for)"/><xsl:copy-of select="$replace-with"/><xsl:call-template name="replace"><xsl:with-param name="str" select="substring-after($str, $search-for)"/><xsl:with-param name="search-for" select="$search-for"/><xsl:with-param name="replace-with" select="$replace-with"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise></xsl:choose></xsl:template>
  <xsl:template match="/">
           <w:p wsp:rsidR="00910C98" wsp:rsidRPr="000F1A8C" wsp:rsidRDefault="007348D1">
            <w:pPr>
               <w:jc w:val="center"/>
               <w:rPr>
                  <w:b/>
                  <w:sz w:val="32"/>
                  <w:sz-cs w:val="32"/>
               </w:rPr>
            </w:pPr>
            <w:r wsp:rsidRPr="000F1A8C">
               <w:rPr>
                  <w:b/>
                  <w:sz w:val="32"/>
                  <w:sz-cs w:val="32"/>
               </w:rPr>
               <w:t>Сводный отчет по исполнительской дисциплине</w:t>
            </w:r>
         </w:p>
    <xsl:if test="$DateFrom or $DateTo">
      
	           <w:p wsp:rsidR="00910C98" wsp:rsidRPr="000F1A8C" wsp:rsidRDefault="007348D1">
            <w:pPr>
               <w:ind w:right="284"/>
               <w:jc w:val="center"/>
               <w:rPr>
                  <w:b/>
                  <w:sz w:val="32"/>
                  <w:sz-cs w:val="32"/>
               </w:rPr>
            </w:pPr>
            <w:r wsp:rsidRPr="000F1A8C">
               <w:rPr>
                  <w:b/>
                  <w:sz w:val="32"/>
                  <w:sz-cs w:val="32"/>
               </w:rPr>
               <w:t>Срок исполнения поручений </w:t>
            </w:r>
            <w:r wsp:rsidRPr="000F1A8C">
               <w:rPr>
                  <w:sz w:val="32"/>
                  <w:sz-cs w:val="32"/>
               </w:rPr>
               <w:t><xsl:if test="$DateFrom">c <xsl:value-of select="$DateFrom"/><xsl:text> </xsl:text></xsl:if>
                <xsl:if test="$DateTo">по <xsl:value-of select="$DateTo"/></xsl:if></w:t>
            </w:r>
         </w:p>
    </xsl:if>
    <xsl:if test="$IsSalesMenFiltered = '1'">
      <xsl:variable name="SalesMen">
        <xsl:for-each select="//NewDataSet/Table">
          <xsl:sort select="SalesMan"/>
          <xsl:copy-of select="SalesMan"/>
        </xsl:for-each>
      </xsl:variable>
      <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="center"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:b/>
          </w:rPr>
          <w:t>Автор: </w:t>
        </w:r>
        <w:r>
          <w:t><xsl:for-each select="msxsl:node-set($SalesMen)/SalesMan[not(text() = preceding-sibling::node()/text())]">
                        <xsl:value-of select="text()"/><xsl:if test="position() != last()">,<w:br/></xsl:if>
                      </xsl:for-each></w:t>
        </w:r>
      </w:p>
    </xsl:if>
    <xsl:if test="$IsCustomersFiltered = '1'">
      <xsl:variable name="Customers">
        <xsl:for-each select="//NewDataSet/Table">
          <xsl:sort select="Customer"/>
          <xsl:copy-of select="Customer"/>
        </xsl:for-each>
      </xsl:variable>
      <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="center"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:b/>
          </w:rPr>
          <w:t>От кого: </w:t>
        </w:r>
        <w:r>
          <w:t><xsl:for-each select="msxsl:node-set($Customers)/Customer[not(text() = preceding-sibling::node()/text())]">
                        <xsl:value-of select="text()"/><xsl:if test="position() != last()">,<w:br/></xsl:if>
                      </xsl:for-each></w:t>
        </w:r>
      </w:p>
    </xsl:if>
    <xsl:if test="$IsExpertsFiltered = '1'">
      <xsl:variable name="Experts">
        <xsl:for-each select="//NewDataSet/Table">
          <xsl:sort select="Expert"/>
          <xsl:copy-of select="Expert"/>
        </xsl:for-each>
      </xsl:variable>
      <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="center"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:b/>
          </w:rPr>
          <w:t>Ответственный исполнитель: </w:t>
        </w:r>
        <w:r>
          <w:t><xsl:for-each select="msxsl:node-set($Experts)/Expert[not(text() = preceding-sibling::node()/text())]">
                        <xsl:value-of select="text()"/><xsl:if test="position() != last()">, </xsl:if>
                      </xsl:for-each></w:t>
        </w:r>
      </w:p>
    </xsl:if>
	<!--
      <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="center"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:b/>
          </w:rPr>
          <w:t>Состояние исполнения: </w:t>
        </w:r>
        <w:r>
          <w:t><xsl:choose>
                         <xsl:when test="$ExecutionState = 0">Все</xsl:when>
                         <xsl:when test="$ExecutionState = 1">Неисполненные</xsl:when>
                         <xsl:when test="$ExecutionState = 2">Исполненные</xsl:when>
                      </xsl:choose></w:t>
        </w:r>
      </w:p>-->

	  	  <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="left"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:b/>
          </w:rPr>
          <w:t>Всего: <xsl:value-of select="count(//NewDataSet/Table[CardTaskID])"/> из них просрочено: <xsl:value-of select="count(//NewDataSet/Table[substring(ExpCategory, 1, 10) = 'Просрочено'])"/></w:t>
        </w:r>
      </w:p>
	  
	           <w:p wsp:rsidR="001334C9" wsp:rsidRPr="00FB399C" wsp:rsidRDefault="00127AF0">
            <w:pPr>
               <w:ind w:right="284"/>
               <w:jc w:val="right"/>
               <w:rPr>
                  <w:i/>
               </w:rPr>
            </w:pPr>
            <w:r wsp:rsidRPr="00FB399C">
               <w:rPr>
                  <w:i/>
               </w:rPr>
               <w:t>По состоянию на <xsl:value-of select="//NewDataSet/Table/today"/></w:t>
            </w:r>
         </w:p>
    <!--  <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="center"/>
          <w:rPr>
            <w:b/>
          </w:rPr>
        </w:pPr>
      </w:p> -->
    <xsl:for-each select="//NewDataSet/Table[InstanceID and not(groupingSet = following-sibling::node()/groupingSet)]">
      <xsl:variable name="CurrentSet" select="groupingSet"/>
	  <xsl:if test="CardTaskID">
      <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:jc w:val="center"/>
          <w:rPr>
            <w:b/>
          </w:rPr>
        </w:pPr>
      </w:p>
	  
      <xsl:if test="not($CurrentSet = '')">
        <w:p>
          <w:pPr>
            <w:spacing w:line="240" w:line-rule="auto"/>
			<w:keepNext/>
            <w:ind w:right="284"/>
            <w:jc w:val="center"/>
            <w:rPr>
              <w:b/>
            </w:rPr>
          </w:pPr>
          <w:r>
            <w:rPr>
              <w:b/>
            </w:rPr>
            <w:t><xsl:value-of select="$CurrentSet"/></w:t>
          </w:r>
        </w:p>
      </xsl:if>
    <!-- <w:p>
        <w:pPr>
          <w:spacing w:line="240" w:line-rule="auto"/>
          <w:ind w:right="284"/>
          <w:rPr>
          </w:rPr>
        </w:pPr>
      </w:p> -->
	  </xsl:if> 
	  
	  <xsl:if test="CardTaskID"> 
      <w:tbl>
        <w:tblPr>
          <w:tblW w:w="15300" w:type="dxa"/>
          <w:tblInd w:w="-162" w:type="dxa"/>
          <w:tblBorders>
            <w:left w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:bottom w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:right w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:insideH w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:insideV w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
          </w:tblBorders>
          <w:tblLayout w:type="Fixed"/>
          <w:tblLook w:val="04A0"/>
        </w:tblPr>
        <w:tblGrid>
               <w:gridCol w:w="540"/>
               <w:gridCol w:w="1980"/>
               <w:gridCol w:w="1980"/>
               <w:gridCol w:w="1620"/>
               <w:gridCol w:w="4140"/>
               <w:gridCol w:w="1440"/>
               <w:gridCol w:w="1620"/>
               <w:gridCol w:w="1980"/>
            </w:tblGrid>
            <w:tr wsp:rsidR="001334C9" wsp:rsidTr="00FB399C">
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="540" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0">
                     <w:pPr>
                        <w:ind w:right="284"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>№</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="1980" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0">
                     <w:pPr>
                        <w:ind w:right="284"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>Автор</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="1980" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0">
                     <w:pPr>
                        <w:ind w:right="284"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>От кого </w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="1620" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0">
                     <w:pPr>
                        <w:ind w:right="284"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>Документ</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="4140" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0">
                     <w:pPr>
                        <w:ind w:right="284"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>Содержание РК</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="1440" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRPr="00127AF0" wsp:rsidRDefault="00127AF0" wsp:rsidP="00FB399C">
                     <w:pPr>
                        <w:ind w:right="-108"/>
                        <w:rPr>
                           <w:b/>
                           <w:color w:val="000000"/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r wsp:rsidRPr="00127AF0">
                        <w:rPr>
                           <w:b/>
                           <w:color w:val="000000"/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>Отв. исполнитель</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="1620" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0" wsp:rsidP="00FB399C">
                     <w:pPr>
                        <w:ind w:right="72"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>Срок исполнения</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
               <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="1980" w:type="dxa"/>
                     <w:tcBorders>
                        <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
                     </w:tcBorders>
                     <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="001334C9" wsp:rsidRDefault="00127AF0" wsp:rsidP="00FB399C">
                     <w:pPr>
                        <w:ind w:right="252"/>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                     </w:pPr>
                     <w:r>
                        <w:rPr>
                           <w:b/>
                           <w:sz w:val="22"/>
                           <w:sz-cs w:val="22"/>
                        </w:rPr>
                        <w:t>Отчет об исполнении</w:t>
                     </w:r>
                  </w:p>
               </w:tc>
            </w:tr>
        <xsl:for-each select="../Table[groupingSet = $CurrentSet and CardTaskID and not(CardTaskID = preceding-sibling::node()/CardTaskID)]">
          <xsl:variable name="CardTaskID" select="CardTaskID"/>
          <xsl:variable name="rowspan" select="count(../Table[groupingSet = $CardTaskID and CardTaskID = $CardTaskID])"/>
          <xsl:for-each select="../Table[groupingSet = $CurrentSet and CardTaskID = $CardTaskID]">
            <w:tr>
			 <w:tc>
                  <w:tcPr>
                     <w:tcW w:w="540" w:type="dxa"/>
						<xsl:choose>
						  <xsl:when test="position() = 1 and $rowspan &gt; 1">
							<w:vmerge w:val="restart"/>
						  </xsl:when>
						  <xsl:when test="$rowspan &gt; 1">
							<w:vmerge/>  
						  </xsl:when>
						</xsl:choose>
						<w:shd w:val="clear" w:color="auto" w:fill="auto"/>
                  </w:tcPr>
                  <w:p wsp:rsidR="007B22D5" wsp:rsidRDefault="00127AF0" wsp:rsidP="00FB399C">
                     <w:pPr>
                        <w:listPr>
                           <w:ilvl w:val="0"/>
                           <w:ilfo w:val="9"/>
                           <wx:t wx:val="1."/>
                           <wx:font wx:val="Times New Roman"/>
                        </w:listPr>
                        <w:spacing w:after="0" w:line="23" w:line-rule="at-least"/>
                        <w:ind w:left="0" w:right="-677" w:first-line="0"/>
                     </w:pPr>
                  </w:p>
               </w:tc>

            <w:tc>
              <w:tcPr>
                <w:tcW w:w="1980" w:type="dxa"/>
               <xsl:choose>
                  <xsl:when test="position() = 1 and $rowspan &gt; 1">
                    <w:vmerge w:val="restart"/>
                  </xsl:when>
                  <xsl:when test="$rowspan &gt; 1">
                    <w:vmerge/>  
                  </xsl:when>
                </xsl:choose>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
              <w:p>
                <xsl:if test="position() = 1">
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                    <w:t><xsl:value-of select="SalesMan"/></w:t>
                  </w:r>
                </xsl:if>
              </w:p>
            </w:tc>  
            <w:tc>
              <w:tcPr>
                <w:tcW w:w="1980" w:type="dxa"/>
                <xsl:choose>
                  <xsl:when test="position() = 1 and $rowspan &gt; 1">
                    <w:vmerge w:val="restart"/>
                  </xsl:when>
                  <xsl:when test="$rowspan &gt; 1">
                    <w:vmerge/>  
                  </xsl:when>
                </xsl:choose>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <xsl:if test="position() = 1">
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                    <w:t><xsl:value-of select="Customer"/></w:t>
                  </w:r>
                </xsl:if>
              </w:p>
            </w:tc>
            <w:tc>
              <w:tcPr>
                <w:tcW w:w="1620" w:type="dxa"/>
                <xsl:choose>
                  <xsl:when test="position() = 1 and $rowspan &gt; 1">
                    <w:vmerge w:val="restart"/>
                  </xsl:when>
                  <xsl:when test="$rowspan &gt; 1">
                    <w:vmerge/>  
                  </xsl:when>
                </xsl:choose>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
			  <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <xsl:if test="position() = 1">	
                  <w:hlink w:dest="{$TaskLink}{CardTaskID}">
                    <w:r>
                      <w:rPr>
                        <w:sz w:val="22"/>
                        <w:sz-cs w:val="22"/>
                        <w:u w:val="single"/>
                      </w:rPr>
                      <w:t><xsl:choose><xsl:when test="RegistrationNumber"><xsl:value-of select="RegistrationNumber"/></xsl:when><xsl:otherwise><xsl:value-of select="SystemNumber"/></xsl:otherwise></xsl:choose></w:t>
                    </w:r>
                  </w:hlink>
                </xsl:if>
              </w:p>
              <xsl:if test="position() = 1">
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                  <xsl:if test="RegistrationDate"><w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                    <w:t><xsl:value-of select="RegistrationDate"/></w:t>
                  </w:r>
                    </xsl:if>
					<w:hlink w:dest="{$LinkThickClient}{{{CardTaskID}}}&amp;ShowPanels=2048">
				<w:r>
					<w:pict>
						<w:binData w:name="wordml://03000002.png" xml:space="preserve">H4sIAAAAAAAEC61Tu07DQBCci0MwChI+ixqcFJDeFLSxTigVciJHtDT00NHhAiG+ga9JlY6akj9A
lBQIM3sm9jlYEQVr7e3Mzu695Ht5Xj7BWoQIlxbdXCjsAN6rEjq2Y5fIUz62GPsdyQva7UiXR3QAqdhW3Sr65Ee9PfSQnadpT12Rj/sPeGNHRIwqjiwWDih+m6woilpObgFzD0y4dkq/Pi3xhLkzam12+AWs+x1zrf7J/Af9nZ7TywnlRsb9JR6rE0R278CIBdGPK3sTZUfbKCfJ8xxgXCwWIGkra83pP1igtQqgqspAB1rRVyZMu9xKjg7Kjf61evY35wsa67H7fy0cig2qSUNB+5u50Y5ujNE1D+ezeeboYRzHmasL/6XX69l6YxQ3Yc3ypN5fyZOVrMP4xGTJwOHxfDasqOjTaU21HNehDejzr6jflrw64FgVhbxE4Bsb2AaE1AMAAA==</w:binData>
						<v:shape id="_x0000_i1026" type="#_x0000_t75" style="width:32px;height:32px;" o:ole="">
							<v:imagedata src="wordml://03000002.png" o:title=""/>
						</v:shape>
						<o:OLEObject Type="Embed" ProgID="PBrush" ShapeID="_x0000_i1026" DrawAspect="Content" ObjectID="_1405156963"/>
					</w:pict>
				</w:r>
			</w:hlink>
			
              </w:p>
             <!-- <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                    <w:t><xsl:value-of select="ReqType"/></w:t>
                  </w:r>
              </w:p> -->
                </xsl:if>
            </w:tc>
            <w:tc>
              <w:tcPr>
                <w:tcW w:w="4140" w:type="dxa"/>
                <xsl:choose>
                  <xsl:when test="position() = 1 and $rowspan &gt; 1">
                    <w:vmerge w:val="restart"/>
                  </xsl:when>
                  <xsl:when test="$rowspan &gt; 1">
                    <w:vmerge/>  
                  </xsl:when>
                </xsl:choose>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <xsl:if test="position() = 1">
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                   <w:t><xsl:call-template name="replace"><xsl:with-param name="str" select="Content"/></xsl:call-template></w:t>
					<!--<w:t><xsl:value-of select="Content"/></w:t>-->
                  </w:r>
                </xsl:if>
              </w:p>
            </w:tc>
            <w:tc>
              <w:tcPr>
                <w:tcW w:w="1440" w:type="dxa"/>
                <w:tcBorders>
                  <xsl:if test="position() != last()">
                    <w:bottom w:val="nil"/>
                  </xsl:if>
                  <xsl:if test="position() &gt; 1">
                    <w:top w:val="nil"/>
                  </xsl:if>
                </w:tcBorders>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <w:r>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                  <w:t><xsl:value-of select="Expert"/></w:t>
                </w:r>
              </w:p>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="72"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <w:r>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                  <w:t><xsl:call-template name="replace">
                            <xsl:with-param name="str" select="TaskText"/>
                          </xsl:call-template></w:t>
                </w:r>
              </w:p>
            </w:tc>
            <w:tc>
              <w:tcPr>
                <w:tcW w:w="1620" w:type="dxa"/>
                <w:tcBorders>
                  <xsl:if test="position() != last()">
                    <w:bottom w:val="nil"/>
                  </xsl:if>
                  <xsl:if test="position() &gt; 1">
                    <w:top w:val="nil"/>
                  </xsl:if>
                </w:tcBorders>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="32"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <xsl:choose>
                  <xsl:when test="ControlTerm">
				    <w:r>
                      <w:rPr>
                        <w:sz w:val="22"/>
                        <w:sz-cs w:val="22"/>
                      </w:rPr>
                      <w:t><xsl:value-of select="ControlTerm"/><xsl:text>
</xsl:text></w:t>
                    </w:r>
                    <w:r>
					  <xsl:choose>
					 <xsl:when test="substring(ExpCategory, 1, 10) = 'Просрочено'">
					<w:rPr>
                        <w:color w:val="red"/>
                        <w:sz w:val="22"/>
                        <w:sz-cs w:val="22"/>
                      </w:rPr>
                      <w:t><xsl:value-of select="ExpCategory"/></w:t>
                        </xsl:when>
                              <xsl:otherwise>
                        <w:rPr>
                        <w:sz w:val="22"/>
                        <w:sz-cs w:val="22"/>
                      </w:rPr>
                      <w:t><xsl:value-of select="ExpCategory"/></w:t>
                              </xsl:otherwise>
                        </xsl:choose>
						
                    </w:r>

                  </xsl:when>
                  <xsl:otherwise>
                    <w:r>
                      <w:rPr>
                        <w:sz w:val="22"/>
                        <w:sz-cs w:val="22"/>
                      </w:rPr>
                      <w:t>Срок не задан</w:t>
                    </w:r>
                  </xsl:otherwise>
                </xsl:choose>
              </w:p>
            </w:tc>
            <w:tc>
              <w:tcPr>
                <w:tcW w:w="1980" w:type="dxa"/>
                <w:tcBorders>
                  <xsl:if test="position() != last()">
                    <w:bottom w:val="nil"/>
                  </xsl:if>
                  <xsl:if test="position() &gt; 1">
                    <w:top w:val="nil"/>
                  </xsl:if>
                </w:tcBorders>
                <w:shd w:val="clear" w:color="auto" w:fill="auto"/>
              </w:tcPr>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                    <w:u w:val="single"/>
                  </w:rPr>
                </w:pPr>
				<xsl:if test="PursuanceDocument">
				<w:hlink w:dest="{$LinkThickClient}{{{PursuanceDocument}}}&amp;ShowPanels=2048">
				<w:r>
					<w:pict>
						<w:binData w:name="wordml://08000002.wmz" xml:space="preserve">H4sIAAAAAAAEC7VTsU7DMBB915Q0KEjk+IDKTSVgrfIBNBIz6oDEysIHsHXMgFAHBmYmPiVTN2ZG
OjIhPgDJ3DnCTpBSIRAvOvs9v7s4Z8XPT+sHOBgYXDp2fUHYBaIXUlm6cSgsogQ7MqcDXVe2N9Cq
SNgYmjGioZ8T0YfxPmKcny0WMV2JLtNbvEmFEQ4/HzuuGiB5tsFa27XnN8B8JXEPLB+B042EcI3l
HXpx8gH8OF4l911i416nJ1Kma6x8B8Z9O9DtRE+kH9pJVVWo67o/qcfhXyCTGmIdGzSavqRzKNic
gZiCLX7GsuShupP/XWs9w+f/O8kdwjYTpQfb9KyY/dVvHZjbr6WnhcCE/adcFHne1RNX1Kxpfstm
badlh0LmRP6LcLf01gFHZK3eROATUTBFCNQDAAA=</w:binData>
						<v:shape id="_x0000_i1061" type="#_x0000_t75" style="width:32px;height:32px;" o:ole="">
							<v:imagedata src="wordml://08000002.wmz" o:title=""/>
						</v:shape>
						<o:OLEObject Type="Embed" ProgID="PBrush" ShapeID="_x0000_i1061" DrawAspect="Content" ObjectID="_1605156963"/>
					</w:pict>
				</w:r>
			</w:hlink>
                <w:hlink w:dest="{$DocumentLink}{PursuanceDocument}">
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                      <w:u w:val="single"/>
                    </w:rPr>
                    <w:t>
                      <xsl:choose>
                        <xsl:when test="PursRegistrationNumber">
                          <xsl:value-of select="PursRegistrationNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="PursSystemNumber"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </w:t>
                  </w:r>
                </w:hlink>
				</xsl:if> 
                <xsl:if test="PursRegistrationDate">
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                    <w:t>
                      <xsl:text> от </xsl:text>
                      <xsl:value-of select="PursRegistrationDate"/>
                    </w:t>
                  </w:r>
                </xsl:if>
                <xsl:if test="PursStateName">
                  <w:r>
                    <w:rPr>
                      <w:sz w:val="22"/>
                      <w:sz-cs w:val="22"/>
                    </w:rPr>
                    <w:t>
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="PursStateName"/>
                      <xsl:text>)</xsl:text>
                    </w:t>
                  </w:r>
                </xsl:if>
              </w:p>
              <w:p>
                <w:pPr>
                  <w:spacing w:line="240" w:line-rule="auto"/>
                  <w:ind w:right="284"/>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                </w:pPr>
                <w:r>
                  <w:rPr>
                    <w:sz w:val="22"/>
                    <w:sz-cs w:val="22"/>
                  </w:rPr>
                  <w:t><xsl:call-template name="replace">
                            <xsl:with-param name="str" select="Reports"/>
                          </xsl:call-template></w:t>
                </w:r>
              </w:p>
            </w:tc>
          </w:tr>
          </xsl:for-each>
        </xsl:for-each>
      </w:tbl>
    </xsl:if> 
	</xsl:for-each>  
</xsl:template>
</xsl:stylesheet>