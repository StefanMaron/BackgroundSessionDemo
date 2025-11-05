codeunit 50103 "Job Queue Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateJobQueueCategory();
        UpdateSalesReceivablesSetup();
        CreateRecurringJobQueueEntry();
    end;

    local procedure CreateJobQueueCategory()
    var
        JobQueueCategory: Record "Job Queue Category";
    begin
        if JobQueueCategory.Get('EMAILNOTIF') then
            exit;

        JobQueueCategory.Init();
        JobQueueCategory.Code := 'EMAILNOTIF';
        JobQueueCategory.Description := 'Email Notification Handler';
        JobQueueCategory.Insert(true);
    end;

    local procedure UpdateSalesReceivablesSetup()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if not SalesReceivablesSetup.Get() then
            exit;

        SalesReceivablesSetup."Past Due Email Templ. Code PTE" := 'PASTDUE';
        SalesReceivablesSetup."Past Due Email JQ Category PTE" := 'EMAILNOTIF';
        SalesReceivablesSetup."Blocked Email Templ. Code PTE" := 'CUSTBLOCK';
        SalesReceivablesSetup."Blocked Email JQ Category PTE" := 'EMAILNOTIF';
        SalesReceivablesSetup.Modify(true);
    end;

    local procedure CreateRecurringJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Find Customers to Process");
        JobQueueEntry.SetRange("Recurring Job", true);
        if not JobQueueEntry.IsEmpty() then
            exit;

        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"Find Customers to Process";
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Starting Time" := 190000T; // 19:00:00
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."No. of Minutes between Runs" := 1440; // 24 hours
        JobQueueEntry.Insert(true);
    end;
}
