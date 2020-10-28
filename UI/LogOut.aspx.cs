using SanchaypatraApp.Modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SanchaypatraApp.UI
{
    public partial class LogOut : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USER_ID"] != null)
            {
                Session.Clear();
                Session.Abandon();
                Session.RemoveAll();

                
            }
            Response.Redirect("Login.aspx", true);
        }
    }
}