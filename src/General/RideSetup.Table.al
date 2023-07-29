table 50100 "Ride Setup"
{
    Caption = 'Customization Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }

        field(2; "Quote Expiration Formula"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Job G/L Account Billable"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InitSetup()
    begin
        reset();
        if not Get() then begin
            Init();
            Insert();
        end;

    end;

}
