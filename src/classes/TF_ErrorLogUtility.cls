/* Class Name   :  TF_ErrorLogUtility 
 * Description  :  Utility Class to log Errors in the Error Object
 * Created By   :  Deloitte
 * Created On   :  02-08-2016

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * 
*/

Public class TF_ErrorLogUtility{

 /**
    * Method name  : createErrorLog
    * Description  : This method will log all the general exceptions encountered
    * Return Type  : None
    * Parameter    : Exception, wErrorLog (Wrapper class with additional error info)
    **/


    public Static void createErrorLog(Exception excep, TF_ErrorLogWrapper wErrorLog){
        
        GLBL_Error_Log__c oErrorlog = new GLBL_Error_Log__c();
        oErrorlog.GLBL_Class_Name__c = wErrorLog.wClassName;
        oErrorlog.GLBL_Method_Name__c = wErrorLog.wMethodName;
        oErrorlog.Stack_Trace__c = excep.getStackTraceString();
        // oErrorlog.Error_Code__c = string.valueOf(excep.getStatusCode());
        oErrorlog.Error_Datetime__c = DateTime.Now();
        oErrorlog.Error_Message__c = excep.getMessage();
        oErrorlog.Additional_Information__c = wErrorLog.wAdditionalInformation;
        oErrorlog.Running_User__c = UserInfo.getUserId();
        oErrorlog.Severity__c = Integer.valueOf(wErrorLog.wSeverity);
        
        insert oErrorlog; 
       
    }


    

}