/// <summary>
/// Simple background task example - 8 second task
/// </summary>
codeunit 50112 "Simple BG Task 2"
{
    trigger OnRun()
    begin
        // Task duration: 8 seconds (longest task)
        Sleep(8000);
    end;
}
