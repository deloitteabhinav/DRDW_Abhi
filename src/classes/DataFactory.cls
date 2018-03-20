/****************************************************************************************************************************************** 
 * Class Name   : DataFactory
 * Description  : Utility Class for Creating Test Data for SMI Project
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@isTest
public with sharing class DataFactory 
{
    
    /* 
     * @Method Name                    :  getTestingUser
     * @Description                    :  Creates a Test User
     * @Return Type                    :  User
     * @Parameters                     :  None
     */
    public static User getTestingUser() 
    {

        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'GSO Basic User_Platform'].Id;
        String rId = [select id from UserRole where Name = 'Lilly Employee'].Id;
        u = new User(profileId = pId, userRoleId = rId, email = uniqueName + '@test' + uniqueName + '.org',
            Username = uniqueName + '@test' + uniqueName + '.org',
            alias = 'UsAlias', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
            languagelocalekey = 'en_US', timezonesidkey = 'GMT');

        insert u;
        return u;

    }
    /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    
    
    /* 
     * @Method Name                    :  givePermissions
     * @Description                    :  Assigning Permission Set to a User
     * @Return Type                    :  void
     * @Parameters                     :  UserID,PSetName
     */
    public static void givePermissions(id UserID, string PSetName) 
    {
        PermissionSet ps = [Select id From PermissionSet WHERE Name = : PSetName];
        PermissionSetAssignment psAssignments = new PermissionSetAssignment(AssigneeId = UserID, PermissionSetId = ps.id);
        insert psAssignments;
    }
    
    /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    
    
    /* 
     * @Method Name                    :  assignToPublicGroup
     * @Description                    :  Assigning User to public group
     * @Return Type                    :  void
     * @Parameters                     :  User Id and Group Name
     */
    public static void assignToPublicGroup(Id userID, String groupName) 
    {
        Group g = [Select Id from Group where DeveloperName =:groupName];
        GroupMember gm = new GroupMember(GroupId=g.Id,UserOrGroupId =userID);
        insert gm ;
    }
    
    /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
     
    
    /* 
     * @Method Name                    :  getRecordTypeId
     * @Description                    :  returns the ID of record type specific to sObject
     * @Return Type                    :  ID
     * @Parameters                     :  string sObjectName , string recTypeName
     */
    public static ID getRecordTypeId(string sObjectName , string recTypeName)
    {
        RecordType oRecType = [SELECT id FROM RecordType WHERE SobjectType =:sObjectName  AND developerName=:recTypeName limit 1];
        return oRecType.ID;
    }
     /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
     
    
    /* 
     * @Method Name                    :  returnSupplierAccounts
     * @Description                    :  returns a list of Supplier Accounts
     * @Return Type                    :  List of Accounts
     * @Parameters                     :  count
     */
    public static list <Account> returnSupplierAccounts(integer count)
    {
        list <Account> lAccount = new list <Account> ();
        ID RecTypeId= getRecordTypeId('Account','Supplier'); 
        Account oAcc;       
        for (integer i = 0; i < count; i++) 
        {
            oAcc= new Account();
            oAcc.RecordTypeID = RecTypeId;
            oAcc.Name = 'Test Supplier'+i;
            oAcc.OwnerId = userinfo.getUserID();
            oAcc.Industry = 'Not For Profit';
            oAcc.Relationship_Owner__c= userinfo.getUserID();
            oAcc.Executive_Sponsor__c = userinfo.getUserID();
            oAcc.SMO_Representative__c = userinfo.getUserID();
            oAcc.Tier__c='Tier 3+';
            //oAcc.Lilly_Locations_Operated_In__c='ABC XYZ';
            lAccount.add(oAcc);
        }
        return lAccount;
    }
    
    /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    /* 
     * @Method Name                    :  returnSupplierContacts
     * @Description                    :  returns a list of Contacts for a Supplier Accounts
     * @Return Type                    :  List of Contacts
     * @Parameters                     :  List of accounts and count
     */
     
    public static List<Contact> returnSupplierContacts(List<Account> lAccount,integer count)
    {
        List<Contact> lContact = new List<Contact>();
     //   ID RecTypeId= getRecordTypeId('Contact','Supplier');   
        Contact oCon;     
        for(Account oAcc:lAccount)
        {
            for (integer i = 0; i < count; i++) 
            {
                oCon= new Contact();
                oCon.FirstName= 'Supplier Contact '+ i;
                oCon.LastName='for SupplierAccount';
                oCon.AccountId=oAcc.Id;
                oCon.Email='testSupplier'+i+'@test.com';
                oCon.Phone='1234567890';
                lContact.add(oCon);
            }
        }
        return lContact;
    }
    
    /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    /* 
     * @Method Name                    :  createQuestion
     * @Description                    :  creates a set of Test Questions
     * @Return Type                    :  List of Questions
     * @Parameters                     :  
     */
    public static List<Question__c> createQuestion(integer countQuestion, integer countContactQuestion)
    {
        List<Question__c> lQuestion=new List<Question__c>();
        Question__c ques;
        for (integer i = 0; i < countQuestion; i++)
        {
            ques=new Question__c();
            ques.Question__c='This is a test Question '+i;
            lQuestion.add(ques);
        }
        for (integer i = 0; i < countContactQuestion; i++)
        {
            ques=new Question__c();
            ques.Question__c='This is a test Question '+i;
            ques.Is_Contact_Specific__c=true;
            lQuestion.add(ques);
        }
        return lQuestion;
    }
    
     /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    /* 
     * @Method Name                    :  CreateContactAttachments
     * @Description                    :  returns a list of ContactAttachments
     * @Return Type                    :  List of Attachments
     * @Parameters                     :  Contact ID, Count of Attachments
     */
     
       public static List<Attachment> CreateContactAttachments(id ContactID,integer count)
       {
          List<Attachment> lImageAttachment = new List<Attachment>();
          Attachment bAttach;
          for(Integer i=0; i<count; i++)
             {
               bAttach = new Attachment();
               bAttach.Name= 'Test Image'+i;
               bAttach.Body=Blob.valueof('This is a Contact Imabge (in BLOB)');
               bAttach.ParentId=ContactID;
               bAttach.ContentType='image/png';
               lImageAttachment.add(bAttach);
            }
           return lImageAttachment;
       }
       
       
       /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    /* 
     * @Method Name                    :  returnSupplierEvents
     * @Description                    :  returns a list of Events associated to Suppliers
     * @Return Type                    :  List of Events
     * @Parameters                     :  List of Accounts & Event count
     */
     
       public static list<Event> returnSupplierEvents(list<Account> lAccounts,integer count)
        {
             
            List<Event> lEvents = new List<Event>();              
            Event oEvent;
            for(Account oAcc:lAccounts)
            {
                for(Integer i=0;i<count;i++)
                {
                    oEvent = new Event();
                    oEvent.WhatId= oAcc.id;
                    oEvent.ActivityDate = system.today();
                    oEvent.ActivityDateTime = system.now();
                    oEvent.DurationInMinutes = 30;
                    oEvent.Subject='Test Meeting'+i;
                    oEvent.Location='Saturn';
                    lEvents.add(oEvent);
                }
            }
            return lEvents;
        }
        
        
    /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    /* 
     * @Method Name                    :  returnSupplierTasks
     * @Description                    :  returns a list of Tasks associated to Suppliers
     * @Return Type                    :  List of Tasks
     * @Parameters                     :  List of Accounts & Task count
     */
     
       public static list<Task> returnSupplierTasks(list<Account> lAccounts,integer count)
        {
             
            List<Task> lTasks = new List<Task>();              
            Task oTask;
            for(Account oAcc:lAccounts)
            {
                for(Integer i=0;i<count;i++)
                {
                    oTask= new Task();
                    oTask.WhatId= oAcc.id;
                    oTask.Subject='Test Task'+i;
                    oTask.Priority='Normal';
                    oTask.Status = 'Not Started';
                    lTasks.add(oTask);
                }
            }
            return lTasks;
        }
}