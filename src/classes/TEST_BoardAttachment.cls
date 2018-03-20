/****************************************************************************************************************************************** 
 * Class Name   : Test_BoardAttachment
 * Description  : Test Class for BoardAttachment Class
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@
isTest(SeeAllData = false)
public with sharing class TEST_BoardAttachment {

    /* 
     * @Method Name                    :  TestBoardAttachment
     * @Description                    :  Method to Test BoardAttachment class
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    static testMethod void TestBoardAttachment() {

        User u = DataFactory1.getTestingUser();
        DataFactory1.givePermissions(u.id, 'User');

        System.runAs(u) {

            //Inserting Simulation
            List < Simulation__c > lSimulations = DataFactory1.returnSimulations(1);
            insert lSimulations;
            System.assertNotEquals(lSimulations.size(), 0);

            //Inserting Boards
            List < Boards__c > lBoards = DataFactory1.returnBoards(1, lSimulations);
            insert lBoards;
            System.assertNotEquals(lBoards.size(), 0);

            //Inserting Attachment for Boards
            List < Attachment > lAttachment = DataFactory1.CreateBoardAttachments(3, lBoards);
            insert lAttachment;
            System.assertNotEquals(lAttachment.size(), 0);

            Test.startTest();

            PageReference pageRef = Page.BoardAttachment;
            Test.setCurrentPage(pageRef);

            ApexPages.StandardController controller = new ApexPages.StandardController(lBoards[0]);
            BoardAttachment oController = New BoardAttachment(controller);

            Test.stopTest();

        }
    }

}