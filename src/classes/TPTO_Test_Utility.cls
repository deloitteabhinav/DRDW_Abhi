/*
*@ Class Name                                                    : TPTO_Test_Utility Class
*@ Description                                                   : Test Class to create test Data for test Classes
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 1-03-2017
*@ Modification Log                                              : Nisha C O (1-03-2017)                   
*/
@isTest
public class TPTO_Test_Utility{

/* 
     * Method name : createPtoRequest
     * Description :  This method is used to create pto requests
     * Param :  Profile name
     * Returns :  User
*/
  public static List<TPTO_PTO_Request__c> createPtoRequest(Integer count,List<User> lead,List<User> BA){
    
    List<TPTO_PTO_Request__c> lstPTOReq = new List<TPTO_PTO_Request__c>();
    
    for(integer i=0;i<count;i++){
        TPTO_PTO_Request__c pto = new TPTO_PTO_Request__c();
        pto.Start_Date__c = system.today() + 20;
        pto.End_Date__c = system.today() + 22;
        pto.Type_of_Absence__c = 'Vacation';
        pto.Lead__c = lead[0].id;
        pto.BA__c = BA[0].id;
        pto.Absence_Comments__c = 'Test Comments';
        pto.Status__c = 'Draft'; 
        lstPTOReq.add(pto);
    }               
    return lstPTOReq;
  }
 
}