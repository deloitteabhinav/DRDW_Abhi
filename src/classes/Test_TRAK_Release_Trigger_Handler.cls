/*
*@ Class Name                                                    : Test_TRAK_Release_Trigger_Handler
*@ Description                                                   : Test class for TRAK_Release_Trigger_Handler
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 12-08-2016

*/

@isTest (seeAlldata=false)
public class Test_TRAK_Release_Trigger_Handler {

/*
*@ Method Name           : GSO1GSO2_Release_Record_Lock
*@ Description           : Test method to cover updateUserStoriesandDefects
*@ Return                : Void

*/

 
    static testmethod void GSO1GSO2_Release_Record_Lock() { 
        List<User> U = TRAK_Test_Utility.createUser('Senior System Administrator',2,'AB');
        system.runAs(U[0]){
            Test.startTest();
            Map<id, TRAK_Release__c> oldMTR = new map<id,TRAK_Release__c>();
            Map<id, TRAK_Release__c> newMTR = new map<id,TRAK_Release__c>();
            List<TRAK_Release__c> lTRelease = TRAK_Test_Utility.createRelease(1,'Monthly');
            lTRelease[0].Name= 'R10';
            lTRelease[0].Tag__c= 'TAG_1';
            lTRelease[0].CR_Number__c ='test';
            lTRelease[0].Code_Review_Completed__c = true;
            lTRelease[0].Approved_for_Pre_Production__c = true;
            lTRelease[0].Branch_Name__c ='develop_dummy';
            lTRelease[0].Commit_ID__c = 'wu3nd3dm';
            lTRelease[0].release_Type__c = 'Monthly';
            lTRelease[0].Override_Release_Name__c = false;
            lTRelease[0].Repository_Name__c = 'Trialforce';
            lTRelease[0].Approval_Status__c = 'Draft';
            insert lTRelease;
            System.assert(lTRelease[0].id!=null);
            
            lTRelease[0].Approval_Status__c = 'Ready for Deployment';
            update lTRelease;
            oldMTR.put(lTRelease[0].id, lTRelease[0]);
            TRAK_Environment_Release__c oTER = new TRAK_Environment_Release__c();
            oTER.Release__c = lTRelease[0].id;
            insert oTER;
            System.assert(oTER.id!=null);
            
            lTRelease[0].Approval_Status__c = 'Production - Released';
            lTRelease[0].Approved_for_Production__c= true;
            lTRelease[0].Description__c= 'test1';
            TRAK_Release__c orelease = new TRAK_Release__c();
            try    {
                update lTRelease;
                orelease = [SELECT Id,Number_of_Environments__c, release_Type__c,Rejected__c ,Approved_for_Production__c,Override_Release_Name__c, Rejected_Reason__c,Approved_for_Pre_Production__c,Description__c,Approval_Status__c  FROM TRAK_Release__c where id =: lTRelease[0].id ];
                newMTR.put(orelease.id, orelease);
                System.assert(orelease.id != null);
            }
            catch(exception ex)    {
                Boolean isException = False;
                String msg = ex.getMessage();
                if(msg.contains(TRAK_Release_Trigger_Handler.gso1gso2ErrorMessage)){
                    isException = True;
                    System.assertEquals(true, isException);
                }
                
            }
            //Create sprint
            TRAK_Sprint__c sprint = new TRAK_Sprint__c();
            List<User> sysCustodian = new List<User>();
            sysCustodian = TRAK_Test_Utility.createUser('Global COPM',2,'sysC');
            List<PermissionSetAssignment> sysPerm = new List<PermissionSetAssignment>();
            sysPerm = TRAK_Test_Utility.createPermissionSet(2,sysCustodian);
            sprint.Name = 'tracker sprint 1';
            insert sprint;
            System.assertNotEquals(sprint.Id, null);
            TRAK_User_Story__c story = new TRAK_User_Story__c();
            story.Story_Points__c = '0';
            story.Story_Points_Other__c = '0';
            story.Proposed_Sprint__c = sprint.Id;
            story.Development_Stage__c = 'Backlog ';
            story.Cirrus_Release__c = orelease.id;
            story.System_Custodian__c = sysCustodian[0].id;
            story.System_Owner__c = sysCustodian[1].id;
            insert story;
            System.assertNotEquals(story.Id, null);
            TRAK_Bug__c odefect = new TRAK_Bug__c();
            odefect.Technology__c = 'SFDC';
            odefect.Status__c = 'Raised';
            odefect.Production_Release__c = lTRelease[0].id;
            odefect.Problem__c = 'defect raised'; 
            oDefect.BusinessImpact__c = '1 = Low';
            insert odefect;
            System.assert(odefect.id!=null);
            
            story.Development_Stage__c  = 'In Development';
            story.Approval_Status__c = 'Approved';
            update story;
            odefect.Status__c = 'In Analysis';
            update odefect;
            TRAK_User_Story__c oUS = [Select id, Development_Stage__c from TRAK_User_Story__c where id =: story.id  ];
            TRAK_Bug__c oDef = [select id, status__c from TRAK_Bug__c where Id =: odefect.id ];
            TRAK_Release_Trigger_Handler oTRTH = new TRAK_Release_Trigger_Handler();
            
            TRAK_Release_Trigger_Handler.updateUserStoriesandDefects(oldMTR,NewmTR);
            TRAK_Release_Trigger_Handler.setReleaseName(lTRelease);
            Test.stopTest();
        }
    } 
    
