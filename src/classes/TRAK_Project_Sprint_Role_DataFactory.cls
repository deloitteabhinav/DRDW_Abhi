@isTest
public class TRAK_Project_Sprint_Role_DataFactory{
    public static User createUser(String UserName, String Email, String PermSet){
                User User1 = new User(Alias = 'TestUser',
                  Email             = Email,
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'TestUser',
                  FirstName         = UserName,
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'testUser@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
      
        insert User1;
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: PermSet];
        PermissionSetAssignment Assign = New PermissionSetAssignment();
        Assign.AssigneeId=USer1.ID;
        Assign.PermissionSetId=pSet.ID;
        Insert Assign;        
        return User1;
    }
    /*
    public static TRAK_Project__c createProject(String projectName){
        TRAK_Project__c newProject = new TRAK_Project__c();
        newProject.name = projectName; 
        return newProject;       
    }
    public static TRAK_Sprint__c createSprint(String SprintName, TRAK_Project__c Project, Date StartDate, Date EndDate){
        TRAK_Sprint__c newSprint = new TRAK_Sprint__c();
        newSprint.Name = SprintName;
        newSprint.Project__c = Project.id;
        newSprint.Start_Date__c = StartDate;
        newSprint.End_Date__c = EndDate; 
        return newSprint;      
    }
    */
  /*  public static TRAK_Delivery_Team__c createRole(TRAK_Sprint__c Sprint, String Role, User UserName, String Location){
        TRAK_Delivery_Team__c newRole = new TRAK_Delivery_Team__c();
        newRole.Sprint__c = Sprint.Id;
        newRole.Role__c = Role;
        newRole.User__c = UserName.Id;
        newRole.Location__c = Location;
        return newRole;    
    }
    public static TRAK_Resource_Billing_Matrix__c createResourceBilling(String Role, String Location, Decimal BillableHours, Decimal Rate, String RecordTypeName){
        TRAK_Resource_Billing_Matrix__c newResourceBilling = new TRAK_Resource_Billing_Matrix__c();
        RecordType RecId = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName =: RecordTypeName];
        newResourceBilling.Billable_Hours__c = BillableHours;
        newResourceBilling.Billing_Rate__c = Rate;
        newResourceBilling.Location__c  = Location;
        newResourceBilling.Role__c  = Role;
        newResourceBilling.RecordTypeId = RecId.Id;
        return newResourceBilling;
    }*/
}