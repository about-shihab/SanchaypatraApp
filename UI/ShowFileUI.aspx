<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="ShowFileUI.aspx.cs" Inherits="SanchaypatraApp.UI.ShowFileUI" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />

    <!-- scale the devices -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="google" content="notranslate"/>

    <!-- include bootstrap css files -->
    <link href="../Content/bootstrap.css" rel="stylesheet" />

    <!-- include jquery and bootstrap script -->    
    <script src="../Scripts/jquery-3.0.0.js"></script>
    <script src="../Scripts/bootstrap.js"></script>

    <script type="text/javascript">
        function closeWindow() {
            self.close();
            return false;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <br />
        <div class="col-lg-2">
            <asp:LinkButton ID="lnkBack" runat="server" Text="<<<<   Back" OnClientClick="return closeWindow();" CssClass="btn btn-success btn-block"></asp:LinkButton>
        </div>        
        <br />
        <br />
        <div class='embed-container'> 
            <iframe id="iframe1" runat="server" style="height:580px;width:1200px;"></iframe> 
        </div>      
    </div>
    </form>
</body>
</html>

