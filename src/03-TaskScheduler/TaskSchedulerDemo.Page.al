/// <summary>
/// Task Scheduler Demo Page
/// Demonstrates scheduling tasks to run at specific times using TaskScheduler.CreateTask()
///
/// Key Concepts:
/// - Tasks can be scheduled to run immediately or at future times (NotBefore parameter)
/// - Tasks must be in "Ready" state to execute (IsReady parameter)
/// - TaskExists() checks if a task still exists (completed tasks are removed)
/// - Each task gets a unique GUID identifier
/// </summary>
page 50112 "Task Scheduler Demo"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Task Scheduler Demo';

    layout
    {
        area(Content)
        {
            group(Information)
            {
                Caption = 'About Task Scheduler';

                field(InfoText1; 'Task Scheduler is designed for SCHEDULED or DELAYED execution')
                {
                    Caption = 'Key Concept';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                    Style = Strong;
                }

                field(InfoText2; 'Tasks can run immediately, after a delay, or at a specific time')
                {
                    Caption = 'Scheduling';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }

                field(InfoText3; 'Completed tasks are REMOVED from the database (TaskExists returns false)')
                {
                    Caption = 'Lifecycle';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }

                field(InfoText4; 'Tasks survive server restarts and have automatic retry logic')
                {
                    Caption = 'Reliability';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }
            }

            group(DemoSetup)
            {
                Caption = 'Demo Configuration';

                field(DemoDescription; 'Schedules the SAME worker 3 times with different delays')
                {
                    Caption = 'Scheduled Tasks Demo';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                    MultiLine = true;
                }

                field(Task1Info; 'Task 1: Run immediately (NotBefore = now)')
                {
                    Caption = 'Task 1';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }

                field(Task2Info; 'Task 2: Run after 3 second delay')
                {
                    Caption = 'Task 2';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }

                field(Task3Info; 'Task 3: Run after 6 second delay')
                {
                    Caption = 'Task 3';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }

                field(FailureInfo; 'Demonstrates Microsoft''s RecordID pattern for error handling')
                {
                    Caption = 'Failure Demo';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunDemo)
            {
                Caption = 'Run Scheduled Tasks Demo';
                ApplicationArea = All;
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Schedules the same worker 3 times with different NotBefore times';

                trigger OnAction()
                var
                    TaskLog1, TaskLog2, TaskLog3 : Record "Task Execution Log";
                    Task1Id, Task2Id, Task3Id : Guid;
                begin
                    // ═══════════════════════════════════════════════════════════════════════════
                    // CREATE LOG ENTRIES AND SCHEDULED TASKS
                    // Same pattern as failure demo - create log entry first, pass RecordID
                    // ═══════════════════════════════════════════════════════════════════════════

                    // Task 1: Run immediately
                    TaskLog1.Init();
                    TaskLog1."Execution Time" := CurrentDateTime;
                    TaskLog1.Status := TaskLog1.Status::Pending;
                    TaskLog1.Insert(true);

                    Task1Id := TaskScheduler.CreateTask(
                        Codeunit::"Task Scheduler Worker",
                        0, // No failure codeunit
                        true, // IsReady = true
                        CompanyName,
                        CurrentDateTime, // NotBefore = now
                        TaskLog1.RecordId
                    );
                    TaskLog1."Task ID" := Task1Id;
                    TaskLog1.Modify(true);

                    // Task 2: Run after 3 seconds (same worker!)
                    TaskLog2.Init();
                    TaskLog2."Execution Time" := CurrentDateTime;
                    TaskLog2.Status := TaskLog2.Status::Pending;
                    TaskLog2.Insert(true);

                    Task2Id := TaskScheduler.CreateTask(
                        Codeunit::"Task Scheduler Worker",
                        0,
                        true,
                        CompanyName,
                        CurrentDateTime + 3000, // NotBefore = now + 3 seconds
                        TaskLog2.RecordId
                    );
                    TaskLog2."Task ID" := Task2Id;
                    TaskLog2.Modify(true);

                    // Task 3: Run after 6 seconds (same worker!)
                    TaskLog3.Init();
                    TaskLog3."Execution Time" := CurrentDateTime;
                    TaskLog3.Status := TaskLog3.Status::Pending;
                    TaskLog3.Insert(true);

                    Task3Id := TaskScheduler.CreateTask(
                        Codeunit::"Task Scheduler Worker",
                        0,
                        true,
                        CompanyName,
                        CurrentDateTime + 6000, // NotBefore = now + 6 seconds
                        TaskLog3.RecordId
                    );
                    TaskLog3."Task ID" := Task3Id;
                    TaskLog3.Modify(true);

                    // ═══════════════════════════════════════════════════════════════════════════
                    // TASKS ARE NOW SCHEDULED
                    // They will run in background at their scheduled times
                    // Check the Task Execution Log to see results
                    // ═══════════════════════════════════════════════════════════════════════════

                    // Open log page to show results
                    Page.Run(Page::"Task Execution Log");
                end;
            }

            action(RunFailureDemo)
            {
                Caption = 'Run Failure Handler Demo';
                ApplicationArea = All;
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Demonstrates Microsoft''s RecordID pattern for error handling';

                trigger OnAction()
                var
                    TaskLog: Record "Task Execution Log";
                    FailingTaskId: Guid;
                begin
                    // ═══════════════════════════════════════════════════════════════════════════
                    // MICROSOFT'S PATTERN: RecordID-based Task Tracking
                    // Based on Codeunit 483 "Change Global Dimensions"
                    //
                    // 1. Create a log entry FIRST
                    // 2. Pass log entry's RecordID to CreateTask
                    // 3. Main task receives Rec via TableNo
                    // 4. Failure handler receives THE SAME Rec via TableNo
                    // 5. Failure handler can call GetLastErrorText()!
                    // ═══════════════════════════════════════════════════════════════════════════

                    // STEP 1: Create log entry BEFORE scheduling task
                    TaskLog.Init();
                    TaskLog."Entry No." := 0; // Auto-increment
                    TaskLog."Execution Time" := CurrentDateTime;
                    TaskLog.Status := TaskLog.Status::Pending;
                    TaskLog.Insert(true);

                    // STEP 2: Schedule task with RecordID
                    // Both main task AND failure handler receive this record
                    FailingTaskId := TaskScheduler.CreateTask(
                        Codeunit::"Task Scheduler Worker Failing", // TableNo = Task Execution Log
                        Codeunit::"Task Scheduler Failure Handler", // TableNo = Task Execution Log
                        true,
                        CompanyName,
                        CurrentDateTime,
                        TaskLog.RecordId // ← Pass the log record!
                    );

                    // Store Task ID for correlation
                    TaskLog."Task ID" := FailingTaskId;
                    TaskLog.Modify(true);

                    // Open log page to monitor results
                    Page.Run(Page::"Task Execution Log");
                end;
            }

            action(ViewLog)
            {
                Caption = 'View Execution Log';
                ApplicationArea = All;
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View the log of failed tasks';

                trigger OnAction()
                begin
                    Page.Run(Page::"Task Execution Log");
                end;
            }
        }
    }
}
