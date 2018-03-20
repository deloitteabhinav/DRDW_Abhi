/* Class Name   :   TRAK_ErrorHandler 
 * Description  :  Utility Class to log errors in the Error Object
 * Created By   :  Deloitte
 * Created On   :  27-05-2016

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * 
*/
public with sharing class TRAK_ErrorHandler {  
    
    /**
    * Method name  : createApplicationException
    * Description  : This method will log all the general exceptions encountered
    * Return Type  : None
    * Parameter    : Exception, Name of the sObject, DML Type, Component of the error, Class or Trigger Name, severity
    **/
    public static void createApplicationException(String className, String methodName, String exceptionStackTrace, String exceptionType) {
        GLBL_Error_Log__c log         = new GLBL_Error_Log__c();
        log.Error_Message__c          = exceptionType;
        log.Error_Datetime__c         = Date.today();
        log.Running_User__c           = UserInfo.getUserId();
        log.Stack_Trace__c            = exceptionStackTrace;   
        log.Additional_Information__c = 'Class name: '+ className + 'Method name: ' + methodName;
        insert log; 
                
    }
}