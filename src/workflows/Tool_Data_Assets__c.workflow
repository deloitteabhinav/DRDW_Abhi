<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UniqueToolDataAsset</fullName>
        <field>Unique_Tool_Data_Asset_TF__c</field>
        <formula>CASESAFEID(Related_Data_Asset__c) &amp;&apos;+&apos;&amp; CASESAFEID(Related_Tool_Inventory__c)</formula>
        <name>UniqueToolDataAsset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique_Tool_Data_Asset</fullName>
        <actions>
            <name>UniqueToolDataAsset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
