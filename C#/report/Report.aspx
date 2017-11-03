<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    
<script src="script/jquery.js" type="text/javascript"></script>
<script src="script/jquery-ui.js" type="text/javascript"></script>
<script src="script/jquery-ui.min.js" type="text/javascript"></script>
<script src="script/i18n/datepicker-ru.js" type="text/javascript"></script>
<script type="text/javascript">
       
    function showrow(txtboxobject, guidobject, updatepanel, typedata) {

        $(txtboxobject).autocomplete({
            delay: 500,
            minLength: 2,
            source: function (request, response) {
                
                $.ajax({
                    url: "SearchHelper.asmx/Get" + typedata + "List",
                    data: "{ 'searchTerm': '" + request.term + "'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        response($.map(data.d, function (item) {
                            return {
                                label: item.split('[~~]')[0],
                                val: item.split('[~~]')[1]
                            }
                        }))
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                    failure: function (response) {
                        alert(response.responseText);
                    }
                });

                
            },
            select: function (e, i) {
                $(txtboxobject).val(i.item.label);
                $(guidobject).val(i.item.val);
                __doPostBack(updatepanel, "");
            }
        });

        $(txtboxobject).focus(function(){
            $(this).val('');
        }); 

    }

    $('#autocomplete').focus(function () {
        $(this).val('');
        $(this).keydown();
    });

    $.datepicker.setDefaults({
        showOn: "both",
        buttonImageOnly: true,
        buttonImage: "images/calendar.png",
        buttonText: "Calendar"
    });
    $.datepicker.formatDate("dd.mm.yy");
    $.datepicker.setDefaults({
        changeMonth: true,
        changeYear: true
    });
    $.datepicker.setDefaults($.datepicker.regional["ru"]);

    $(function () {
        $("#<%=dtpDocStatDateStart.ClientID %>").datepicker();
        $("#<%=dtpDocStatDateEnd.ClientID %>").datepicker();
    });

    function pageLoad(sender, args) {
        if (args.get_isPartialLoad()) {
            $(function () {
                showrow("#<%=tbDocStatSalesMan.ClientID %>", "#<%=lbDocStatSalesManGuid.ClientID %>", "<%=lbDocStatSalesManUpdatePanel.UniqueID %>", "Employees");
                showrow("#<%=tbDocStatCustomer.ClientID %>", "#<%=lbDocStatCustomerGuid.ClientID %>", "<%=lbDocStatCustomerUpdatePanel.UniqueID %>", "Companies");
                showrow("#<%=tbDocStatExpert.ClientID %>"  , "#<%=lbDocStatExpertGuid.ClientID %>"  , "<%=lbDocStatExpertUpdatePanel.UniqueID %>"  , "EmployeesWithGroups");
            });
        }
    }

    $(document).ready(function () { showrow("#<%=tbDocStatSalesMan.ClientID %>", "#<%=lbDocStatSalesManGuid.ClientID %>", "<%=lbDocStatSalesManUpdatePanel.UniqueID %>", "Employees") });
    $(document).ready(function () { showrow("#<%=tbDocStatCustomer.ClientID %>", "#<%=lbDocStatCustomerGuid.ClientID %>", "<%=lbDocStatCustomerUpdatePanel.UniqueID %>", "Companies") });
    $(document).ready(function () { showrow("#<%=tbDocStatExpert.ClientID %>"  , "#<%=lbDocStatExpertGuid.ClientID %>"  , "<%=lbDocStatExpertUpdatePanel.UniqueID %>"  , "EmployeesWithGroups") });

</script>
<head>
    <title>Контрольный отчёт</title>
    <style type="text/css">
        .reportChecker {
            padding-left: 30px;
            padding-bottom: 15px;
            padding-top: 15px;
            margin-bottom: 15px;
        }
        .mainForm {
            margin-left:15px;
        }
        .rightcolumn
        {
            width: 30px;
        }
        .leftcolumn
        {
            width: 180px;
        }
		.colorbutton
		{
		background:#6fa537;
		}
    </style>
    <style type="text/css">
        input[type=text]::-ms-clear {  display: none; width : 0; height: 0; }
        input[type=text]::-ms-reveal {  display: none; width : 0; height: 0; }
        input[type="search"]::-webkit-search-decoration,
        input[type="search"]::-webkit-search-cancel-button,
        input[type="search"]::-webkit-search-results-button,
        input[type="search"]::-webkit-search-results-decoration { display: none; }   
        .fancy-green
        {}
    </style>
    <link id="favicon" rel="shortcut icon" type="image/png" href="http://dv-web:88/favicon-rosles.ico"/>
    <link href="App_Themes/Theme/styles.3ec9bd26.css" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Theme/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Theme/jquery-ui.min.css" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Theme/jquery-ui.structure.css" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Theme/jquery-ui.structure.min.css" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Theme/jquery-ui.theme.css" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Theme/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" />
