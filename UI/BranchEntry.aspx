<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BranchEntry.aspx.cs" Inherits="SanchaypatraApp.UI.BranchEntry" %>
<%@ MasterType VirtualPath="~/Site.Master" %>  
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../Content/jquery-ui.css" rel="stylesheet" />
    <script src="../Scripts/jquery-ui.js"></script>
    <script src="../Scripts/BootstrapTagInput.js"></script>
    <style type="text/css">
        .textboxHeight {
            height: 25px;
            color: black;
            font-size: 12px;
            font-weight: 500;
        }

        .modal {
            overflow-y: scroll;
        }

        .modal-open {
            overflow-y: scroll;
        }

        .form-inline .form-control {
            width: 80%;
        }

        .myLabel {
            text-align: right;
            font-size: 13px;
            font-weight: 500;
        }

        label {
            display: block;
        }

        .loader {
            position: relative;
            text-align: center;
            margin: 15px auto 35px auto;
            z-index: 9999;
            display: block;
            width: 80px;
            height: 80px;
            border: 10px solid rgba(0, 0, 0, .3);
            border-radius: 50%;
            border-top-color: #000;
            animation: spin 1s ease-in-out infinite;
            -webkit-animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to {
                -webkit-transform: rotate(720deg);
            }
        }

        @-webkit-keyframes spin {
            to {
                -webkit-transform: rotate(720deg);
            }
        }

        .bootstrap-tagsinput {
            background-color: #fff;
            border: 1px solid #ccc;
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
            display: inline-block;
            padding: 4px 6px;
            color: #555;
            vertical-align: middle;
            border-radius: 4px;
            max-width: 100%;
            line-height: 22px;
            cursor: text;
            line-height: 33px;
            width: 80%;
        }

            .bootstrap-tagsinput input {
                border: none;
                box-shadow: none;
                outline: none;
                background-color: transparent;
                padding: 0 6px;
                margin: 0;
                width: auto;
                max-width: inherit;
            }

            .bootstrap-tagsinput.form-control input::-moz-placeholder {
                color: #777;
                opacity: 1;
            }

            .bootstrap-tagsinput.form-control input:-ms-input-placeholder {
                color: #777;
            }

            .bootstrap-tagsinput.form-control input::-webkit-input-placeholder {
                color: #777;
            }

            .bootstrap-tagsinput input:focus {
                border: none;
                box-shadow: none;
            }

            .bootstrap-tagsinput .tag {
                color: white;
                padding: 3px;
                background-color: darkblue;
                border-radius: 7px;
                font-weight: 500;
                font-size: 11px;
                margin: 2px;
            }

                .bootstrap-tagsinput .tag [data-role="remove"] {
                    margin-left: 8px;
                    cursor: pointer;
                }

                    .bootstrap-tagsinput .tag [data-role="remove"]:after {
                        content: "";
                        padding: 0px 0px;
                    }

                    .bootstrap-tagsinput .tag [data-role="remove"]:hover {
                        box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
                    }

                        .bootstrap-tagsinput .tag [data-role="remove"]:hover:active {
                            box-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
                        }

        .required {
            color: #e31937;
            font-family: Verdana;
            margin: 0 5px;
        }

        .field-validation-error {
            color: #e31937;
        }

        .validaion-error {
            color: red;
            visibility: visible;
            font-size: 9px;
            margin-top: -9px;
            margin-bottom: 9px;
        }
    </style>
    <script type="text/javascript">
       

        function Success(messeage) {
            swal.fire({
                icon: 'success',
                title: messeage

            })
        }
        function Error(messeage) {
            swal.fire({
                icon: 'error',
                title: messeage

            })
        }
        function SuccessSendToHo(messeage) {
            swal.fire({
                icon: 'error',
                title: messeage

            });
            Swal.fire({
                title: messeage,
                icon: 'success',
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok'
            }).then((result) => {
                if (result.isConfirmed) {
                    document.location.href = '../UI/BranchEntry.aspx'

                }
            });

        }
        $(document).ready(function () {
            $('loading-container').hide();
            $('#navbarColor01 li').removeClass('active');
            $("#BranchEntry").addClass('active');

            $("#<%=investDate.ClientID %>").datepicker({
                dateFormat: 'dd/mm/yy',
                beforeShow: function (input, inst) {
                    if ($(input).attr('readonly') !== undefined) {
                        if (inst.o_dpDiv === undefined)
                            inst.o_dpDiv = inst.dpDiv;
                            inst.dpDiv = $('<div style="display: none;"></div>');
                    } else {
                        if (inst.o_dpDiv !== undefined) {
                            inst.dpDiv = inst.o_dpDiv;
                        }
                    }
                }
            });

            var documentType = $("#<%=documentsTypeDropDown.ClientID%>").val();
            if (documentType == '') {
                document.getElementById("<%=FileUploadControl.ClientID %>").disabled = 'disabled';
            };
            $("#<%=documentsTypeDropDown.ClientID%>").change(function (event) {

                documentType = event.target.value;
                if (documentType == '') {
                    document.getElementById("<%=FileUploadControl.ClientID %>").disabled = 'disabled';
                } else {
                    document.getElementById("<%=FileUploadControl.ClientID %>").disabled = '';
                }

            });

            $('input[name="input"]').tagsinput({
                trimValue: true,
                confirmKeys: [13, 188],
                focusClass: 'my-focus-class'
            });

            $('.bootstrap-tagsinput input').on('focus', function () {
               
                $(this).closest('.bootstrap-tagsinput').addClass('has-focus');
            }).on('blur', function () {
                $(this).closest('.bootstrap-tagsinput').removeClass('has-focus');
            });
            $('.bootstrap-tagsinput input').on('keypress', function (e) {
                if (e.keyCode == 13) {
                    e.keyCode = 188;
                    e.preventDefault();
                };
            });

            $("#<%=startCuponTextBox.ClientID %>, #<%=endCuponTextBox.ClientID %>").on('keydown blur', function (e) {

                // was it the Enter key?
                if (e.which == 13) {
                    e.preventDefault();
                    $(this).blur();
                }

                if (e.type == 'blur') {
                    let regNo = $("#<%=regNoTextBox.ClientID %>").val();
                    let investDate = convertToDate($("#<%=investDate.ClientID %>").val());

                    let currentDate = convertToDate(GetCurrentDate());
                    let monthDifference = monthDiff(investDate, currentDate);
                    let sanchapatraTyp = $("#spType").val();
                   

                    
                    let startCupon = $("#<%=startCuponTextBox.ClientID %>").val();
                    let endCupon = $("#<%=endCuponTextBox.ClientID %>").val();
                    if (sanchapatraTyp.toLowerCase() === '3ms' || sanchapatraTyp.toLowerCase() === 'psc') {
                        monthDifference /= 3;
                        
                    }


                    if (startCupon > monthDifference && sanchapatraTyp.toLowerCase() != 'bsp') {
                        Error('Invalid Start Cupon');
                        $("#<%=startCuponTextBox.ClientID %>").val('');
                        startCupon = $("#<%=startCuponTextBox.ClientID %>").val();
                    }
                    if (endCupon > monthDifference && sanchapatraTyp.toLowerCase() != 'bsp') {
                        Error('Invalid End Cupon');
                        $("#<%=endCuponTextBox.ClientID %>").val('');
                        startCupon = $("#<%=endCuponTextBox.ClientID %>").val();
                    }
                    if (startCupon.length > 0 && endCupon.length > 0) {
                        let cuponNo = endCupon - startCupon + 1;
                        if (cuponNo>0) {
                            $("#<%=cuponNoTextBox.ClientID %>").val(cuponNo).attr("readonly", true);
                            //$(':input[readonly]').css({ 'background-color': 'beige' });
                        }
                        else {
                            $("#<%=cuponNoTextBox.ClientID %>").val('').attr("readonly", true);
                            Error('End Cupon Should be greater than start cupon');


                        }
                        
                    } else {
                        $("#<%=cuponNoTextBox.ClientID %>").val('').attr("readonly", true);
                    } 

                }

            });
            //to keep value of spfacevalue table after refresh
            if ($("#<%=regNoTextBox.ClientID %>").val().length > 0) {
                let regNo = $("#<%=regNoTextBox.ClientID %>").val();
                LoadSpFaceValue(regNo);

            }
            //regn text box enter
            $("#<%=regNoTextBox.ClientID %>").on('keydown blur', function (e) {

                // was it the Enter key?
                if (e.which == 13) {
                    $(this).blur();
                }

                if (e.type == 'blur') {
                    var regNo = $(this).val();
                    if (regNo.length > 0) {
                        ResetInputField();
                        LoadAllSpDetails(regNo);
                        
                        

                    }else {
                        //alert('hey');
                        ResetInputField();
                    }
                }

            });

            
        });

        
        function LoadAllSpDetails(regNo) {

            var url = "../UI/BranchEntry.aspx/GetAllSpDetails";
            var parameter = {
                pregistration_no: regNo

            };
            AjaxPostRequest(url, parameter, function (response) {
                var jsonData = JSON.parse(response.d);
                if (jsonData.length > 0) {
                    //LoadSpFaceValue(regNo);
                    $('.refreshBtn').click(function (e) {
                        if (regNo.length > 0) {
                            LoadSpFaceValue(regNo);

                        }
                        else {
                            Error('Enter Registration No. first');

                        }

                    });
                    BindInputField(jsonData);

                } else {
                    Error('Invalid Registration No.');
                }
                
                
            });
        };

        function BindInputField(jsonData) {

            if (jsonData.length != 0) {
                for (i = 0; i < jsonData.length; i++) {
                    console.log(jsonData[i].CUSTOMER_NAME);

                    if (jsonData[i].BRANCH_NAME != null) {
                        $("#<%=branchDropDownListChosen.ClientID %>").val(jsonData[i].BRANCH_NAME).change();
                        $("#<%=branchDropDownListChosen.ClientID %>").trigger("chosen:updated");
                        //$("#<%=branchDropDownListChosen.ClientID %>").prop('disabled', true).trigger('chosen:updated').prop('disabled', false);
                    }

                    if (jsonData[i].ACCOUNT_NUMBER != null) {
                        $("#<%=accNoTextBox.ClientID %>").val(jsonData[i].ACCOUNT_NUMBER).attr("readonly", true);
                        $("#<%=walkingCheckBox.ClientID %>").attr("disabled", true);

                    }

                    if (jsonData[i].CUSTOMER_NAME != null)
                        $("#<%=custNameTextBox.ClientID %>").val(jsonData[i].CUSTOMER_NAME).attr("readonly", true);
                    if (jsonData[i].MOBILE_NUMBER != null && jsonData[i].MOBILE_NUMBER !="N/A")
                        $("#<%=mobileTextBox.ClientID %>").val(jsonData[i].MOBILE_NUMBER).attr("readonly", true);
                    if (jsonData[i].INVESTMENT_DATE != null) {
                        $("#<%=investDate.ClientID %>").val(jsonData[i].INVESTMENT_DATE);
                        var currentlyReadonly = $('#<%=investDate.ClientID %>').attr('readonly') !== undefined;

                        currentlyReadonly ? $("#<%=investDate.ClientID %>").removeAttr('readonly') : $("#<%=investDate.ClientID %>").attr('readonly', 'readonly');
                        currentlyReadonly = !currentlyReadonly;
                        $('div#current').html(currentlyReadonly.toString());
                    }
                    if (jsonData[i].TOTAL_AMOUNT != null)
                        $("#<%=investmentTextBox.ClientID %>").val(jsonData[i].TOTAL_AMOUNT).attr("readonly", true);
                    if (jsonData[i].SANCHAYPATRA_TYPE != null) {
                        $("#spType").val(jsonData[i].SANCHAYPATRA_TYPE);

                        let sanchapatraTyp = jsonData[i].SANCHAYPATRA_TYPE;
                        if (sanchapatraTyp.toLowerCase() == 'bsp') {

                            ValidatorEnable(document.getElementById("<%=RequiredFieldValidator7.ClientID %>"), false);
                            ValidatorEnable(document.getElementById("<%=RequiredFieldValidator8.ClientID %>"), false);
                            $("#<%=startCuponTextBox.ClientID %>").attr("readonly", true);
                            $("#<%=endCuponTextBox.ClientID %>").attr("readonly", true);
                            $("#<%=cuponNoTextBox.ClientID %>").attr("readonly", true);
                        }
                    }
                    
                    $(':input[readonly]').css({ 'background-color': 'beige' });

                }
            } else {
                swal.fire({
                    icon: 'warning',
                    title: 'Enter valid Registration No.'

                })

            }
            
        }

        function LoadSpFaceValue(regNo) {

            var url = "../UI/BranchEntry.aspx/GetSpFacevalue";
            var parameter = {
                pregistration_no: regNo,
                pinstrument_number: ''

            };
            AjaxPostRequest(url, parameter, function (response) {
                var jsonData = JSON.parse(response.d);
                console.log(jsonData);
                BindSpFaceValue(jsonData);

            });
        };

        function BindSpFaceValue(jsonData) {
            let tableHtml = '<table class="table table-bordered table-striped table-hover shadow" style="margin: 0 auto;width:auto;font-size:11px">' +
                '<thead style = "background-color:#BB6805;color:white;padding:5px;" ><tr>' +
                '<th>SL</th>' +
                '<th style="width:43%">Sanchaypatra No</th>' +
                '<th>Face value</th>' +
                '</tr></thead ><tbody>';
            for (var i = 0; i < jsonData.length; i++) {
                tableHtml += '<tr>';
                tableHtml += '<td>' + (i + 1) + '</td>';
                tableHtml += '<td>' + jsonData[i].INSTRUMENT_NUMBER + '</td>';
                tableHtml += '<td style="padding: 5px;"><input style="text-align:right;width:100%" type="text" class="form-control mb-2 mr-sm-2 textboxHeight facevalue" readonly value="' + jsonData[i].DENOMINATION + '"></td>';

                tableHtml += '</tr>';

            }
            tableHtml += '<tr style="background-color: steelblue; color: white;">';
            tableHtml += '<td></td>';
            tableHtml += '<td><strong>' + 'Total Investment' + '<strong></td>';
            tableHtml += '<td style="text-align:right;"><strong>' + $("#<%= investmentTextBox.ClientID%>").val()+ '<strong></td>';

            tableHtml += '</tr>';

            tableHtml += ' </tbody></table >';
            if (jsonData.length > 0) {

                $('#spFaceValueTable').empty();
                $('#spFaceValueTable').append(tableHtml);
            }
            else {
                $('#spFaceValueTable').empty();

            }
        }

        function AjaxPostRequest(url, parameters, successCallback) {
            //show loading... image

            $.ajax({
                type: 'POST',
                url: url,
                data: JSON.stringify(parameters),
                contentType: 'application/json;',
                dataType: 'json',
                beforeSend: function () {
                    //$("#loadMe").show();
                    //$('.modal-backdrop').show();

                    //$("#loadMe").modal({
                    //    backdrop: "static", //remove ability to close modal with click
                    //    keyboard: false, //remove option to close with keyboard
                    //    show: true, //Display loader!
                    //    setTimeout:3000
                    //});

                    },
                complete: function () {
                    //$("#loadMe").hide();
                    //$('.modal-backdrop').hide();
                    ////$('body').removeClass('modal-open');
                    ////$('.modal-backdrop').remove();
                },
                success: successCallback,
                error: function (err) {
                    alert("Failed to Load Data");
                    //console.log(err);
                }
            });
        };

        function ResetInputField() {
            let spFaceDiv = '<div class="card shadow"style="justify-content: center;min-width:100% ;min-height:100px;border:1px dashed black">' +
                '<button style="padding:4px;min-height: 100px;" type="button" class="btn btn-outline-primary refreshBtn"> Click Here to <br/>'+
                '<i class="fas fa-sync-alt"></i>Load Sanchaypatra List</button></div>';
            $('#spFaceValueTable').empty();
            $('#spFaceValueTable').append(spFaceDiv);

            $(':input[readonly]').css({ 'background-color': 'white' });
            $('#inputField').find('input:not(".reg-no")').val('').attr("readonly", false);
            $("#<%=branchDropDownListChosen.ClientID %>").val('').attr("readonly", false);
          $("#<%=branchDropDownListChosen.ClientID %>").prop('disabled', false);
            $("#<%=branchDropDownListChosen.ClientID %>").trigger("chosen:updated");
            $("#<%=walkingCheckBox.ClientID %>").attr("disabled", false);

            //$('.bootstrap-tagsinput').find('input').attr("readonly", false);

            

        }

        function GetCurrentDate() {
            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
            var yyyy = today.getFullYear();

            let currentDate = dd + '/' + mm + '/' + yyyy;
            return currentDate;
        }
        function monthDiff(d1, d2) {
            var months;
            months = (d2.getFullYear() - d1.getFullYear()) * 12;
            months -= d1.getMonth();
            months += d2.getMonth();
            return months <= 0 ? 0 : months;
        }

        function convertToDate(dateString) {
            var dateParts = dateString.split("/");
            var dateObject = new Date(+dateParts[2], dateParts[1] - 1, +dateParts[0]);
            return dateObject;
        }

        var validFilesTypes = ["png", "jpg", "jpeg", "pdf"];
        function ValidateFile() {

            var file = document.getElementById("<%=FileUploadControl.ClientID%>");

                var path = file.value;

                var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();

                var isValidFile = false;

                for (var i = 0; i < validFilesTypes.length; i++) {

                    if (ext == validFilesTypes[i]) {

                        isValidFile = true;

                        break;

                    }

                }

                if (!isValidFile) {

                    alert('Invalid File. Please upload a image(jpg,jpeg,png) and pdf documents');

                }

                return isValidFile;

        };

        var $loading = $('#loadMe').hide();
        $(document)
            .ajaxStart(function () {
                //$('.modal-backdrop').show();
                //$("#loadMe").show();
                $('#loadMe').modal('toggle');
            })
            .ajaxStop(function () {
                //$("#loadMe").hide();
                //$('.modal-backdrop').hide();
                $('#loadMe').modal('toggle');

            });
    </script>

    <div class="modal" id="loadMe"  data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="loadMeLabel">
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
    <form id="form1" runat="server">
        <div class="row" style="margin-top: 10px">
            <div class="card shadow" style="width: 100%">
                <div class="card-header" style="font-weight: 600; background-color: #621e73; text-align: center; color: white">
                    Sanchaypatra Service Request Form
                </div>
                <div class="card-body row" id="inputField" style="width: 100%">
                    <div class="col-md-6">
                        <div class="form-inline row">
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
                                <label style="display: block">Walking Customer</label>
                            </div>
                            <div class="col-md-8">
                                <asp:CheckBox ID="walkingCheckBox" CssClass="form-check-input ignore" runat="server" />
                            </div>

                        </div>
                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Account No.</label>
                            </div>
                            <div class="col-md-8 form-group">

                                <asp:TextBox ID="accNoTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>

                            </div>

                        </div>
                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Customer Name</label>
                            </div>
                            <div class="col-md-8 form-group">
                                <asp:TextBox ID="custNameTextBox" CssClass="form-control  mb-2  textboxHeight" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator2" runat="server" ErrorMessage="Customer Name cannot be blank" ControlToValidate="custNameTextBox" ForeColor="Red"></asp:RequiredFieldValidator>

                            </div>
                        </div>

                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Mobile No</label>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="mobileTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight ignore" runat="server"></asp:TextBox>
                            </div>

                        </div>
                       
                        <div class="form-inline row"  style="display:none">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Total Investment</label>
                            </div>
                            <div class="col-md-8 form-group">
                                <asp:TextBox ID="investmentTextBox" type="number" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator5" runat="server" ErrorMessage="Investment Amount required" ControlToValidate="investmentTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                        </div>

                        <%--<div class="form-inline row" style="display:none">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Sanchaypatra No</label>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="spNoTextBox" data-role="tagsinput" CssClass="form-control tagsinput  mb-2 mr-sm-2 textboxHeight ignore" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator3" runat="server" ErrorMessage="Sp Number cannot be blank" ControlToValidate="spNoTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                        </div>--%>
                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Start Cupon No</label>
                            </div>
                            <div class="col-md-8 form-group">
                                <asp:TextBox ID="startCuponTextBox" type="number" min="1" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator7" runat="server" ErrorMessage="Start Cupon No required" ControlToValidate="startCuponTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                        </div>
                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">End Cupon No</label>
                            </div>
                            <div class="col-md-8 form-group">
                                <asp:TextBox ID="endCuponTextBox" type="number" min="1" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator8" runat="server" ErrorMessage="End Cupon No required" ControlToValidate="endCuponTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                        </div>

                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Total Cupon</label>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="cuponNoTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Reg No.</label>
                            </div>
                            <div class="col-md-8 form-group">
                                <input type="text" style="display:none" id="spType" />
                                <asp:TextBox ID="regNoTextBox" CssClass="form-control  mb-2 mr-sm-2 textboxHeight reg-no" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator6" runat="server" ErrorMessage="Registration No required" ControlToValidate="regNoTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                        </div>
                        
                        


                         <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">Investment Date</label>
                            </div>
                            <div class="col-md-8 form-group">
                                <asp:TextBox ID="investDate" autocomplete="off" CssClass="form-control  mb-2 mr-sm-2 textboxHeight" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="validaion-error" ID="RequiredFieldValidator4" runat="server" ErrorMessage="Investment date cannot be blank" ControlToValidate="investDate" ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                        </div>

                        <div class="form-inline row">
                            <div class="col-md-4 myLabel">
                                <label style="display: block">SanchayPatra List</label>
                            </div>
                            <div class="col-md-8 form-group" id="spFaceValueTable" style="justify-content: center; width: 55%;">
                                <div class="card shadow" style="justify-content: center; min-width: 100%; min-height: 100px; border: 1px dashed black">
                                    <%--<h6 style="margin-left:6vw">SanchayPatra List</h6>--%>
                                    <button style="padding: 4px; min-height: 100px;" type="button" class="btn btn-outline-primary refreshBtn">
                                        Click Here to
                                        <br />
                                        <i class="fas fa-sync-alt"></i>
                                        Load Sanchaypatra List

                                    </button>
                                </div>
                            </div>
                        </div>



                    </div>

                    
                </div>
            </div>

            
            <div class="card shadow" style="width: 100%">
                <div class="card-header" style="font-weight: 400; background-color: #621e73; text-align: center; color: white; padding: 2px">
                    Input Documents
                </div>
                <div class="card-body" style="width: 100%">

                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-inline row">
                                <div class="col-md-4 myLabel">
                                    <label style="display: block">Documents Type</label>
                                </div>

                                <div class="col-md-8">
                                    <asp:DropDownListChosen ID="documentsTypeDropDown" runat="server" CssClass="form-control  mb-2 mr-sm-2"
                                        Width="270px"
                                        DataPlaceHolder="Select a Document Type">
                                    </asp:DropDownListChosen>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div class="row">
                                <div class="col-md-8">
                                    <asp:FileUpload CssClass="form-control-file" ID="FileUploadControl" runat="server" />
                                </div>
                                <div class="col-md-4">
                                    <%--<i class="fas fa-upload"></i>--%>
                                    <%--<asp:Button runat="server" UseSubmitBehavior="true" CausesValidation="false"
                                        CssClass="btn btn-warning" ID="UploadButton" Text="Upload" OnClick="UploadButton_Click" />--%>

                                    <button type="button" CausesValidation="false" runat="server" onserverclick="UploadButton_Click" id="UploadButton" class="btn btn-warning">
                                        <i class="fas fa-upload"></i>
                                        Upload
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-top: 5px; justify-content: center;border-bottom: 1px solid gainsboro;">
                        <asp:GridView ID="fileGridview" runat="server"
                            AutoGenerateColumns="false"
                            EmptyDataText="No Files are uploaded yet"
                            OnRowCommand="fileGridView_OnRowCommand"
                            CssClass="table table-bordered table-striped table-hover">
                            <Columns>
                                <asp:BoundField DataField="DocType" HeaderText="Documents Type" />
                                <asp:BoundField DataField="FileName" HeaderText="File Name" />
                                <asp:BoundField DataField="FilePath" HeaderText="File Path" Visible="false" />
                                <asp:TemplateField ShowHeader="true">
                                    <HeaderTemplate>
                                        Action
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="showButton" class="btn btn-warning btn-sm" runat="server"
                                            CausesValidation="false" CommandName="showbtn" CommandArgument='<%#Eval("FilePath")%>' Font-Size="9px"
                                            Text="Show" />
                                        <asp:LinkButton ID="deleteButton" class="btn btn-danger btn-sm" runat="server"
                                            CausesValidation="false" CommandName="deletebtn" CommandArgument='<%#Eval("FileName")%>' Font-Size="9px"
                                            Text="Delete" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>


                    </div>

                    <div class="row" style="justify-content: center; margin-top: 20px; margin-bottom: 10px;">

                        <%--<asp:Button runat="server" UseSubmitBehavior="false" CssClass="btn btn-success" ID="SendHoButton" Text="Send to HO" OnClick="SendHoButton_Click" />--%>
                        <button runat="server" onserverclick="SendHoButton_Click" id="SendHoButton" class="btn btn-success">
                            <i class="fas fa-paper-plane"></i>
                            Send to HO
                        </button>
                    </div>
                </div>
            </div>

           
        </div>
        
    </form>
</asp:Content>
