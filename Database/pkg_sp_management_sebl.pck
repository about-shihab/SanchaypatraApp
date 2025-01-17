CREATE OR REPLACE PACKAGE pkg_sp_management_sebl
IS
  --*****************************************************************
  -------------------------------------------------------------------
  --*****************************************************************
  -- Creator           : Uzzal KOIRI
  -- Creation Date     :181420040096
  -- Purpose           : Sanchay Patra Management System
  -- Modification Date :
  --------------------------------------------------------------------------------------------
  --************************  CONSTANT DEFINITION ********************************************
  --------------------------------------------------------------------------------------------
  -- Auth status
  c_auth_status_authorized            CONSTANT sebl_edf_request_mast.auth_status_id%TYPE := 'A';
  c_auth_status_unauthorized          CONSTANT sebl_edf_request_mast.auth_status_id%TYPE := 'U';
  c_auth_status_declined              CONSTANT sebl_edf_request_mast.auth_status_id%TYPE := 'D';
  -- Request Status
  c_req_status_claim                  CONSTANT SEBL_SP_MANAGE_STATUS_PARAM.status_id%TYPE := 1;
  c_req_status_in_process             CONSTANT SEBL_SP_MANAGE_STATUS_PARAM.status_id%TYPE := 6;
  c_req_status_honor                  CONSTANT SEBL_SP_MANAGE_STATUS_PARAM.status_id%TYPE := 7;
  c_req_status_Lck_BR                 CONSTANT SEBL_SP_MANAGE_STATUS_PARAM.status_id%TYPE := 2;
  c_req_status_lck_HO                 CONSTANT SEBL_SP_MANAGE_STATUS_PARAM.status_id%TYPE := 99;
  c_req_status_exception              CONSTANT SEBL_SP_MANAGE_STATUS_PARAM.status_id%TYPE := 3;
  --Process Flag
  c_process_flag_nonprocessed         CONSTANT sebl_pi_request_mast.process_flag%TYPE := 0;
  c_process_flag_processed            CONSTANT sebl_pi_request_mast.process_flag%TYPE := 1;
  --------------------------------------------------------------------------------------------
  --************************   ********************************************
   -----------------------------------------------------------------------------------------
  PROCEDURE fsp_addup_sp_request_master
      (
         pbranch_id              IN branch_home_bank.branch_id%TYPE
       , prequest_id             IN SEBL_SP_REQUEST_MASTER.request_id%TYPE
       , pregistration_No        IN SEBL_SP_REQUEST_MASTER.registration_no%TYPE
       , psanchay_Patra_No       IN SEBL_SP_REQUEST_MASTER.sanchay_patra_no%TYPE
       , pwalk_In_Customer       IN SEBL_SP_REQUEST_MASTER.walk_in_customer%TYPE
       , pcustomer_Acc_No        IN SEBL_SP_REQUEST_MASTER.customer_acc_no%TYPE
       , pcustomer_Name          IN SEBL_SP_REQUEST_MASTER.customer_name%TYPE
       , pcustomer_Mobile_No     IN SEBL_SP_REQUEST_MASTER.customer_mobile_no%TYPE
       , pinvestment_Date        IN SEBL_SP_REQUEST_MASTER.investment_date%TYPE
       , ptotal_Investment       IN SEBL_SP_REQUEST_MASTER.total_investment%TYPE
       , pface_Value             IN SEBL_SP_REQUEST_MASTER.face_value%TYPE
       , pstart_Coupon_No        IN SEBL_SP_REQUEST_MASTER.start_coupon_no%TYPE
       , pend_Coupon_No          IN SEBL_SP_REQUEST_MASTER.end_coupon_no%TYPE
       , ppaid_Amount            IN SEBL_SP_REQUEST_MASTER.paid_amount%type
       , prequest_status_id      IN SEBL_SP_REQUEST_MASTER.request_status_id%TYPE
       , pauthorize_status       IN SEBL_SP_REQUEST_MASTER.authorize_status%TYPE
       , pmake_By                IN sms_user_profile.user_id%TYPE
       , pmake_Date              IN SEBL_SP_REQUEST_MASTER.make_date%TYPE
       , pauthorize_By           IN sms_user_profile.user_id%TYPE
       , pauthorize_Date         IN SEBL_SP_REQUEST_MASTER.authorize_date%TYPE
       , papproved_by            IN sms_user_profile.user_id%TYPE
       , papproved_dt            IN SEBL_SP_REQUEST_MASTER.approved_dt%TYPE
       , premarks                IN SEBL_SP_REQUEST_MASTER.remarks%TYPE
       , prequest_id_out      OUT SEBL_SP_REQUEST_MASTER.request_id%TYPE
       , perrorcode           OUT INTEGER
       , perrormsg            OUT VARCHAR2
      );
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
  PROCEDURE fsp_addup_sp_doc_register(pregistration_no     IN sebl_sp_doc_reg.registration_no%TYPE
                                    ,prequest_id          IN sebl_sp_doc_reg.request_id%TYPE
                                    ,pdocsl_no            IN sebl_sp_doc_reg.sl_no%TYPE
                                    ,pdocuments_type_id   IN sebl_sp_doc_reg.documents_type_id%TYPE
                                    ,pfile_nm             IN sebl_sp_doc_reg.file_nm%TYPE
                                    ,pfile_navigate_url   IN sebl_sp_doc_reg.file_navigate_url%TYPE
                                    ,pfolder_location     IN sebl_sp_doc_reg.folder_location%TYPE
                                    ,pho_upload_flag      IN sebl_sp_doc_reg.ho_upload_flag%TYPE
                                    ,pbr_upload_flag      IN sebl_sp_doc_reg.br_upload_flag%TYPE
                                    ,premarks             IN sebl_sp_doc_reg.remarks%TYPE
                                    ,psys_gen_flag        IN sebl_sp_doc_reg.sys_gen_flag%TYPE
                                    ,pauth_status_id      IN sebl_sp_doc_reg.auth_status_id%TYPE
                                    ,puser_id             IN sebl_sp_doc_reg.make_by%TYPE
                                    ,perrorcode           OUT INTEGER
                                    ,perrormsg            OUT VARCHAR2
                                    ) ;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
  PROCEDURE fsp_get_documents_typ
         (
           presult             OUT SYS_REFCURSOR
         );
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 PROCEDURE fsp_delete_documents_file
         (
           prequest_id          IN sebl_sp_doc_reg.request_id%TYPE
         , pmake_by             IN sebl_sp_doc_reg.make_by%TYPE
         , pdocsl_no            IN sebl_sp_doc_reg.sl_no%TYPE
         , perrorcode           OUT INTEGER
          ,perrormsg            OUT VARCHAR2
         );
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
  FUNCTION get_sp_instrument
      (Registration_NO  nvarchar2) return varchar2 ;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
  PROCEDURE rsp_get_sp_details_sebl
      (
             pregistration_no  IN NVARCHAR2,
             pinstrument_number IN NVARCHAR2,
             presult   OUT       SYS_REFCURSOR
      ) ;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
  PROCEDURE rsp_get_sp_request_master
      (
             pbranch_id          IN NVARCHAR2,
             prequest_id         IN NVARCHAR2,
             prequest_status_id  IN NVARCHAR2,
             pregistration_no    IN NVARCHAR2,
             psanchay_patra_no   IN NVARCHAR2,
             pcustomer_name      IN NVARCHAR2,
             pcustomer_mobile_no IN NVARCHAR2,
             presult       OUT SYS_REFCURSOR
      );
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

   PROCEDURE rsp_get_sp_request_doc_master
      (
         pbranch_id          IN NVARCHAR2,
         prequest_id         IN NVARCHAR2,
         prequest_status_id  IN NVARCHAR2,
         pregistration_no    IN NVARCHAR2,
         psanchay_patra_no   IN NVARCHAR2,
         pcustomer_name      IN NVARCHAR2,
         pcustomer_mobile_no IN NVARCHAR2,
         presult       OUT SYS_REFCURSOR
      );

