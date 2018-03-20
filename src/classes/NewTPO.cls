/****************************************************************************************************************************************** 
* Class Name   : NewTPO 
* Description  : Class to Create New TPO
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
Public with sharing class NewTPO 
{
	Public TPO_Location__c Tpolocation{get;set;}
	Public TPO__c Tpo{get;set;}
	
	Public Void CreateNewTpo(){
		insert Tpolocation;
		insert Tpo;
		
		SendGroupEmail([select id from group where name='Tpo Manager' Limit 1].id);
		
	}
	
	Public Static Void SendGroupEmail(Id GroupID){
		List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
		List<GroupMember> lGroup = new List<GroupMember>();
		lGroup = [Select UserOrGroupId From GroupMember where GroupId =:GroupID];
		for(GroupMember g : lGroup){
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			email.setPlainTextBody('Test');
			email.setSubject('New Tpo Created');
			email.setTargetObjectId(g.UserOrGroupId); 
			email.setSaveAsActivity(false);
			emails.add(email);
		}
		Messaging.sendEmail(emails);
	}
}