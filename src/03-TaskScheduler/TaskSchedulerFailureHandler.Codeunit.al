/// <summary>
/// Task Scheduler Failure Handler
/// Follows Microsoft's pattern from Codeunit 485 "Change Global Dim Err. Handler"
///
/// CRITICAL DISCOVERY: The failure handler CAN access error details!
/// - GetLastErrorText() returns the error message
/// - GetLastErrorCallStack() returns the call stack
/// - Receives the SAME record via TableNo as the main task
///
/// This is Microsoft's proven pattern for production Task Scheduler usage.
///
/// See: Base Application/Finance/Dimension/ChangeGlobalDimErrHandler.Codeunit.al
/// </summary>
codeunit 50124 "Task Scheduler Failure Handler"
{
    TableNo = "Task Execution Log";

    trigger OnRun()
    begin
        Rec.LockTable();

        // Reload the record to get latest state
        if not Rec.Get(Rec."Entry No.") then
            exit;

        // Update status to indicate failure
        Rec.Status := Rec.Status::Failed;

        // CRITICAL: GetLastErrorText() IS available in the failure handler!
        Rec."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(Rec."Error Message"));
        Rec."Handler Message" := 'Failure handler executed - error logged';

        Rec.Modify(true);

        // Note: The failure handler must complete successfully
        // If we throw an error here, it will be retried automatically
    end;
}
