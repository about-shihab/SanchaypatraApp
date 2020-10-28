using Oracle.DataAccess.Client;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;

namespace DAL
{
    public class SpGateway
    {
        string connectionString = ConfigurationManager.ConnectionStrings["ULTIMUS"].ToString();
        private DataTable GetDataByProcedure(Dictionary<string,object> inputParamHt, Dictionary<string, object> outputParamHt, string procedureName)
        {
            DataTable dtab = new DataTable();
            using (OracleConnection connection = new OracleConnection())
            {

                connection.ConnectionString = connectionString;
                try
                {

                    connection.Open();
                    OracleCommand command = new OracleCommand();
                    command.Connection = connection;
                    command.CommandText = procedureName;
                    command.CommandType = CommandType.StoredProcedure;
                    foreach (string obj in inputParamHt.Keys)
                    {
                        string ColumnName = Convert.ToString(obj);
                        if (string.IsNullOrEmpty(inputParamHt[obj].ToString()))
                        {
                            OracleParameter param = new OracleParameter(ColumnName, DBNull.Value);
                            command.Parameters.Add(param);
                        }
                        else
                        {
                            int size = Convert.ToInt32(inputParamHt[obj].ToString().Length);
                            OracleParameter param = new OracleParameter(ColumnName, inputParamHt[obj]);
                            command.Parameters.Add(param);
                        }
                    }
             
                    foreach (string obj in outputParamHt.Keys)
                    {
                        string ColumnName = Convert.ToString(obj);
                        if (ColumnName.Equals("presult"))
                        {
                           command.Parameters.Add(ColumnName, OracleDbType.RefCursor).Direction = ParameterDirection.Output;
                        }
                        //else if (ColumnName.Equals("prequest_id_out")|| ColumnName.Equals("perrorcode"))
                        //{
                        //    command.Parameters.Add(ColumnName, OracleDbType.Int64).Direction = ParameterDirection.Output;

                        //}
                        //else
                        //{
                        //    command.Parameters.Add(ColumnName, outputParamHt[obj]).Direction = ParameterDirection.Output;

                        //}

                        else
                        {
                            command.Parameters.Add(ColumnName, OracleDbType.Varchar2, Convert.ToInt32(outputParamHt[obj].ToString())).Direction = ParameterDirection.Output;

                        }
                    }

                    OracleDataReader dr = command.ExecuteReader();
                    dtab.Load(dr);

                    //adp.SelectCommand = command;
                    //adp.Fill(dtab);
                    //if (dtab.Rows.Count == 0)
                    //{
                    //    DataRow row = dtab.NewRow();

                    //    foreach (string obj in outputParamHt.Keys)
                    //    {
                    //        dtab.Columns.Add(obj, typeof(string));
                    //        row[obj] = command.Parameters[obj].Value.ToString();
                    //    }

                    //    dtab.Rows.Add(row);

                    //}

                    command.Parameters.Clear();
                    return dtab;

                }

                catch (OracleException ex)
                {
                    throw ex;
                }
                finally
                {
                    connection.Close();
                }
            }
        }

        private DataTable GetDataByQuery(string query, Hashtable inputParamHt)
        {
            DataTable dtab = new DataTable();
            using (OracleConnection connection = new OracleConnection())
            {

                connection.ConnectionString = connectionString;
                try
                {

                    connection.Open();
                    OracleCommand command = new OracleCommand();
                    command.Connection = connection;
                    command.CommandText = query;
                    command.CommandType = CommandType.Text;
                    foreach (object obj in inputParamHt.Keys)
                    {
                        string ColumnName = Convert.ToString(obj);
                        if (string.IsNullOrEmpty(inputParamHt[obj].ToString()))
                        {
                            OracleParameter param = new OracleParameter(ColumnName, DBNull.Value);
                            command.Parameters.Add(param);
                        }
                        else
                        {
                            OracleParameter param = new OracleParameter(ColumnName, inputParamHt[obj]);
                            command.Parameters.Add(param);
                        }
                    }

                    OracleDataReader dr = command.ExecuteReader();
                    dtab.Load(dr);

                    //adp.SelectCommand = command;
                    //adp.Fill(dtab);

                    command.Parameters.Clear();
                    return dtab;

                }

                catch (OracleException ex)
                {
                    throw ex;
                }
                finally
                {
                    connection.Close();
                }
            }
        }
        public DataTable GetAllDocumentType()
        {
            Dictionary<string, object> inputHt = new Dictionary<string, object>();
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("presult", "presult");
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.fsp_get_documents_typ");


        }
        public DataTable GetAllBranch(string pbranch_id, string pmodule_id)
        {
            Hashtable inputHt = new Hashtable();
            inputHt.Add("pbranch_id", pbranch_id);
            inputHt.Add("pmodule_id", pmodule_id);
            string query = @"SELECT t.branch_id, t.branch_nm FROM table(pkg_mis_system.fxn_get_branch_info(:pbranch_id,:pmodule_id)) t order by t.branch_id asc";
            return this.GetDataByQuery(query, inputHt);

        }
        public DataTable ClaimSpRequest(Dictionary<string, object> inputHt)
        {
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("prequest_id_out", 20);
            outputHt.Add("perrorcode", 5);
            outputHt.Add("perrormsg", 50);
            string procedureNm = "pkg_sp_management_sebl.fsp_addup_sp_request_master";
            return this.GetDataByProcedure(inputHt,outputHt,procedureNm);
        }

