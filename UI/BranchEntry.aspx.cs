using BLL;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SanchaypatraApp.UI
{
    public partial class BranchEntry : System.Web.UI.Page
    {
        SpManager spManager = new SpManager();
        Dictionary<string, string> fileDictionary = new Dictionary<string, string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USER_ID"] != null)
            {
                if (Session["BranchID"].ToString().Equals("0001"))
                {
                    Response.Redirect("SpRequestDetails.aspx", true);
                }
            }
            else
            {
                Response.Redirect("Login.aspx", true);

            }
            SetFileGrid();
            KeepReadOnlyData();
            if (!IsPostBack)
            {
                Session.Remove("SpFaceValue");

                this.BindBranchDropdown();
                this.BindDocumentsTypeDropdown();
                SetInitialRow();
            }


        }

        private void KeepReadOnlyData()
        {
            foreach (Control c in form1.Controls)
            {
                TextBox t = c as TextBox;
                if (t != null)
                {
                    if (t.Text.Length > 0&& t!=regNoTextBox)
                    {
                        t.Attributes.Add("readonly", "readonly");

                    }
                }
               
            }
            if (regNoTextBox.Text.Length > 3)
            {
                string spType = regNoTextBox.Text.Substring(0, 3);
                if (spType.ToLower().Equals("bsp"))
                {
                    startCuponTextBox.ReadOnly = true;
                    endCuponTextBox.ReadOnly = true;
                    cuponNoTextBox.ReadOnly = true;
                    RequiredFieldValidator7.Enabled = false;
                    RequiredFieldValidator8.Enabled = false;
                }
            }
            
            
        }
        private void BindBranchDropdown()
        {
            string branchId = string.Empty;
            string moduleId = string.Empty;
            DataTable dtab = spManager.GetAllBranch(branchId, moduleId);
            if (Session["BranchId"] != null)
            {
                if (!Session["BranchId"].ToString().Equals("0001"))
                {
                    dtab = dtab.AsEnumerable()
                             .Where(r => r.Field<string>("BRANCH_ID") == Session["BranchId"].ToString())
                             .CopyToDataTable();
                }
                
            }
            branchDropDownListChosen.DataSource = dtab;
            branchDropDownListChosen.DataTextField = "BRANCH_NM";
            branchDropDownListChosen.DataValueField = "BRANCH_ID";
            branchDropDownListChosen.DataBind();
            //branchDropDownListChosen.SelectedValue = Session["BranchId"].ToString();
        }
        private void BindDocumentsTypeDropdown()
        {

            DataTable dtab = spManager.GetAllDocumentType();
            documentsTypeDropDown.DataSource = dtab;
            documentsTypeDropDown.DataTextField = "DOCUMENTS_TYPE_NM";
            documentsTypeDropDown.DataValueField = "DOCUMENTS_TYPE_ID";

            documentsTypeDropDown.DataBind();
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (FileUploadControl.HasFile)
            {
                string[] validFileTypes = { "png", "jpg", "jpeg", "pdf"};
                string ext = System.IO.Path.GetExtension(FileUploadControl.PostedFile.FileName);

                bool isValidFile = false;

                for (int i = 0; i < validFileTypes.Length; i++)

                {

                    if (ext == "." + validFileTypes[i])

                    {

                        isValidFile = true;

                        break;

                    }

                }
                try
                {
                    string errorMsg = "";
                    if (isValidFile)
                    {
                        DataTable dt;

                        if (ViewState["DocData"] != null)
                        {
                            dt = (DataTable)ViewState["DocData"];
                        }
                        else
                        {
                            dt = new DataTable();
                            dt.Columns.Add("DocType", typeof(string));
                            dt.Columns.Add("FileName", typeof(string));
                            dt.Columns.Add("FilePath", typeof(string));
                        }

                        string filename = Path.GetFileName(FileUploadControl.FileName);
                        string filePath = Server.MapPath("~/SPFile/") + DateTime.Now.ToString("ddMMyyyyhhmmss") + filename;
                        FileUploadControl.SaveAs(filePath);
                        DataRow dr = dt.NewRow();
                        dr["DocType"] = documentsTypeDropDown.SelectedItem.Text.ToString();
                        dr["FileName"] = filename;
                        dr["FilePath"] = filePath;
                        dt.Rows.Add(dr);
                        ViewState["DocData"] = dt;
                        //BindFileTable();
                        SetFileGrid();
                        errorMsg = "Upload status: File uploaded!";
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "Success('" + errorMsg + "');", true);
                    }
                    else
                    {
                        errorMsg = "Upload status: Only image and pdf  files are accepted!";
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "Error('" + errorMsg + "');", true);



                    }

                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('Upload status: The file could not be uploaded. The following error occured: " + @ex.Message + "');", true);

                }
            }

        }

        protected void fileGridView_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "deletebtn")
            {
                DeletefileFromViewState(e.CommandArgument.ToString());
            }else if (e.CommandName == "showbtn")
            {
                ShowFile(sender, e.CommandArgument.ToString());
            }
        }

        private void ShowFile(object sender, string filePath)
        {
            filePath = filePath.Substring(filePath.LastIndexOf("\\")+"\\".Length);
            if (ViewState["DocData"] != null)
            {

                //DataTable dt = (DataTable)ViewState["DocData"];

                //string queryString = Page.ResolveClientUrl("~/UI/ShowFileUI.aspx?FilePath=" + Server.UrlEncode(filePath.Trim()));
                //string newWin = "window.open('" + queryString + "');";
                //ScriptManager.RegisterClientScriptBlock(sender as Control, this.GetType(), "pop", newWin, true);
                //string FilePath = Server.MapPath(filePath);
                //WebClient User = new WebClient();
                //Byte[] FileBuffer = User.DownloadData(FilePath);
                //if (FileBuffer != null)
                //{
                //    Response.ContentType = "application/pdf";
                //    Response.AddHeader("content-length", FileBuffer.Length.ToString());

                //    //Response.Redirect("ShowFileFromServer.aspx");
                //    Response.BinaryWrite(FileBuffer);

                //}
                Response.Write("<script>");
                Response.Write("window.open('../SpFile/"+ filePath + "', '_newtab');");
                Response.Write("</script>");

            }
        }
        private void DeletefileFromViewState(string fileName)
        {
            if (ViewState["DocData"] != null)
            {
                DataTable dt = (DataTable)ViewState["DocData"];
                string filePath = string.Empty;
                for (int i = dt.Rows.Count - 1; i >= 0; i--)
                {
                    DataRow dr = dt.Rows[i];
                    if (dr["FileName"].ToString().Equals(fileName))
                    {
                        filePath = dr["FilePath"].ToString();
                        dr.Delete();
                    }
                }
                dt.AcceptChanges();
                ViewState["DocData"] = dt;
                SetFileGrid();
                File.Delete(filePath);
            }
        }


        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('Upload status: The file could not be uploaded. The following error occured", true);

        }

        private void SetInitialRow()
        {

            DataTable dt = new DataTable();

            dt.Columns.Add("DocType", typeof(string));
            dt.Columns.Add("FileName", typeof(string));
            dt.Columns.Add("FilePath", typeof(string));
            //DataRow dr = dt.NewRow();
            //dr["FileName"] = "test";
            //dr["FilePath"] = "test";
            //dt.Rows.Add(dr);
            //Bind the Gridview   
            fileGridview.DataSource = dt;
            fileGridview.DataBind();

            
        }
        private void SetFileGrid()
        {


            if (ViewState["DocData"] != null)
            {
                DataTable dt = (DataTable)ViewState["DocData"];
                
                fileGridview.DataSource = dt;
                fileGridview.DataBind();

            }

        }

        protected void SendHoButton_Click(object sender, EventArgs e)
        {
            string makeby = Session["USER_ID"].ToString();

            Dictionary<string, object> SpRequestClaimParam = this.ClaimSpRequest(makeby);
            List<Dictionary<string, object>> fileInfoParamList = new List<Dictionary<string, object>>();
            string requestIdOut = string.Empty;
            string errorMsg = string.Empty;
            if (Session["SpFaceValue"] != null)
            {
                List<Dictionary<string, object>> spFacevalueParamList = this.GetSpFacevalue();
                if (ViewState["DocData"] != null)
                {
                    DataTable dt = (DataTable)ViewState["DocData"];

                    foreach (DataRow dr in dt.Rows)
                    {
                        string filePath = dr["FilePath"].ToString();
                        Dictionary<string, object> fileParam = new Dictionary<string, object>();
                        fileParam.Add("pregistration_no", regNoTextBox.Text.Trim().ToString());
                        fileParam.Add("prequest_id", string.Empty);
                        fileParam.Add("pdocsl_no", string.Empty);
                        fileParam.Add("pdocuments_type_id", documentsTypeDropDown.SelectedValue);
                        fileParam.Add("pfile_nm", dr["FileName"].ToString());
                        fileParam.Add("pfile_navigate_url", filePath);
                        fileParam.Add("pfolder_location", filePath.Substring(0, filePath.LastIndexOf(@"\")));
                        fileParam.Add("pho_upload_flag", 0);
                        fileParam.Add("pbr_upload_flag", 1);
                        fileParam.Add("premarks", string.Empty);
                        fileParam.Add("psys_gen_flag", "S");
                        fileParam.Add("pauth_status_id", "A");
                        fileParam.Add("puser_id", makeby);
                        fileInfoParamList.Add(fileParam);
                    }


                    try
                    {
                        Dictionary<string, object> outPutvalues = spManager.TransactionInsertRequest(SpRequestClaimParam, spFacevalueParamList, fileInfoParamList);
                        requestIdOut = outPutvalues["prequest_id_out"].ToString();
                        errorMsg = outPutvalues["perrormsg"].ToString();
                        if (string.IsNullOrEmpty(errorMsg) || errorMsg.Equals("null"))
                        {
                            if (!string.IsNullOrEmpty(requestIdOut))
                            {
                                //MessageBox.Show("Request Claimed Successfully. Request Id: " + requestIdOut);
                                Response.Write("<script language='javascript'>swal.fire({icon: 'success',title: 'Request Claimed Successfully. Request Id: " + requestIdOut + "'});</script>");
                                errorMsg = "Request Claimed Successfully. Request Id: " + requestIdOut;
                                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "SuccessSendToHo('" + errorMsg + "');", true);


                            }
                        }
                        else
                        {
                            if (errorMsg.Contains("unique"))
                            {
                                errorMsg = "Already Claimed with this Registration No.";
                            }
                            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "Error('" + errorMsg + "');", true);

                        }

                    }
                    catch (Exception ex)
                    {
                        errorMsg = " The following error occured: " + @ex.Message.Replace("\\", "").Replace("//", "");
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "Error('" + errorMsg + "');", true);

                        //MessageBox.Show(" The following error occured: " + ex.Message);
                    }
                }
                else
                {
                    errorMsg = "File Upload Required";
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "Error('" + errorMsg + "');", true);

                }
            }
            else
            {
                errorMsg = "Sanchaypatra and Facevalues are required";
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "Error('" + errorMsg + "');", true);
            }
            

        }
        private List<Dictionary<string,object>> GetSpFacevalue()
        {
            List<Dictionary<string, object>> spFacevalueList = new List<Dictionary<string, object>>();
            if (Session["SpFaceValue"] != null)
            {
                DataTable dt = (DataTable)Session["SpFaceValue"];

                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> inputParam = new Dictionary<string, object>();
                    inputParam.Add("prequest_id", "");
                    inputParam.Add("psanchy_patra_no", dr["INSTRUMENT_NUMBER"]);
                    inputParam.Add("pdenomination", dr["DENOMINATION"]);
                    inputParam.Add("puser_id", Session["USER_ID"].ToString());
                    spFacevalueList.Add(inputParam);
                }
            }
            return spFacevalueList;
        }

        private Dictionary<string, object> ClaimSpRequest(string makeby)
        {
            int walkingCustomer = walkingCheckBox.Checked ? 1 : 0;
            Dictionary<string, object> claimParam = new Dictionary<string, object>();
            claimParam.Add("pbranch_id", branchDropDownListChosen.SelectedValue.ToString());
            claimParam.Add("prequest_id", string.Empty);
            claimParam.Add("pregistration_No", regNoTextBox.Text.Trim().ToString());
            //claimParam.Add("psanchay_Patra_No", spNoTextBox.Text.Trim().ToString());
            claimParam.Add("pwalk_In_Customer", walkingCustomer);
            claimParam.Add("pcustomer_Acc_No", accNoTextBox.Text.Trim().ToString());
            claimParam.Add("pcustomer_Name", custNameTextBox.Text.Trim().ToString());
            claimParam.Add("pcustomer_Mobile_No", mobileTextBox.Text.Trim().ToString());
            claimParam.Add("pinvestment_Date", DateTime.ParseExact(investDate.Text, "dd/MM/yyyy", null).ToString("dd-MMM-yyyy"));
            claimParam.Add("ptotal_Investment", Convert.ToDouble(investmentTextBox.Text.Trim()));
            //claimParam.Add("pface_Value", Convert.ToDouble(faceValueTextBox.Text.Trim().ToString()));
            claimParam.Add("pstart_Coupon_No", startCuponTextBox.Text.Trim().ToString());
            claimParam.Add("pend_Coupon_No", endCuponTextBox.Text.Trim().ToString());
            claimParam.Add("ppaid_Amount", string.Empty);
            claimParam.Add("prequest_status_id", "1");
            claimParam.Add("pauthorize_status", 'A');
            claimParam.Add("pmake_By", makeby);
            claimParam.Add("pmake_Date", DateTime.Now.ToString("dd-MMM-yyyy"));
            claimParam.Add("pauthorize_By", makeby);
            claimParam.Add("pauthorize_Date", DateTime.Now.ToString("dd-MMM-yyyy"));
            claimParam.Add("papproved_by", string.Empty);
            claimParam.Add("papproved_dt", string.Empty);
            claimParam.Add("premarks", string.Empty);



            return claimParam;
        }

        [WebMethod]
        public static string GetAllSpDetails(string pregistration_no)
        {
            SpManager spManager = new SpManager();

            DataTable dt = new DataTable();
            if (HttpContext.Current.Session["BranchId"] != null)
            {
                if (!HttpContext.Current.Session["BranchId"].ToString().Equals("0001"))
                {
                    dt = spManager.GetSpDetailsByReg(pregistration_no);
                    DataColumn[] columns = dt.Columns.Cast<DataColumn>().ToArray();
                    bool contains = dt.AsEnumerable()
                        .Any(row => columns.Any(col => row[col].ToString() == HttpContext.Current.Session["BranchId"].ToString()));
                    if (contains)
                    {
                        dt = dt.AsEnumerable().Where(r => r.Field<string>("BRANCH_NAME") == HttpContext.Current.Session["BranchId"].ToString()).CopyToDataTable();
                    }
                    else
                    {
                        dt = new DataTable();
                    }

                }

            }
            return DatatableToJson(dt);
        }
        [WebMethod]
        public static string GetSpFacevalue(string pregistration_no, string pinstrument_number)
        {
            SpManager spManager = new SpManager();

            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("pregistration_no", pregistration_no);
            inputParam.Add("pinstrument_number", pinstrument_number);
            DataTable dt = spManager.GetImportedSpFacevalue(inputParam);
            HttpContext.Current.Session["SpFaceValue"] = dt;
            DataTable filteredData = new DataTable();
            filteredData.Columns.Add("INSTRUMENT_NUMBER");
            filteredData.Columns.Add("DENOMINATION");
            foreach (DataRow dr in dt.Rows)
            {

                DataRow row = filteredData.NewRow();
                row["INSTRUMENT_NUMBER"] = dr["INSTRUMENT_NUMBER"];
                row["DENOMINATION"] = dr["DENOMINATION"];
                filteredData.Rows.Add(row);
            }

            return DatatableToJson(filteredData);
        }

        public static string DatatableToJson(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {

                    row.Add(col.ColumnName.Replace(".", ""), dr[col].GetType() == typeof(DateTime) ? Convert.ToDateTime(dr[col]).ToString("dd/MM/yyyy") : dr[col]);

                }
                rows.Add(row);
            }

            return JsonConvert.SerializeObject(rows);
        }

    }
}