END pkg_sp_management_sebl;
/
CREATE OR REPLACE PACKAGE BODY pkg_sp_management_sebl
IS
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 PROCEDURE fsp_addup_sp_request_master
      (
         pbranch_id              IN branch_home_bank.branch_id%TYPE
       , prequest_id             IN SEBL_SP_REQUEST_MASTER.request_id%TYPE
       , pregistration_No        IN SEBL_SP_REQUEST_MASTER.registration_no%TYPE
       , psanchay_Patra_No       IN SEBL_SP_REQUEST_MASTER.sanchay_patra_no%TYPE
       , pwalk_In_Customer       IN SEBL_SP_REQUEST_MASTER.walk_in_customer%TYPE
       , pcustomer_Acc_No        IN SEBL_SP_REQUEST_MASTER.customer_acc_no%TYPE
       , pcustomer_Name          IN SEBL_SP_REQUEST_MASTER.customer_name%TYPE
       , pcustomer_Mobile_No     IN SEBL_SP_REQUEST_MASTER.customer_mobile_no%TYPE
       , pinvestment_Date        IN SEBL_SP_REQUEST_MASTER.investment_date%TYPE
       , ptotal_Investment       IN SEBL_SP_REQUEST_MASTER.total_investment%TYPE
       , pface_Value             IN SEBL_SP_REQUEST_MASTER.face_value%TYPE
       , pstart_Coupon_No        IN SEBL_SP_REQUEST_MASTER.start_coupon_no%TYPE
       , pend_Coupon_No          IN SEBL_SP_REQUEST_MASTER.end_coupon_no%TYPE
       , ppaid_Amount            IN SEBL_SP_REQUEST_MASTER.paid_amount%type
       , prequest_status_id      IN SEBL_SP_REQUEST_MASTER.request_status_id%TYPE
       , pauthorize_status       IN SEBL_SP_REQUEST_MASTER.authorize_status%TYPE
       , pmake_By                IN sms_user_profile.user_id%TYPE
       , pmake_Date              IN SEBL_SP_REQUEST_MASTER.make_date%TYPE
       , pauthorize_By           IN sms_user_profile.user_id%TYPE
       , pauthorize_Date         IN SEBL_SP_REQUEST_MASTER.authorize_date%TYPE
       , papproved_by            IN sms_user_profile.user_id%TYPE
       , papproved_dt            IN SEBL_SP_REQUEST_MASTER.approved_dt%TYPE
       , premarks                IN SEBL_SP_REQUEST_MASTER.remarks%TYPE
       , prequest_id_out      OUT SEBL_SP_REQUEST_MASTER.request_id%TYPE
       , perrorcode           OUT INTEGER
       , perrormsg            OUT VARCHAR2
      )

     IS
      v_request_id           SEBL_SP_REQUEST_MASTER.request_id%TYPE;
      v_request_status_id    SEBL_SP_REQUEST_MASTER.request_status_id%TYPE;
      v_count                PLS_INTEGER := 0;
      v_date                 NVARCHAR2(10);
      v_queue_id             number;

    BEGIN

      v_request_status_id   := pkg_mis_system.fxn_convert_to_null(prequest_status_id);
      perrorcode   := 0;

      SELECT TO_CHAR(sysdate,'RRRRMMDD')
            INTO V_DATE
          FROM DUAL ;

      SELECT seq_sebl_sp_doc_queue_id.NEXTVAL
          INTO v_queue_id
          FROM dual;

      /*Generating Request ID*/
      v_request_id  :=  LPAD(pbranch_id,4,0)||V_DATE||LPAD(v_queue_id,4,0) ;

      SELECT COUNT(1)
        INTO v_count
        FROM sebl_sp_request_master m
       WHERE m.request_id = prequest_id;

      IF v_count > 0 THEN

      SELECT m.request_status_id
        INTO v_request_status_id
        FROM sebl_sp_request_master m
       WHERE m.request_id = prequest_id;

      IF v_request_status_id IN(c_req_status_in_process) THEN

      /*Updating Master Table For "Locked by HO" */

   IF prequest_status_id = c_req_status_honor THEN

      IF ppaid_Amount IS NULL THEN
        perrorcode := -1001;
        perrormsg  := 'Paid Amount is required!!';
        GOTO EXIT_ABORT;
      ELSIF papproved_by IS NULL THEN
        perrorcode := -1002;
        perrormsg  := 'Approved By is required!!';
        GOTO EXIT_ABORT;
      ELSIF prequest_status_id IS NULL THEN
        perrorcode := -1002;
        perrormsg  := 'Request Status ID is required!!';
        GOTO EXIT_ABORT;
      END IF ;

         UPDATE sebl_sp_request_master m
             SET m.request_status_id = prequest_status_id
               , m.approved_by       = papproved_by
               , m.approved_dt       = SYSDATE
               , m.paid_amount       = ppaid_Amount
           WHERE m.request_id        = prequest_id;
    ELSE

    IF premarks IS NULL THEN
        perrorcode := -1001;
        perrormsg  := 'Remarks is required!!';
        GOTO EXIT_ABORT;
      ELSIF papproved_by IS NULL THEN
        perrorcode := -1002;
        perrormsg  := 'Approved By is required!!';
        GOTO EXIT_ABORT;
      ELSIF prequest_status_id IS NULL THEN
        perrorcode := -1002;
        perrormsg  := 'Request Status ID is required!!';
        GOTO EXIT_ABORT;
      END IF ;

         UPDATE sebl_sp_request_master m
             SET m.request_status_id = prequest_status_id
               , m.approved_by       = papproved_by
               , m.approved_dt       = SYSDATE
               , m.remarks           = premarks
           WHERE m.request_id        = prequest_id;
    END IF ;

    /*Updating Master Table For "Claim Request" */

        ELSIF v_request_status_id IN(c_req_status_claim) THEN

       /* For Branch */

       IF pbranch_id <> '0001' THEN

         UPDATE sebl_sp_request_master m
              SET m.customer_acc_no      = NVL(pcustomer_Acc_No,m.customer_acc_no)
                , m.customer_Mobile_No   = NVL(pcustomer_Mobile_No,m.customer_Mobile_No)
                , m.face_Value           = NVL(pface_Value, m.face_Value)
                , m.start_coupon_no      = NVL(pstart_Coupon_No , m.start_coupon_no)
                , m.end_Coupon_No        = NVL(pend_Coupon_No, m.end_Coupon_No)
                , m.make_by              = pmake_By
                , m.make_date            = SYSDATE
                , m.authorize_by         = pauthorize_By
                , m.authorize_date       = SYSDATE
            WHERE m.request_id = prequest_id
              AND m.branch_id   = pbranch_id ;

       ELSE

         /* For Head Office */

          IF papproved_by IS NULL THEN
            perrorcode := -1001;
            perrormsg  := 'Approved By is required!!';
            GOTO EXIT_ABORT;
          ELSIF prequest_status_id IS NULL THEN
            perrorcode := -1002;
            perrormsg  := 'Request Status ID is required!!';
            GOTO EXIT_ABORT;
          END IF ;

          UPDATE sebl_sp_request_master m
             SET m.request_status_id = prequest_status_id
               , m.approved_by       = papproved_by
               , m.approved_dt       = SYSDATE
           WHERE m.request_id        = prequest_id;

      END IF ;
     END IF ;

      ELSE

        INSERT INTO sebl_sp_request_master
            (
              request_id        ,
              branch_id         ,
              registration_no   ,
              sanchay_patra_no  ,
              walk_in_customer  ,
              customer_acc_no   ,
              customer_name     ,
              customer_mobile_no,
              investment_date   ,
              total_investment  ,
              face_value        ,
              start_coupon_no   ,
              end_coupon_no     ,
              request_status_id ,
              authorize_status  ,
              make_by           ,
              make_Date         ,
              authorize_by      ,
              authorize_Date
            )
        VALUES
            (
              v_request_id       ,
              pbranch_id         ,
              pregistration_no   ,
              psanchay_patra_no  ,
              pwalk_in_customer  ,
              pcustomer_acc_no   ,
              pcustomer_name     ,
              pcustomer_mobile_no,
              pinvestment_date   ,
              ptotal_investment  ,
              pface_value        ,
              pstart_coupon_no   ,
              pend_coupon_no     ,
              v_request_status_id,
              pauthorize_status  ,
              pmake_by           ,
              pmake_Date         ,
              pauthorize_by      ,
              pauthorize_Date
            )
        RETURNING request_id
             INTO v_request_id;

     prequest_id_out := v_request_id;

    END IF ;
       <<EXIT_ABORT>>
    NULL;
    EXCEPTION
      WHEN OTHERS THEN
          perrorcode := SQLCODE;
          perrormsg  := SQLERRM;
    END fsp_addup_sp_request_master;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 PROCEDURE fsp_addup_sp_doc_register(pregistration_no     IN sebl_sp_doc_reg.registration_no%TYPE
                                    ,prequest_id          IN sebl_sp_doc_reg.request_id%TYPE
                                    ,pdocsl_no            IN sebl_sp_doc_reg.sl_no%TYPE
                                    ,pdocuments_type_id   IN sebl_sp_doc_reg.documents_type_id%TYPE
                                    ,pfile_nm             IN sebl_sp_doc_reg.file_nm%TYPE
                                    ,pfile_navigate_url   IN sebl_sp_doc_reg.file_navigate_url%TYPE
                                    ,pfolder_location     IN sebl_sp_doc_reg.folder_location%TYPE
                                    ,pho_upload_flag      IN sebl_sp_doc_reg.ho_upload_flag%TYPE
                                    ,pbr_upload_flag      IN sebl_sp_doc_reg.br_upload_flag%TYPE
                                    ,premarks             IN sebl_sp_doc_reg.remarks%TYPE
                                    ,psys_gen_flag        IN sebl_sp_doc_reg.sys_gen_flag%TYPE
                                    ,pauth_status_id      IN sebl_sp_doc_reg.auth_status_id%TYPE
                                    ,puser_id             IN sebl_sp_doc_reg.make_by%TYPE
                                    ,perrorcode           OUT INTEGER
                                    ,perrormsg            OUT VARCHAR2
                                    )
     IS

     v_sl_no               sebl_sp_doc_reg.sl_no%TYPE;
     v_ho_upload_flag      sebl_sp_doc_reg.ho_upload_flag%TYPE;
     v_br_upload_flag      sebl_sp_doc_reg.br_upload_flag%TYPE;
     v_request_id          sebl_sp_doc_reg.request_id%TYPE;
     v_count               PLS_INTEGER:= 0;
     v_prev_request_info   sebl_pi_request_mast%ROWTYPE;
     v_date                NVARCHAR2(10);
     v_queue_id            number;

    BEGIN

      perrorcode          := 0;
      v_ho_upload_flag    := pkg_mis_system.fxn_convert_to_null(pho_upload_flag);
      v_br_upload_flag    := pkg_mis_system.fxn_convert_to_null(pbr_upload_flag);
