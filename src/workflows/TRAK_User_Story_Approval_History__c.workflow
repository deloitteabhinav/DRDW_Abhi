<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TRAK_USA_Approved_Send_Notification</fullName>
        <description>TRAK USA Approved &gt; Send Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_USA_Approved</template>
    </alerts>
    <alerts>
        <fullName>TRAK_USA_Rejected_Send_Notification</fullName>
        <description>TRAK USA Rejected &gt; Send Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_USA_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Update_on_History</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Approval Status Update on History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BSQ_Marked_Approved</fullName>
        <field>Business_Quality_Approved__c</field>
        <literalValue>1</literalValue>
        <name>BSQ Marked Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSQ_Mark_Approved</fullName>
        <field>Computer_Systems_Quality_Approved__c</field>
        <literalValue>1</literalValue>
        <name>CSQ Mark Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Approval_Status_on_User_Story</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Pending Approval Status on User Story</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>User_Story__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Status_on_User_Story</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected Status on User Story</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>User_Story__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Custodian_Mark_Approved</fullName>
        <description>System Custodian Mark Approved</description>
        <field>System_Custodian_Approved__c</field>
        <literalValue>1</literalValue>
        <name>System Custodian Mark Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Owner_Mark_Approved</fullName>
        <description>System Owner Mark Approved</description>
        <field>System_Owner_Approved__c</field>
        <literalValue>1</literalValue>
        <name>System Owner Mark Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Rejected_Status_on_User_Story_Hist</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>TRAK USA.Approval_Status &gt; Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_USA_Approval_Status_Approved</fullName>
        <description>Update the status of the USA Approval Status Field to &quot;Approved&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>TRAK USA.Approval_Status &gt; Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_USA_Approval_Status_to_Pending</fullName>
        <description>Sets the Approval Status on the USer Story Approval Record to &quot;Pending Approval&apos;</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>TRAK USA.Approval_Status &gt; Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_on_User_Story</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status on User Story</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>User_Story__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>TRAK_Update User Story Approval Status to Approved</fullName>
        <actions>
            <name>Update_Approval_Status_on_User_Story</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will update Approval Status on User Story record based on Approval Status on User Story History Object</description>
        <formula>ISPICKVAL(Approval_Status__c, &quot;Approved&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Update User Story Approval Status to Pending Approval</fullName>
        <actions>
            <name>Pending_Approval_Status_on_User_Story</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will update Approval Status on User Story record based on Approval Status on User Story History Object</description>
        <formula>ISPICKVAL(Approval_Status__c, &quot;Pending Approval&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Update User Story Approval Status to Rejected</fullName>
        <actions>
            <name>Rejected_Status_on_User_Story</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will update Approval Status on User Story record based on Approval Status on User Story History Object</description>
        <formula>ISPICKVAL(Approval_Status__c, &quot;Rejected&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
