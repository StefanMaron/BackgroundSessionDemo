/// <summary>
/// Task Scheduler Worker - Successful task with logging
/// Demonstrates a task that completes successfully and logs to the Task Execution Log
/// Uses the same RecordID pattern as the failure handler
/// </summary>
codeunit 50120 "Task Scheduler Worker"
{
    TableNo = "Task Execution Log";

    trigger OnRun()
    begin
        // Update status to Running
        Rec.Status := Rec.Status::Running;
        Rec.Modify(true);

        // Simulate work
        Sleep(2000);

        // Mark as completed
        Rec.Status := Rec.Status::Completed;
        Rec."Handler Message" := 'Task completed successfully';
        Rec.Modify(true);
    end;
}