    /*
*@ Method Name           : GSO3_PreProd_Release_Record_Lock
*@ Description           : Test method to cover setReleaseName
*@ Return                : Void

*/

    static testmethod void GSO3_PreProd_Release_Record_Lock() { 
        Test.startTest();
            List<TRAK_Release__c> lTRelease = TRAK_Test_Utility.createRelease(1,'Monthly');
            lTRelease[0].Name= 'R10.1';
            lTRelease[0].Tag__c= 'TAG_2';
            lTRelease[0].CR_Number__c ='test';
            lTRelease[0].Code_Review_Completed__c = true;
            lTRelease[0].Approved_for_Pre_Production__c = true;
            lTRelease[0].Branch_Name__c ='develop_dummy';
            lTRelease[0].Commit_ID__c = 'wu3nd3dm12';
            lTRelease[0].release_Type__c = 'Weekly';
            lTRelease[0].Override_Release_Name__c = false;
            lTRelease[0].Repository_Name__c = 'Trialforce';
            lTRelease[0].Approval_Status__c = 'Draft';
            insert lTRelease;
            System.assertNotEquals(lTRelease[0].Id, null);
            lTRelease[0].Approval_Status__c = 'Ready for Deployment';
            update lTRelease;
            System.assert(lTRelease[0].id!=null);
            Trak_Release__c releaseUp = [Select id,Release_Type__c,Override_Release_Name__c from Trak_Release__C where ID =: lTRelease[0].id];
            TRAK_Release_Trigger_Handler oTRTH = new TRAK_Release_Trigger_Handler();   
            TRAK_Release_Trigger_Handler.setReleaseName(lTRelease);
        Test.stopTest();
    }
    
    /*
*@ Method Name           : GSO3_Reject_Release_Record_Lock
*@ Description           : Test method to cover setReleaseName
*@ Return                : Void

*/
    
    static testmethod void GSO3_Reject_Release_Record_Lock() {
        List<User> U = TRAK_Test_Utility.createUser('Senior System Administrator',2,'AB');
        system.runAs(U[0]){
            Test.startTest();
                List<TRAK_Release__c> lTRelease = TRAK_Test_Utility.createRelease(1,'Hotfix');
                lTRelease[0].Name= 'R10.1.1';
                lTRelease[0].Tag__c= 'TAG_3';
                lTRelease[0].CR_Number__c ='test';
                lTRelease[0].Code_Review_Completed__c = true;
                lTRelease[0].Approved_for_Pre_Production__c = true;
                lTRelease[0].Branch_Name__c ='develop_dummy';
                lTRelease[0].Commit_ID__c = 'wu3nd3dm13';
                lTRelease[0].release_Type__c = 'Hotfix';
                lTRelease[0].Override_Release_Name__c = false;
                lTRelease[0].Repository_Name__c = 'Trialforce';
                lTRelease[0].Approval_Status__c = 'Draft';
                insert lTRelease;            
                System.assert(lTRelease[0].id!=null);
                Trak_Release__c releaseUp = [Select id,Release_Type__c,Override_Release_Name__c from Trak_Release__C where ID =: lTRelease[0].id];
                TRAK_Release_Trigger_Handler oTRTH = new TRAK_Release_Trigger_Handler();   
                TRAK_Release_Trigger_Handler.setReleaseName(lTRelease);
                lTRelease[0].Override_Release_Name__c = true;
                update lTRelease;
            Test.stopTest();
         }
    }
    
/*
*@ Method Name           : updateUserStoriesandDefects
*@ Description           : Test method to cover updateUserStoriesandDefects
*@ Return                : Void
*@ Developer       : Rahul
*/
    static testmethod void updateUserStoriesandDefects(){
        List<User> U = TRAK_Test_Utility.createUser('Senior System Administrator',2,'AB');
        List<User> sysCustodian = TRAK_Test_Utility.createUser('Global COPM',2,'sysC');
        system.runAs(U[0]){
            Test.startTest();
            List<TRAK_Release__c> lTRelease = TRAK_Test_Utility.createRelease(1,'Weekly');
            insert lTRelease;
            System.assert(lTRelease[0].id != Null);
            List<TRAK_User_Story__c> lUsrStory = TRAK_Test_Utility.createUserStory(1);
            lUsrStory[0].Cirrus_Release__c = lTRelease[0].id;
            lUsrStory[0].System_Custodian__c = sysCustodian[0].id;
            lUsrStory[0].System_Owner__c = sysCustodian[1].id;
            insert lUsrStory;
            System.assert(lUsrStory[0].id != Null);
            List<TRAK_Bug__c> lstBugs = TRAK_Test_Utility.createDefect(1);
            lstBugs[0].Production_Release__c = lTRelease[0].id;
            lstBugs[0].BusinessImpact__c = '1 = Low';
            insert lstBugs;
      System.assert(lstBugs[0].id != Null);            
            lTRelease[0].Override_Release_Name__c = true;
            lTRelease[0].Approval_Status__c = 'Production - Released';
            update lTRelease;
            system.assertEquals(lTRelease[0].Approval_Status__c, 'Production - Released');
            Test.stopTest();
        }
    
    }
}