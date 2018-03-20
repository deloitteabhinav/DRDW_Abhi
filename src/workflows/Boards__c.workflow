<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Board_TF_Update</fullName>
        <field>Board_TF__c</field>
        <formula>Simulation__c &amp;&apos;+&apos;&amp; Board_Title__c</formula>
        <name>Board_TF_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BoardExtID</fullName>
        <actions>
            <name>Board_TF_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the Board_TF field on the Board object.
Board_TF = Simulation Id + Board Title</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
