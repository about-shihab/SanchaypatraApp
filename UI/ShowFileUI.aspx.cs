using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SanchaypatraApp.UI
{
    public partial class ShowFileUI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string output = Request.QueryString["FilePath"];
            string filepath = HttpUtility.UrlDecode(output);
            iframe1.Attributes["src"] = @"ShowFileContent.aspx?FilePath=" + output.ToString();
        }
    }
}