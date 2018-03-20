/*
*@ Class Name                                                    : TRAK_AttachmentSuccessStory_Extension
*@ Description                                                   : Class for attaching Logo
*@ CreatedBy                                                     : Karthik Reddy Pullagurla
*@ CreatedOn                                                     : 07-13-2015
*@ Modification Log                                              :                                      
*/

public with sharing class TRAK_AttachmentSuccessStory_Controller{
  
    // Class level Variable declaration
  //  private TRAK_App__c app;
    private Id attachParentId;    
    private List<Attachment> attachmentlist;
    
    // Constructor  
    public TRAK_AttachmentSuccessStory_Controller() {        
    
    }
    
    
  
    
    
    /* 
          * @Method Name                    :  savecontent
          * @Description                    :  This Method will is invoked by page action parameter on click of button Attach Logo
          * @Return Type                    :  Pagereference
          * @Param                          :  pagereference to the App detail page on which the Attach Logo button was clicked
                                            
    */
    public pagereference saveApp(){
        if(ApexPages.currentPage().getParameters().containsKey('id')){
                attachParentId = ApexPages.currentPage().getParameters().get('id');   
                                          
        }      
        
        if (attachParentId != NULL) {
             
            try {   
           /*     app = [ SELECT id,App_Logo__c FROM TRAK_App__c
                                 WHERE id=: attachParentId]; */
                                
                attachmentList=[SELECT id 
                                FROM attachment 
                                WHERE parentid=:attachParentId 
                                ORDER BY CreatedDate DESC 
                                LIMIT 1];
                
                string pUrl =  string.valueof(URL.getSalesforceBaseUrl());
                string[] splitBaseURL = pUrl.split('=',2);
                
                if(attachmentList.size() > 0 ){                             
                     /*
                    app.App_Logo__c = splitBaseURL[1].substring(0,splitBaseURL[1].length()-1)+'/servlet/servlet.FileDownload?file='+attachmentList[0].id;          
                    system.debug('app.App_Logo__c ' + app.App_Logo__c);  
                     */
                }
            }    
            catch(QueryException ex) {           TF_ErrorLogUtility.createErrorLog(ex, new TF_ErrorLogWrapper('TRAK_AttachmentSuccessStory_Controller', 'saveApp','','1'));}
                    
                
        }   
        
         /*if(app != NULL){
            try { 
                   if(TRAK_App__c.SObjectType.getDescribe().isUpdateable())
                    update app;
            }
            catch(DMLException e) {
                    System.debug('Exception occurred during insert of update of App record for App Logo' + e);
                    GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                                     Error_Message__c= e.getMessage(),
                                                                     Running_User__c = UserInfo.getUserId() ,
                                                                     Stack_Trace__c = e.getStackTraceString());
                    if(GLBL_Error_Log__c.SObjectType.getDescribe().isCreateable())                                                  
                        insert errlog;  
            }
      
        }    */       
                
        PageReference contPage = new PageReference('/' + attachParentId);
        contPage.setRedirect(true);
        return contPage;
    }
                
    

}