/*      v_request_id        := pkg_mis_system.fxn_convert_to_null(prequest_id);*/

     --BEGIN VALIDATION
      IF pfile_navigate_url IS NULL THEN
        perrorcode := -1005;
        perrormsg  := 'File Navigate URL is required!!';
        GOTO EXIT_ABORT;
      ELSIF pfolder_location IS NULL THEN
        perrorcode := -1006;
        perrormsg  := 'Folder location is required!!';
        GOTO EXIT_ABORT;
      ELSIF pfile_nm IS NULL THEN
        perrorcode := -1007;
        perrormsg  := 'File Name is required!!';
        GOTO EXIT_ABORT;
      ELSIF v_ho_upload_flag IS NULL THEN
        perrorcode := -1008;
        perrormsg  := 'Head Office Upload Flag is required!!';
        GOTO EXIT_ABORT;
      ELSIF v_br_upload_flag IS NULL THEN
        perrorcode := -1009;
        perrormsg  := 'Branch Office Upload Flag is required!!';
        GOTO EXIT_ABORT;
      ELSIF pauth_status_id IS NULL THEN
        perrorcode := -1011;
        perrormsg  := 'Authorization Status is required!!';
        GOTO EXIT_ABORT;
      ELSIF puser_id IS NULL THEN
        perrorcode := -1020;
        perrormsg  := 'User ID is required!!';
        GOTO EXIT_ABORT;
      END IF;

      --VALIDATION END

      INSERT INTO SEBL_SP_DOC_REG
                  (REGISTRATION_NO,
                   REQUEST_ID,
                   DOCUMENTS_TYPE_ID,
                   SL_NO,
                   STATUS_ID,
                   FILE_NM,
                   FILE_NAVIGATE_URL,
                   FOLDER_LOCATION,
                   HO_UPLOAD_FLAG,
                   BR_UPLOAD_FLAG,
                   REMARKS,
                   SYS_GEN_FLAG,
                   AUTH_STATUS_ID,
                   MAKE_BY,
                   MAKE_DT,
                   AUTH_BY,
                   AUTH_DT
                   )

      VALUES
                (pregistration_no,
                 prequest_id,
                 pdocuments_type_id,
                 pdocsl_no,
                 NULL,
                 pfile_nm,
                 pfile_navigate_url,
                 pfolder_location,
                 v_ho_upload_flag,
                 v_br_upload_flag,
                 premarks,
                 psys_gen_flag,
                 pauth_status_id,
                 puser_id,
                 SYSDATE,
                 CASE WHEN UPPER(pauth_status_id) = UPPER(c_auth_status_authorized) THEN puser_id END,
                 CASE WHEN UPPER(pauth_status_id) = UPPER(c_auth_status_authorized) THEN SYSDATE END
                )
     RETURNING REQUEST_ID
        INTO v_request_id;

