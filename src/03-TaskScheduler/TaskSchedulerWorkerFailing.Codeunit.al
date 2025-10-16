/// <summary>
/// Task Scheduler Worker (Failing) - Intentionally throws an error
/// Demonstrates the RecordID pattern used by Microsoft in Change Global Dimensions.
///
/// MICROSOFT'S PATTERN:
/// 1. Main task receives a Record via TableNo (the RecordID parameter from CreateTask)
/// 2. Task updates Rec as it progresses
/// 3. On failure, failure handler receives THE SAME Rec
/// 4. Failure handler uses GetLastErrorText() to get error details
///
/// See: Codeunit 483 "Change Global Dimensions" and Codeunit 485 "Change Global Dim Err. Handler"
/// </summary>
codeunit 50123 "Task Scheduler Worker Failing"
{
    TableNo = "Task Execution Log";

    trigger OnRun()
    begin
        // Update status to show task is running
        Rec.Status := Rec.Status::Running;
        Rec.Modify(true);

        Sleep(1000); // Simulate some work

        // Intentionally fail to trigger the failure handler
        Error('Intentional error to demonstrate failure handling');

        // Note: If task succeeds, update status:
        // Rec.Status := Rec.Status::Completed;
        // Rec.Modify(true);
    end;
}
