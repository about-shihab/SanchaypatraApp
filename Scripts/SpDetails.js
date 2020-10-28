
$(document).ready(function () {

    //for exception Message
    
    //end

    //bootstrap tag input
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
    //bootstrap tag input end

    $('.detailsBtn').click(function (e) {
        let row = $(this).closest('tr');
        let requestId = row.find("td:eq(2)").text();
        var regNo = row.find("td:eq(4)").text();
        LoadSpDetailsByRegNo(requestId);
        
        //LoadSpFaceValue(requestId);
        $('.modal-backdrop').show();
        $('#myModal').modal('show');

        let openOnce = 0;
        $('#collapse-example').on('shown.bs.collapse', function () {
            if (openOnce==0)
                LoadFileInfo(requestId);
            

        });
        $('#collapse-example').on('hidden.bs.collapse', function () {
            openOnce = 1;
        });
        $('.refreshBtn').click(function (e) {
            //LoadSpDetailsByRegNo(requestId);
            LoadSpFaceValue(requestId);

        });

        $(function () {
            var url = 'FileUpload.ashx';
            //let documentTyp = $('.result-selected').val();
            //alert(docType);
            $('#fileupload').fileupload({
                url: url,
                formData: function (form) {
                    return [{ name: 'requestId', value: requestId }, { name: 'regNo', value: regNo }, { name: 'docType', value: docType }];
                },
                add: function (e, data) {
                    //$.each(data.files, function (index, file) {
                    //    $('#fileupload').empty();
                        

                    //    $('#txtFileName').val(file.name);

                    //});
                    $('#txtFileName').val(data.files[0].name);


                    $('#btnUpload').click(function () {
                        //data.files = data.files[0];
                        data.submit();
                        //$('#txtFileName').val('No Files are choosen');
                       // $('#fileupload').empty();
                        //clearFileInput("fileupload");


                    });
                },
                done: function (e, data) {
                    // data.context.text('Upload finished.');
                    LoadFileInfo(requestId);
                    $("#fileupload").replaceWith($("#fileupload").val('').clone(true));
                    $("table tbody.files").empty();
                    document.getElementById("fileupload").value = "";

                     $('#fileupload').empty();
                    $("form")[0].reset();

                }

            });
        });
        

    });

    $(':input[readonly]').css({ 'background-color': 'beige' });

    $('.heading-example').click(function (e) {
        $(this).next('ul').slideToggle('500');
        $(this).find('i').toggleClass('fa-chevron-down fa-chevron-left');
    });
});

function clearFileInput(id) {
    var oldInput = document.getElementById(id);

    var newInput = document.createElement("input");

    newInput.type = "file";
    newInput.id = oldInput.id;
    newInput.name = oldInput.name;
    newInput.className = oldInput.className;
    newInput.style.cssText = oldInput.style.cssText;
    // TODO: copy any other relevant attributes 

    oldInput.parentNode.replaceChild(newInput, oldInput);
}



