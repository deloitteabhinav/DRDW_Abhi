/* Class Name  : Test_Event_TriggerHandler
* Description  : Test Class for Event_TriggerHandler
* Created By   : Deloitte
* Created Date : 9th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public with sharing class Test_Event_TriggerHandler
{

    /* 
    * @Method Name                    :  testEvent
    * @Description                    :  Method to create & delete the Event created.
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testEvent() 
    {

        User u = DataFactory.getTestingUser();
        DataFactory.givePermissions(u.id, 'Supplier_Assessor');

        System.runAs(u) 
        {
        Test.startTest();
        
        list <Account> lAccounts= new list<Account>(DataFactory.returnSupplierAccounts(5));
        insert lAccounts;
        system.assertNotEquals(lAccounts.size(),0);
        
        list<Event> lEvents = new list<Event>(DataFactory.returnSupplierEvents(lAccounts,2));
        insert lEvents;
        system.assertNotEquals(lEvents.size(),0);
        
        delete lEvents;
        
        Test.stopTest();
        }
    }

}