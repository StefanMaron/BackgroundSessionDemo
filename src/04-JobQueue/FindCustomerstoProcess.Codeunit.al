codeunit 50101 "Find Customers to Process"
{
    trigger OnRun()
    begin
        CreateJobQueueEntriesForPastDueCustomers();
    end;

    local procedure CreateJobQueueEntriesForPastDueCustomers()
    var
        Customer: Record Customer;
    begin
        Customer.SetLoadFields("No.", "Balance Due");
        Customer.SetAutoCalcFields("Balance Due");
        Customer.Setfilter("Balance Due", '<>%1', 0);
        if not Customer.FindSet() then
            exit;

        repeat
            DoCreateJobQueueEntryForCustomer(Customer);
        until Customer.next() = 0;
    end;

    local procedure DoCreateJobQueueEntryForCustomer(Customer: Record Customer)
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueManagement: Codeunit "Job Queue Management";

    begin
        JobQueueEntry.Init();
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime() + 600000;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"JQ Send Customer Notification";
        JobQueueEntry."Record ID to Process" := Customer.RecordId;
        JobQueueEntry.Description := CopyStr(StrSubstNo('Past Due Notice: %1 %2', Customer."No.", Customer.Name), 1, MaxStrLen(JobQueueEntry.Description));
        JobQueueEntry."Run in User Session" := false;
        JobQueueEntry."Parameter String" := 'PASTDUE';
        codeunit.run(codeunit::"Job Queue - Enqueue", JobQueueEntry);
    end;

}
