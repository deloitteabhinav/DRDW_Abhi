<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_sent_to_Approver_to_approve_Test_Execution_record</fullName>
        <description>Email Alert sent to Approver to approve Test Execution record</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Test_Execution_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_LastModified_to_review_approved_Test_Execution_record</fullName>
        <description>Email Alert sent to the Submitter to review the Approved Test Execution record</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_NEW_Test_Execution_Approved_Message</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_approver_when_approval_request_in_test_execution_is_recalled</fullName>
        <description>Email Alert sent to approver when approval request in test execution is recalled</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Test_Execution_Recall_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_the_Last_Modifier_to_review_the_Rejected_Test_Execution_reco</fullName>
        <description>Email Alert sent to the Submitter to review the Rejected Test Execution record</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_NEW_Test_Execution_Rejection_Message</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_to_Open_when_Recalled</fullName>
        <description>TRAK: The &quot;Approval Status&quot; field should be set to &quot;Open&quot; when the Test Execution record is recalled from an Approval</description>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Approval Status to Open when Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Approval_Test_Execution</fullName>
        <description>Update the Approval Status field on the Test Execution record to Pending Approval</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Pending Approval Test Execution</name>
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
        <fullName>TRAK_Test_Execution_Status_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>TRAK_Test Execution Status Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Test_Execution_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>TRAK_Test Execution Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Test_Execution_Uncheck_Lock</fullName>
        <field>Locked_For_editing__c</field>
        <literalValue>0</literalValue>
        <name>TRAK_Test Execution Uncheck Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Date_Test_Execution</fullName>
        <description>Update the Approval Date field on the Test Execution record</description>
        <field>Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Approval Date Test Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Test_Execution</fullName>
        <description>Update the Approval Status field on the Test Execution record</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status Test Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_to_Rejected_Test_Exec</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval to Rejected Test Exec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Recall_Flag_on_Test_Execution</fullName>
        <field>Recall_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Update Recall Flag on Test Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAK Test Execution Approved  Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_LastModified_to_review_approved_Test_Execution_record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Test__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Test Execution Recall Approval Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_approver_when_approval_request_in_test_execution_is_recalled</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Recall_Flag_on_Test_Execution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( AND( Text(PriorValue(Approval_Status__c))=&quot;Pending Approval&quot;, Text(Approval_Status__c)=&quot;Open&quot;, Recall_Flag__c ),true,false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Test Execution Rejected Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_the_Last_Modifier_to_review_the_Rejected_Test_Execution_reco</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Test__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Test Execution Send Approval Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_Approver_to_approve_Test_Execution_record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Test__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Update Rejected_Test_Execution</fullName>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule will change the status of an approved Test Execution to Open when it is updated</description>
        <formula>AND( ISPICKVAL(Approval_Status__c, &apos;Rejected&apos;),    NOT(ISCHANGED(Approval_Status__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
