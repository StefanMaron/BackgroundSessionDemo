codeunit 50100 ExpensiveFieldCalculationBPT
{
    trigger OnRun()
    var
        Results: Dictionary of [Text, Text];
    begin
        // Simulate an expensive operation
        Sleep(5000);
        Results.Add('ExpensiveFieldInBackground', '123.45');
        Page.SetBackgroundTaskResult(Results);
    end;

}