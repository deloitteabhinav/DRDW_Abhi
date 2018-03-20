<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Unique_Sequence_Field</fullName>
        <description>Updates Unique Sequence field whenever Sequence is Entered.</description>
        <field>Unique_Sequence_text__c</field>
        <formula>if(TEXT(Sequence__c )!=null,CASESAFEID(Questionnaire__c) &amp;&apos;-&apos;&amp;  TEXT(Sequence__c ),&apos;&apos;)</formula>
        <name>Update Unique Sequence Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