function LoadSpDetailsByRegNo(requestId) {

    var url = "../UI/SpRequestDetails.aspx/GetSpDetails";
    var parameter = {
        prequest_id: requestId

    };

    AjaxPostRequest(url, parameter, function (response) {
        var jsonData = JSON.parse(response.d);
        BindInputField(jsonData);//bind modal field
        
        if (jsonData.length > 0) {
            status = jsonData[0].STATUS_ID;
        }
            
        if (seessionBranchId == '0001') {
            let buttonHtml = '<button type="button" class="btn btn-primary lockBtn"><i class="fas fa-lock"></i> Lock By HO</button>' +
                '<button type="button" class="btn btn-danger exceptionBtn"><i class="fas fa-exclamation-triangle"></i> Exception</button>' +
                '<button type="button" class="btn btn-success dealBtn"><i class="fas fa-check-double"></i> Deal Done</button>' +
                '<button type = "button" class="btn btn-secondary closeButton" data-dismiss="modal" > Close</button>';
            $('#modalFooter').empty();
            $('#modalFooter').append(buttonHtml);

            if (status== '1') {
                $("#paidAmountTextbox").attr("readonly", true);
                $('.dealBtn').hide();
                $('.exceptionBtn').hide();
            } 
            else if (status == '6') {
                $("#paidAmountTextbox").attr("readonly", false);
                $('.lockBtn').hide();

            }
            else {
                $('.lockBtn').hide();
                $('.dealBtn').hide();
                $('.exceptionBtn').hide();

            }
            $('.lockBtn').click(function (e) {
                let requestId = jsonData[0].REQUEST_ID;
                let status = 6;
                let paidAmount = '';
                let exceptionMessage = '';
                LockApprove(requestId, status, paidAmount, exceptionMessage);

                //$('.lockBtn').hide();
                //$('.dealBtn').show();
                $("#paidAmountTextbox").attr("readonly", false);
                $("#paidAmountTextbox").css({ 'background-color': 'white' });
               

            });
            $('.exceptionBtn').click(function (e) {
                    (async () => {
                        const { value: text } = await Swal.fire({
                                input: 'textarea',
                                inputPlaceholder: 'Type your Exception message here...',
                                inputAttributes: {
                                    'aria-label': 'Type your Exception message here'
                                },
                                showCancelButton: true,
                                title: 'Request will return to branch',
                                allowOutsideClick: false

                            });
                        if (text) {
                            let requestId = jsonData[0].REQUEST_ID;
                            let status = 3;
                            let paidAmount = '';
                            let exceptionMessage = text;
                            LockApprove(requestId, status, paidAmount, exceptionMessage);

                        } else {
                            swal.fire({
                                icon: 'warning',
                                title:'Exception message Require to return branch'

                            });

                        }
                    })()
                    
                
                
            });
            $('.dealBtn').click(function (e) {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Deal Done!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        let requestId = jsonData[0].REQUEST_ID;
                        let status = 7;
                        let paidAmount = $('#paidAmountTextbox').val();
                        let exceptionMessage = '';
                        if (paidAmount.length > 0) {

                            $("#paidAmountTextbox").attr("readonly", true);
                            $("#paidAmountTextbox").css({ 'background-color': 'beige' });
                            LockApprove(requestId, status, paidAmount, exceptionMessage);

                        } else {
                            swal.fire({
                                icon: 'warning',
                                title: 'Enter valid Paid Amount'

                            })
                        }
                    }

                });

            });

        }
        else if (seessionBranchId != '0001' && (status == '1' || status == '3')) {
            let buttonHtml = '<button type="button" class="btn btn-warning updBtn">Save</button>' +
                '<button type = "button" class="btn btn-secondary closeButton" data-dismiss="modal" > Close</button>';
            if (status == 3) {
                buttonHtml = '<button type="button" class="btn btn-success updBtn">Send To HO</button>' +
                    '<button type = "button" class="btn btn-secondary closeButton" data-dismiss="modal" > Close</button>';
            }
            $('#modalFooter').empty();
            $('#modalFooter').append(buttonHtml);
            $('#inputField').find('input:not("#mobileTextBox")').attr("readonly", true);
            $('#mobileTextBox').attr("readonly", false);
            $("#paidAmountTextbox").attr("readonly", true);
            $("#inputDocUpload").show();
            $('.updBtn').click(function (e) {
                let requestId = jsonData[0].REQUEST_ID;
                let branchId = jsonData[0].BRANCH_ID;
                let mobileNo = $('#mobileTextBox').val();
                console.log(jsonData);
                let url = "../UI/SpRequestDetails.aspx/EditRequestByBranch";
                let parameter = {
                    requestId     : requestId,
                    branchId      : branchId,
                    mobileNo      : mobileNo,
                    customerAccNo : '',
                    faceValue     : '',
                    startCupon    : '',
                    endCupon      : '',
                    prequest_status_id: 1

                };
                
                AjaxPostRequest(url, parameter, function (response) {
                    var jsonData = JSON.parse(response.d);
                    if (jsonData.length === 0) {
                        swal.fire({
                            icon: 'success',
                            title: 'Your changes have been saved',

                        })
                    } else {
                        swal.fire({
                            icon: 'warning',
                            title: 'Failed to save',

                        })
                    }
                });

            });
        }
        else {
            $("#paidAmountTextbox").attr("readonly", true);
            let buttonHtml = '<button type = "button" class="btn btn-secondary closeButton" data-dismiss="modal" > Close</button>';
            $('#modalFooter').empty();
            $('#modalFooter').append(buttonHtml);
        }



        $('.closeButton').click(function (e) {
            location.reload();
        });


    });
};


