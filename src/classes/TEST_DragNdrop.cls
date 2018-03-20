/****************************************************************************************************************************************** 
 * Class Name   : Test_DragNdrop
 * Description  : Test Class for DragNdrop Class
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@
isTest(SeeAllData = false)
public with sharing class TEST_DragNdrop {

    /* 
     * @Method Name                    :  TestDragnDrop
     * @Description                    :  Method to Test DragNdrop class
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    static testMethod void TestDragnDrop() {

        User u = DataFactory1.getTestingUser();
        DataFactory1.givePermissions(u.id, 'Admin');

        System.runAs(u) {

            //Inserting Simulation
            List < Simulation__c > lSimulations = DataFactory1.returnSimulations(1);
            insert lSimulations;
            System.assertNotEquals(lSimulations.size(), 0);

            Test.startTest();

            //Testing for Chrome Browser
            PageReference pageRef = Page.DragNdrop;
            pageRef.getHeaders().put('USER-AGENT', 'Chrome');
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id',lSimulations[0].Id);

            ApexPages.StandardController controller = new ApexPages.StandardController(lSimulations[0]);
            DragNdrop oController = New DragNdrop(controller);
            
            //Inserting Text File with Tab seperated values
            String sTextFileData;
            sTextFileData = 'contentLabel' + '\t' + 'label0' + '\t' + 'label1' + '\t' + 'label2' + '\t' + 'Magnets' + '\t' + 'name' + '\t' + 'id' ;
            sTextFileData = sTextFileData + '\n';
            sTextFileData = sTextFileData + 'TestContent' + '\t' + 'Test' + '\t' + 'Test' +  'Test' + '\t' + 'Test' + '\t' + 'General' + '\t' + '90';
            oController.sAttachmentName = 'TestFileName.txt';
            Blob bFile = Blob.valueOf(sTextFileData);
            oController.sAttachment =  EncodingUtil.base64Encode(bFile);
            oController.sFileType = 'text/plain';          
            oController.saveValues();
            
            //Inserting CSV File
            String sCsvFileData;
            sCsvFileData = 'contentLabel' + '\t' + 'label0' + '\t' + 'label1' + '\t' + 'label2' + '\t' + 'Magnets' + '\t' + 'name' + '\t' + 'id';
            sCsvFileData = sCsvFileData + '\n';
            sCsvFileData = sCsvFileData + 'TestContent' + '\t' + 'Test' + '\t' + 'Test' + 'Test' + '\t' + 'Test' + '\t' + 'General' + '\t' + '91';
            oController.sAttachmentName = 'TestFileName2.csv';
            Blob bFile2 = Blob.valueOf(sCsvFileData);
            oController.sAttachment =  EncodingUtil.base64Encode(bFile2);
            oController.sFileType = 'application/vnd.ms-excel'; 
            oController.saveValues();   
            
            //Testing for IE Browser
            PageReference pageRef2 = Page.DragNdrop;
            pageRef2.getHeaders().put('USER-AGENT', 'Trident');
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('Id',lSimulations[0].Id);

            ApexPages.StandardController controller2 = new ApexPages.StandardController(lSimulations[0]);
            DragNdrop oController2 = New DragNdrop(controller2);
            
            //Inserting Text File with Tab seperated values
            String sTextFileData2;
            sTextFileData2 = 'contentLabel' + '\t' + 'label0' + '\t' + 'label1' + '\t' + 'name' + '\t' + 'id';
            sTextFileData2 = sTextFileData2 + '\n';
            sTextFileData2 = sTextFileData2 + 'TestContent' + '\t' + 'Test' + '\t' + 'Quick Win' + '\t' + 'General' + '\t' + '92';
            Blob bFile3 = Blob.valueOf(sTextFileData);
            oController2.sAttachmentName = 'TestFileName3.txt';
            oController2.sAttachmentIE = bFile3;
            oController2.sFileType = 'text/plain';
            oController2.saveValues();   
            
            Test.stopTest();

        }
    }

}