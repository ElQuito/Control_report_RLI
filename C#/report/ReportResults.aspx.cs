using System;
using System.Xml;
using System.Xml.Xsl;
using System.Configuration;
using System.Web;
using System.IO;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using App_Code;


public partial class ReportResults : System.Web.UI.Page
{

    private DateTime DocStatDateStart;
    private DateTime DocStatDateEnd;
    private string DocStatSalesManIDs;
    private string DocStatCustomerIDs;
    private string DocStatExpertIDs;
    private int DocStatExecutionState;
    private int DocStatGroupingSet;
	private int DocStatDocumentType;
	private int DocStatAppointedType;
	private int DocStatCounterpartyException;

    protected void MessageBox(string strMsg)
    {
        Label lbl = new Label();

        lbl.Text = "<script language='javascript'>" + Environment.NewLine + "window.alert(" + "'" + strMsg + "'" + ")</script>";

        Page.Controls.Add(lbl);
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        DocStatDateStart = ParseDateTimeValue("docStatDateStart");

        DocStatDateEnd = ParseDateTimeValue("docStatDateEnd");
        
        DocStatSalesManIDs = Request["salesMen"];

        DocStatCustomerIDs = Request["customers"];

        DocStatExpertIDs = Request["experts"];

        DocStatExecutionState = ParseIntValue("executionState");

        DocStatGroupingSet = ParseIntValue("groupingSet");
		
		DocStatDocumentType = ParseIntValue("documentType");
		
		DocStatAppointedType = ParseIntValue("appointedType");
		
		DocStatCounterpartyException = ParseIntValue("counterpartyException");

    }

    private bool ParseBoolValue (string request)
    {

        bool result;
        
        if (!bool.TryParse(Request[request], out result))
        {
            result = false;
        }

        return result;

    }

    private int ParseIntValue(string request)
    {

        int result;

        if (!int.TryParse(Request[request], out result))
        {
            result = 0;
        }

        return result;

    }

