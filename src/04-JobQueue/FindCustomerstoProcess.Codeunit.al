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

    begin
        JobQueueEntry.Init();
        JobQueueEntry.ScheduleJobQueueEntryWithParameters(Codeunit::"JQ Send Customer Notification", Customer.RecordId(), 'PASTDUE');
    end;

}