/*     prequest_id_out := v_request_id;*/

    <<EXIT_ABORT>>
    NULL;

    EXCEPTION
      WHEN OTHERS THEN
          perrorcode := SQLCODE;
          perrormsg  := SQLERRM;
    END fsp_addup_sp_doc_register;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 PROCEDURE fsp_get_documents_typ

       (
         presult             OUT SYS_REFCURSOR
       )
   IS
   BEGIN
     OPEN presult FOR
     SELECT t.documents_type_id
          , t.documents_type_nm
       FROM sebl_sp_documents_type t
      WHERE t.status = 1;

   END fsp_get_documents_typ;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 PROCEDURE fsp_delete_documents_file
         (
           prequest_id          IN sebl_sp_doc_reg.request_id%TYPE
         , pmake_by             IN sebl_sp_doc_reg.make_by%TYPE
         , pdocsl_no            IN sebl_sp_doc_reg.sl_no%TYPE
         , perrorcode           OUT INTEGER
          ,perrormsg            OUT VARCHAR2
         )
   IS
   BEGIN
     UPDATE sebl_sp_doc_reg r
        SET r.auth_status_id='D'
          , r.make_by=pmake_by
          , r.make_dt=SYSDATE
      WHERE r.request_id = prequest_id
        AND r.sl_no=pdocsl_no;

   EXCEPTION
      WHEN OTHERS THEN
          perrorcode := SQLCODE;
          perrormsg  := SQLERRM;

  END fsp_delete_documents_file;

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
FUNCTION get_sp_instrument
      (Registration_NO  nvarchar2) return varchar2 is
    v_Instrument_Number nvarchar2(5000);

  BEGIN

      FOR rec IN (SELECT DISTINCT t.instrument_number               Instrument_Number
                      FROM sebl_sp_southtech_import_data t
                    WHERE t.regno = Registration_NO
                 ) loop
        v_Instrument_Number := v_Instrument_Number || rec.instrument_number || ' ; ';

      END LOOP;
    RETURN(v_Instrument_Number);

  END get_sp_instrument;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

