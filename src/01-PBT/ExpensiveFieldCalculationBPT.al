codeunit 50100 ExpensiveFieldCalculationBPT
{
    trigger OnRun()
    var
        Parameters, Results : Dictionary of [Text, Text];
    begin
        // Simulate an expensive operation
        Parameters := Page.GetBackgroundParameters();
        Sleep(5000);
        Results.Add('ExpensiveFieldInBackground', '123.45');
        Page.SetBackgroundTaskResult(Results);
    end;

}