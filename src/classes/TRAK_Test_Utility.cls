/*
*@ Class Name                                                    : TRAK_Test_Utility Class
*@ Description                                                   : Test Class to create test Data for test Classes
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 11-08-2016
*@ Modification Log                                              : Neha kumari (11-08-2016)                   
*/
@isTest
public class TRAK_Test_Utility{

public static final String TRAK_TESTDATA = 'TRAK Test Data';
/* 
     * Method name : createUser
     * Description :  This method is used to create User without any userrole assigned
     * Param :  Profile name
     * Returns :  User
*/
  public static List<User> createUser(String prof, Integer noOfUser, String add){
    Profile p = [select Id from Profile WHERE Name=:prof];
    List<user> userLst = new List<User>();
    for(Integer i=0;i<noOfUser;i++){
      User u = new User(Alias = 'st'+i+add, Email='a'+add+i+'trfouser@testorg.com', LocaleSidKey='en_US', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='a'+add+i+'trfouser@testorg.com');  
      userLst.add(u);      
    }    
    insert userLst;                             
    return userLst;
  }

/*
     * Method name : createBurndownStat
     * Description :  This method is used to create Burndown Stat
     * Param :  
     * Returns :  
*/
  public static List<TRAK_BurnDown2__c> createBurndown(integer count){
    List<TRAK_BurnDown2__c> lstBD = new List<TRAK_BurnDown2__c>();
    for(integer i=0;i<count;i++){
      TRAK_BurnDown2__c BD = new TRAK_BurnDown2__c();
      BD.name = 'Burndown'+i;
      BD.Actual_burndown__c = 30;
      BD.Current_velocity__c = 10;
      BD.Date__c = date.newInstance(2000,8,11);
      BD.Points_Complete__c = 5;
      BD.Project__c = 'Project'+i;
      lstBD.add(BD);
  }
  return lstBD;
}
/*
     * Method name : createUserStory
     * Description :  This method is used to create User story
     * Param :  
     * Returns :  
*/
  public static List<TRAK_User_Story__c> createUserStory(Integer count){
    List<TRAK_User_Story__c> lstUS = new List<TRAK_User_Story__c>();
    List<User> usrLst = createUser('Senior System Administrator', 2, 'abaa');
    for(integer i=0;i<count;i++){
      TRAK_User_Story__c US = new TRAK_User_Story__c();
      US.As_A_text__c = 'User'+i;
      US.I_Want_To__c = 'Action'+i;
      US.So_that__c = 'SoThat'+i;
      US.Acceptance_Criteria__c = 'AC';
      US.Development_Stage__c='Backlog';
      US.System_Owner__c = usrLst[0].id;
      US.System_Custodian__c = usrLst[1].id;
      lstUS.add(US);
    }
    return lstUS;
  }

/*
     * Method name : createSprint
     * Description :  This method is used to create Sprint
     * Param :  
     * Returns :  
*/
  public static List<TRAK_Sprint__c> createSprint(Integer count){
    List<TRAK_Sprint__c> lstSprint = new List<TRAK_Sprint__c>();
    for(integer i=0;i<count;i++){
      TRAK_Sprint__c Sprnt = new TRAK_Sprint__c();
      Sprnt.name = 'Sprint '+i;
      Sprnt.Status__c = 'Not Started';
      Sprnt.Objective__c = 'Test Objective';
      Sprnt.Start_Date__c = date.newInstance(2000,8,11);
      Sprnt.End_Date__c = date.newInstance(2004,8,11);
      Sprnt.Tech1_Story_Points__c=50;
      Sprnt.Story_Points__c=20;
      Sprnt.Tech2_Story_Points__c=10;
      Sprnt.Completed_story_points__c=5;
      lstSprint.add(Sprnt);
    }
    return lstSprint;
  }
  
/*
     * Method name : createDefect
     * Description :  This method is used to create Defect
     * Param :  
     * Returns :  
*/
  public static List<TRAK_Bug__c> createDefect(Integer count){
    List<TRAK_Bug__c> lstBug = new List<TRAK_Bug__c>();
    for(integer i=0;i<count;i++){
      TRAK_Bug__c Bug = new TRAK_Bug__c();
      Bug.BusinessImpact__c = '2.Medium';
      Bug.Release_Note__c = 'Release note'+i;
      Bug.Defect_Type__c = 'Code Issue';
      Bug.Priority__c = i;
      Bug.Problem__c='Problem'+i;
      lstBug.add(Bug);
    }
    return lstBug;
  }

/*
     * Method name : createPPSessionContent
     * Description :  This method is used to create Planning poker session content
     * Param :  
     * Returns :  
*/  
  public static List<TRAK_Planning_Poker_Session_Content__c> createPPSessionContent(Integer Count,ID USid){
    List<TRAK_Planning_Poker_Session_Content__c> lst = new List<TRAK_Planning_Poker_Session_Content__c>();
    for(integer i=0;i<count;i++){
      TRAK_Planning_Poker_Session_Content__c PP = new TRAK_Planning_Poker_Session_Content__c();
      PP.System_Is_Selected__c=true;
      PP.Unique_Id__c='id'+i;
      PP.User_Story__c = USid;
      lst.add(PP);
    }
    return lst;
  }
  
/*
     * Method name : createPPSession
     * Description :  This method is used to create Planning poker session
     * Param :  
     * Returns :  
*/  
  public static List<TRAK_Planning_Poker_Session__c> createPPSession(Integer Count){
    List<TRAK_Planning_Poker_Session__c> lst = new List<TRAK_Planning_Poker_Session__c>();
    for(integer i=0;i<count;i++){
      TRAK_Planning_Poker_Session__c PPS = new TRAK_Planning_Poker_Session__c();
      PPS.IsActive__c=true;
      PPS.Title__c='Title'+i;
      lst.add(PPS);
    }
    return lst;
  }
  
/*
     * Method name : createTestScript
     * Description :  This method is used to create Test Script
     * Param :  
     * Returns :  
*/  
  public static List<TRAK_Test_Templates__c> createTestScript(Integer Count){
    List<TRAK_Test_Templates__c> lst = new List<TRAK_Test_Templates__c>();
    List<TRAK_User_Story__c> lUserStory = createUserStory(count);
    insert lUserStory;
    for(integer i=0;i<count;i++){
      TRAK_Test_Templates__c oTestScript = new TRAK_Test_Templates__c();
      oTestScript.User_Story__c = luserStory[i].Id;
      oTestScript.Approval_Status__c = 'Open';
      oTestScript.Approver__c = Userinfo.getUserId();
      oTestScript.Expected_Result__c = TRAK_TESTDATA;
      oTestScript.Introduction__c= TRAK_TESTDATA;
      oTestScript.Signature_Meaning__c = TRAK_TESTDATA;
      oTestScript.Status__c = 'Open';
      oTestScript.Title__c =  TRAK_TESTDATA;
      lst.add(oTestScript);
    }
    return lst;
  }
  
/*
     * Method name : createPPSessionUser
     * Description :  This method is used to create Planning Poker Session User
     * Param :  
     * Returns :  
*/ 
  public static List<TRAK_Planning_Poker_Session_User__c> createPPSessionUser(integer count,ID PPSessionID){
    List<TRAK_Planning_Poker_Session_User__c> LstUsr = new List<TRAK_Planning_Poker_Session_User__c>();
    TRAK_Planning_Poker_Session_User__c Usr = new TRAK_Planning_Poker_Session_User__c();
    for(integer i=0;i<count;i++){
      Usr.IsActive__c=true;
      Usr.Planning_Poker_Session__c = PPSessionID;
      LstUsr.add(Usr);
    }
    return LstUsr;
  }
/*
     * Method name : createPPVotes
     * Description :  This method is used to create Planning Poker Votes
     * Param :  
     * Returns :  
*/ 
  public static List<TRAK_Planning_Poker_Votes__c> createPPVotes(integer count, ID PPContentID){
    List<TRAK_Planning_Poker_Votes__c> LstVote = new List<TRAK_Planning_Poker_Votes__c>();
    TRAK_Planning_Poker_Votes__c vote = new TRAK_Planning_Poker_Votes__c();
    for(integer i=0;i<count;i++){
      vote.Planning_Poker_Session_Content__c = PPContentID;
      vote.Vote__c = 10;
      LstVote.add(vote);
    }
    return LstVote;
  }
  
