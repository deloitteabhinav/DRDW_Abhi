<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Unique_Sequence_Text_Field</fullName>
        <description>Updates Unique Sequence Text field  (on Checklist Master Item junction object) whenever Sequence is Entered.</description>
        <field>Unique_Sequence_text__c</field>
        <formula>if(TEXT(Sequence__c )!=null,CASESAFEID(Checklist_Version_Id__c ) &amp;&apos;-&apos;&amp; TEXT(Sequence__c ) &amp;&apos;-&apos;&amp; Text(  Checklist_Item_Id__r.Process__c) ,&apos;&apos;)</formula>
        <name>PANG Update Unique Sequence Text Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