</head>
<body  class="rosles-style main-background" style="margin: 0px; background-color: #f5f5f5;">
    <div class="main-header full-width complex-container" style="padding-left:103px; padding-top:0px; padding-bottom: 0px;margin-bottom: 20px;">
        <div class="logo logo-undefined" ng-class="logo"><!--<img alt="Лого" src="http://dv-web:88/images/styleImages/logo_rosles.cbc51a55.png" />--></div>
       <!-- <div style="padding-left: 220px; font-weight: bold; font-size: large;">Контрольный отчёт</div> -->
    </div>
    <form id="MainForm" runat="server" style="padding-left:65px; padding-top:30px; padding-bottom: 0px;margin-bottom: 20px;">

        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true"/>
        
        <div id="form1" class="mainForm" runat="server" style="margin-left: 50px; margin-bottom: 20px;">
            <table style="margin-bottom:10px;">
                <tr>
                    <td class="leftcolumn">
                        <asp:Label ID="Label2" runat="server" Text="Срок исполнения с:"></asp:Label>
                    </td>
                    <td colspan="2">
                        <asp:TextBox ID="dtpDocStatDateStart" class="datepicker" style="width: 100px;" runat="server"/>
                        <span style="margin-left: 10px;">по:</span>
                       <asp:TextBox ID="dtpDocStatDateEnd" class="datepicker" style="width: 100px; margin-left: 10px;" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        <label>
                        Автор</label>
                    </td>
                    <td>
                        <asp:UpdatePanel ID="lbDocStatSalesManUpdatePanel" UpdateMode="Conditional" runat="server">
                            <ContentTemplate>
                                <asp:HiddenField ID="lbDocStatSalesManGuid" runat="server" OnValueChanged="lbDocStatSalesManGuid_ValueChanged" />
                                <asp:TextBox ID="tbDocStatSalesMan" runat="server" AutoPostBack="true" Width="400px" style="margin-bottom: 5px;"/>
                                <br/>
                                <asp:ListBox ID="lbDocStatSalesManList" runat="server" Width="404px"/>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td style="vertical-align:top;">
                        <div style="margin-bottom: 10px;">&nbsp;</div>
                        <asp:ImageButton ID="btnDocStatDeleteSalesMan" runat="server" ImageUrl="~/Images/delete.gif"
                            OnClick="btnDocStatDeleteSalesMan_Click" />
                    </td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        <label>
                        Контрагент</label>
                    </td>
                    <td>
                        <asp:UpdatePanel ID="lbDocStatCustomerUpdatePanel" UpdateMode="Conditional" runat="server">
                            <ContentTemplate>
                                <asp:HiddenField ID="lbDocStatCustomerGuid" runat="server" OnValueChanged="lbDocStatCustomerGuid_ValueChanged" />
                                <asp:TextBox ID="tbDocStatCustomer" runat="server" AutoPostBack="true" Width="400px" style="margin-bottom: 5px;"/>
                                <br/>
                                <asp:ListBox ID="lbDocStatCustomerList" runat="server" Width="404px" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td style="vertical-align:top;">
                        <div style="margin-bottom: 10px;">&nbsp;</div>
                        <asp:ImageButton ID="btnDocStatDeleteCustomer" runat="server" ImageUrl="~/Images/delete.gif"
                            OnClick="btnDocStatDeleteCustomer_Click" />
                    </td>
					<td>
						<asp:CheckBox id="CheckBox1" runat="server"
						AutoPostBack="True"
						Text="Исключить выбранные"
						TextAlign="Right"
						/>
					</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        Ответственный исполнитель</td>
                    <td>
                        <asp:UpdatePanel ID="lbDocStatExpertUpdatePanel" UpdateMode="Conditional" runat="server">
                            <ContentTemplate>
                                <asp:HiddenField ID="lbDocStatExpertGuid" runat="server" OnValueChanged="lbDocStatExpertGuid_ValueChanged" />
                                <asp:TextBox ID="tbDocStatExpert" runat="server" AutoPostBack="true" Width="400px" style="margin-bottom: 5px;"/>
                                <br/>
                                <asp:ListBox ID="lbDocStatExpertList" runat="server" Width="404px"/>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td style="vertical-align:top;">
                        <div style="margin-bottom: 10px;">&nbsp;</div>
                        <asp:ImageButton ID="btnDocStatDeleteExpert" runat="server" ImageUrl="~/Images/delete.gif"
                            OnClick="btnDocStatDeleteExpert_Click" />
                    </td>
                </tr>
				<tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        Тип документа</td>
                    <td>
                        <asp:RadioButton id="Radio1" Text="Все"  GroupName="RadioGroup1" runat="server" />
						<asp:RadioButton id="Radio2" Text="Входящий" Checked="True" GroupName="RadioGroup1" runat="server"/>
						<asp:RadioButton id="Radio3" Text="Внутренний" GroupName="RadioGroup1" runat="server"   />
                    </td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
				 <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        Тип исполнения</td>
                    <td>
                        <asp:RadioButton id="Radio11" Text="Все"  GroupName="RadioGroup11" runat="server" />
						<asp:RadioButton id="Radio21" Text="Только задания ответственных" Checked="True" GroupName="RadioGroup11" runat="server"/>
                    </td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        Состояние исполнения</td>
                    <td>
                        <asp:DropDownList ID="ddlExecutionState" runat="server" Height="20px" Width="200px">
                            <asp:ListItem Value="0">Все неисполненные</asp:ListItem>
                            <asp:ListItem Selected="True" Value="1">Просроченные</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        Группировать по</td>
                    <td>
                        <asp:DropDownList ID="ddlGroupingSet" runat="server" Height="20px" Width="200px">
                            <asp:ListItem Value="0">Автор</asp:ListItem>
                            <asp:ListItem Value="1">Контрагент</asp:ListItem>
                            <asp:ListItem Value="2">Ответственные исполнитель</asp:ListItem>
                            <asp:ListItem Selected="True" Value="4">Не группировать</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="leftcolumn" style="vertical-align:top;">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td style="vertical-align:top;">
                        &nbsp;</td>
                </tr>
            </table>
        </div>
        <div class="mainForm" style="margin-left: 50px; margin-bottom: 20px;">
            <asp:Button ID="btnMakeReport" class="colorbutton btn volume width-float top-button ng-binding"  runat="server" OnClick="btnMakeReport_Click" 
                    Text="Сформировать отчет" />
        </div>

    </form>

</body>
</html>
