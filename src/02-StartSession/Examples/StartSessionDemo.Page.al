/// <summary>
/// Demo page showing parallel task execution with StartSession
/// </summary>
page 50111 "Start Session Demo"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Start Session Demo';

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                Caption = 'Demo Setup';
                InstructionalText = 'This demo runs 3 background tasks in parallel while the main session continues working. Click "Run 3 Tasks in Parallel" to start.';

                field(Task1Info; 'Background Task 1: 5 seconds')
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(Task2Info; 'Background Task 2: 8 seconds (longest)')
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(Task3Info; 'Background Task 3: 6 seconds')
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(MainInfo; 'Main Session Work: 4 seconds (8 iterations)')
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(ComparisonInfo; 'Sequential: 23 sec | Parallel: ~8 sec')
                {
                    Editable = false;
                    ShowCaption = false;
                    Style = Strong;
                }
            }

            group(Results)
            {
                Caption = 'Results';

                field(ExecutionTimeInfo; ExecutionTimeText)
                {
                    Caption = 'Total Time';
                    Editable = false;
                    Style = Strong;
                }
            }
            group(Details)
            {

                field(StatusInfo; StatusText)
                {
                    Caption = 'Details';
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunParallelTasks)
            {
                Caption = 'Run 3 Tasks in Parallel';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RunTasksInParallel();
                end;
            }

            action(ClearAction)
            {
                Caption = 'Clear';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    StatusText := '';
                    ExecutionTimeText := '';
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        StatusText: Text;
        ExecutionTimeText: Text;

    local procedure RunTasksInParallel()
    var
        TaskManager: Codeunit "Background Task Manager";
        ProgressDialog: Dialog;
        StartTime: DateTime;
        Session1, Session2, Session3 : Integer;
        AllCompleted: Boolean;
        MainSessionWork: Integer;
        I: Integer;
        ProgressText: Text;
    begin
        // ═══════════════════════════════════════════════════════════════════
        // STEP 1: INITIALIZE
        // ═══════════════════════════════════════════════════════════════════
        TaskManager.ClearAll();
        StartTime := CurrentDateTime();

        // Open progress dialog to show real-time updates
        ProgressDialog.Open(
            'Running Background Tasks...\' +
            '\' +
            'Background Sessions: #1##################\' +
            '\' +
            '#2##########################################\' +
            '\' +
            'Progress: #3##########################################');

        // ═══════════════════════════════════════════════════════════════════
        // STEP 2: START BACKGROUND SESSIONS IN PARALLEL
        // This is the key step - all 3 tasks start simultaneously!
        // ═══════════════════════════════════════════════════════════════════
        ProgressDialog.Update(1, 'Starting background sessions...');

        // Start all three background sessions - they run in parallel
        Session1 := TaskManager.StartTask(Codeunit::"Simple BG Task 1");  // 5 seconds
        Session2 := TaskManager.StartTask(Codeunit::"Simple BG Task 2");  // 8 seconds
        Session3 := TaskManager.StartTask(Codeunit::"Simple BG Task 3");  // 6 seconds

        ProgressDialog.Update(1, StrSubstNo('✓ Started: %1, %2, %3', Session1, Session2, Session3));
        ProgressDialog.Update(2, '→ Main session is NOT blocked! Doing work here...');

        // ═══════════════════════════════════════════════════════════════════
        // STEP 3: MAIN SESSION CONTINUES WORKING
        // While background tasks run, the main session is FREE to do other work
        // This demonstrates that StartSession is NON-BLOCKING
        // ═══════════════════════════════════════════════════════════════════
        for I := 1 to 8 do begin
            Sleep(500); // Simulate some work (8 × 500ms = 4 seconds total)
            MainSessionWork += Random(100);
            ProgressDialog.Update(3, StrSubstNo('  Iteration %1/8 - Value: %2', I, MainSessionWork));
        end;

        ProgressDialog.Update(2, '✓ Main session work complete (4 seconds elapsed)');
        Sleep(500);
        ProgressDialog.Update(3, '→ Now waiting for remaining background tasks...');

        // ═══════════════════════════════════════════════════════════════════
        // STEP 4: WAIT FOR ALL BACKGROUND TASKS TO COMPLETE
        // WaitAll() polls until all background sessions finish
        // At this point, main session work is done (4 sec), but background tasks
        // may still be running (longest is 8 sec)
        // ═══════════════════════════════════════════════════════════════════
        AllCompleted := TaskManager.WaitAll(15000);  // Wait max 15 seconds

        // ═══════════════════════════════════════════════════════════════════
        // STEP 5: SHOW RESULTS
        // Total time should be ~8 seconds (max of all parallel tasks)
        // instead of 23 seconds if run sequentially!
        // ═══════════════════════════════════════════════════════════════════
        if AllCompleted then begin
            ExecutionTimeText := StrSubstNo('All tasks completed in %1 seconds',
                Round((CurrentDateTime() - StartTime) / 1000, 0.01));
            ProgressDialog.Update(3, '✓ All background tasks completed successfully!');
            Sleep(1000);
        end else begin
            ExecutionTimeText := 'Timeout!';
            ProgressDialog.Update(3, '⚠ Not all background tasks completed within timeout.');
            Sleep(1000);
        end;

        ProgressDialog.Close();

        // Update page with final status
        StatusText := 'Demo completed! Check execution time below.\' +
                     '\' +
                     StrSubstNo('Sessions: %1, %2, %3', Session1, Session2, Session3) + '\' +
                     StrSubstNo('Main session iterations: %1', MainSessionWork);
        CurrPage.Update(false);
    end;
}
