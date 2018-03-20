<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NoteExtID</fullName>
        <description>Note_TF = Board Id + Simulation Note Id</description>
        <field>Note_TF__c</field>
        <formula>Board__c &amp;&apos;+&apos;&amp; SimulationNoteId_TF__c</formula>
        <name>NoteExtID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NoteUpdate</fullName>
        <actions>
            <name>NoteExtID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Note_TF field on Simulation Note object.
Note_TF = Board Id + Simulation Note Id</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
