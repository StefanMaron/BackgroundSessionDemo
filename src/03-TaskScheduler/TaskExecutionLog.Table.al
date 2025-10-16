/// <summary>
/// Task Execution Log - Stores execution results and errors
/// Logs both task failures and failure handler executions
/// </summary>
table 50113 "Task Execution Log"
{
    DataClassification = CustomerContent;
    Caption = 'Task Execution Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Execution Time"; DateTime)
        {
            Caption = 'Execution Time';
            DataClassification = SystemMetadata;
        }
        field(3; Status; Enum "Task Status")
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
        field(4; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = SystemMetadata;
        }
        field(5; "Handler Message"; Text[250])
        {
            Caption = 'Handler Message';
            DataClassification = SystemMetadata;
        }
        field(6; "Task ID"; Guid)
        {
            Caption = 'Task ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ExecutionTime; "Execution Time")
        {
        }
    }
}