        private OracleCommand BindOracleCommand(OracleConnection connection, Dictionary<string, object> inputParamHt, Dictionary<string, object> outputParamHt, string procedureName)
        {
            OracleCommand command = new OracleCommand();
            command.Connection = connection;
            command.CommandText = procedureName;
            command.CommandType = CommandType.StoredProcedure;
            command.BindByName = true;
            foreach (string obj in inputParamHt.Keys)
            {
                string ColumnName = Convert.ToString(obj);
                if (string.IsNullOrEmpty(inputParamHt[obj].ToString()))
                {
                    OracleParameter param = new OracleParameter(ColumnName, DBNull.Value);
                    command.Parameters.Add(param);
                }
                else
                {
                    int size = Convert.ToInt32(inputParamHt[obj].ToString().Length);
                    OracleParameter param = new OracleParameter(ColumnName, inputParamHt[obj]);
                    command.Parameters.Add(param);
                }
            }

            foreach (string obj in outputParamHt.Keys)
            {
                string ColumnName = Convert.ToString(obj);
                if (ColumnName.Equals("presult"))
                {
                    command.Parameters.Add(ColumnName, OracleDbType.RefCursor).Direction = ParameterDirection.Output;
                }
                //else if (ColumnName.Equals("perrorcode"))
                //{
                //    command.Parameters.Add(ColumnName, OracleDbType.Int64).Direction = ParameterDirection.Output;

                //}
                //else if (ColumnName.Equals("prequest_id_out"))
                //{
                //    command.Parameters.Add(ColumnName, OracleDbType.Varchar2,20).Direction = ParameterDirection.Output;

                //}
                else
                {
                    command.Parameters.Add(ColumnName, OracleDbType.Varchar2, Convert.ToInt32(outputParamHt[obj].ToString())).Direction = ParameterDirection.Output;

                }
            }

            return command;
        }
        public Dictionary<string,object> TransactionInsertRequest(Dictionary<string, object> requestInputParamHt, List<Dictionary<string, object>> spFacevalueParamHtList, List<Dictionary<string, object>> fileInputParamHtList)
        {

            string requestIdOut = string.Empty;
            string errorMsg = string.Empty;
            Dictionary<string, object> requestoutputHt = new Dictionary<string, object>();
            requestoutputHt.Add("prequest_id_out", 20);
            requestoutputHt.Add("perrorcode", 5);
            requestoutputHt.Add("perrormsg", 200);
            string requstInfoProcedureNm = "pkg_sp_management_sebl.fsp_addup_sp_request_master";

            

            using (OracleConnection connection = new OracleConnection())
            {

                connection.ConnectionString = connectionString;
                try
                {

                    connection.Open();
                    OracleCommand requestCommand = this.BindOracleCommand(connection, requestInputParamHt, requestoutputHt, requstInfoProcedureNm);
                    OracleTransaction transaction = connection.BeginTransaction(IsolationLevel.ReadCommitted);
                    try
                    {
                       requestCommand.ExecuteNonQuery();
                       requestIdOut = requestCommand.Parameters["prequest_id_out"].Value.ToString();
                       errorMsg = requestCommand.Parameters["perrormsg"].Value.ToString();
                       requestCommand.Parameters.Clear();
                        if (string.IsNullOrEmpty(errorMsg)||errorMsg.Equals("null"))
                        {
                            //insert spface value 
                            errorMsg = this.InsertSpFacevalue(connection, spFacevalueParamHtList, requestIdOut);
                            if (string.IsNullOrEmpty(errorMsg) || errorMsg.Equals("null"))
                            {
                                try
                                {
                                    this.InsertFileInfo(connection, fileInputParamHtList, requestIdOut);
                                    transaction.Commit();
                                }
                                catch (OracleException ex)
                                {
                                    transaction.Rollback();
                                    throw ex;
                                }
                            }
                           
                            
                        }
                        else
                        {
                            transaction.Rollback();
                        }



                    }
                    catch (OracleException ex)
                    {
                        transaction.Rollback();
                        throw ex;
                    }


                }

                catch (OracleException ex)
                {
                    throw ex;
                }
                finally
                {
                    connection.Close();
                }
            }

            requestoutputHt["prequest_id_out"] = requestIdOut;
            requestoutputHt["perrormsg"] = errorMsg;
            return requestoutputHt;


        }

