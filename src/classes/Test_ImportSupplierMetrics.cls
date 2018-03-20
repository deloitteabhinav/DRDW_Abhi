/* Class Name  : Test_ImportSupplierMetrics
* Description  : Test Class for ImportSupplierMetrics
* Created By   : Deloitte
* Created Date : 7th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public with sharing class Test_ImportSupplierMetrics
{

    /* 
    * @Method Name                    :  testImportData
    * @Description                    :  Method to test ImportSupplierMetrics page by importing Account(supplier), Supplier Metrics & Org Master data
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testImportData() 
    {

        User u = DataFactory.getTestingUser();
        u.Username='1234567'+'@gso1.lly';
        u.Alias='UsAlias';
        update u;
        DataFactory.givePermissions(u.id, 'Admin');

        System.runAs(u) 
        {
        Test.startTest();
        
            PageReference pageRef = new pageReference('/apex/ImportSupplierMetrics');
            Test.setCurrentPage(pageRef);
            ImportSupplierMetrics oController= new ImportSupplierMetrics();
            
            String sFailfile;
            sFailfile= 'Header1' + '\t' + 'Header2' + '\t' + 'Header3' + '\t' + 'Header4' + '\t' + 'Header5' + '\t' + 'Header6';
            sFailfile= sFailfile+ '\n';
            sFailfile= sFailfile+ 'test1' + '\t' + 'test12' + '\t' + 'test13' + 'test14' + '\t' + 'test15' + '\t' + 'test16';
            Blob bFile0 = Blob.valueOf(sFailfile);
            
            oController.sfilename= 'TestFileName0.xls';
            oController.csvFileBody = bFile0; 
            oController.ImportFile(); //Checks fail case with non-csv file
            
            oController.sfilename= 'TestFileName1.csv';
            oController.ImportFile(); //checks fail case with no Type selected
            
            oController.sType='SAP';
            oController.ImportFile(); //checks fail case with incorrect SAP file type
            
            oController.sType='Archer';
            oController.ImportFile(); //checks fail case with incorrect Archer file type
            
            oController.sType='Org Master';
            oController.ImportFile(); //checks fail case with incorrect Org Master file type
            
            /****** Testing Archer file ******/
            //Inserting Account Records first
            list <Account> lAccs = DataFactory.returnSupplierAccounts(3);
            insert lAccs;
            String sArcherfile;
            sArcherfile= 'Supplier Name,Supplier Tier,Supplier Org ID,Supplier Management Leadership Organization,Highest Inherent CSQ Classification,Highest Residual CSQ Classification,Highest Residual Business Impact Rating,Highest Inherent Business Impact Rating,Highest Information Class Hosted,Highest Information Class Handled,Relationship Overview,Supplier Management Plan Review Frequency,Executive Review Meeting Frequency,Supplier Management Plan Link,Supplier Relationship Owner,IT SMO Representative,Executive Sponsor,Executive Sponsor Global ID,Lilly Information Officer,Information Officer Global ID'+ '\n';
            sArcherfile= sArcherfile+'File Test 1,TIER3,test0,IT,Not Rated,Not Rated,Not Rated,Not Rated,Does Not Host Data,Does Not Handle Data,PENDING,,Never,,Username UsAlias,Username ABC UsAlias,SomeUsername,1234567,SomeUsername,1234567'+ '\n';
            sArcherfile= sArcherfile+'File Test 2,TIER3,test1,IT,Not Rated,Not Rated,Not Rated,Not Rated,Does Not Host Data,Does Not Handle Data,PENDING,,Never,,Username UsAlias,Username ABC UsAlias,SomeUsername,1234567,SomeUsername,1234567'+ '\n';
            sArcherfile= sArcherfile+'File Test 3,TIER3,test2,IT,Not Rated,Not Rated,Not Rated,Not Rated,Does Not Host Data,Does Not Handle Data,PENDING,,Never,,Username UsAlias,Username ABC UsAlias,SomeUsername,1234567,SomeUsername,1234567'+ '\n';
            sArcherfile= sArcherfile+'File Test 4,TIER3,Failtest5,IT,Not Rated,Not Rated,Not Rated,Not Rated,Does Not Host Data,Does Not Handle Data,PENDING,,Never,,Username UsAlias,Username ABC UsAlias,SomeUsername,1234567,SomeUsername,1234567'+ '\n';
            Blob bArcherFile = Blob.valueOf(sArcherfile);
            oController.csvFileBody = bArcherFile;
            oController.sfilename= 'TestArcherFile.csv';
            oController.sType='Archer';
            oController.ImportFile(); //checks correct & incorrect case with Archer file type
            
            system.assertEquals(oController.lnullAccount.size(),1);
            system.assertEquals(oController.lFinalAccount.size(),3);
            
            
            
            /****** Testing Org Master file ******/
            String sOrgMasterfile;
            sOrgMasterfile= 'ORG_BUS_ID1,ORG_PRMRY_NM2,VNDR_CD1'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'test0,Microsoft,11111'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'test0,Microsoft,22222'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'test0,Microsoft,33333'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'test1,Apple,44444'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'test1,Apple,55555'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'test2,Google,66666'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'Ftest4,FailCase1,77777'+ '\n';
            sOrgMasterfile= sOrgMasterfile+ 'Ftest5,FailCase2,'+ '\n';
            
            Blob bOrgMasterFile = Blob.valueOf(sOrgMasterfile);
            oController.csvFileBody = bOrgMasterFile ;
            oController.sfilename= 'TestOrgMasterFile.csv';
            oController.sType='Org Master';
            oController.ImportFile(); //checks correct & incorrect case with Org Master file type
            
            system.assertEquals(oController.lOrgMaster.size(),6);
            system.assertEquals(oController.lnullOrgMaster.size(),2);
            
            
            
            /****** Testing SAP file ******/
            String sSAPfile;
            sSAPfile= 'Fiscal Year,Fiscal Month,Net Spend in USD,Vendor ID,Vendor Name,Grouping Desc'+ '\n';
            sSAPfile= sSAPfile+ '2014,9,500.12,11111,Microsoft v1,Microsoft G1'+ '\n';
            sSAPfile= sSAPfile+ '2014,9,-1500.92,11111,Microsoft v2,Microsoft G1'+ '\n';
            sSAPfile= sSAPfile+ '2014,9,7860.72,11111,Microsoft v3,Microsoft G2'+ '\n';
            sSAPfile= sSAPfile+ '2015,7,1500,11111,Microsoft v4,Microsoft G2'+ '\n';
            sSAPfile= sSAPfile+ '2015,7,7500.99,11111,Microsoft v5,Microsoft G3'+ '\n';
            sSAPfile= sSAPfile+ '2015,7,-300.82,11111,Microsoft v6,Microsoft G3'+ '\n';
            sSAPfile= sSAPfile+ '2016,5,3100.22,11111,Microsoft v6,Microsoft G2'+ '\n';
            sSAPfile= sSAPfile+ '2014,3,1100.22,44444,Apple v1,Apple G1'+ '\n';
            sSAPfile= sSAPfile+ '2014,3,-8100.62,44444,Apple v2,Apple G1'+ '\n';
            sSAPfile= sSAPfile+ '2014,3,5100.22,44444,Apple v3,Apple G2'+ '\n';
            sSAPfile= sSAPfile+ '2015,1,,55555,Apple v4,Apple G1'+ '\n'; //will error out in Exception
            sSAPfile= sSAPfile+ '2015,1,0.82,99999,Failv1,Failv1'+ '\n';
            sSAPfile= sSAPfile+ '2015,1,-0.22,,Failv2,Failv2'+ '\n';
            
            Blob bSAPFile = Blob.valueOf(sSAPfile);
            oController.csvFileBody = bSAPFile;
            oController.sfilename= 'TestSAPFile.csv';
            oController.sType='SAP';
            oController.ImportFile(); //checks correct & incorrect case with SAP file type
            
            system.assertEquals(oController.lSM.size(),10);
            system.assertEquals(oController.lnullSM.size(),2);
            system.assertEquals(oController.SMICount,7);
            
            
        Test.stopTest();
        }
    }

}