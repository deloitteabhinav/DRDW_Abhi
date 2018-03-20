Public with Sharing CLass AccountTriggerHandler{

    Public static void AssignTasks(List<Account> lAccounts){
        Set<Id> sAccountIds = new Set<Id>();
        Set<Id> sContactIds = new Set<Id>();
        Map<Id,List<Contact>> mMap = new Map<Id,List<Contact>>();
        List<Task> lTasks = new List<Task>();
        List<Contact> lContacts = new List<Contact>();
        
        For(Account oAccount: lAccounts){
            sAccountIds.add(oAccount.Id);
        }
        
        For(Contact oContact: [Select Id,AccountId,Task_Sent__c from Contact where AccountId IN :sAccountIds]){
            If(mMap.containsKey(oContact.AccountId)){
                mMap.get(oContact.AccountId).add(oContact);
            }
            Else{
                mMap.put(oContact.AccountId,new List<Contact>{oContact});
            }
            sContactIds.add(oContact.Id);
        }
        
        
        Map<Id,Id> mContactUserMap = new Map<Id,Id>(); 
        For(User u : [Select Id,ContactId from User where ContactId IN :sContactIds]){
            mContactUserMap.put(u.ContactId,u.id);
        }
        
        For(Account oAccount: lAccounts){
            If(oAccount.Active__c == 'Yes' && mMap.containsKey(oAccount.Id)){
                For(Contact oContact: mMap.get(oAccount.Id)){
                    If(mContactUserMap.containsKey(oContact.Id) && !oContact.Task_Sent__c){
                        Task oTask = new Task();
                        oTask.OwnerId = mContactUserMap.get(oContact.Id);
                        oTask.Subject = 'Setup weekly status meetings';
                        oTask.Status = 'In Progress';
                        oTask.Priority = 'High';
                        oTask.WhatId = oAccount.Id;
                        oTask.ActivityDate = Date.Today() + 7;
                        lTasks.add(oTask);
                        
                        oTask = new Task();
                        oTask.OwnerId = mContactUserMap.get(oContact.Id);
                        oTask.Subject = 'Review initial draft research paper';
                        oTask.Status = 'In Progress';
                        oTask.Priority = 'High';
                        oTask.WhatId = oAccount.Id;
                        oTask.ActivityDate = Date.Today() + 14;
                        lTasks.add(oTask);
                        
                        oTask = new Task();
                        oTask.OwnerId = mContactUserMap.get(oContact.Id);
                        oTask.Subject = 'Pre-final review of research paper';
                        oTask.Status = 'In Progress';
                        oTask.Priority = 'High';
                        oTask.WhatId = oAccount.Id;
                        oTask.ActivityDate = Date.Today() + 28;
                        lTasks.add(oTask);
                        
                        oTask = new Task();
                        oTask.OwnerId = mContactUserMap.get(oContact.Id);
                        oTask.Subject = 'Final review of research paper';
                        oTask.Status = 'In Progress';
                        oTask.Priority = 'High';
                        oTask.WhatId = oAccount.Id;
                        oTask.ActivityDate = Date.Today() + 42;
                        lTasks.add(oTask);
                        
                        oTask = new Task();
                        oTask.OwnerId = mContactUserMap.get(oContact.Id);
                        oTask.Subject = 'For internal team: Publish research paper onto internal system';
                        oTask.Status = 'In Progress';
                        oTask.Priority = 'High';
                        oTask.WhatId = oAccount.Id;
                        oTask.ActivityDate = Date.Today() + 45;
                        lTasks.add(oTask);
                      
                        oContact.Task_Sent__c = True;
                        lContacts.add(oContact);
                    }
                }
            }
        }
        
        Insert lTasks;
        Update lContacts;
        
    }

}