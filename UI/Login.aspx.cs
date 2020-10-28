using HtmlAgilityPack;
using SanchaypatraApp.Modal;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SanchaypatraApp.UI
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            String strResult;
            String randomKey = Request.QueryString["j_random_key"];

            if (randomKey != null && randomKey != "")
            {

                //String strURl = LoginLink.validationLink + randomKey + "&flag=1";
                String strURl = LoginLink.validationLink + randomKey;
                WebResponse objResponse;
                WebRequest objRequest = HttpWebRequest.Create(strURl);
                objResponse = objRequest.GetResponse();
                using (StreamReader sr = new StreamReader(objResponse.GetResponseStream()))
                {
                    strResult = sr.ReadToEnd();
                    sr.Close();
                }
                HtmlWeb htmlWeb = new HtmlWeb();
                HtmlAgilityPack.HtmlDocument document = htmlWeb.Load(strURl);

                HtmlNode UserIdNode = document.GetElementbyId("UserId");
                HtmlNode UserNameNode = document.GetElementbyId("UserName");
                HtmlNode BranchIdNode = document.GetElementbyId("branchID");
                HtmlNode BranchNameNode = document.GetElementbyId("BranchName");

                Session["USER_ID"] = UserIdNode.InnerText.Trim();
                Session["UserName"] = UserNameNode.InnerText.Trim();
                Session["BranchID"] = BranchIdNode.InnerText.Trim();
                Session["BranchName"] = BranchNameNode.InnerText.Trim();

                

                
            }

            if (Session["BranchID"] != null)
            {
                if (Session["BranchID"].ToString().Equals("0001"))
                {
                    Response.Redirect("SpRequestDetails.aspx", true);
                }
                else
                {
                    Response.Redirect("BranchEntry.aspx", true);
                }
            }
            else
            {
                Response.Redirect(LoginLink.UltimasLogin, true);
            }





        }
    
    }
}