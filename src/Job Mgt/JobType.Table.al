table 50102 "Job Type"
{
    Caption = 'Job Type';
    DataClassification = ToBeClassified;
    LookupPageId = "Job Types";
    DrillDownPageId = "Job Types";

    fields
    {
        field(1; "Job Type Code"; Code[20])
        {
            Caption = 'Job Type Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Document"; Enum "Job Type Document")
        {
            Caption = 'Document';
            DataClassification = ToBeClassified;

        }
    }
    keys
    {
        key(PK; "Job Type Code")
        {
            Clustered = true;
        }
    }

}
