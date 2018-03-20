<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UniqueStudyMolecule</fullName>
        <field>Unique_Molecule_TF__c</field>
        <formula>CASESAFEID(Project__c) &amp;&apos;+&apos;&amp; CASESAFEID(Molecule__c)</formula>
        <name>UniqueStudyMolecule</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique_StudyMolecule</fullName>
        <actions>
            <name>UniqueStudyMolecule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
