/*************************************************************************\
    @ Author        : Shoumyabrata Chanda
    @ Date          : 1-Sep-2014
    @ Description   : Test Class for class TRAK_opProjectRecords
****************************************************************************/

@isTest(seeAllData = false)
private class Test_TRAK_projectRecords{
/*
        static Profile profile = [SELECT Id FROM Profile WHERE Name='GSO Basic User_Platform'];    
        public static User createUser(String permissionSetLabel, String alias){
            User runAsUser = new User(alias = alias, email='testTRAK@testorg.com',
                                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                      localesidkey='en_US', profileid = profile.Id,  country='United States', CommunityNickname = alias,
                                      timezonesidkey='America/Los_Angeles',username='testuser'+alias+'@testorg.com');
            insert runAsUser; 
            PermissionSet permissionSet = [SELECT ID,Label from PermissionSet WHERE Name=:PermissionSetLabel];       
            PermissionSetAssignment permissionSetAssignment = New PermissionSetAssignment();
            permissionSetAssignment.AssigneeId=runAsUser.ID;
            permissionSetAssignment.PermissionSetId=permissionSet.ID;
            insert permissionSetAssignment;      
            return runAsUser; 
        }
        static testmethod void TestAsTRAKAdmin() {    
            User usr = new User();
            User usr1 = new User();
            User usr2 = new User();
            TRAK_Project__c prjupdate;
            TRAK_Project__c prj1;   
            usr = Test_TRAK_projectRecords.createUser('TRAK_Admin','TRAKadm');
            test.startTest();
            System.runAs(usr) {                         
                prj1 = new TRAK_Project__c(name='TestProjectAdmin');
                insert prj1;           
                prjupdate = [select ID, TRAK_Cirrus_Stage__c,On_Hold__c,Reminder_date__c,On_Hold_Reason__c from TRAK_Project__c where ID =: prj1.ID];
                //System.debug('count '+[select count() from TRAK_Cirrus_Stage_Change_Information__c]);
                //System.debug('existing stages '+[select id, Cirrus_Stage_Name__c, Project__c, Days_In_Stage__c from TRAK_Cirrus_Stage_Change_Information__c]);
                prjupdate.TRAK_Cirrus_Stage__c = 'Assessment';
                prjupdate.On_Hold__c = true;
                prjupdate.On_Hold_Reason__c = 'test reason';
                prjupdate.Reminder_date__c = date.today();
                update prjupdate;
            }
            usr1 = Test_TRAK_projectRecords.createUser('TRAK_Admin','micadm');
            System.runAs(usr1) {  
                System.debug('Updated Project '+[select ID, TRAK_Cirrus_Stage__c,On_Hold__c,Reminder_date__c,On_Hold_Reason__c from TRAK_Project__c where ID =: prjupdate.ID]);
                //System.debug('count '+[select count() from TRAK_Cirrus_Stage_Change_Information__c]);
                //System.debug('existing stages '+[select id, Cirrus_Stage_Name__c, Project__c, Days_In_Stage__c from TRAK_Cirrus_Stage_Change_Information__c]);
                //System.debug('count '+[select count() from TRAK_Cirrus_Stage_Change_Information__c]);
                TRAK_Project__c prjupdate1 = [select ID, TRAK_Cirrus_Stage__c,On_Hold__c,Reminder_date__c,On_Hold_Reason__c from TRAK_Project__c where ID =: prjupdate.ID];
                prjupdate1.TRAK_Cirrus_Stage__c = 'Awaiting Project Approval';
                update prjupdate1;
                
            }
            usr2 = Test_TRAK_projectRecords.createUser('TRAK_Admin','micadmn');
            System.runAs(usr2) { 
                //System.debug('existing stages '+[select id, Cirrus_Stage_Name__c, Project__c, Days_In_Stage__c from TRAK_Cirrus_Stage_Change_Information__c]);
                //System.debug('count '+[select count() from TRAK_Cirrus_Stage_Change_Information__c]);
                prj1.TRAK_Cirrus_Stage__c = 'Assessment';
                update prj1;                
                prj1.TRAK_Cirrus_Stage__c = 'Ideation';
                update prj1;
                //System.debug('existing stages '+[select id, Cirrus_Stage_Name__c, Project__c, Days_In_Stage__c from TRAK_Cirrus_Stage_Change_Information__c]);
                //System.debug('count '+[select count() from TRAK_Cirrus_Stage_Change_Information__c]);
                TRAK_Project__c prj2 = new TRAK_Project__c(name='TestProjectAdminholdinsert');
                prj2.On_Hold__c = true;
                prj2.On_Hold_Reason__c = 'test reason';
                prj2.Reminder_date__c = date.today();
                insert prj2;
                prj2.On_Hold__c = false;
                update prj2;    
                TRAK_Project__c proj = [Select ID, Name,Hold_Days__c from TRAK_Project__c where ID =: prj2.ID ];
                System.assertEquals(1,proj.Hold_Days__c);
                prj2.TRAK_Cirrus_Stage__c = 'Assessment';
                Update prj2;
                TRAK_Project__c prj3 = new TRAK_Project__c(name='TestProjectAdminholdinsertIdeation');
                insert prj3;
                prj3.TRAK_Cirrus_Stage__c = 'Assessment';
                update prj3;
                //TRAK_Cirrus_Stage_Change_Information__c changeInfo = [select count() from TRAK_Cirrus_Stage_Change_Information__c where Project__C = :prj3.ID];
                //System.assertEquals(1,[select count() from TRAK_Cirrus_Stage_Change_Information__c where Project__C = :prj3.ID] );
                test.stoptest();
            }
        }
        static testmethod void TestAsTRAKBasicUser() {    
            User usr = new User();
            TRAK_Project__c prj1;   
            usr = Test_TRAK_projectRecords.createUser('TRAK_Basic','TRAKbsc');
            test.startTest();
            System.runAs(usr) {                         
                prj1 = new TRAK_Project__c(name='TestProjectBasicUser');
                insert prj1;  
                prj1.On_Hold__c = true;
                prj1.On_Hold_Reason__c = 'test reason';
                prj1.Reminder_date__c = date.today();
                update prj1;                
                prj1.On_Hold__c = false;
                update prj1;  
                TRAK_Project__c proj = [Select ID, Name,Hold_Days__c from TRAK_Project__c where ID =: prj1.ID ];
                System.assertEquals(1,proj.Hold_Days__c);
            }
            test.stoptest();
        }
         public static List<User> sysOwnerLst;
         public static User sysOwner1;
         public static User sysCust ;
         public static User SysQual ;
         
         static testMethod void createProjectRecord1() 
          {
          
          sysOwnerLst = new list<User>();
          
          //Creating the test user for System Custodian
            sysCust = new User();
            sysCust.username = 'sysCust@Test.com.env';
            sysCust.Email = 'sysCust@Test.com';
            sysCust.profileid = UserInfo.getProfileId();
            sysCust.lastname = 'Custodian';
            sysCust.firstname = 'System';
            sysCust.Alias = 'syc';
            sysCust.TimeZoneSidKey = 'America/Los_Angeles';
            sysCust.LocaleSidKey = 'en_US';
            sysCust.EmailEncodingKey = 'UTF-8';
            sysCust.LanguageLocaleKey = 'en_US';
           
            sysOwnerLst.add(sysCust);
            
               //Creating the test user for Computer Systems Quality
            SysQual = new User();
            SysQual.username = 'SysQual@Test.com.env';
            SysQual.Email = 'SysQual@Test.com';
            SysQual.profileid = UserInfo.getProfileId();
            SysQual.lastname = 'Quality';
            SysQual.firstname = 'System';
            SysQual.Alias = 'syq';
            SysQual.TimeZoneSidKey = 'America/Los_Angeles';
            SysQual.LocaleSidKey = 'en_US';
            SysQual.EmailEncodingKey = 'UTF-8';
            SysQual.LanguageLocaleKey = 'en_US';
       
            
            sysOwnerLst.add(SysQual);
           
             //Creating the test user for System Admin
            sysOwner1 = new User();
            sysOwner1.username = 'sysOwner@Test.com.env';
            sysOwner1.Email = 'sysOwner@Test.com';
            sysOwner1.profileid = UserInfo.getProfileId();
            sysOwner1.lastname = 'Owner';
            sysOwner1.firstname = 'System';
            sysOwner1.Alias = 'syo';
            sysOwner1.TimeZoneSidKey = 'America/Los_Angeles';
            sysOwner1.LocaleSidKey = 'en_US';
            sysOwner1.EmailEncodingKey = 'UTF-8';
            sysOwner1.LanguageLocaleKey = 'en_US';
            
            sysOwnerLst.add(sysOwner1);
            
           
            insert sysOwnerLst;
          
             //List<User> sysOwnerLst1=[select id,name from User where isactive = true and profileId = :UserInfo.getProfileId() ];
            // Profile adminProfiel = [SELECT Id,Name from Profile where name = 'System Administrator' LIMIT 1];
            //List<User> adminUserList = [select id,name from User where isactive = true and profileId = :adminProfiel.Id];
           
            
            TRAK_Project__c TRAKProjct_test=new TRAK_Project__c(Name='TRAK Project for test class');
            
            System.runAs(sysOwner1){
            
            insert TRAKProjct_test;
            
            List<TRAK_Project__share> TRAK_ProjectShareLst=new List<TRAK_Project__share>();
            
            for(Integer i=0;i<2;i++)
            {
              TRAK_Project__share obj1=new TRAK_Project__share(accesslevel='Edit',UserOrGroupId=sysOwnerLst[i].Id,rowcause=TRAK_Project__share.RowCause.Manual,parentId=TRAKProjct_test.Id);
              TRAK_ProjectShareLst.add(obj1);
            }
            
           /* List<TRAK_Project__share> TRAK_projctShareLst=new List<TRAK_Project__share>();
           
            TRAK_projctShareLst.add(TRAK_ProjectShare);*/
      
            /*
            insert TRAK_ProjectShareLst;
            }
            
           //List<TRAK_Project__share> getProjectOwner=[SELECT id from TRAK_Project__share where rowcause='Owner'and parentId=:TRAKProjct_test.Id];
           
            Test.startTest();
            
            System.runAs(SysQual){
            
            TRAKProjct_test.OwnerId = sysOwnerLst[1].Id;
            
            update TRAKProjct_test;
            
            
            TRAK_Project__share  ManualSharing = new TRAK_Project__share();
            ManualSharing= ([SELECT Id, accesslevel, UserOrGroupId
            FROM TRAK_Project__share
            WHERE rowcause = 'Manual' and  parentId=:TRAKProjct_test.Id
            LIMIT 1])[0];
    
           // check manual sharing is retained
            System.assertEquals(true, ManualSharing.accesslevel == 'Edit');
            System.assertEquals(true, ManualSharing.UserOrGroupId == sysOwnerLst[0].Id);
            }
            
            Test.stopTest();
          } */
}