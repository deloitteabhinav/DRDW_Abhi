/* Class Name   : Test_TRAK_ErrorHandler
 * Description  : test class for TRAK_ErrorHandler
 *
 * Created By   : Deloitte
 * Created On   : 27/05/2016

 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Modification ID      Description
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * 
*/
@isTest
public class Test_TRAK_ErrorHandler{
     static testmethod void testcreateApplicationException() { 
         test.startTest();
         TRAK_ErrorHandler.createApplicationException('TRAK_Dummy','dummy','dummy','dummy');  
         test.stopTest();
         system.assertEquals([SELECT count() from GLBL_Error_Log__c],1);
     }
}