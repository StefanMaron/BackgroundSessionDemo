pageextension 50100 "Sales & Receivables Setup PTE" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            group(EmailNotifications)
            {
                Caption = 'EMail Notification';
                field("Past Due Email Templ. Code PTE"; Rec."Past Due Email Templ. Code PTE") { }
                field("Past Due Email JQ Category PTE"; Rec."Past Due Email JQ Category PTE") { }
                field("Blocked Email Templ. Code PTE"; Rec."Blocked Email Templ. Code PTE") { }
                field("Blocked Email JQ Category PTE"; Rec."Blocked Email JQ Category PTE") { }

            }
        }





    }
}