        private string InsertSpFacevalue(OracleConnection connection, List<Dictionary<string, object>> spFacevalueParamHtList, string requestIdOut)
        {
            string errorMsg = string.Empty;
            Dictionary<string, object> filetoutputHt = new Dictionary<string, object>();
            filetoutputHt.Add("perrorcode", 15);
            filetoutputHt.Add("perrormsg", 250);
            string fileInfoProcedureNm = "pkg_sp_management_sebl.fsp_addup_sp_denomination";
            foreach (Dictionary<string, object> InputParam in spFacevalueParamHtList)
            {
                InputParam["prequest_id"] = requestIdOut;
                OracleCommand Command = this.BindOracleCommand(connection, InputParam, filetoutputHt, fileInfoProcedureNm);
                Command.ExecuteNonQuery();
                errorMsg = Command.Parameters["perrormsg"].Value.ToString();
                Command.Parameters.Clear();
            }
            return errorMsg;
        }
        private void InsertFileInfo(OracleConnection connection, List<Dictionary<string, object>> fileInputParamHtList, string requestIdOut)
        {
            Dictionary<string, object> filetoutputHt = new Dictionary<string, object>();
            filetoutputHt.Add("perrorcode", 15);
            filetoutputHt.Add("perrormsg", 250);
            string fileInfoProcedureNm = "pkg_sp_management_sebl.fsp_addup_sp_doc_register";
            int i = 1;
            foreach (Dictionary<string, object> fileInputParam in fileInputParamHtList)
            {
                fileInputParam["prequest_id"] = requestIdOut;
                fileInputParam["pdocsl_no"] = i.ToString();
                OracleCommand fileCommand = this.BindOracleCommand(connection, fileInputParam, filetoutputHt, fileInfoProcedureNm);
                fileCommand.ExecuteNonQuery();
                fileCommand.Parameters.Clear();
                i++;
            }

        }

        public void InsertAdditionalFile(List<Dictionary<string, object>> fileInputParamHtList, string requestId)
        {
            using (OracleConnection connection = new OracleConnection())
            {

                connection.ConnectionString = connectionString;
                try
                {

                    connection.Open();
                    this.InsertFileInfo(connection, fileInputParamHtList, requestId);
                }

                catch (OracleException ex)
                {
                    throw ex;
                }
                finally
                {
                    connection.Close();
                }
            }
         }
        public DataTable GetSpDetailsByReg(string regNo)
        {
            Dictionary<string, object> inputHt = new Dictionary<string, object>();
            inputHt.Add("pregistration_no", regNo);
            //inputHt.Add("pinstrument_number", spNo);
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("presult", "presult");
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.get_sp_details_migrated_data");
        }

        public DataTable GetRspMasterData(Dictionary<string, object> inputHt)
        {
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("presult", "presult");
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.rsp_get_sp_request_master");
        }

        public DataTable GetFileInfo(Dictionary<string, object> inputHt)
        {
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("presult", "presult");
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.rsp_get_sp_request_doc_master");
        }
        public DataTable DeleteFile(Dictionary<string, object> inputHt)
        {
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("perrorcode", 5);
            outputHt.Add("perrormsg", 10);
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.fsp_delete_documents_file");
        }

        public DataTable GetImportedSpFacevalue(Dictionary<string, object> inputHt)
        {
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("presult", "presult");
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.get_sp_denom_migrate_data");
        }
        public DataTable GetSpFacevalue(Dictionary<string, object> inputHt)
        {
            Dictionary<string, object> outputHt = new Dictionary<string, object>();
            outputHt.Add("presult", "presult");
            return this.GetDataByProcedure(inputHt, outputHt, "pkg_sp_management_sebl.rsp_get_sp_denomination_master");
        }

    }
}
