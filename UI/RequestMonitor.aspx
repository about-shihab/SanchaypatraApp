<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RequestMonitor.aspx.cs" Inherits="SanchaypatraApp.UI.RequestMonitor" %>
<%@ MasterType VirtualPath="~/Site.Master" %>  
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../Content/jQuery.FileUpload/css/jquery.fileupload.css" rel="stylesheet" />
    <link href="../Content/jquery-ui.css" rel="stylesheet" />
    <link href="../Content/SpDetails.css?id=<%= DateTime.Now.ToString() %>" rel="stylesheet" />    
    <script src="../Scripts/jquery-ui.js"></script>
    <script src="../Scripts/BootstrapTagInput.js"></script>
    <script src="../Scripts/SpDetails.js?id=<%= DateTime.Now.ToString() %>"></script>
    <script src="../Scripts/jQuery.FileUpload/jquery.iframe-transport.js"></script>
    <script src="../Scripts/jQuery.FileUpload/jquery.fileupload.js"></script>

    <script type="text/javascript">
        var seessionBranchId = '' +<%="1" + Session["BranchId"].ToString() %>;
        seessionBranchId = seessionBranchId.substring(1);
        var docType = '';
        if (seessionBranchId != '0001') {
            $(document).ready(function () {
                $("#mobileTextBox").attr("readonly", false);
                $("#mobileTextBox").css({ 'background-color': 'white' });
                 
            });
        }

        var status = '7';
        
           
        $(document).ready(function () {
            $('#navbarColor01 li').removeClass('active');
            $("#RequestMonitor").addClass('active');
            $('#<%=documentsTypeDropDown.ClientID%>').on('change', function (e) {
                // triggers when whole value changed
                docType = $(this).val();
                if (docType == 0) {
                    $("#fileupload").attr("disabled", "disabled");
                    document.getElementById("fileupload").disabled = true;
                }
            });
        });

        
    </script>
    <form id="form1" runat="server">
        <div class="row" style="margin-top: 10px">
            <div class="card shadow" style="width: 100%">
                <div class="card-header" style="                        font-weight: 600;
                        background-color: #621e73;
                        text-align: center;
                        color: white">
                    Search Request
                </div>
                <div class="card-body" id="" style="width: 100%">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-inline row" style="margin-bottom: 10px;">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Branch</label>
                                </div>

                                <div class="col-md-8">
                                    <asp:DropDownListChosen ID="branchDropDownListChosen" runat="server" CssClass="form-control  mb-2 mr-sm-2"
                                        Width="270px">
                                    </asp:DropDownListChosen>
                                </div>
                            </div>
                            <div class="form-inline row">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Request Id</label>
                                </div>
                                <div class="col-md-8 form-group">

                                    <asp:TextBox ID="requestIdField" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>

                                </div>

                            </div>
                            <div class="form-inline row">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Customer Name</label>
                                </div>
                                <div class="col-md-8 form-group">
                                    <asp:TextBox ID="custNameField" CssClass="form-control  mb-2  textboxHeight" runat="server"></asp:TextBox>

                                </div>
                            </div>

                            <div class="form-inline row">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Mobile No</label>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="mobileField" CssClass="form-control  mb-2 mr-sm-2 textboxHeight ignore" runat="server"></asp:TextBox>
                                </div>

                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-inline row">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Reg No.</label>
                                </div>
                                <div class="col-md-8 form-group">
                                    <asp:TextBox ID="regNoField" CssClass="form-control  mb-2 mr-sm-2 textboxHeight reg-no" runat="server"></asp:TextBox>
                                </div>

                            </div>
                       <%--     <div class="form-inline row">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Sanchaypatra No</label>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="spNoField" data-role="tagsinput" CssClass="form-control tagsinput  mb-2 mr-sm-2 textboxHeight ignore" runat="server"></asp:TextBox>
                                </div>

                            </div>--%>


                            
                        </div>
                    </div>
                    <div class="row" style="justify-content:center">
                        <div style="width: 55%">

                        <asp:RadioButtonList runat="server" ID="statusRadioButtonList" RepeatDirection="Horizontal" CssClass="table table-bordered table-striped statusTable shadow">
                            <asp:ListItem Value="1" Text="Request for Payment" Selected="True" />
                            <asp:ListItem Value="6" Text="Under Process" />
                            <asp:ListItem Value="7" Text="Encashment Done" />
                            <asp:ListItem Value="3" Text="Exception" />
                        </asp:RadioButtonList>
                    </div>
                    </div>
                    <div class="row" style="margin-top: 20px; justify-content: center">
                            <%--<asp:Button runat="server" UseSubmitBehavior="true" CausesValidation="false"
                                CssClass="btn btn-warning" ID="UploadButton" OnClick="SearchButton_Click" Text="Search" />--%>

                        <button  runat="server" onserverclick="SearchButton_Click" id="searchButton" class="btn btn-warning">
                            <i class="fas fa-search"></i>
                            Search
                        </button>
                        </div>
                </div>
        </div>
            
            </div>
        <div class="row">
            <div class="card shadow" style="width: 100%">
                <div class="card-header" style="font-weight: 400; background-color: #621e73; text-align: center; color: white; padding: 2px">
                    Search Details
                </div>
                <div class="card-body" style="width: 100%">
                    <asp:GridView ID="pendingRequestGridView" runat="server"
                        AutoGenerateColumns="false"
                        EmptyDataText="No Requests Found"
                        HorizontalAlign="Center"
                        AllowPaging="True"
                        PageSize="10"
                        OnPageIndexChanging="OnPageIndexChanging"
                        >
                        <RowStyle Font-Size="Smaller" HorizontalAlign="Center" />
                        <HeaderStyle BackColor="#bb6805" ForeColor="White" Font-Size="Smaller" HorizontalAlign="Center" />
                        
                        <Columns>
                            <asp:TemplateField HeaderText="SL No" HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="table_04" HorizontalAlign="Left"></HeaderStyle>
                                <ItemStyle CssClass="table_02" HorizontalAlign="Left"></ItemStyle>
                            </asp:TemplateField>
                            <asp:BoundField DataField="BRANCH_ID" HeaderText="Branch Id" />
                            <asp:BoundField  DataField="REQUEST_ID" HeaderText="Request Id" />
                          
                            <asp:BoundField DataField="CUSTOMER_NAME" ItemStyle-HorizontalAlign="left" HeaderText="Customer Name" />
                            <asp:BoundField DataField="REGISTRATION_NO" HeaderText="Reg. No." />
                            <asp:TemplateField HeaderText="Investment Date">
                                <ItemTemplate>
                                    <%#Eval("INVESTMENT_DATE","{0:dd/MMM/yyyy}")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="TOTAL_INVESTMENT" HeaderText="Total Investment" />
                            <asp:BoundField DataField="REQUEST_STATUS_NM" HeaderText="Status" />
                            <asp:BoundField DataField="MAKE_BY" HeaderText="Make By" />
                            
                            <asp:TemplateField HeaderText="Make Date">
                                <ItemTemplate>
                                    <%#Eval("MAKE_DATE","{0:dd/MMM/yyyy}")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                   
                                    <button  style="background-color:#bb6805;color:white" type="button" class="btn btn-warning btn-sm detailsBtn">Details</button>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="modal " id="myModal" data-keyboard="false" data-backdrop="static">
            <%--loader--%>
            <div class="modal" data-backdrop="static" id="loadMe" tabindex="-1" role="dialog" aria-labelledby="loadMeLabel">
                <div class="modal-dialog modal-sm" role="document">
                    <div class="modal-content">
                        <div class="modal-body text-center">
                            <div class="loader"></div>
                            <div class="loader-txt">
                                <p>Fetching Data</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--loader--%>
            <div class="modal-dialog modal-lg" style="min-width: 95%; min-height: 90%">
                <div class="modal-content " style="min-width: 100%; min-height: 100%">
                    <div class="card-header myheader" style="font-weight: 600; background-color: #621e73; text-align: center; color: white; padding: 5px">
                        <div class="row" style="margin-left: 145px">
                            <div class="col-md-10" style="text-align: center">
                                <h6>Sanchaypatra Details
                                </h6>
                            </div>
                            <div class="col-md-2">

                                <button type="button" class="close btn-danger closeButton" style="font-size: 30px; color: white" data-dismiss="modal" aria-hidden="true">×</button>
                            </div>
                        </div>
                    </div>
                    <div class="container" style="min-width: 100%; min-height: 100%"></div>
                    <div class="modal-body " style="min-width: 90%; min-height: 100%">
                        <div class="row" style="margin-top: 10px">
                            <div class="card " style="width: 100%">

                                <div class="card-body row" id="inputField" style="width: 100%">
                                    <div class="col-md-6">
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Branch</label>
                                            </div>

                                            <div class="col-md-8">
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="branchTextBox">
                                            </div>
                                        </div>
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Walking Customer</label>
                                            </div>
                                            <div class="col-md-8">
                                                <%--<asp:CheckBox ID="walkingCheckBox" onclick="return false; CssClass="form-check-input ignore" runat="server" />--%>
                                                <input type="checkbox" class="form-check-input" onclick="return false; " id="walkingCheckBox">
                                            </div>

                                        </div>
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Account No.</label>
                                            </div>
                                            <div class="col-md-8 form-group">

                                                <%--<asp:TextBox ID="accNoTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" readonly runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="accNoTextBox">
                                            </div>

                                        </div>
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Customer Name</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <%--<asp:TextBox ID="custNameTextBox" CssClass="form-control  mb-2  textboxHeight" readonly runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="custNameTextBox">
                                            </div>
                                        </div>

                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Mobile No</label>
                                            </div>
                                            <div class="col-md-8">
                                                <%--<asp:TextBox ID="mobileTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight ignore" runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="mobileTextBox">
                                            </div>

                                        </div>
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Start Cupon No</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <%--<asp:TextBox ID="startCuponTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" readonly runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="startCuponTextBox">
                                            </div>

                                        </div>
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">End Cupon No</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <%--<asp:TextBox ID="endCuponTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" readonly runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="endCuponTextBox">
                                            </div>

                                        </div>

                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Total Cupon</label>
                                            </div>
                                            <div class="col-md-8">
                                                <%--<asp:TextBox ID="cuponNoTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" readonly runat="server"></asp:TextBox>--%>
                                                <input type="number" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="cuponNoTextBox">
                                            </div>

                                        </div>

                                        
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Reg No.</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <%--<asp:TextBox ID="regNoTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight reg-no" runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="regNoTextBox">
                                            </div>

                                        </div>

                                        <%--<div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Sanchaypatra No</label>
                                            </div>
                                            <div class="col-md-8">
                                                <input type="text" data-role="tagsinput" class="form-control tagsinput mb-2 mr-sm-2 textboxHeight" readonly id="spNoTextBox">
                                            </div>

                                        </div>
                                        

                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Face Value</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <input type="number" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="faceValueTextBox">
                                            </div>

                                        </div>--%>

                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Investment Date</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <%--<asp:TextBox ID="investDate" autocomplete="off" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" readonly runat="server"></asp:TextBox>--%>
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="investDate">
                                            </div>

                                        </div>
                                    <div class="form-inline row" style="display:none">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Total Investment</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <input type="text" class="form-control mb-2 mr-sm-2 textboxHeight" readonly id="investmentTextBox">
                                            </div>

                                        </div>

                                        <div class="form-inline row">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">SanchayPatra List</label>
                                            </div>
                                            <div class="col-md-8 form-group" id="spFaceValueTable" style="justify-content: center; width: 55%;">
                                                <div class="card shadow" style="justify-content: center; min-width: 100%; min-height: 100px; border: 1px dashed black">
                                                    <%--<h6 style="margin-left: 6vw">SanchayPatra List</h6>--%>
                                                    <button style="padding:4px;min-height: 100px;" type="button" class="btn btn-outline-primary refreshBtn">
                                                    Click Here to <br />
                                                    <i class="fas fa-sync-alt"></i> 
                                                    Load Sanchaypatra List

                                                </button>

                                                </div>
                                            </div>
                                        </div>
                                        <%--<div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Paid Amount</label>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="paidAmountTextBox" type="number" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" readonly runat="server"></asp:TextBox>
                            </div>

                        </div>--%>
                                    </div>
                                    
                                </div>
                            </div>
                            
                            <div class="card " style="width: 100%">
                                <div class="card-header" style="margin-bottom: 15px;font-weight: 400; background-color: #621e73; text-align: center; color: white; padding: 2px">
                                    Input Documents
                                    <a class ="heading-example" data-toggle="collapse" style="text-decoration:none;color:white;float:right;margin-right:10px;" href="#collapse-example" aria-expanded="false" aria-controls="collapse-example">
                                        <i class="fa fa-chevron-down"></i>
                                    </a>
                                </div>
                                <div id="collapse-example" class="collapse" aria-labelledby="heading-example">
                                    <div class="card-body" style="width: 100%">

                                        <div class="row" id="inputDocUpload" style="display:none">
                                            <div class="col-md-5">
                                                <div class="form-inline row">
                                                    <div class="col-md-4 myLabel">
                                                        <label style="display: block">Documents Type</label>
                                                    </div>

                                                    <div class="col-md-8">
                                                        <asp:DropDownListChosen ID="documentsTypeDropDown" runat="server" CssClass="form-control  mb-2 mr-sm-2 dcType"
                                                            Width="270px"
                                                            DataPlaceHolder="Select a Document Type">
                                                        </asp:DropDownListChosen>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-7">
                                                <div class="row">
                                                    <div class="col-md-8">
                                                        <div class="row form-inline">
                                                                <span class="btn btn-outline-secondary btn-sm fileinput-button">
                                                                    <span>Browse</span>
                                                                    <input id="fileupload" type="file" name="file[]"  accept=".jpg,.jpeg,.pdf" class="form-control-file" />
                                                                </span>
                                                            
                                                            <input type="text" style="border:none;background-color:white" value="No file choosen" id="txtFileName" name="fname" class="form-control" disabled="" />
                                                               <%--<h6 id="txtFileName">No file choosen</h6>--%>
                                                            </div>
                                                        
                                                    </div>
                                                    <div class="col-md-4">

                                                        <span id="btnUpload" class="btn btn-warning fileinput-button">
                                                            <i class="fas fa-upload"></i>
                                                            <span>upload</span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>


                                           <%-- <div class="form-group">
                                                
                                            </div>
                                            <div class="form-group">
                                                <div class="col-sm-8">
                                                    <div id="progress" class="progress">
                                                        <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col-sm-8">
                                                   
                                                </div>
                                            </div>--%>
                                        </div>
                                        <div class="row" id="fileInfoDiv" style="margin-top: 5px">
                                        </div>


                                    </div>
                                </div>
                            </div>
                            <%--<div class="card " style="width: 100%">
                                <div class="card-header" style="margin-bottom: 15px;font-weight: 400; background-color: #621e73; text-align: center; color: white; padding: 2px">
                                    Output Documents
                                    <a class ="heading-example" data-toggle="collapse" style="text-decoration:none;color:white;float:right;margin-right:10px;" href="#outputDoc" aria-expanded="false" aria-controls="outputDoc">
                                        <i class="fa fa-chevron-down"></i>
                                    </a>
                                </div>
                                <div id="outputDoc" class="collapse" aria-labelledby="heading-example">
                                    <div class="card-body" style="width: 100%">

                                        <div class="row" id="outputFileUpload" style="display:none">
                                            <div class="col-md-5">
                                                <div class="form-inline row">
                                                    <div class="col-md-4 myLabel">
                                                        <label style="display: block">Documents Type</label>
                                                    </div>

                                                    <div class="col-md-8">
                                                        <asp:DropDownListChosen ID="DropDownListChosen1" runat="server" CssClass="form-control  mb-2 mr-sm-2 dcType"
                                                            Width="270px"
                                                            DataPlaceHolder="Select a Document Type">
                                                        </asp:DropDownListChosen>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-7">
                                                <div class="row">
                                                    <div class="col-md-8">
                                                        <div class="row form-inline">
                                                                <span class="btn btn-outline-secondary btn-sm fileinput-button">
                                                                    <span>Browse</span>
                                                                    <input id="fileupload1" disabled type="file" name="file[]"  accept=".jpg,.jpeg,.pdf" class="form-control-file" />
                                                                </span>
                                                            
                                                            <input type="text" style="border:none;background-color:white" value="No file choosen" id="txtFileName1" name="fname" class="form-control" disabled="" />
                                                            </div>
                                                        
                                                    </div>
                                                    <div class="col-md-4">

                                                        <span id="btnUpload1" class="btn btn-warning fileinput-button">
                                                            <i class="fas fa-upload"></i>
                                                            <span>upload</span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" id="outputFileDiv" style="margin-top: 5px">
                                        </div>


                                    </div>
                                </div>
                            </div>--%>

                            <div class="card " style="width: 100%">
                                <div class="card-header" style="margin-bottom: 15px;font-weight: 400; background-color: #621e73; text-align: center; color: white; padding: 2px">
                                    Exception Messages
                                    <a class ="heading-example" data-toggle="collapse" style="text-decoration:none;color:white;float:right;margin-right:10px;" href="#exceptionDiv" aria-expanded="false" aria-controls="exceptionDiv">
                                        <i class="fa fa-chevron-down"></i>
                                    </a>
                                </div>
                                <div id="exceptionDiv" class="collapse" aria-labelledby="heading-example">
                                    <div class="card-body" style="justify-content:center;width: 100%">


                                       <div class="form-inline">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Exception Messages</label>
                                            </div>
                                            <div class="col-md-8 form-group">
                                                <textarea style="font-size: 12px; color: red;" class="form-control" id="exceptionMessageTextbox" readonly rows="3"></textarea>
                                            </div>

                                        </div>


                                    </div>
                                </div>
                            </div>


                            <div class="card " style="width: 100%">
                                <div class="card-header" style="font-weight: 400; background-color: #621e73; text-align: center; color: white; padding: 2px">
                                    Other Details
                                </div>
                                <div class="card-body row" style="width: 100%">

                                    <div class="col-md-2"></div>
                                    <div class="col-md-8">
                                        <div class="form-inline">
                                            <div class="col-md-4 myLabel">
                                                <label style="display: block">Paid Amount</label>
                                            </div>
                                            <div class="col-md-8 form-group">

                                                <input type="number" class="form-control mb-2 mr-sm-2 textboxHeight" id="paidAmountTextbox">
                                            </div>

                                        </div>
                                    </div>
                                    <div class="col-md-2"></div>


                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer" id="modalFooter" style="justify-content: center">
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
