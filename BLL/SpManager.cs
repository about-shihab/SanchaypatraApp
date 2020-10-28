using DAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace BLL
{
    public class SpManager
    {
        SpGateway spGateway = new SpGateway();
        public DataTable GetAllBranch(string pbranch_id, string pmodule_id)
        {
            return spGateway.GetAllBranch(pbranch_id, pbranch_id);
        }
        public DataTable GetAllDocumentType()
        {
            return spGateway.GetAllDocumentType();
        }
        public DataTable ClaimSpRequest(Dictionary<string, object> inputHt)
        {
            return spGateway.ClaimSpRequest(inputHt);
        }
        public Dictionary<string, object> TransactionInsertRequest(Dictionary<string, object> requestInputParamHt, List<Dictionary<string, object>> spFacevalueParamHtList, List<Dictionary<string, object>> fileInputParamHtList)
        {
            return spGateway.TransactionInsertRequest(requestInputParamHt, spFacevalueParamHtList, fileInputParamHtList);
        }
        public DataTable GetSpDetailsByReg(string regNo)
        {
            return spGateway.GetSpDetailsByReg(regNo);
        }

        public DataTable GetRspMasterData(Dictionary<string, object> inputHt)
        {
            
            return spGateway.GetRspMasterData(inputHt);
        }
        public DataTable GetFileInfo(Dictionary<string, object> inputHt)
        {

            return spGateway.GetFileInfo(inputHt);
        }
        public DataTable DeleteFile(Dictionary<string, object> inputHt)
        {
            return spGateway.DeleteFile(inputHt);
        }
        public DataTable GetImportedSpFacevalue(Dictionary<string, object> inputHt)
        {
            return spGateway.GetImportedSpFacevalue(inputHt);
        }
        public DataTable GetSpFacevalue(Dictionary<string, object> inputHt)
        {
            return spGateway.GetSpFacevalue(inputHt);
        }
        public void InsertAdditionalFile(List<Dictionary<string, object>> fileInputParamHtList, string requestId)
        {
             spGateway.InsertAdditionalFile(fileInputParamHtList,requestId);
        }
    }
}
