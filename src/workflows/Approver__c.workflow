<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CopyApprover_Backend_Field</fullName>
        <field>Approver_TF__c</field>
        <formula>Approver__r.FirstName  &amp;&apos; &apos;&amp;  Approver__r.LastName</formula>
        <name>CopyApprover_Backend_Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_ApproverName</fullName>
        <field>Name</field>
        <formula>Approver__r.FirstName &amp; &quot; &quot; &amp; Approver__r.LastName</formula>
        <name>Populate_ApproverName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approver_Record_Save</fullName>
        <actions>
            <name>Populate_ApproverName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Approver__c.Approver__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
