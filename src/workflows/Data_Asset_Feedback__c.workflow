<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Study_Data_Asset</fullName>
        <field>Unique_Study_DataAsset_TF__c</field>
        <formula>Study__r.Id &amp;&apos; &apos;&amp; Data_Asset__r.Id</formula>
        <name>Study Data_Asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Unique Data Asset Feedback</fullName>
        <actions>
            <name>Study_Data_Asset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
