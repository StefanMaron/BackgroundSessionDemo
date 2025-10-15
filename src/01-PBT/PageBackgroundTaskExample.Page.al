page 50100 PageBackgroundTaskExample
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Name; 'Some Name') { }
                field(Description; 'Some Description') { }
                field(ExpensiveField; SomeExpensiveReadingOperation()) { }
                field(ExpensiveFieldInBackground; ExpensiveFieldInBackground) { }
            }
        }
    }

    var
        ExpensiveFieldInBackground: Decimal;
        ExpensiveFieldInBackgroundTaskId: Integer;

    local procedure SomeExpensiveReadingOperation(): Decimal
    begin
        // Simulate an expensive operation
        Sleep(5000);
        exit(123.45);
    end;

    trigger OnAfterGetRecord()
    begin
        StartBackgroundCalculation();
    end;

    local procedure StartBackgroundCalculation()
    var
        Parameters: Dictionary of [Text, Text];
    begin
        CurrPage.EnqueueBackgroundTask(ExpensiveFieldInBackgroundTaskId, Codeunit::ExpensiveFieldCalculationBPT, Parameters);
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    begin
        Evaluate(ExpensiveFieldInBackground, Results.Get('ExpensiveFieldInBackground'));
    end;

    trigger OnPageBackgroundTaskError(TaskId: Integer; ErrorCode: Text; ErrorText: Text; ErrorCallStack: Text; var IsHandled: Boolean)
    var
        Notification: Notification;
    begin
        Notification.Id := '93b8551d-b1a9-4912-8b3c-a5364959e6c4';
        Notification.Message := StrSubstNo('Background task %1 failed with error: %2', TaskId, ErrorText);
        Notification.Send();
        IsHandled := true;
    end;
}