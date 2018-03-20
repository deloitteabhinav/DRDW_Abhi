/****************************************************************************************************************************************** 
 * Class Name   : CreateDataAssetController
 * Description  : Class to Create a Data Asset from the UI Page
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class CreateDataAssetController {
    Public Data_asset__c oDataAsset{get;set;}
    /*getter setters to be removed after R20*/
    public Transient Blob attachmentBody1 {get;set;}
    public String attachmentName1 {get;set;}
    public Transient Blob attachmentBody2 {get;set;}
    public String attachmentName2 {get;set;}
    public Transient Blob attachmentBody3 {get;set;}
    public String attachmentName3 {get;set;}
    public Boolean isSaved{get;set;}

    //Loading the constructor the page
    Public CreateDataAssetController(apexpages.standardcontroller stdCon) {

        Try{
            if (ApexPages.currentPage().getParameters().get('id') == NULL) {
                oDataAsset = new Data_asset__c();
            } else {
                String SobjectApiName = 'Data_asset__c';
                Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
                String commaSepratedFields = '';
                for (String fieldName: fieldMap.keyset()) {
                    if (commaSepratedFields == null || commaSepratedFields == '') {
                        commaSepratedFields = fieldName;
                    } else {
                        commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                    }
                }
    
                string query = 'select ' + string.escapeSingleQuotes(commaSepratedFields) + ' from ' + string.escapeSingleQuotes(SobjectApiName) + ' where id =\'' + string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id')) + '\' limit 1';
                oDataAsset = Database.query(query);
            }
          }
       Catch(Exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
            insert errlog;
        }

    }
        
      //Method to be removed after R20
      Public pagereference saveApplicant() {return null;}

}