    private DateTime ParseDateTimeValue(string request)
    {

        DateTime result;

        if (!DateTime.TryParseExact(Request[request], "dd.MM.yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out result))
        {
            if (!string.IsNullOrEmpty(Request[request]))
            {
                result = GetDateByExpression(Request[request]);
            }
        }

        return result;

    }

    private DateTime GetDateByExpression(string expression)
    {
        DateTime? result = null;
        
        if (expression.StartsWith("today"))
        {
            int addDays = 0;
            string addDaysExpression = expression.Remove(0, 5);
            if (addDaysExpression.Length == 0 || !int.TryParse(addDaysExpression, out addDays))
                addDays = 0;

            result = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            result = result.Value.AddDays(addDays);
        }
        else if (expression.StartsWith("firstDayOfTheMonth"))
        {
            int addDays = 0;
            string addDaysExpression = expression.Remove(0, 18);
            if (addDaysExpression.Length == 0 || !int.TryParse(addDaysExpression, out addDays))
                addDays = 0;
            DateTime firstDayOfTheMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            result = firstDayOfTheMonth.AddDays(addDays);
        }
        else if (expression.StartsWith("lastDayOfTheMonth"))
        {
            int addDays = 0;
            string addDaysExpression = expression.Remove(0, 17);
            if (addDaysExpression.Length == 0 || !int.TryParse(addDaysExpression, out addDays))
                addDays = 0;
            DateTime firstDayOfTheMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime lastDayOfTheMonth = firstDayOfTheMonth.AddMonths(1).AddDays(-1);
            result = lastDayOfTheMonth.AddDays(addDays);
        }
        else if (expression.StartsWith("firstDayOfQuarter"))
        {
            int addDays = 0;
            string addDaysExpression = expression.Remove(0, 17);
            if (addDaysExpression.Length == 0 || !int.TryParse(addDaysExpression, out addDays))
                addDays = 0;
            int quarterNumber = (DateTime.Now.Month - 1) / 3 + 1;
            DateTime firstDayOfQuarter = new DateTime(DateTime.Now.Year, (quarterNumber - 1) * 3 + 1, 1);
            result = firstDayOfQuarter.AddDays(addDays);
        }
        else if (expression.StartsWith("lastDayOfQuarter"))
        {
            int addDays = 0;
            string addDaysExpression = expression.Remove(0, 16);
            if (addDaysExpression.Length == 0 || !int.TryParse(addDaysExpression, out addDays))
                addDays = 0;
            int quarterNumber = (DateTime.Now.Month - 1) / 3 + 1;
            DateTime firstDayOfQuarter = new DateTime(DateTime.Now.Year, (quarterNumber - 1) * 3 + 1, 1);
            DateTime lastDayOfQuarter = firstDayOfQuarter.AddMonths(3).AddDays(-1);
            result = lastDayOfQuarter.AddDays(addDays);
        }

        return result ?? DateTime.MinValue;
    }

    private string GetResultTable(string inputXml, string xsltFilePath, XsltArgumentList args)
    {

        if (string.IsNullOrEmpty(xsltFilePath))
        {
            
            return inputXml;

        }

        XsltSettings settings = new XsltSettings(true, true);
        settings.EnableScript = true;

        XslCompiledTransform xslTransform = new XslCompiledTransform(true);
        try
        {
            xslTransform.Load(xsltFilePath, settings, new XmlUrlResolver());
        }
        catch (Exception ex)
        {
            Response.Clear();
            Response.Write(string.Format("Xslt '{0}' load exception:{1}", xsltFilePath, ex));
            return "";
        }

        using (XmlReader inputXmlReader = XmlReader.Create(new StringReader(inputXml)))
        {
            using (MemoryStream stream = new MemoryStream())
            {
                try
                {

                    xslTransform.Transform(inputXmlReader, args, stream);

                }
                catch (Exception ex)
                {
                    Response.Clear();
                    Response.Write(string.Format("Xslt transform exception:{0}", ex));
                    return "";
                }
                Byte[] bytearray = stream.ToArray();

                return /*inputXml + "||" + */System.Text.Encoding.UTF8.GetString(bytearray);
            }
        }

    }

    public void GetDocStatReport()
    {
        Response.Write(GetDocStatReport(""));
    }

    private string GetDocStatReport(string outputType)
    {

        string xsltFilePath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["DocStatReportXSLT" + outputType];

        string procResult = DocStat.GetProcResult(DocStatDateStart, DocStatDateEnd, DocStatSalesManIDs, DocStatCustomerIDs, DocStatExpertIDs, DocStatExecutionState, DocStatGroupingSet, DocStatDocumentType, DocStatAppointedType,DocStatCounterpartyException);

        string result;

        var args = new XsltArgumentList();

        if (DocStatDateStart != DateTime.MinValue)
        {
            args.AddParam("DateFrom", "", DocStatDateStart.ToString("dd.MM.yyyy"));
        }

        if (DocStatDateEnd != DateTime.MinValue)
        {
            args.AddParam("DateTo", "", DocStatDateEnd.ToString("dd.MM.yyyy"));
        }

        if (!String.IsNullOrWhiteSpace(DocStatSalesManIDs))
        {
            args.AddParam("IsSalesMenFiltered", "", 1);
        }

        if (!String.IsNullOrWhiteSpace(DocStatCustomerIDs))
        {
            args.AddParam("IsCustomersFiltered", "", 1);
        }

        if (!String.IsNullOrWhiteSpace(DocStatExpertIDs))
        {
            args.AddParam("IsExpertsFiltered", "", 1);
        }

        args.AddParam("ExecutionState", "", DocStatExecutionState);

        args.AddParam("DocumentLink", "", ConfigurationManager.AppSettings["DocumentLink"]);
		
		args.AddParam("TaskLink", "", ConfigurationManager.AppSettings["TaskLink"]);
		
		args.AddParam("LinkThickClient", "", ConfigurationManager.AppSettings["LinkThickClient"]);
		
		//args.AddParam("LinkThickClientEnd", "", ConfigurationManager.AppSettings["LinkThickClientEnd"]);

        if (!String.IsNullOrEmpty(ConfigurationManager.AppSettings["DocStatReportXSLT" + outputType]))
        {
            result  = GetResultTable(procResult, xsltFilePath, args);
        }
        else
        {
            result = GetResultTable(procResult, String.Empty, args);
        }
        
        return result;

    }

    private string GetDocument(string outputType)
    {
        string result = System.IO.File.ReadAllText(Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["ResultTable" + outputType]);
        
        string resultReport = GetDocStatReport(outputType);
            
        result = result.Replace("$DocStatReport", resultReport);

        return result;

    }

    protected void buttonExportToWord_Click(object sender, EventArgs e)
    {

        string ResultTableWord = GetDocument("Word");
        
        Response.Clear();

        Response.ContentType = "application/ms-word";

        Response.AddHeader("Content-Disposition", "attachment; filename=Report.doc");

        Response.Write(ResultTableWord);

        Response.Flush();

        Response.End();

    }

}