PROCEDURE rsp_get_sp_details_sebl
(
       pregistration_no    IN NVARCHAR2,
       pinstrument_number  IN NVARCHAR2,
       presult       OUT SYS_REFCURSOR
)
IS
BEGIN


OPEN presult FOR

SELECT x.*
    FROM
      (
      SELECT DISTINCT t.regno                           Registration_NO
                    , t.branchid                        Branch_Name
                    , t.accountno                       Account_Number
                    , t.issuename                       Customer_Name
                    , TO_CHAR(t.phone)                  Mobile_Number
                    , to_date(t.entrydate,'dd-mm-rrrr') Investment_Date
                    , t.issueamount                     Total_Amount
                    , get_sp_instrument(t.regno)        Sanchaypatra_No
                    , ''                                Face_Value_Amount
                    , t.sptypeid                        SanchayPatra_Type
                    , to_char(t.typedesc)               Customer_Type
                    , to_char(t.address)                Address

        FROM sebl_sp_southtech_import_data t

       UNION ALL

     SELECT DISTINCT c.reg_no                           Registration_NO
                   , c.branch_id                        Branch_Name
                   , c.pay_in_acc_no                    Account_Number
                   , p.customer_full_nm                 Customer_Name
                   , CASE WHEN ca.mobile IS NULL THEN ca.phone ELSE ca.mobile END Mobile_Number
                   , c.reg_date                         Investment_Date
                   , c.amount_ccy                       Total_Amount
                   , LISTAGG(TO_Char(ci.inst_pfx||ci.inst_start_no||
                       CASE WHEN ci.inst_start_no = ci.inst_end_no
                         THEN '' ELSE ' To ' END ||
                       CASE WHEN ci.inst_start_no = ci.inst_end_no
                         THEN '' ELSE To_char(ci.inst_end_no) END),' ; ')
                        WITHIN GROUP (ORDER BY C.reg_date) Sanchaypatra_No
                   , '' Face_Value_Amount
                   , c.product_id                       SanchayPatra_Type
                   , ''                                 Customer_Type
                   , ca.address1||''||ca.address2       Address

                 FROM cor_gsi_reg c
                    , cor_cus_profile p
                    , cor_gsi_reg_instrument ci
                    , table(customer.fxn_get_cust_address
                                (CASE WHEN c.customer_id IS NULL THEN c.group_id
                                   ELSE c.customer_id END
                                 ,NULL
                                 ,NULL
                                 ,NULL)
                            ) ca
                 WHERE c.customer_id = p.customer_id
                   AND c.reg_no = ci.reg_no
               GROUP BY c.reg_no
                     , c.branch_id
                     , c.pay_in_acc_no
                     , p.customer_full_nm
                     , CASE WHEN ca.mobile IS NULL THEN ca.phone ELSE ca.mobile END
                     , c.reg_date
                     , c.amount_ccy
                     , c.product_id
                     , c.reg_date
                     , ca.address1||''||ca.address2

      UNION ALL

          SELECT DISTINCT c.reg_no                      Registration_NO
                   , c.branch_id                        Branch_Name
                   , c.pay_in_acc_no                    Account_Number
                   , p.group_nm                         Customer_Name
                   , CASE WHEN ca.mobile IS NULL THEN ca.phone ELSE ca.mobile END Mobile_Number
                   , c.reg_date                         Investment_Date
                   , c.amount_ccy                       Total_Amount
                   , LISTAGG(TO_Char(ci.inst_pfx||ci.inst_start_no||
                       CASE WHEN ci.inst_start_no = ci.inst_end_no
                         THEN '' ELSE ' To ' END ||
                       CASE WHEN ci.inst_start_no = ci.inst_end_no
                         THEN '' ELSE To_char(ci.inst_end_no) END),' ; ')
                        WITHIN GROUP (ORDER BY C.reg_date) Sanchaypatra_No
                   , '' Face_Value_Amount
                   , c.product_id                       SanchayPatra_Type
                   , ''                                 Customer_Type
                   , ca.address1||''||ca.address2       Address
             FROM cor_gsi_reg c
                , cor_cus_group_profile p
                , cor_gsi_reg_instrument ci
                , table(customer.fxn_get_cust_address
                                (CASE WHEN c.customer_id IS NULL THEN c.group_id
                                   ELSE c.customer_id END
                                 ,NULL
                                 ,NULL
                                 ,NULL
                                 )
                         ) ca
             WHERE c.group_id = P.group_id
               AND c.reg_no = ci.reg_no
        GROUP BY c.reg_no
                     , c.branch_id
                     , c.pay_in_acc_no
                     , p.group_nm
                     , CASE WHEN ca.mobile IS NULL THEN ca.phone ELSE ca.mobile END
                     , c.reg_date
                     , c.amount_ccy
                     , c.product_id
                     , c.reg_date
                     , ca.address1||''||ca.address2
      ) x