function LockApprove(requestId, status, paidAmount, exceptionMessage) {

    let url = "../UI/SpRequestDetails.aspx/LockApprovedRequest";
    let parameter = {
        requestId: requestId,
        status: status,
        paidAmount: paidAmount,
        exceptionMessage: exceptionMessage
    };
    let l = 1;
    AjaxPostRequest(url, parameter, function (response) {
        var jsonData = JSON.parse(response.d);
        if (jsonData.length === 0) {
            if ($('.dealBtn').is(":hidden")) {
                $('.lockBtn').hide();
                $('.dealBtn').show();
                $('.exceptionBtn').show();
            } else {
                $('.dealBtn').hide();
                $('.exceptionBtn').hide();

            }

            swal.fire({
                icon: 'success',
                title: 'Successful'

            })

        } else {
            swal.fire({
                icon: 'warning',
                title: 'Failed to update data '

            })
        }
    });

}
function BindInputField(jsonData) {
    ResetInputField();
    console.log(jsonData);

    if (jsonData.length != 0) {
        for (i = 0; i < jsonData.length; i++) {
            console.log(jsonData[i]);

            if (jsonData[i].BRANCH_ID != null) {
                $("#branchTextBox").val(jsonData[i].BRANCH_ID).attr("readonly", true);

            }

            if (jsonData[i].CUSTOMER_ACC_NO != null) {
                $("#accNoTextBox").val(jsonData[i].CUSTOMER_ACC_NO).attr("readonly", true);

            }
            if (jsonData[i].WALK_IN_CUSTOMER != null) {
                if (jsonData[i].WALK_IN_CUSTOMER == 1) {
                    $("#walkingCheckBox").prop('checked');
                    $("#walkingCheckBox").prop("checked", true);
                }
            }
            if (jsonData[i].SANCHAY_PATRA_NO != null) {
                var spNumbers = jsonData[i].SANCHAY_PATRA_NO.trim().split(";");
                for (k = 0; k < spNumbers.length; k++) {
                    if (spNumbers[k].length > 0) {
                        $("#spNoTextBox").tagsinput('add', spNumbers[k]);
                    }
                }
                console.log(spNumbers);
                //$("#spNoTextBox.ClientID").val(jsonData[i].ACCOUNT_NUMBER).attr("readonly", true);

            }
            if (jsonData[i].REGISTRATION_NO != null)
                $("#regNoTextBox").val(jsonData[i].REGISTRATION_NO).attr("readonly", true);
            if (jsonData[i].CUSTOMER_NAME != null)
                $("#custNameTextBox").val(jsonData[i].CUSTOMER_NAME).attr("readonly", true);
            if (jsonData[i].CUSTOMER_MOBILE_NO != null && jsonData[i].CUSTOMER_MOBILE_NO != "N/A")
                $("#mobileTextBox").val(jsonData[i].CUSTOMER_MOBILE_NO).attr("readonly", true);
            if (jsonData[i].INVESTMENT_DATE != null)
                $("#investDate").val(jsonData[i].INVESTMENT_DATE).attr("readonly", true);
            if (jsonData[i].TOTAL_INVESTMENT != null)
                $("#investmentTextBox").val(jsonData[i].TOTAL_INVESTMENT).attr("readonly", true);
            //if (jsonData[i].FACE_VALUE != null)
            //    $("#faceValueTextBox").val(jsonData[i].FACE_VALUE).attr("readonly", true);
            if (jsonData[i].START_COUPON_NO != null)
                $("#startCuponTextBox").val(jsonData[i].START_COUPON_NO).attr("readonly", true);
            if (jsonData[i].END_COUPON_NO != null)
                $("#endCuponTextBox").val(jsonData[i].END_COUPON_NO).attr("readonly", true);

            if (jsonData[i].REMARKS != null)
                $("#exceptionMessageTextbox").val(jsonData[i].REMARKS).attr("readonly", true);

            if (jsonData[i].PAID_AMOUNT != null)
                $("#paidAmountTextbox").val(jsonData[i].PAID_AMOUNT).attr("readonly", true);

            if ($("#startCuponTextBox").val().length > 0 && $("#endCuponTextBox").val().length > 0) {
                let cuponNo = $("#endCuponTextBox").val() - $("#startCuponTextBox").val() + 1;

                $("#cuponNoTextBox").val(cuponNo).attr("readonly", true);
            }
         

        }
    } else if (jsonData == null) {
        alert("no data");

    }

}
function ResetInputField() {
    $('#inputField').find('input').val('');
    $("#spNoTextBox").tagsinput('removeAll');
    $("#walkingCheckBox").prop("checked", false);

}

