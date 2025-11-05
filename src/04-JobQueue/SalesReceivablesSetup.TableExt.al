tableextension 50100 "Sales & Receivables Setup PTE" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Past Due Email Templ. Code PTE"; Code[10])
        {
            Caption = 'Past Due Email Template Code';
            DataClassification = ToBeClassified;
        }
        field(50101; "Past Due Email JQ Category PTE"; Code[10])
        {
            Caption = 'Past Due Email JQ Category';
            DataClassification = ToBeClassified;
            TableRelation = "Job Queue Category".Code;
        }
        field(50102; "Blocked Email Templ. Code PTE"; Code[10])
        {
            Caption = 'Blocked Email Template Code';
            DataClassification = ToBeClassified;
        }

        field(50103; "Blocked Email JQ Category PTE"; Code[10])
        {
            Caption = 'Blocked Email JQ Category';
            DataClassification = ToBeClassified;
            TableRelation = "Job Queue Category".Code;
        }
    }
}
