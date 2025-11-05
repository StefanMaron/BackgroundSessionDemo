codeunit 50102 "JQ Send Customer Notification"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Customer: Record Customer;
        UnknownNoticeErr: Label 'Unknown Notice to Send';

    begin
        if not Customer.get(rec."Record ID to Process") then
            exit;

        case rec."Parameter String" of
            'PASTDUE':
                SendPastDueNotice(Customer);
            'BLOCKED':
                SendBlockedNotice(Customer);
            else
                Error(UnknownNoticeErr);
        end;
    end;

    local procedure SendPastDueNotice(Customer: Record Customer);
    var
        SalesSetup: Record "Sales & Receivables Setup";

    begin
        Customer.CalcFields("Balance Due");
        if Customer."Balance Due" = 0 then
            exit;

        SalesSetup.get();
        SalesSetup.TestField("Past Due Email Templ. Code PTE");
        DoSendNotification(Customer, SalesSetup."Past Due Email Templ. Code PTE", SalesSetup."Past Due Email JQ Category PTE");

    end;

    local procedure SendBlockedNotice(Customer: Record Customer);
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if Customer.IsBlocked() then
            exit;

        SalesSetup.get();
        SalesSetup.TestField("Blocked Email Templ. Code PTE");
        DoSendNotification(Customer, SalesSetup."Blocked Email Templ. Code PTE", SalesSetup."Blocked Email JQ Category PTE");
    end;

    local procedure DoSendNotification(Customer: Record Customer; EmailNotificationCode: Code[10]; JQCategoryCode: Code[10]);
    begin

        // Find Email Template, Populate and send email.

    end;
}
