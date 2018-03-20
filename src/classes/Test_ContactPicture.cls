/* Class Name  : Test_ContactPicture
* Description  : Test Class for ContactPicture
* Created By   : Deloitte
* Created Date : 8th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public with sharing class Test_ContactPicture
{

    /* 
    * @Method Name                    :  testContactPicture
    * @Description                    :  Method to test ContactPicture page by creating & fetching latest Image Attachment
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testContactPicture() 
    {

        User u = DataFactory.getTestingUser();
        DataFactory.givePermissions(u.id, 'Supplier_Assessor');

        System.runAs(u) 
        {
        Test.startTest();
        
        List<Account> lAccounts = new List<Account>();
        lAccounts = DataFactory.returnSupplierAccounts(2);
        insert lAccounts; // Insert Supplier Accounts
        
        List<Contact> lContacts = new List<Contact>();
        lContacts = DataFactory.returnSupplierContacts(lAccounts,3);
        insert lContacts; //Insert Contacts to the Supplier Accounts
        
        List<Attachment> lImageAttachments = new List<Attachment>();
        lImageAttachments = DataFactory.CreateContactAttachments(lContacts[0].id,5);
        insert lImageAttachments; //Insert Image Attachments to those Supplier Contacts
        
        PageReference pageRef = new PageReference('/'+lContacts[0].id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController oController = new ApexPages.StandardController(lContacts[0]);
        ContactPicture contPicture=new ContactPicture(oController );
        system.assertNotEquals(contPicture.getsAttachmentId(),null);  //Positive Scenario
        
        PageReference pageRef2 = new PageReference('/'+lContacts[1].id);
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController oController2 = new ApexPages.StandardController(lContacts[1]);
        ContactPicture contPicture2=new ContactPicture(oController2);
        system.assertEquals(contPicture2.getsAttachmentId(),null);    //Negative Scenario
        
        Test.stopTest();
        }
    }

}