  /*
     * Method name : createRelease
     * Description :  This method is used to create Release
     * Param :  
     * Returns :  
*/ 
  public static List<TRAK_Release__c> createRelease(integer count, String releaseType){
  Id RecordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeINfosByName().get('Creation of Release').getRecordTypeId();
    List<TRAK_Release__c> LstVote = new List<TRAK_Release__c>();
        for(integer i=0;i<count;i++){
    TRAK_Release__c oRelease = new TRAK_Release__c();
    oRelease.RecordTypeId = RecordTypeId;
    oRelease.Release_Type__c = releaseType;
    oRelease.Name= 'Rxx.x';
    oRelease.Tag__c= 'TAG_x';
    oRelease.Branch_Name__c ='develop_dummy';
    oRelease.Commit_ID__c = 'wu3nd3dm13';
    oRelease.Override_Release_Name__c = false;
    oRelease.Repository_Name__c = 'Trialforce';
    oRelease.Approval_Status__c = 'Draft';
    LstVote.add(oRelease);
    }
    return LstVote;
  }
  
  public static List<TRAK_Design__c> createDesign(Integer n) {
  List<TRAK_Design__c> lDesign = new List<TRAK_Design__c>();
  for(Integer i = 0;i < n;i++) {
  TRAK_Design__c oDesign = new TRAK_Design__c();
  oDesign.Name = 'Test Design '+i;
  lDesign.add(oDesign);
  }
  return lDesign;
  }
  
  public static List<PermissionSetAssignment> createPermissionSet(Integer count,List<User> trackerUser){
      List<PermissionSetAssignment > psaList = new List<PermissionSetAssignment>();
      PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'TRAK_Tracker_Read'];
      
      for(integer i=0; i<count; i++){
        for(User u: trackerUser){
          PermissionSetAssignment psa = new PermissionSetAssignment();
          psa.AssigneeId = u.id;
          psa.PermissionSetId = ps.Id;
          psaList.add(psa);
        }
      }
      return psaList;
  }
 
}