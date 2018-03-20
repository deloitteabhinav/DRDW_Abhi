<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Study_TPO_Location</fullName>
        <field>Unique_Study_TPO_Location__c</field>
        <formula>Study__r.Id &amp;&apos; &apos;&amp; TPO__r.Id</formula>
        <name>Study TPO_Location</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Unique TPO Feedback</fullName>
        <actions>
            <name>Study_TPO_Location</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