function LoadSpFaceValue(requestId) {

    var url = "../UI/SpRequestDetails.aspx/GetSpFacevalue";
    var parameter = {
        prequest_id: requestId,
        psanchay_patra_no: ''

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
        tableHtml += '<td>' + jsonData[i].SANCHAY_PATRA_NO + '</td>';
        tableHtml += '<td style="padding: 5px;"><input style="text-align:right;width:100%" type="text" class="form-control mb-2 mr-sm-2 textboxHeight facevalue" readonly value="' + jsonData[i].DENOMINATION + '"></td>';

        tableHtml += '</tr>';

    }
    tableHtml += '<tr style="background-color: steelblue; color: white;">';
    tableHtml += '<td></td>';
    tableHtml += '<td><strong>' + 'Total Investment' + '<strong></td>';
    tableHtml += '<td style="text-align:right;"><strong>' + $("#investmentTextBox").val() + '<strong></td>';

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
function LoadFileInfo(requestId) {
    var url = "../UI/SpRequestDetails.aspx/GetFileInfo";
    var parameter = {
        prequest_id: requestId

    };

    AjaxPostRequest(url, parameter, function (response) {
        var jsonData = JSON.parse(response.d);
        BindFileTable(jsonData);
        $('.showBtn').click(function (e) {
            let row = $(this).closest('tr');
            var filename = row.find("td:eq(5)").text();
            var index = filename.lastIndexOf('\\');
            filename = "../Spfile/" + filename.substring(index);

            //var filename = result.get('sProviderName') + '-TSCA.pdf';
            var downloadLink = document.createElement("a");
            downloadLink.href = encodeURI(filename);
            downloadLink.download = "<FILENAME_TO_SAVE_WITH_EXTENSION>";
            window.open(downloadLink.href, '_blank');

        });
        $('.downloadBtn').click(function (e) {
            let row = $(this).closest('tr');
            let path = row.find("td:eq(5)").text();
            let filename = row.find("td:eq(2)").text();
            var index = path.lastIndexOf('\\');
            path = "../Spfile/" + path.substring(index);;
            var downloadLink = document.createElement("a");
            downloadLink.href = encodeURI(path);
            downloadLink.download = filename;
            downloadLink.dispatchEvent(new MouseEvent('click'));


        });
        $('.deletedBtn').click(function (e) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "../UI/SpRequestDetails.aspx/DeleteFile";
                    let sl_no = $(this).closest('tr').find("td:eq(6)").text();
                    var parameter = {
                        prequestId: jsonData[0].REQUEST_ID,
                        pdocsl_no: sl_no
                    };

                    AjaxPostRequest(url, parameter, function (response) {
                        var jsonData = JSON.parse(response.d);
                        if (jsonData.length == 0) {
                            LoadFileInfo(requestId);
                            
                            swal.fire({
                                icon: 'success',
                                title: 'Your File has been removed'
                                
                            })

                        }
                    })
                }
            })
            


        });
    });
}
function BindFileTable(jsonData) {
    console.log(jsonData);
    let tableHtml = '<table class="table table-bordered table-striped table-hover" style="margin: 0 auto;width:auto;font-size:11px">' +
        '<thead style = "background-color:#BB6805;color:white;padding:5px;" ><tr>' +
        '<th>Sl No.</th>' +
        '<th>Documents Type</th>' +
        '<th>File Name</th>' +
        '<th>Uploaded By</th>' +
        '<th>Uploaded Date</th>' +
        '<th style="display:none">Path</th>' +
        '<th></th>' +
        '</tr></thead ><tbody>';
    var fileDltButton = '';
    if (seessionBranchId != '0001' && (status == '1' || status == '3')) {
        fileDltButton = '<button  style="margin-left:10px;font-size:9px;padding:3px;background-color:red;color:white" type="button" class="btn btn-warning btn-sm deletedBtn">Delete</button>';
    }
    for (var i = 0; i < jsonData.length; i++) {
        tableHtml += '<tr>';
        tableHtml += '<td>' + (i + 1) + '</td>';
        tableHtml += '<td>' + jsonData[i].DOCUMENTS_TYPE_NM + '</td>';
        tableHtml += '<td>' + jsonData[i].FILE_NM + '</td>';
        tableHtml += '<td>' + jsonData[i].MAKE_BY + '</td>';
        tableHtml += '<td>' + jsonData[i].MAKE_DATE + '</td>';
        tableHtml += '<td style="display:none">' + jsonData[i].FILE_NAVIGATE_URL + '</td>';
        tableHtml += '<td style="display:none">' + jsonData[i].SL_NO + '</td>';

        //tableHtml += '<td><a href="' + jsonData[i].FILE_NAVIGATE_URL+'" class="btn btn-warning btn-sm showBtn" role="button">Show</a></td>';
        tableHtml += '<td><button  style="font-size:9px;padding:3px;background-color:#bb6805;color:white" type="button" class="btn btn-warning btn-sm showBtn">Show</button>'
        tableHtml += '<button  style="margin-left:10px;font-size:9px;padding:3px;background-color:green;color:white" type="button" class="btn btn-warning btn-sm downloadBtn">Download</button>' + fileDltButton + '</td>'
        tableHtml += '</tr>';

    }
    tableHtml += ' </tbody></table >';
    if (jsonData.length > 0) {

        $('#fileInfoDiv').empty();
        $('#fileInfoDiv').append(tableHtml);
    }
    else {
        $('#fileInfoDiv').empty();

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
            //    show: true,
            //    setTimeout:10
            //});

        },
        complete: function () {
            //$("#loadMe").hide();
            //$('.modal-backdrop').hide();
            //$('body').removeClass('modal-open');
            //$('.modal-backdrop').remove();
        },
        success: successCallback,
        error: function (err) {
            alert("Failed to Load Data");
            //console.log(err);
        }
    });
};
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
    $.ajaxSetup({ cache: false });