WHERE x.Registration_NO = NVL(pregistration_NO,x.Registration_no)
   AND x.Sanchaypatra_No = NVL(pinstrument_number,x.Sanchaypatra_No);

END rsp_get_sp_details_sebl ;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

PROCEDURE rsp_get_sp_request_master
(
       pbranch_id          IN NVARCHAR2,
       prequest_id         IN NVARCHAR2,
       prequest_status_id  IN NVARCHAR2,
       pregistration_no    IN NVARCHAR2,
       psanchay_patra_no   IN NVARCHAR2,
       pcustomer_name      IN NVARCHAR2,
       pcustomer_mobile_no IN NVARCHAR2,
       presult       OUT SYS_REFCURSOR
)
IS
BEGIN

IF prequest_status_id = 99 THEN

OPEN presult FOR

SELECT t.branch_id
     , t.request_id
     , t.registration_no
     , t.sanchay_patra_no
     , t.customer_name
     , t.customer_acc_no
     , t.customer_mobile_no
     , t.investment_date
     , t.total_investment
     , t.paid_amount
     , t.face_value
     , t.start_coupon_no
     , t.end_coupon_no
     , t.no_of_coupon
     , s.request_status_nm
     , t.remarks
     , t.walk_in_customer
     , t.make_by
     , t.make_date
    FROM SEBL_SP_REQUEST_MASTER t
       , sebl_edf_request_status_param s
 WHERE t.request_status_id IN (c_req_status_claim,c_req_status_in_process)
    AND t.branch_id = NVL(pbranch_id,t.branch_id)
    AND t.request_id = NVL(prequest_id,t.request_id)
    AND t.registration_no = NVL(pregistration_no,t.registration_no)
    AND t.sanchay_patra_no LIKE '%'||NVL(psanchay_patra_no,t.sanchay_patra_no)||'%'
    AND t.customer_name LIKE '%'||NVL(pcustomer_name,t.customer_name)||'%'
    AND t.request_status_id = s.request_status_id;
