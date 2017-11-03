<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportResults.aspx.cs"
    Inherits="ReportResults" %>
<%@ OutputCache Duration="60" VaryByParam="*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Контрольный отчёт</title>
    <style type="text/css">
        body
        {
            font-size: 12pt;
            font-family:"Times New Roman","serif";
            background-color: #f5f5f5;
        }
        .header
        {
            font-size: 14pt;
            text-align:center;   
        }
        .subheader
        {
            font-weight: bold;
            text-align:center;
        }
        .leftheadercolumn
        {
            width: 80%;
            text-align: right;
            margin: 0px;
            padding: 0px;
        }
        .rightheadercolumn
        {
            width: 20%;
            text-align: right;
            margin: 0px;
            padding: 0px;
        }
        td.underlined
        {
            text-decoration: underline;
        }
        div.underlined
        {
            display: inline-block;
            border-bottom: 1px solid black;
        }
        table.execctrlheader
        {
            margin-left:30.05pt;
            width: 90%;
            align-self: center;
            padding: 0px;
            border: 0px;
        
        
        }
        table.sample
        {
            border-width: 1px;
            border-spacing: 0px;
            border-style: solid;
            border-color: black;
            border-collapse: collapse;
            margin-left:30.05pt;
            font-size: 10pt;
        }
        table.sample th
        {
            border-width: 3px;
            padding: 10px;
            border-style: solid;
            border-color: black;
            border-collapse: collapse;
            text-align: center;
            font-weight: normal;
        }
        table.sample td
        {
            border-left-width: 3px;
            border-right-width: 3px;
            border-top-width: 1px;
            border-bottom-width: 1px;
            padding: 5px;
            border-style: solid;
            border-color: black;
            background-color: white;
            border-collapse: collapse;
            text-align: center;
        }
        table.sample td.leftthinborder
        {
            border-left-width: 1px;
        }
        table.sample td.rightthinborder
        {
            border-right-width: 1px;
        }
        table.sample_det
        {
            border-width: 1px;
            border-spacing: 0px;
            border-style: solid;
            border-color: black;
            border-collapse: collapse;
            margin-left:30.05pt;
        }
        table.sample_det th
        {
            border-width: 1px;
            padding: 1px;
            border-style: inset;
            border-color: gray;
        }
        table.sample_det td
        {
            border-width: 1px;
            padding: 5px;
            border-style: inset;
            border-color: gray;
            vertical-align: top;
        }
        .linkButton
        {
            text-decoration: none;
            text-align: center;
        }   
        .tableHeader
        {
            font-family: Times New Roman;
            font-size: 10pt;
            font-weight: bold;
        }
        .tableData
        {
            font-family: Times New Roman;
            font-size: 10pt;
        }   
        .employeeName
        {
            font-family: Times New Roman;
            font-size: 11pt;
            font-weight: bold;
        }    
        .CELL_REPORT0_COLSPAN1,.CELL_REPORT0_COLSPAN_OTHER,.CELL_REPORT0_COLSPAN1_STYLE2{
	        text-decoration: none; 	  
	        font-size:1em;
	        word-wrap:break-word;
	        border-collapse:collapse; 
	        font-family: Times New Roman; 
	        font-size: 11pt
        } 
        .CELL_REPORT0_COLSPAN1{width:75px} 
        .CELL_REPORT0_COLSPAN1_STYLE2{width:100%} 
        .CELL_REPORT0_COLSPAN_OTHER{width:100%} 
        .CELL_REPORT1_COLSPAN1,.CELL_REPORT1_COLSPAN_OTHER,.CELL_REPORT1_COLSPAN1_STYLE2{
	        text-decoration: none; 	  
	        font-size:1em;
	        word-wrap:break-word;
	        border-collapse:collapse; 
	        font-family: Times New Roman; 
	        font-size: 11pt
        } 
        .CELL_REPORT1_COLSPAN1{width:110px} 
        .CELL_REPORT1_COLSPAN1_STYLE2{width:100%} 
        .CELL_REPORT1_COLSPAN_OTHER{width:100%} 
        .td_style{
	        text-align: center;
	        vertical-align: middle;	
        } 
        .style1
        {
            width: 221px;
        }
        .smalltext
        {
            font-size:10.0pt;
            text-align:right;
            font-style: italic;
        }
        .circle {
            border-radius: 50%;
            width: 10px;
            height:10px;
            margin-top: 4px;
            margin-right: 2px;
            float: left;
        }
        .orange {
            background: #ed7d31;
        }
        .red {
            background: #ff0000;
        }
        .green {
            background: #00ff21;
        }
		.colorbutton
		{
		background:#6fa537;
		}
    </style>
<link href="App_Themes/Theme/styles.3ec9bd26.css" rel="stylesheet" type="text/css" />
<link id="favicon" rel="shortcut icon" type="image/png" href="http://dv-web:88/favicon-rosles.ico"/>
</head>
<body class="rosles-style main-background" style="margin: 0px;">
    <div class="main-header full-width complex-container" style="padding-left:103px; padding-top:0px; padding-bottom: 0px;margin-bottom: 20px;">
        <div class="logo logo-undefined" ng-class="logo"><!--<img alt="Лого" src="http://dv-web:88/images/styleImages/logo_rosles.cbc51a55.png" />--></div>
       <!-- <div style="padding-left: 220px; font-weight: bold; font-size: large;">Контрольный отчёт</div> -->
    </div>
    <div id="PrintArea" class="Landscape">
        <form id="form1" runat="server" style="padding-left:65px; padding-top:30px; padding-bottom: 0px;margin-bottom: 20px;">
        <table>
            <tr align="left">
                <td style="width: 20px;">&nbsp;
                </td>
                <td align="left" style="width: 1150px;" colspan="2">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 1150px;">
                        <tr align="left">
                            <td align="left" style="margin-left: 20px" class="style1">
                                <input type="button" class="colorbutton btn volume width-float top-button ng-binding" value="Назад" onclick="history.go(-1);return false;" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr><td colspan="3"><br /></td></tr>
            <tr align="left">
            <td style="width: 20px;">
                    
            </td>
            <td> <asp:Button ID="buttonExportToWord1" class="colorbutton btn volume width-float top-button ng-binding" Width="150px" runat="server" OnClick="buttonExportToWord_Click"
                                Text="Экспорт в Word" Font-Names="System" Font-Size="12pt" />&nbsp;</td>
            </tr>
            <tr style="padding: 20px;">
                <td style="width: 20px;">&nbsp;
                    
                </td>
                <td>
                    <%-- ГЛАВНАЯ СТРАНИЦА ОТЧЁТА --%>
		            <asp:Panel ID="PanelGeneral" runat="server" Style="margin-right: 75px" Width="1150px">
                        <% GetDocStatReport(); %>
                    </asp:Panel>
                </td>
            </tr>
            <tr><td colspan="3">&nbsp;
                    </td></tr>
            <tr align="left" style="padding-top: 20px;">
            <td style="width: 20px; "></td>
            <td><asp:Button ID="buttonExportToWord" class="colorbutton btn volume width-float top-button ng-binding" Width="150px" runat="server" OnClick="buttonExportToWord_Click"
                                Text="Экспорт в Word" Font-Names="System" Font-Size="12pt" />&nbsp;</td>
            </tr>
            </table>
         
        </form>
    </div>
</body>
</html>