/****************************************************************************************************************************************** 
 * Class Name   : StudyTeamMembersController 
 * Description  : Class to display team members on a Study Record
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
public with sharing class StudyTeamMembersController {
  
    public list < user > lStudyTeamMembers {
        get;
        set;
    }

    public StudyTeamMembersController(ApexPages.StandardController controller) {
        Set < ID > lUsers = new Set < id > ();

        for (Project__Share oShare: [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : (Id) controller.getId() AND AccessLevel = 'Edit']) {
            lUsers.add(oShare.UserOrGroupId);
        }
        lStudyTeamMembers = [SELECT id, Name from USER where id IN: lUsers];
    }
}