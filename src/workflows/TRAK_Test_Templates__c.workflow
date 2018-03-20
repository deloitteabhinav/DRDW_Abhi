<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_sent_to_Approver_to_approve_Test_script_record</fullName>
        <description>Email Alert sent to Approver to approve Test script record</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Test_Script_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_LastModified_to_review_Rejected_Test_Script_record</fullName>
        <description>Email_Alert_sent_to_LastModified_to_review_Rejected_Test_Script_record</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Test_Script_Rejection_Message</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_Submitter_to_review_approved_Test_Script_record</fullName>
        <description>Email_Alert_sent_to_Submitter_to_review_approved_Test_Script_record</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_NEW_Test_Script_Approved_Message</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_approver_when_approval_request_is_recalled</fullName>
        <description>Email Alert sent to approver when approval request is recalled</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Test_Script_Recall_Request</template>
    </alerts>
    <alerts>
        <fullName>TRAK_Send_rejection_notification_to_Submitter_of_test_script</fullName>
        <description>Send rejection notification to Submitter of test script</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_NEW_Test_Script_Rejection_Message</template>
    </alerts>
    <alerts>
        <fullName>TRAK_Send_rejection_notification_to_last_modifier_of_test_script</fullName>
        <description>Send rejection notification to last modifier of test script</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Test_Script_Rejection_Message</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Rejection_Update</fullName>
        <description>Update Approval status to Rejected</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Rejection Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Approval</fullName>
        <description>Update status to &quot;Pending Approval&quot; on initial submission</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>TRAK_Approval_Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Check_Locked_for_Editing_Submission</fullName>
        <field>Locked_For_editing__c</field>
        <literalValue>1</literalValue>
        <name>TRAK_Check Locked for Editing Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_TestScipt_Step_Locked</fullName>
        <field>Locked_For_editing__c</field>
        <literalValue>1</literalValue>
        <name>TRAK_TestScipt_Step_Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Uncheck_lock</fullName>
        <field>Locked_For_editing__c</field>
        <literalValue>0</literalValue>
        <name>TRAK_Uncheck lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Update_Approval_Date</fullName>
        <description>This will blank out the Approval date if the approved test script is edited</description>
        <field>Approval_Date__c</field>
        <name>Update Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Update_Approval_Status</fullName>
        <description>Update approval status to Open</description>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApproval_StatusToOpen_TestScript</fullName>
        <description>TRAK: Update the Approval Status to Open when the approval request is recalled / rejected.</description>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>UpdateApproval StatusToOpen-TestScript</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Date</fullName>
        <description>Update Approval date to current time</description>
        <field>Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <description>Change status to &quot;Approved&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Recall_Flag</fullName>
        <field>Recall_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Update Recall Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAK Test Script Recall Approval Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_approver_when_approval_request_is_recalled</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Recall_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( 	AND( 	Text(PriorValue(Approval_Status__c))=&quot;Pending Approval&quot;, 	Text(Approval_Status__c)=&quot;Open&quot;, Recall_Flag__c   ),true,false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Test Script Send Approval Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_Approver_to_approve_Test_script_record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Test_Templates__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Test Script Send Approved Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_Submitter_to_review_approved_Test_Script_record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_User_Story__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Test Script Send Rejection Notification</fullName>
        <actions>
            <name>TRAK_Send_rejection_notification_to_Submitter_of_test_script</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_User_Story__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Update Approved_Test_Script</fullName>
        <actions>
            <name>TRAK_Update_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TRAK_Update_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule will change the status of an approved Test Script to Open when it is updated</description>
        <formula>AND(    OR(       ISPICKVAL(Approval_Status__c, &apos;Approved&apos;),        ISPICKVAL(Approval_Status__c, &apos;Rejected&apos;)    ),    NOT(ISCHANGED(Approval_Status__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
