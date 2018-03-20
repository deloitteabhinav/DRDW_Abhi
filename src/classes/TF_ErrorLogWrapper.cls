/* Class Name   :  TF_ErrorLogWrapper 
 * Description  :  Utility Wrapper Class for Error Object
 * Created By   :  Deloitte
 * Created On   :  02-08-2016

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * 
*/

Public class TF_ErrorLogWrapper{

    Public String wClassName;
    Public String wMethodName;
    Public String wDataSFDCID;
    Public String wErrorCode;
    Public String wAdditionalInformation;
    Public String wSeverity;
    
    //Wrapper Constructor
    public TF_ErrorLogWrapper(String wClassName, String wMethodName, String wAdditionalInformation, String wSeverity){
        
        this.wClassName = wClassName;
        this.wMethodName = wMethodName;
        this.wAdditionalInformation = wAdditionalInformation;
        this.wSeverity = wSeverity;
        
    }
}