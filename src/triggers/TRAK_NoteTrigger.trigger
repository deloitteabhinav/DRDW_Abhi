trigger TRAK_NoteTrigger on Note (after insert, after update, after undelete) {

if((Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) && (Trigger.isAfter)) {
TRAK_NoteTriggerHandler.duplicateNameCheck(trigger.new);
}

}