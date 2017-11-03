using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Configuration;
using System.IO;

namespace App_Code
{
    /// <summary>
    /// Summary description for Class1
    /// </summary>
    public class DocStat : BaseBC
    {

        private static readonly string DOC_STAT_REPORT_PROC = ConfigurationManager.AppSettings["DocStatReportProc"];

        private static string _overalProcResult;

        private static DateTime _docStatDateStart;

        private static DateTime _docStatDateEnd;

        private static string _docStatSalesManIDs;

        private static string _docStatCustomerIDs;

        private static string _docStatExpertIDs;

        private static int _docStatExecutionState;

        private static int _docStatGroupingSet;
		
		private static int _docStatDocumentType;
		
		private static int _docStatAppointedType;
		
		private static int _docStatCounterpartyException;

        public static string GetProcResult(DateTime DocStatDateStart, DateTime DocStatDateEnd, string DocStatSalesManIDs, string DocStatCustomerIDs, string DocStatExpertIDs
                                         , int DocStatExecutionState, int DocStatGroupingSet, int DocStatDocumentType, int DocStatAppointedType, int DocStatCounterpartyException)
        {
        
            if (_overalProcResult == null || 
                DocStatDateStart != _docStatDateStart ||
                DocStatDateEnd != _docStatDateEnd ||
                DocStatSalesManIDs != _docStatSalesManIDs ||
                DocStatCustomerIDs != _docStatCustomerIDs ||
                DocStatExpertIDs != _docStatExpertIDs ||
                DocStatExecutionState != _docStatExecutionState ||
                DocStatGroupingSet != _docStatGroupingSet || 
				DocStatDocumentType != _docStatDocumentType || 
				DocStatAppointedType != _docStatAppointedType ||
				DocStatCounterpartyException != _docStatCounterpartyException
                )
            {

                List<SqlParameter> ParametersList = new List<SqlParameter>();  
             
                if (DocStatDateStart != DateTime.MinValue)
                {
                    ParametersList.Add(new SqlParameter("@startRegDate", DocStatDateStart));
                }
                if (DocStatDateEnd != DateTime.MinValue)
                {
                    ParametersList.Add(new SqlParameter("@endRegDate", DocStatDateEnd));
                }
                ParametersList.Add(new SqlParameter("@salesManIDs", DocStatSalesManIDs));
                ParametersList.Add(new SqlParameter("@customerIDs", DocStatCustomerIDs));
                ParametersList.Add(new SqlParameter("@expertIDs", DocStatExpertIDs));
                ParametersList.Add(new SqlParameter("@executionState", DocStatExecutionState));
                ParametersList.Add(new SqlParameter("@groupingSet", DocStatGroupingSet));
				ParametersList.Add(new SqlParameter("@documentType", DocStatDocumentType));
				ParametersList.Add(new SqlParameter("@appointedType", DocStatAppointedType));
				ParametersList.Add(new SqlParameter("@counterpartyException", DocStatCounterpartyException));

                _overalProcResult = GetDataSet(DOC_STAT_REPORT_PROC, ParametersList);

                _docStatDateStart = DocStatDateStart;

                _docStatDateEnd = DocStatDateEnd;

                _docStatSalesManIDs = DocStatSalesManIDs;

                _docStatCustomerIDs = DocStatCustomerIDs;

                _docStatExpertIDs = DocStatExpertIDs;

                _docStatExecutionState = DocStatExecutionState;

                _docStatGroupingSet = DocStatGroupingSet;
				
				_docStatDocumentType = DocStatDocumentType;
				
				_docStatAppointedType = DocStatAppointedType;
				
				_docStatCounterpartyException = DocStatCounterpartyException;

            }

            return _overalProcResult;

        }

    }

}