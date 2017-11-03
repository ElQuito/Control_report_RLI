using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace App_Code
{
    /// <summary>
    /// Summary description for BaseBC
    /// </summary>
    public abstract class BaseBC
    {
        #region Fields

        private static string _connectionString;

        #endregion Fields

        protected static SqlConnection DVConnectionSQL
        {
            get
            {
                _connectionString = ConfigurationManager.ConnectionStrings["DVConnectionString"].ConnectionString;
                SqlConnection connection = new SqlConnection(_connectionString);
                connection.Open();
                return connection;
            }
        }

        protected static string GetDataSet (string ProcName, List<SqlParameter> ParametersList)
        {
            SqlConnection connection = DVConnectionSQL;
            SqlCommand commDb = connection.CreateCommand();

            commDb.CommandText = ProcName;
            commDb.CommandType = CommandType.StoredProcedure;

            foreach (SqlParameter param in ParametersList)
            {
                commDb.Parameters.Add(param);
            }

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = commDb;

            DataSet ds = new DataSet();
            da.Fill(ds);

            return XMLHelper.ToXml(ds);

        }

    }
}