public class TRAK_NoteTriggerHandler {

public static final String DUPLICATE_NOTE = 'You cannot attach the same note multiple times to the same Record. Please update the Title of the Note. ';

    public static void duplicateNameCheck(List<Note> lNote) {
       Set<Id> parentIDs = new Set<ID>();
       Map<String,List<Note>> mNoteTitleParentIdtoId = new Map<String,List<Note>>();
       for(Note oNote : lNote) {
           if(String.valueOf(oNote.ParentId.getSObjectType()).startswithIgnoreCase('TRAK_')) {
               parentIDs.add(oNote.ParentId);
               if(mNoteTitleParentIdtoId.containsKey(oNote.Title+','+oNote.ParentId)) {
               List<Note> lNoteID = mNoteTitleParentIdtoId.get(oNote.Title+','+oNote.ParentId);
               lNoteID.add(oNote);
               mNoteTitleParentIdtoId.put(oNote.Title+','+oNote.ParentId,lNoteID);
               } else {
               List<Note> lNoteID = new List<Note>();
               lNoteID.add(oNote);
               mNoteTitleParentIdtoId.put(oNote.Title+','+oNote.ParentId,lNoteID);
               }
           }
       }
        
       if(parentIds.size() > 0) { 
           List<AggregateResult> lDuplicateNotes = [SELECT Count(id) recCount, Title title, ParentId parentId FROM Note where ParentID IN :parentIds group by ParentId, Title having count(id) > 1 limit 2000];
           //lNote[0].addError('**'+parentIds);
           if(lDuplicateNotes.size() > 0) {
                 for(AggregateResult ar : lDuplicateNotes) {
                     if(mNoteTitleParentIdtoId.containsKey(ar.get('title')+','+ar.get('parentId'))) {
                     for(Note oNote : mNoteTitleParentIdtoId.get(ar.get('title')+','+ar.get('parentId'))) {
                         oNote.Title.addError(DUPLICATE_NOTE);
                     }
                 }    
                 }            
           }
       }
           
    }
    
}