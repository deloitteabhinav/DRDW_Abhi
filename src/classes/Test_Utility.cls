/*
*@ Class Name                                                    : TRFO_Test_Utility_Class
*@ Description                                                   : Test Class to create test Data for test Classes
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 23-04-2015
*@ Modification Log                                              :                     
*/

public class Test_Utility{

   public static List <User> createUser(String prof, Integer NoOfUsers, String add) {
    String profileQueryString = '%'+prof+'%';
        Profile p = [SELECT Id FROM Profile WHERE Name like :profileQueryString Limit 1];
        List <User> userLst = new List<User>();    
        for (Integer i=0; i<NoOfUsers; i++) {
            User u = new User(Alias = 'st'+i+add, Email='a'+add+i+'trfouser@testorg.com', LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='a'+add+i+'trfouser@testorg.com', UserPermissionsMarketingUser = true); 
            userLst.add(u);   
            
        }    
 
        insert userLst;                             
        return userLst;
    }
    
    

    /* 
     * Method name : createUserwithUserRole
     * Description :  This method is used to create User with a userrole assigned
     * Param :  Profile name
     * Returns :  User
    */
    

    public static List <User> createUserwithUserRole(String prof, Integer NoOfUsers, String add) {
    String profileQueryString = '%'+prof+'%';
        Profile p = [SELECT Id FROM Profile WHERE Name like :profileQueryString Limit 1];
        UserRole ur = [Select Id,Name From UserRole limit 1];
        List <User> userLst = new List<User>();    
        for (Integer i=0; i<NoOfUsers; i++) {
            User u = new User(Alias = 'st'+i+add, Email='a'+add+i+'trfouser@testorg.com', LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ProfileId = p.Id,UserRoleId = ur.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='a'+add+i+'trfouser@testorg.com', UserPermissionsMarketingUser = true);  
            userLst.add(u);      
        }    
 
        insert userLst;                             
        return userLst;
    }  
    
      public static List <User> createUserwithSpecificRole(String prof, Integer NoOfUsers, String add,String roleName) {
        Profile p = [SELECT Id FROM Profile WHERE Name=:prof];
        UserRole ur = [Select Id,Name From UserRole where Name =: roleName limit 1];
        List <User> userLst = new List<User>();    
        for (Integer i=0; i<NoOfUsers; i++) {
            User u = new User(Alias = 'st'+i+add, Email='a'+add+i+'trfouser@testorg.com', LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ProfileId = p.Id,UserRoleId = ur.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='a'+add+i+'trfouser@testorg.com', UserPermissionsMarketingUser = true);  
            userLst.add(u);      
        }    
 
        insert userLst;                             
        return userLst;
    }  
    
    
    
    //Create userRole
    public static List<UserRole> createUserRole(Integer i){
        List<UserRole> roleLst = new List<UserRole>();
        for(Integer count = 0; Count <= i; count ++){
            UserRole oRole = new UserRole();
            oRole.Name = 'AP CDC';
            roleLst.add(oRole);
        }
        return roleLst;
    }
}