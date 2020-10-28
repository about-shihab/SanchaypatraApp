using BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SanchaypatraApp.UI
{
    public partial class SpRequestDetails : System.Web.UI.Page
    {
        SpManager spManager = new SpManager();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USER_ID"] != null)
            {
                if (!Session["BranchID"].ToString().Equals("0001"))
                {
                    Response.Redirect("BranchEntry.aspx", true);
                }

                
            }
            else
            {
                Response.Redirect("Login.aspx", true);

            }
            if (!IsPostBack)
            {
                this.BindPendingSpRequests();
            }
        }


        protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pendingRequestGridView.PageIndex = e.NewPageIndex;
            this.BindPendingSpRequests();
        }
        
        private void BindPendingSpRequests()
        {
            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("pbranch_id", string.Empty);
            inputParam.Add("prequest_id", string.Empty);
            inputParam.Add("prequest_status_id", 99);
            inputParam.Add("pregistration_no", string.Empty);
            //inputParam.Add("psanchay_patra_no", string.Empty);
            inputParam.Add("pcustomer_name", string.Empty);
            inputParam.Add("pcustomer_mobile_no", string.Empty);
            DataTable dtab = spManager.GetRspMasterData(inputParam);
            pendingRequestGridView.DataSource = dtab;
            pendingRequestGridView.DataBind();
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
        protected void Show_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('Upload status: The file could not be uploaded. The following error occured')", true);

        }


        [WebMethod]
        public static string GetSpDetails(string prequest_id)
        {
            SpManager spManager = new SpManager();

            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("pbranch_id", string.Empty);
            inputParam.Add("prequest_id", prequest_id);
            inputParam.Add("prequest_status_id", string.Empty);
            inputParam.Add("pregistration_no", string.Empty);
            //inputParam.Add("psanchay_patra_no", string.Empty);
            inputParam.Add("pcustomer_name", string.Empty);
            inputParam.Add("pcustomer_mobile_no", string.Empty);
            DataTable dt = spManager.GetRspMasterData(inputParam);
            return DatatableToJson(dt);
        }
        [WebMethod]
        public static string GetFileInfo(string prequest_id)
        {
            SpManager spManager = new SpManager();

            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("pbranch_id", string.Empty);
            inputParam.Add("prequest_id", prequest_id);
            inputParam.Add("prequest_status_id", string.Empty);
            inputParam.Add("pregistration_no", string.Empty);
            inputParam.Add("psanchay_patra_no", string.Empty);
            inputParam.Add("pcustomer_name", string.Empty);
            inputParam.Add("pcustomer_mobile_no", string.Empty);
            DataTable dt = spManager.GetFileInfo(inputParam);
            return DatatableToJson(dt);
        }
        //[WebMethod]

        //public static string ShowFile(string filePath)
        //{
        //    //string FilePath = Server.MapPath("javascript1-sample.pdf");
        //    string FilePath = filePath;
        //    WebClient User = new WebClient();
        //    Byte[] FileBuffer = User.DownloadData(FilePath);
        //    if (FileBuffer != null)
        //    {
        //        HttpContext.Current.Response.ContentType = "application/pdf";
        //        HttpContext.Current.Response.AddHeader("content-length", FileBuffer.Length.ToString());
        //        HttpContext.Current.Response.BinaryWrite(FileBuffer);
        //    }

        //    return "saved";
        //}


        [WebMethod]
        public static string LockApprovedRequest(string requestId, int status,string paidAmount,string exceptionMessage)
        {
            SpManager spManager = new SpManager();
            string approveUser = HttpContext.Current.Session["USER_ID"].ToString();
            

            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam = ClaimSpRequest(requestId, status, approveUser, paidAmount, exceptionMessage);
            DataTable dt = spManager.ClaimSpRequest(inputParam);
            return DatatableToJson(dt);
        }

        [WebMethod]
        public static string EditRequestByBranch(string requestId, string branchId,string mobileNo, string customerAccNo, string faceValue, string startCupon, string endCupon, string prequest_status_id)
        {
            SpManager spManager = new SpManager();
            string makeBy = HttpContext.Current.Session["USER_ID"].ToString();


            Dictionary<string, object> claimParam = new Dictionary<string, object>();
            claimParam.Add("pbranch_id", branchId);
            claimParam.Add("prequest_id", requestId);
            claimParam.Add("pregistration_No", string.Empty);
            //claimParam.Add("psanchay_Patra_No", string.Empty);
            claimParam.Add("pwalk_In_Customer", string.Empty);
            claimParam.Add("pcustomer_Acc_No", customerAccNo);
            claimParam.Add("pcustomer_Name", string.Empty);
            claimParam.Add("pcustomer_Mobile_No", mobileNo);
            claimParam.Add("pinvestment_Date", string.Empty);
            claimParam.Add("ptotal_Investment", string.Empty);
            //claimParam.Add("pface_Value", faceValue);
            claimParam.Add("pstart_Coupon_No", startCupon);
            claimParam.Add("pend_Coupon_No", endCupon);
            claimParam.Add("ppaid_Amount", string.Empty);
            claimParam.Add("prequest_status_id", prequest_status_id);
            claimParam.Add("pauthorize_status", string.Empty);
            claimParam.Add("pmake_By", makeBy);
            claimParam.Add("pmake_Date", string.Empty);
            claimParam.Add("pauthorize_By", makeBy);
            claimParam.Add("pauthorize_Date", string.Empty);
            claimParam.Add("papproved_by", string.Empty);
            claimParam.Add("papproved_dt", string.Empty);
            claimParam.Add("premarks", string.Empty);

            DataTable dt = spManager.ClaimSpRequest(claimParam);
            return DatatableToJson(dt);
        }

        [WebMethod]
        public static string DeleteFile(string prequestId, int pdocsl_no)
        {
            SpManager spManager = new SpManager();
            string make_by = HttpContext.Current.Session["USER_ID"].ToString();


            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("prequest_id", prequestId);
            inputParam.Add("pmake_by", make_by);
            inputParam.Add("pdocsl_no", pdocsl_no);
            DataTable dt = spManager.DeleteFile(inputParam); 
            return DatatableToJson(dt);
        }
        private static Dictionary<string, object> ClaimSpRequest(string requestId,int status,string approveUser,string paidAmount, string exceptionMessage)
        {
            Dictionary<string, object> claimParam = new Dictionary<string, object>();
            claimParam.Add("pbranch_id", string.Empty);
            claimParam.Add("prequest_id", requestId);
            claimParam.Add("pregistration_No", string.Empty);
            //claimParam.Add("psanchay_Patra_No", string.Empty);
            claimParam.Add("pwalk_In_Customer", string.Empty);
            claimParam.Add("pcustomer_Acc_No", string.Empty);
            claimParam.Add("pcustomer_Name", string.Empty);
            claimParam.Add("pcustomer_Mobile_No", string.Empty);
            claimParam.Add("pinvestment_Date", string.Empty);
            claimParam.Add("ptotal_Investment", string.Empty);
            //claimParam.Add("pface_Value", string.Empty);
            claimParam.Add("pstart_Coupon_No", string.Empty);
            claimParam.Add("pend_Coupon_No", string.Empty);
            claimParam.Add("ppaid_Amount", paidAmount);
            claimParam.Add("prequest_status_id", status);
            claimParam.Add("pauthorize_status", string.Empty);
            claimParam.Add("pmake_By", string.Empty);
            claimParam.Add("pmake_Date", string.Empty);
            claimParam.Add("pauthorize_By", string.Empty); 
            claimParam.Add("pauthorize_Date", string.Empty);
            claimParam.Add("papproved_by", approveUser);
            claimParam.Add("papproved_dt", string.Empty);
            claimParam.Add("premarks", exceptionMessage);



            return claimParam;
        }


        [WebMethod]
        public static string GetSpFacevalue(string prequest_id, string psanchay_patra_no)
        {
            SpManager spManager = new SpManager();

            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("prequest_id", prequest_id);
            inputParam.Add("psanchay_patra_no", psanchay_patra_no);
            DataTable dt = spManager.GetSpFacevalue(inputParam);

            DataTable filteredData = new DataTable();
            filteredData.Columns.Add("SANCHAY_PATRA_NO");
            filteredData.Columns.Add("DENOMINATION");
            foreach (DataRow dr in dt.Rows)
            {

                DataRow row = filteredData.NewRow();
                row["SANCHAY_PATRA_NO"] = dr["SANCHAY_PATRA_NO"];
                row["DENOMINATION"] = dr["DENOMINATION"];
                filteredData.Rows.Add(row);
            }
            return DatatableToJson(filteredData);
        }
    }
}