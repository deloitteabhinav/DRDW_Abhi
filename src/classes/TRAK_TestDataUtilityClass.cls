/*
*@ Class Name                                                    : GLBL_FormTemplateActions
*@ Description                                                   : Class for creation of Test dats for Text class usage ( LaunchPad)
*@ CreatedBy                                                     : Jayalakshmi Mohanan Pillai
*@ CreatedOn                                                     : 08-21-2014
*@ Modification Log                                              : On 12-02-2014, modified the folowing :
                                                                      1) End date to be after start Date due to new custom validation rule in create Form template method 
                                                                      2) Question type cannot be blank  : added Type                                   
*/


@isTest
public class TRAK_TestDataUtilityClass {
    
    // Class level Variable declaration
    public Static Final String TYPE_LAUNCHPAD = 'Launchpad Assessment';
    public static final string LPADUSER = 'LAPD_User';
    public static final string LPADADMIN = 'LAPD_Admin';
    
    
    public static User createLPADAdmin(){
          
        PermissionSet psLpadAdmin = [SELECT ID From PermissionSet WHERE Name =: LPADADMIN];
        Profile p = [SELECT Id FROM Profile WHERE Name='GSO Basic User_Platform'];          
        PermissionSetAssignment PSAssignments = new PermissionSetAssignment();
        
        //Create Lpad Admin
        User LpadAdmin1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',profileId = p.id, 
                          LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='LpadAdmin@testorg.com');
        
        insert LpadAdmin1;
        
        PSAssignments.AssigneeId = LpadAdmin1.id;
        PSAssignments.PermissionSetId = psLpadAdmin.ID;
        
        insert PSAssignments;
        
        return LpadAdmin1;                    
        
    }
    
    public static User createLPADUser(){
        PermissionSet psLpadUser = [SELECT ID From PermissionSet WHERE Name =: LPADUSER];
        Profile p = [SELECT Id FROM Profile WHERE Name='GSO Basic User_Platform'];   
        PermissionSetAssignment PSAssignments = new PermissionSetAssignment();
        
        //Create Lpad User
        User LpadUser1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',profileId = p.id, 
                          LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='LpadUser@testorg.com');
        insert LpadUser1;
        
        PSAssignments.AssigneeId = LpadUser1.id;
        PSAssignments.PermissionSetId = psLpadUser.ID;
        
        insert PSAssignments;                         
        
        return LpadUser1;
    }
     
       
      
     /* 
          * @Method Name                    :  createErrorLof
          * @Description                    :  This Method is used to log the Error Message in Global Error Log Object. 
          * @Return Type                    :  void
          * @Param                          :  Exception
                                            
      */
      public static void createErrorLog(Exception e) {
           system.debug('Exception occurred during query of form template or form template question' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
          
      }
      
}