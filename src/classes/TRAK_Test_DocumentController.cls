@isTest(seeAllData = false)
public class TRAK_Test_DocumentController{

    static testMethod void DocumentController(){
            
          
            //user
            List<User> user = TRAK_Test_Utility.createUser('Senior System Administrator', 4, 'abc');
            system.assertNotEquals(user[0].id,null);
            system.assertNotEquals(user[1].id,null);
            System.runAs(user[0]){
            TRAK_Sprint__c  sp = new TRAK_Sprint__c();
            sp.Name = 'Test Sprint 1';
            
            insert sp;
            system.assertNotEquals(sp.id,null);
            // create a standard story
            TRAK_User_Story__c r = new TRAK_User_Story__c();
            r.Proposed_Sprint__c = sp.Id;
            r.Allocated_Sprint__c = sp.Id;
            r.Functional_Area__c  = 'SFA';
            r.Sub_Process__c = 'Marketing';
            r.User__c = UserInfo.getUserId();
            r.Supporting_BA__c = user[3].id;
            r.Development_Stage__c = 'Backlog';
            r.System_Custodian__c = user[2].id;
            r.System_Owner__c= user[1].id;
            insert r;
            system.assertNotEquals(r.id,null);
            TRAK_UserStory2Design__c  usd = new TRAK_UserStory2Design__c();
            usd.User_Story__c = r.Id;
            insert usd;
            system.assertNotEquals(usd.id,null);
            
            // a story we will not select
            TRAK_User_Story__c r2 = new TRAK_User_Story__c();
            r2.Proposed_Sprint__c = sp.Id;
            r2.Allocated_Sprint__c = sp.Id;
            r2.Functional_Area__c  = 'SFA';
            r2.Sub_Process__c = 'Marketing';
            r2.User__c = UserInfo.getUserId();
            r2.Supporting_BA__c = user[3].id;
            r2.Development_Stage__c = 'Backlog';
            r2.System_Custodian__c = user[0].id;
            r2.System_Owner__c= user[1].id;
           
            insert r2;
            
            system.assertNotEquals(r2.id,null);
            TRAK_UserStory2Design__c  usd2 = new TRAK_UserStory2Design__c();
            usd2.User_Story__c = r2.Id;
            insert usd2;
            system.assertNotEquals(usd2.id,null);
                        
            // a story with some missing criteria
            TRAK_User_Story__c r3 = new TRAK_User_Story__c();
            r3.Proposed_Sprint__c = sp.Id;
            r3.Allocated_Sprint__c = sp.Id;
            r3.Functional_Area__c  = null;
            r3.Sub_Process__c = null;
            r3.User__c = UserInfo.getUserId();
            r3.Supporting_BA__c = user[3].id;
            r3.Development_Stage__c = 'Backlog';
            r3.System_Custodian__c = user[0].id;
            r3.System_Owner__c= user[1].id;
            insert r3;
            system.assertNotEquals(r3.id,null);
            
            TRAK_UserStory2Design__c  usd3 = new TRAK_UserStory2Design__c();
            usd2.User_Story__c = r3.Id;
            //usd2.Author__c ='';
            insert usd3;
            system.assertNotEquals(usd3.id,null);
            
            List<TRAK_Release__c> lRelease = TRAK_Test_Utility.createRelease(1,'abc');
            insert lRelease;
            system.assertNotEquals(lRelease[0].id,null);
            
            List<TRAK_Bug__c> lDefect = TRAK_Test_Utility.createDefect(1);
            insert lDefect;
            system.assertNotEquals(lDefect[0].id,null);
            
            Test.startTest();
            pageReference pr = new pageReference('');
            pr.getParameters().put('ReleaseId', lRelease[0].id);
            Test.setCurrentPage(pr);

            // initialise the doc controller
            TRAK_DocumentController TDC = new TRAK_DocumentController();
            TDC.AuthorRole= 'test';
            TDC.Author= 'test';
            TDC.ReviewAuthorRole1= 'test';
            TDC.ReviewAuthor1= 'test';
            TDC.ReviewAuthorRole2= 'test';
            TDC.ReviewAuthor2= 'test';
            TDC.ReviewAuthorRole3= 'test';
            TDC.ReviewAuthor3= 'test';
            TDC.ReviewAuthorRole4= 'test';
            TDC.ReviewAuthor4= 'test';
            TDC.ReviewAuthorRole5= 'test';
            TDC.ReviewAuthor5= 'test';
            String domainName = TDC.domainName;
            domainName = 'QRScan';
            TDC.Version = '1.0';
            TDC.Organization = 'Deloitte';
            TDC.Project_Name = 'Tracker';
            TDC.createDocument(); // run without stories, so we can generate definitions and references
            TDC.CreateFunctionalDocument(); // run without stories, so we can generate definitions and references
            TDC.Version = '';
            TDC.Organization = '';
            TDC.ReleaseId = lRelease[0].id;
            TDC.Project_Name = '--None--';
            TDC.Deliverable_Id = '';
            TDC.Change_Desp = '';
            TDC.DefinitionsExist = true;
            TDC.ReferencesExist = true;
            TDC.getProjNameList();
            TDC.getUserStories(); 
            TDC.initUS= r ;
            TDC.createQuery();
            TDC.toggleSort();
            TDC.lstSprintProposed.add(sp.Id);
            TDC.lstSprintAllocated.add(sp.Id);
            TDC.createQuerySOQL();
            TDC.lstUS = new List<TRAK_DocumentController.cUS>();
        
            
            
            // add our stories to the list
            TRAK_DocumentController.cUS  cus = new TRAK_DocumentController.cUS(r);
            cus.selected = true;
            TDC.lstUS.add(cus);
            TDC.userStoriesList.add(cus);
            
            TRAK_DocumentController.cUS  cus2 = new TRAK_DocumentController.cUS(r2, true);
            TDC.lstUS.add(cus2);
            TDC.userStoriesList.add(cus2);
            
            TRAK_DocumentController.cUS  cus3 = new TRAK_DocumentController.cUS(r3, true);
            TDC.lstUS.add(cus3);
            TDC.userStoriesList.add(cus3);
            
            TDC.processUnselected();
            TDC.processSelected();
            TDC.selectedUS.add(r);
            TDC.selectedUS.add(r2);
            TDC.selectedUS.add(r3);
            TDC.createDocument();
            TDC.CreateFunctionalDocument();
            
            TDC.Version = '1.0';
            TDC.Organization = 'Deloitte';
            TDC.Project_Name = 'Tracker';
            TDC.createDocument(); // run this again now that we've set up the fields
            TDC.CreateFunctionalDocument(); // run this again now that we've set up the fields
            TDC.generateQAcards();
            
            
            delete r;
            TRAK_DocumentController TDC1 = new TRAK_DocumentController();
            TDC1.getUserStories(); 
            TDC1.getProjNameList();
            Test.stopTest();
       }     
    } 

}