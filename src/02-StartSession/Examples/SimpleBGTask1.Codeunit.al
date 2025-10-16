/// <summary>
/// Simple background task example - 5 second task
/// </summary>
codeunit 50111 "Simple BG Task 1"
{
    trigger OnRun()
    begin
        // Task duration: 5 seconds
        Sleep(5000);
    end;
}
