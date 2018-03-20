public class TRAK_UpdateBurndownChart implements Schedulable, Database.Batchable<SObject> {
    public String query {set;get; }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
     query = Label.TRAK_Burndown_Query;
     return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, list<TRAK_Sprint__c> activeSprints) {
        TRAK_automateBurnDown.updateSprintBurndown(activeSprints);
    }
    public void finish(Database.BatchableContext bc) {
        
    }
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
}