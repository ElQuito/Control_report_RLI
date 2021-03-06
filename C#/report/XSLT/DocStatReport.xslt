<?xml version="1.0" standalone="yes" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  >
  <xsl:param name="DateFrom" />
  <xsl:param name="DateTo" />
  <xsl:param name="IsSalesMenFiltered"/>
  <xsl:param name="IsCustomersFiltered"/>
  <xsl:param name="IsExpertsFiltered"/>
  <xsl:param name="ExecutionState"/>
  <xsl:param name="DocumentLink"/>
  <xsl:param name="TaskLink"/>
  <xsl:param name="LinkThickClient"/>
  <xsl:output indent="no" omit-xml-declaration="yes" encoding="UTF-8"/>
  <xsl:template name="replace" match="text()" mode="replace">
    <xsl:param name="str" select="."/>
    <!--xsl:param name="search-for" select="'&#xA;'"/-->
    <xsl:param name="search-for" select="'#TPFS#'"/>
    <xsl:param name="replace-with">
      <br />
    </xsl:param>
    <xsl:choose>
      <xsl:when test="contains($str, $search-for)">
        <xsl:value-of select="substring-before($str, $search-for)"/>
        <xsl:copy-of select="$replace-with"/>
        <xsl:call-template name="replace">
          <xsl:with-param name="str" select="substring-after($str, $search-for)"/>
          <xsl:with-param name="search-for" select="$search-for"/>
          <xsl:with-param name="replace-with" select="$replace-with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/">
    <div style="width: 100%">
      <br /><br />
        <table width="100%">
          <tr>
            <td class="header">
              <strong>Сводный отчет по исполнительской дисциплине</strong>
              <xsl:if test="$DateFrom or $DateTo">
                <br/>
                <strong>Срок исполнения поручений </strong>
                <xsl:if test="$DateFrom">c <xsl:value-of select="$DateFrom"/><xsl:text> </xsl:text></xsl:if>
                <xsl:if test="$DateTo">по <xsl:value-of select="$DateTo"/></xsl:if>
              </xsl:if>
              <table align="center">
              <xsl:if test="$IsSalesMenFiltered = '1'">
                <xsl:variable name="SalesMen">
                   <xsl:for-each select="//NewDataSet/Table">
                     <xsl:sort select="SalesMan"/>
                     <xsl:copy-of select="SalesMan"/>
                   </xsl:for-each>
                </xsl:variable>
                  <tr>
                    <td style="text-align:right; vertical-align: top;">
                      <strong>Автор: </strong>
                    </td>
                    <td style="text-align:left;">
                      <xsl:for-each select="msxsl:node-set($SalesMen)/SalesMan[not(text() = preceding-sibling::node()/text())]">
                        <xsl:value-of select="text()"/><xsl:if test="position() != last()">,<br/></xsl:if>
                      </xsl:for-each>
                    </td>
                  </tr>
              </xsl:if>
              <xsl:if test="$IsCustomersFiltered = '1'">
                <xsl:variable name="Customers">
                   <xsl:for-each select="//NewDataSet/Table">
                     <xsl:sort select="Customer"/>
                     <xsl:copy-of select="Customer"/>
                   </xsl:for-each>
                </xsl:variable>
                  <tr>
                    <td style="text-align:right; vertical-align: top;">
                      <strong>От кого: </strong>
                    </td>
                    <td style="text-align:left;">
                      <xsl:for-each select="msxsl:node-set($Customers)/Customer[not(text() = preceding-sibling::node()/text())]">
                        <xsl:value-of select="text()"/><xsl:if test="position() != last()">,<br/></xsl:if>
                      </xsl:for-each>
                    </td>
                  </tr>
              </xsl:if>
              <xsl:if test="$IsExpertsFiltered = '1'">
                <xsl:variable name="Experts">
                   <xsl:for-each select="//NewDataSet/Table">
                     <xsl:sort select="Expert"/>
                     <xsl:copy-of select="Expert"/>
                   </xsl:for-each>
                </xsl:variable>
                  <tr>
                    <td style="text-align:right; vertical-align: top;">
                      <strong>Ответственный исполнитель: </strong>
                    </td>
                    <td style="text-align:left;">
                      <xsl:for-each select="msxsl:node-set($Experts)/Expert[not(text() = preceding-sibling::node()/text())]">
                        <xsl:value-of select="text()"/><xsl:if test="position() != last()">, </xsl:if>
                      </xsl:for-each>
                    </td>
                  </tr>
              </xsl:if>
                <tr>
                 <!-- <td style="text-align:right; vertical-align: top;">
                      <strong>Состояние исполнения: </strong>
                    </td>
                    <td style="text-align:left;">
                      <xsl:choose>
                         <xsl:when test="$ExecutionState = 0">Все</xsl:when>
                         <xsl:when test="$ExecutionState = 1">Неисполненные</xsl:when>
                         <xsl:when test="$ExecutionState = 2">Исполненные</xsl:when>
                      </xsl:choose>
                    </td> -->
                </tr> 
              </table>
            </td>
          </tr>
		  	 <tr>
			<td style="text-align:right;">
			<strong>По состоянию на <xsl:value-of select="//NewDataSet/Table/today"/></strong>
			</td>
		  </tr>
		  <tr>
			<td style="text-align:left;">
			<strong>Всего: <xsl:value-of select="count(//NewDataSet/Table[CardTaskID])"/> из них просрочено: <xsl:value-of select="count(//NewDataSet/Table[substring(ExpCategory, 1, 10) = 'Просрочено'])"/></strong>
			</td>
		  </tr>
			<xsl:for-each select="//NewDataSet/Table[InstanceID and not(groupingSet = following-sibling::node()/groupingSet)]">
            <xsl:variable name="CurrentSet" select="groupingSet"/>
			<xsl:if test="CardTaskID">
            <tr>
              <td class="subheader">
                <xsl:text disable-output-escaping="yes"><![CDATA[&#160;]]></xsl:text>
              </td>
            </tr>
			
				<xsl:if test="not($CurrentSet = '')">
				  <tr>
					<td class="subheader">
					  <xsl:value-of select="$CurrentSet"/>
					</td>
				  </tr>
				</xsl:if>
			</xsl:if> 
            <tr>
              <td>
			 <xsl:if test="CardTaskID"> 
                <table class="sample_det" width="90%" align="center">
				 
                  <thead>
                    <tr>
					  <th width="7%" class="sample_header">№</th>
                      <th width="14%" class="sample_header">Автор</th>
                      <th width="12%" class="sample_header">От кого</th>
                      <th width="12%" class="sample_header">Документ</th>
                      <th width="19%" class="sample_header">Содержание РК</th>
                      <th width="17%" class="sample_header">Отв. исполнитель</th>
                      <th width="12%" class="sample_header">Срок исполнения</th>
                      <th width="14%" class="sample_header">Ход исполнения</th>
                    </tr>
                  </thead>
				 
                  <xsl:for-each select="../Table[groupingSet = $CurrentSet and CardTaskID and not(CardTaskID = preceding-sibling::node()/CardTaskID)]">
                    <xsl:variable name="CardTaskID" select="CardTaskID"/>
                    <xsl:variable name="rowspan" select="count(../Table[groupingSet = $CurrentSet and CardTaskID = $CardTaskID])"/>
                    <tr>
					  <td rowspan="{$rowspan}">
                        <xsl:value-of select="count(preceding-sibling::Table[CardTaskID])+1"/>
                      </td>
                      <td rowspan="{$rowspan}">
                        <xsl:value-of select="SalesMan"/>
                      </td>
                      <td rowspan="{$rowspan}">
                        <xsl:value-of select="Customer"/>
                      </td>
                      <td rowspan="{$rowspan}">

                        <a href="{$TaskLink}{CardTaskID}" target="_blank">
                          <xsl:choose>
                            <xsl:when test="RegistrationNumber">
                              <xsl:value-of select="RegistrationNumber"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="SystemNumber"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </a>
						
                        <xsl:if test="RegistrationDate">
                          <br/>
                          <xsl:value-of select="RegistrationDate"/>
                        </xsl:if>
                        <br/>
                        <!--<xsl:value-of select="ReqType"/>-->
						 <br/>
						<a href="{$LinkThickClient}{{{CardTaskID}}}&amp;ShowPanels=2048" target="_blank">
						  <img src="images/KZ.ico" style="border:0px;" />
                        </a>
                      </td>
                      <td rowspan="{$rowspan}">
                        <xsl:call-template name="replace">
                          <xsl:with-param name="str" select="Content"/>
                        </xsl:call-template>
                      </td>
                      <xsl:for-each select="../Table[groupingSet = $CurrentSet and CardTaskID = $CardTaskID]">
                        <td>
                          <xsl:value-of select="Expert"/>
                          <br/>
                          <xsl:call-template name="replace">
                            <xsl:with-param name="str" select="TaskText"/>
                          </xsl:call-template>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="ControlTerm">
                              <!--<div class="circle {ExpCategory}"><xsl:text disable-output-escaping="yes"><![CDATA[&#160;]]></xsl:text></div>-->
							
                              <xsl:value-of select="ControlTerm"/>
							  <br/>
							  <xsl:choose>
							  <xsl:when test="substring(ExpCategory, 1, 10) = 'Просрочено'">
                                <font color="red" ><xsl:value-of select="ExpCategory"/></font>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="ExpCategory"/>
                              </xsl:otherwise>
                            </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>Срок не задан</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td> 
						 <xsl:if test="PursuanceDocument">
						 <a href="{$LinkThickClient}{{{PursuanceDocument}}}&amp;ShowPanels=2048"  target="_blank">
						  <img src="images/RK.ico" style="border:0px;" />
                         </a>
                          <a href="{$DocumentLink}{PursuanceDocument}"  target="_blank">
                            <xsl:choose>
                              <xsl:when test="PursRegistrationNumber">
                                <xsl:value-of select="PursRegistrationNumber"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="PursSystemNumber"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </a>
						 </xsl:if>
                          <xsl:if test="PursRegistrationDate">
                            <xsl:text> от </xsl:text>
                            <xsl:value-of select="PursRegistrationDate"/>
                          </xsl:if>
                          <xsl:if test="PursStateName">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="PursStateName"/>
                            <xsl:text>)</xsl:text>
                          </xsl:if>
                          <br/>
                          <xsl:call-template name="replace">
                            <xsl:with-param name="str" select="Reports"/>
                          </xsl:call-template>
                        </td>
                        <xsl:if test="position() != last()">
                          <xsl:text disable-output-escaping="yes"><![CDATA[</tr><tr>]]></xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                    </tr>
                  </xsl:for-each>
                </table>
				 </xsl:if> 
              </td>
            </tr>
          </xsl:for-each>
        </table>
    </div>
  </xsl:template>
</xsl:stylesheet>