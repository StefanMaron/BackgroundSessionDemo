/// <summary>
/// Simple background task example - 6 second task
/// </summary>
codeunit 50113 "Simple BG Task 3"
{
    trigger OnRun()
    begin
        // Task duration: 6 seconds
        Sleep(6000);
    end;
}
