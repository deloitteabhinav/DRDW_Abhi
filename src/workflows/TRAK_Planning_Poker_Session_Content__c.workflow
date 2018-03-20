<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TRAK_Planning_Poker_Sess_Content_Uniq</fullName>
        <description>Set a unique Id on Planning Poker session content in order to make sure the same user story cannot be added twice to the same session</description>
        <field>Unique_Id__c</field>
        <formula>User_Story__r.Id &amp; &apos;-&apos; &amp; Planning_Poker_Session__r.Id</formula>
        <name>Planning Poker Session Content Unique Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAK_Planning Poker Session Content Unique Id</fullName>
        <actions>
            <name>TRAK_Planning_Poker_Sess_Content_Uniq</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set a unique Id on Planning Poker session content in order to make sure the same user story cannot be added twice to the same session</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
