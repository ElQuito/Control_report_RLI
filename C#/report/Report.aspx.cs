using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class _Default : System.Web.UI.Page
{
    int reportType;
    
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            var name = HttpContext.Current.User.Identity.Name;

        }

    }

    protected void MessageBox(string strMsg)
    {
        Label lbl = new Label();

        lbl.Text = "<script language='javascript'>" + Environment.NewLine + "window.alert(" + "'" + strMsg + "'" + ")</script>";

        Page.Controls.Add(lbl);
    }

    protected void btnDocStatDeleteSalesMan_Click(object sender, ImageClickEventArgs e)
    {

        if (lbDocStatSalesManList.SelectedItem != null)
            lbDocStatSalesManList.Items.Remove(lbDocStatSalesManList.SelectedItem);

    }

    protected void btnDocStatDeleteCustomer_Click(object sender, ImageClickEventArgs e)
    {

        if (lbDocStatCustomerList.SelectedItem != null)
            lbDocStatCustomerList.Items.Remove(lbDocStatCustomerList.SelectedItem);

    }

    protected void btnDocStatDeleteExpert_Click(object sender, ImageClickEventArgs e)
    {

        if (lbDocStatExpertList.SelectedItem != null)
            lbDocStatExpertList.Items.Remove(lbDocStatExpertList.SelectedItem);

    }


    protected void btnMakeReport_Click(object sender, EventArgs e)
    {

        StringBuilder addressStringBuilder = new StringBuilder("ReportResults.aspx?reportInstanceID=1");
        
        if (!string.IsNullOrEmpty(dtpDocStatDateStart.Text))
        {
            addressStringBuilder.AppendFormat("&docStatDateStart={0}",
                                                    dtpDocStatDateStart.Text);
        }

        if (!string.IsNullOrEmpty(dtpDocStatDateEnd.Text))
        {
            addressStringBuilder.AppendFormat("&docStatDateEnd={0}",
                                                    dtpDocStatDateEnd.Text);
        }

        if (lbDocStatSalesManList.Items.Count > 0)
        {
            addressStringBuilder.AppendFormat("&salesMen={0}",
                                              HttpUtility.UrlEncode(GetString(lbDocStatSalesManList.Items)));
        }

        if (lbDocStatCustomerList.Items.Count > 0)
        {
            addressStringBuilder.AppendFormat("&customers={0}",
                                              HttpUtility.UrlEncode(GetString(lbDocStatCustomerList.Items)));
        }

        if (lbDocStatExpertList.Items.Count > 0)
        {
            addressStringBuilder.AppendFormat("&experts={0}",
                                              HttpUtility.UrlEncode(GetString(lbDocStatExpertList.Items)));
        }

        addressStringBuilder.AppendFormat("&executionState={0}",
                                          ddlExecutionState.SelectedItem.Value);

        addressStringBuilder.AppendFormat("&groupingSet={0}",
                                          ddlGroupingSet.SelectedItem.Value);
										  
		if (Radio1.Checked) {
                 addressStringBuilder.AppendFormat("&documentType={0}",
                                          0);
        }
        else if (Radio2.Checked) {
                                  addressStringBuilder.AppendFormat("&documentType={0}",
                                          1);
        }
        else if (Radio3.Checked) {
                                  addressStringBuilder.AppendFormat("&documentType={0}",
                                          2);
        }

		if (Radio11.Checked) {
                 addressStringBuilder.AppendFormat("&appointedType={0}",
                                          1);
        }
        else{
                                  addressStringBuilder.AppendFormat("&appointedType={0}",
                                          0);
        }
		if (CheckBox1.Checked == true){
                                  addressStringBuilder.AppendFormat("&counterpartyException={0}",
                                          0);
		}else{
                                  addressStringBuilder.AppendFormat("&counterpartyException={0}",
                                          1);
		}
        
        Session["PrevPages"] = null;
        Session["CurrentPosition"] = null;
        Session["CurrentItem"] = null;

        this.Response.Redirect(addressStringBuilder.ToString());

    }

    private string GetString(ListItemCollection list)
    {
        string res = string.Empty;
        foreach (ListItem item in list)
        {
            res += string.Format("{0};", '{' + (item.Value.Trim(new char[] { '{', '}' })) + '}');
        }
        if (res.Length > 1) res = res.Substring(0, res.Length - 1);
        return res;
    }

    protected void lbDocStatSalesManGuid_ValueChanged(object sender, EventArgs e)
    {
        if (!lbDocStatSalesManList.Items.Contains(new ListItem(tbDocStatSalesMan.Text, lbDocStatSalesManGuid.Value)))
        {
            lbDocStatSalesManList.Items.Add(new ListItem(tbDocStatSalesMan.Text, lbDocStatSalesManGuid.Value));
        }
        tbDocStatSalesMan.Text = string.Empty;
        lbDocStatSalesManGuid.Value = string.Empty;
    }

    protected void lbDocStatCustomerGuid_ValueChanged(object sender, EventArgs e)
    {
        if (!lbDocStatCustomerList.Items.Contains(new ListItem(tbDocStatCustomer.Text, lbDocStatCustomerGuid.Value)))
        {
            lbDocStatCustomerList.Items.Add(new ListItem(tbDocStatCustomer.Text, lbDocStatCustomerGuid.Value));
        }
        tbDocStatCustomer.Text = string.Empty;
        lbDocStatCustomerGuid.Value = string.Empty;
    }
    protected void lbDocStatExpertGuid_ValueChanged(object sender, EventArgs e)
    {
        if (!lbDocStatExpertList.Items.Contains(new ListItem(tbDocStatExpert.Text, lbDocStatExpertGuid.Value)))
        {
            lbDocStatExpertList.Items.Add(new ListItem(tbDocStatExpert.Text, lbDocStatExpertGuid.Value));
        }
        tbDocStatExpert.Text = string.Empty;
        lbDocStatExpertGuid.Value = string.Empty;
    }

}