/*    AND t.customer_mobile_no = NVL(pcustomer_mobile_no,t.customer_mobile_no) ;*/

ELSE

OPEN presult FOR

SELECT t.branch_id
     , t.request_id
     , t.registration_no
     , t.sanchay_patra_no
     , t.customer_name
     , t.customer_acc_no
     , t.customer_mobile_no
     , t.investment_date
     , t.total_investment
     , t.paid_amount
     , t.face_value
     , t.start_coupon_no
     , t.end_coupon_no
     , t.no_of_coupon
     , s.request_status_nm
     , t.remarks
     , t.walk_in_customer
     , t.make_by
     , t.make_date
    FROM SEBL_SP_REQUEST_MASTER t
       , sebl_edf_request_status_param s
 WHERE t.request_status_id = NVL(prequest_status_id,t.request_status_id)
    AND t.branch_id = NVL(pbranch_id,t.branch_id)
    AND t.request_id = NVL(prequest_id,t.request_id)
    AND t.registration_no = NVL(pregistration_no,t.registration_no)
    AND t.sanchay_patra_no LIKE '%'||NVL(psanchay_patra_no,t.sanchay_patra_no)||'%'
    AND t.customer_name LIKE '%'||NVL(pcustomer_name,t.customer_name)||'%'
    AND t.request_status_id = s.request_status_id ;

