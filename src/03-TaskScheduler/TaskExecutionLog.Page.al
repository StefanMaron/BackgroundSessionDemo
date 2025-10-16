/// <summary>
/// Task Execution Log page
/// Shows the results of failed tasks handled by the failure codeunit
/// </summary>
page 50113 "Task Execution Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Task Execution Log";
    Caption = 'Task Execution Log';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Task ID"; Rec."Task ID")
                {
                    ApplicationArea = All;
                }
                field("Execution Time"; Rec."Execution Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                }
                field("Handler Message"; Rec."Handler Message")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeleteAll)
            {
                Caption = 'Delete All';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                begin
                    if Confirm('Delete all log entries?') then begin
                        Rec.DeleteAll();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
}
