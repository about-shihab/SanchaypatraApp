using BLL;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SanchaypatraApp.UI
{
    public partial class RequestMonitor : System.Web.UI.Page
    {
        SpManager spManager = new SpManager();

        protected void Page_Load(object sender, EventArgs e)
        {

            //Session["BranchId"] = "0002";
            if (Session["USER_ID"] == null)
            {
                
                Response.Redirect("Login.aspx", true);

            }

            Session.Remove("NewBranchFileList");
            if (!IsPostBack)
            {
                this.BindBranchDropdown();
                this.BindDocumentsTypeDropdown();
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
                             .Where(r => r.Field<string>("BRANCH_ID") == Session["BranchID"].ToString())
                             .CopyToDataTable();
                }

            }
            branchDropDownListChosen.DataSource = dtab;
            branchDropDownListChosen.DataTextField = "BRANCH_NM";
            branchDropDownListChosen.DataValueField = "BRANCH_ID";
            branchDropDownListChosen.DataBind();
            if (Session["BranchId"] != null)
            {
                if(!Session["BranchId"].ToString().Equals("0001"))
                   branchDropDownListChosen.SelectedValue = Session["BranchId"].ToString();
            }
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            //string brancId = string.Empty;
            //if (!Session["BranchID"].ToString().Equals("0001"))
            //{
            //    brancId = Session["BranchID"].ToString();
            //}
            this.BindGrid();
        }
        protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pendingRequestGridView.PageIndex = e.NewPageIndex;
            this.BindGrid();
        }
       

        private void BindDocumentsTypeDropdown()
        {

            DataTable dtab = spManager.GetAllDocumentType();
            documentsTypeDropDown.DataSource = dtab;
            documentsTypeDropDown.DataTextField = "DOCUMENTS_TYPE_NM";
            documentsTypeDropDown.DataValueField = "DOCUMENTS_TYPE_ID";

            documentsTypeDropDown.DataBind();
        }
        private void BindGrid()
        {
            string status = statusRadioButtonList.SelectedValue;
            Dictionary<string, object> inputParam = new Dictionary<string, object>();
            inputParam.Add("pbranch_id", branchDropDownListChosen.SelectedValue.ToString());
            inputParam.Add("prequest_id", requestIdField.Text.Trim().ToString());
            inputParam.Add("prequest_status_id", status);
            inputParam.Add("pregistration_no", regNoField.Text.Trim().ToString());
            //inputParam.Add("psanchay_patra_no", spNoField.Text.ToString());
            inputParam.Add("pcustomer_name", custNameField.Text.Trim().ToString());
            inputParam.Add("pcustomer_mobile_no", mobileField.Text.Trim().ToString());
            DataTable dtab = spManager.GetRspMasterData(inputParam);
            pendingRequestGridView.DataSource = dtab;
            pendingRequestGridView.DataBind();
        }


        //[WebMethod]

        //public static string UploadFile(string file)
        //{
        //    string filename = Path.GetFileName(HttpContext.Current.FileUploadControl.FileName);
        //    string filePath = HttpContext.Current.Server.MapPath("~/SPFile/") + DateTime.Now.ToString("ddMMyyyyhhmmss") + filename;

        //    System.IO.File.WriteAllBytes(string.Format("{0}{1}", filePath, filename), System.IO.File.ReadAllBytes(filePath));

        //    return "";
        //}
    }
}