END IF ;

END rsp_get_sp_request_master ;

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
PROCEDURE rsp_get_sp_request_doc_master
(
   pbranch_id          IN NVARCHAR2,
   prequest_id         IN NVARCHAR2,
   prequest_status_id  IN NVARCHAR2,
   pregistration_no    IN NVARCHAR2,
   psanchay_patra_no   IN NVARCHAR2,
   pcustomer_name      IN NVARCHAR2,
   pcustomer_mobile_no IN NVARCHAR2,
   presult       OUT SYS_REFCURSOR
)
IS
BEGIN

IF prequest_status_id = 99 THEN

OPEN presult FOR

SELECT t.branch_id
     , t.request_id
     , t.registration_no
     , sd.sl_no
     , dt.documents_type_nm
     , sd.file_nm
     , sd.file_navigate_url
     , sd.folder_location
     , t.make_by
     , t.make_date
    FROM sebl_sp_request_master t
       , sebl_edf_request_status_param s
       , sebl_sp_doc_reg sd
       , sebl_sp_documents_type dt
 WHERE t.request_status_id = s.request_status_id
    AND t.request_id = sd.request_id
    AND t.registration_no = sd.registration_no
    AND sd.documents_type_id = dt.documents_type_id
    AND t.request_status_id IN (c_req_status_claim,c_req_status_in_process)
    AND t.branch_id = NVL(pbranch_id,t.branch_id)
    AND t.request_id = NVL(prequest_id,t.request_id)
    AND t.registration_no = NVL(pregistration_no,t.registration_no)
    AND t.sanchay_patra_no LIKE '%'||NVL(psanchay_patra_no,t.sanchay_patra_no)||'%'
    AND t.customer_name LIKE '%'||NVL(pcustomer_name,t.customer_name)||'%'
    AND sd.auth_status_id = 'A'
 ORDER BY sd.documents_type_id ;

ELSE

OPEN presult FOR

SELECT t.branch_id
     , t.request_id
     , t.registration_no
     , sd.sl_no
     , dt.documents_type_nm
     , sd.file_nm
     , sd.file_navigate_url
     , sd.folder_location
     , t.make_by
     , t.make_date
    FROM sebl_sp_request_master t
       , sebl_edf_request_status_param s
       , sebl_sp_doc_reg sd
       , sebl_sp_documents_type dt
 WHERE t.request_status_id = s.request_status_id
    AND t.request_id = sd.request_id
    AND t.registration_no = sd.registration_no
    AND sd.documents_type_id = dt.documents_type_id
    AND t.request_status_id = NVL(prequest_status_id,t.request_status_id)
    AND t.branch_id = NVL(pbranch_id,t.branch_id)
    AND t.request_id = NVL(prequest_id,t.request_id)
    AND t.registration_no = NVL(pregistration_no,t.registration_no)
    AND t.sanchay_patra_no LIKE '%'||NVL(psanchay_patra_no,t.sanchay_patra_no)||'%'
    AND t.customer_name LIKE '%'||NVL(pcustomer_name,t.customer_name)||'%'
    AND sd.auth_status_id = 'A'
 ORDER BY sd.documents_type_id ;
END IF ;

END rsp_get_sp_request_doc_master;
/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

END pkg_sp_management_sebl;
/
