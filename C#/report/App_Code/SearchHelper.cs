using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Services;

/// <summary>
/// Summary description for SearchHelper
/// </summary>
[WebService(Namespace = "http://digdes.com/DDM/Reports")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class SearchHelper : System.Web.Services.WebService
{

    private static readonly string GET_SEARCH_DATA = ConfigurationManager.AppSettings["SearchProc"];

    public SearchHelper()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    private string[] GetList(string searchTerm, string typedata)
    {

        List<string> Rows = new List<string>();

        string _connectionString;

        _connectionString = ConfigurationManager.ConnectionStrings["DVConnectionString"].ConnectionString;

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {

            SqlCommand cmd = new SqlCommand(GET_SEARCH_DATA, connection);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@searchTerm", searchTerm));

            cmd.Parameters.Add(new SqlParameter("@typedata", typedata));

            connection.Open();

            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                Rows.Add(string.Format("{0}[~~]{1}", rdr["Name"], rdr["RowID"]));

            }

            connection.Close();
        }

        return Rows.ToArray();


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetEmployeesList(string searchTerm)
    {
        return GetList(searchTerm, "Employees");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetUnitsList(string searchTerm)
    {
        return GetList(searchTerm, "Units");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetCardKindsList(string searchTerm)
    {
        return GetList(searchTerm, "CardKinds");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetCompaniesList(string searchTerm)
    {
        return GetList(searchTerm, "Companies");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetCompaniesEmployeesList(string searchTerm)
    {
        return GetList(searchTerm, "CompaniesEmployees");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetRefUniversalItemList(string searchTerm)
    {
        return GetList(searchTerm, "RefUniversalItem");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetCategoriesList(string searchTerm)
    {
        return GetList(searchTerm, "Categories");
    }
	
	[WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string[] GetEmployeesWithGroupsList(string searchTerm)
    {
        return GetList(searchTerm, "EmployeesWithGroups");
    }

}