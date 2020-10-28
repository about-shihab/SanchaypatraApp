using BLL;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace SanchaypatraApp.UI
{
    /// <summary>
    /// Summary description for FileUpload
    /// </summary>
    public class FileUpload : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            SpManager spManager = new SpManager();
            string makeby = context.Session["USER_ID"].ToString();
            string requestId = context.Request.Form["requestId"];
            string regNo = context.Request.Form["regNo"];
            string docType = context.Request.Form["docType"];
            string hoFlag = context.Session["BranchID"].ToString().Equals("0001") ? "1" : "0";
            string branchFlag = context.Session["BranchID"].ToString().Equals("0001") ? "0" : "1";
            bool fileAlreadyUploaded = false;
            List<Dictionary<string, object>> fileInfoParamList = new List<Dictionary<string, object>>();

            foreach (string file in context.Request.Files)
            {
                var hpf = context.Request.Files[file] as HttpPostedFile;
                if (hpf.ContentLength == 0)
                    break;

                List<Dictionary<string, object>> previousFileList = new List<Dictionary<string, object>>();

                if (context.Session["NewBranchFileList"] != null)
                {
                    previousFileList = (List<Dictionary<string, object>>)context.Session["NewBranchFileList"];
                    foreach(Dictionary<string,object> previousFile in previousFileList)
                    {
                        if (requestId.Equals(previousFile["prequest_id"].ToString()) && hpf.FileName.ToLower().Equals(previousFile["pfile_nm"].ToString().ToLower()))
                            fileAlreadyUploaded=true;
                    }
                }
                if (fileAlreadyUploaded)
                    break;
                var savedFileName = context.Server.MapPath("~/SPFile/") + DateTime.Now.ToString("ddMMyyyyhhmmss") + Path.GetFileName(hpf.FileName);
                hpf.SaveAs(savedFileName);
                //save file

                
                Dictionary<string, object> fileParam = new Dictionary<string, object>();
                fileParam.Add("pregistration_no", regNo);
                fileParam.Add("prequest_id", requestId);
                fileParam.Add("pdocsl_no", string.Empty);
                fileParam.Add("pdocuments_type_id", docType);
                fileParam.Add("pfile_nm", hpf.FileName.ToString());
                fileParam.Add("pfile_navigate_url", savedFileName);
                fileParam.Add("pfolder_location", savedFileName.Substring(0, savedFileName.LastIndexOf(@"\")));
                fileParam.Add("pho_upload_flag", hoFlag);
                fileParam.Add("pbr_upload_flag", branchFlag);
                fileParam.Add("premarks", string.Empty);
                fileParam.Add("psys_gen_flag", "S");
                fileParam.Add("pauth_status_id", "A");
                fileParam.Add("puser_id", makeby);
                fileInfoParamList.Add(fileParam);

                if (context.Session["NewBranchFileList"] != null)
                {
                    previousFileList = (List<Dictionary<string, object>>)context.Session["NewBranchFileList"];
                    previousFileList.Add(fileParam);
                    context.Session["NewBranchFileList"] = previousFileList;
                }
                else
                {
                    context.Session["NewBranchFileList"] = fileInfoParamList;
                }

            }
            spManager.InsertAdditionalFile(fileInfoParamList, requestId);
            context.Response.ContentType = "text/plain";
            context.Response.Write("Uploaded");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}