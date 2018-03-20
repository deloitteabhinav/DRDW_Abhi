/****************************************************************************************************************************************** 
 * Class Name   : DataFactory1
 * Description  : Utility Class for Creating Test Data for CoLAB
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@
isTest
public with sharing class DataFactory1 {


     /* 
     * @Method Name                    :  getTestingUser
     * @Description                    :  Creates a Test User
     * @Return Type                    :  User
     * @Parameters                     :  None
     */
    public static User getTestingUser() 
    {
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'GSO Basic User_Platform'].Id;
        String rId = [select id from UserRole where Name = 'Lilly Employee'].Id;
        u = new User(profileId = pId, userRoleId = rId, email = uniqueName + '@test' + uniqueName + '.org',
            Username = uniqueName + '@test' + uniqueName + '.org',
            alias = 'utusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
            languagelocalekey = 'en_US', timezonesidkey = 'GMT');

        insert u;
        return u;

    }

    /* 
     * @Method Name                    :  givePermissions
     * @Description                    :  Assigning Permission Set to a User
     * @Return Type                    :  void
     * @Parameters                     :  UserID,PSetName
     */
    public static void givePermissions(id UserID, string PSetName) {
        PermissionSet ps = [Select id From PermissionSet WHERE Name = : PSetName];
        PermissionSetAssignment psAssignments = new PermissionSetAssignment(AssigneeId = UserID, PermissionSetId = ps.id);
        insert psAssignments;
    }



    /* 
     * @Method Name                    :  returnSimulations
     * @Description                    :  returns a list of Simulation
     * @Return Type                    :  List
     * @Parameters                     :  count
     */
    public static list < Simulation__c > returnSimulations(integer count) {
        list < Simulation__c > lSimulations = new list < Simulation__c > ();
        for (integer i = 0; i < count; i++) {
            Simulation__c oSimulation = new Simulation__c();
            oSimulation.Name = 'test Simulation' + i;
            oSimulation.Business_Unit__c = 'Oncology';
            oSimulation.Comments__c = 'test comments';
            oSimulation.Country__c = 'test Country';
            lSimulations.add(oSimulation);
        }
        return lSimulations;
    }



    /* 
     * @Method Name                    :  returnBoards
     * @Description                    :  returns a list of Boards
     * @Return Type                    :  List
     * @Parameters                     :  count,List of Simulations
     */
    public static list < Boards__c > returnBoards(integer count, List < Simulation__c > lSimulations) {
        list < Boards__c > lBoards = new list < Boards__c > ();
        for (Simulation__c oSimulation: lSimulations) {
            for (integer i = 0; i < count; i++) {
                Boards__c oBoard = new Boards__c();
                oBoard.Board_Title__c = 'test Board' + i;
                oBoard.Simulation__c = oSimulation.id;
                lBoards.add(oBoard);
            }
        }
        return lBoards;
    }



    /* 
     * @Method Name                    :  returnSimulationNotes
     * @Description                    :  returns a list of SimulationNotes
     * @Return Type                    :  List
     * @Parameters                     :  count,List of Boards
     */
    public static list < Simulation_Note__c > returnSimulationNotes(integer count, List < Boards__c > lBoards) {
        list < Simulation_Note__c > lNotes = new list < Simulation_Note__c > ();
        for (Boards__c oBoard: lBoards) {
            for (integer i = 0; i < count; i++) {
                Simulation_Note__c oNote = new Simulation_Note__c();
                oNote.Note_Content__c = 'test content' + i;
                oNote.Board__c = oBoard.id;
                oNote.Comments__c = 'test comment';
                oNote.Impact_Level__c = 'Quick Win';
                oNote.Note_Type__c = 'General';
                lNotes.add(oNote);
            }
        }
        return lNotes;
    }



    /* 
     * @Method Name                    :  returnTrials
     * @Description                    :  returns a list of Trials
     * @Return Type                    :  List
     * @Parameters                     :  count
     */
 /*   public static list < Trial__c > returnTrials(integer count) {
        list < Trial__c > lTrials = new list < Trial__c > ();
        for (integer i = 0; i < count; i++) {
            Trial__c oTrial = new Trial__c();
            oTrial.Name = 'test trial' + i;
            oTrial.Compound__c = 'test compound';
            oTrial.FPV__c = system.today();
            oTrial.LPET__c = system.today();
            oTrial.Phase__c = 'Test Phase';
            lTrials.add(oTrial);
        }
        return lTrials;
    }



    /* 
     * @Method Name                    :  returnSimulationTrials
     * @Description                    :  returns a list of Simulation Trials
     * @Return Type                    :  List of Simulation Trials
     * @Parameters                     :  List of Simulations, List of Trials
     */
/*    public static list < Simulation_Trial__c > returnSimulationTrials(list < Simulation__c > lSimulations, list < Trial__c > lTrials) {
        list < Simulation_Trial__c > lSimulationTrials = new list < Simulation_Trial__c > ();
        for (Simulation__c oSimulation: lSimulations) {
            for (Trial__c oTrial: lTrials) {
                Simulation_Trial__c oSimTrial = new Simulation_Trial__c();
                oSimTrial.Simulation__c = oSimulation.id;
                oSimTrial.Trial__c = oTrial.id;
                lSimulationTrials.add(oSimTrial);
            }
        }
        return lSimulationTrials;
    }
  */  
    
    
    /* 
     * @Method Name                    :  CreateBoardAttachments
     * @Description                    :  returns a list of BoardAttachments
     * @Return Type                    :  List of Attachments
     * @Parameters                     :  List of Boards
     */
     
       public static List<Attachment> CreateBoardAttachments(integer count,List<Boards__c> lBoards){
          List<Attachment> lBoardAttachment = new List<Attachment>();
          for(Boards__c oBoard : lBoards){
             for(Integer i =0; i<count; i++){
               Attachment bAttach = new Attachment();
               bAttach.Name= 'Test '+i;
               bAttach.Body=Blob.valueof('This is a Board');
               bAttach.ParentId=oBoard.id;
               bAttach.ContentType='image/png';
               lBoardAttachment.add(bAttach);
            }
           }
           return lBoardAttachment;
       }
}