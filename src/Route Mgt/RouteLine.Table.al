table 50104 "Route Line"
{
    Caption = 'Route Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Route No."; Code[20])
        {
            Caption = 'Route No.';
            DataClassification = ToBeClassified;
            TableRelation = "Route Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Waypoint Id"; Integer)
        {
            Caption = 'Waypoint Id';
            DataClassification = ToBeClassified;
            TableRelation = Waypoint."Waypoint Id";
        }
        field(4; "Sorting No."; Integer)
        {
            Caption = 'Sorting No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Name"; Text[100])
        {
            Caption = 'Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint.Name where("Waypoint Id" = field("Waypoint Id")));
        }
        field(6; "Name 2"; Text[100])
        {
            Caption = 'Name 2';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint."Name 2" where("Waypoint Id" = field("Waypoint Id")));
        }

        field(7; "Address"; Text[100])
        {
            Caption = 'Address';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint.Address where("Waypoint Id" = field("Waypoint Id")));
        }
        field(8; "Address 2"; Text[100])
        {
            Caption = 'Address 2';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint."Address 2" where("Waypoint Id" = field("Waypoint Id")));
        }

        field(9; City; Text[30])
        {
            Caption = 'City';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint.City where("Waypoint Id" = field("Waypoint Id")));
        }
        field(10; "Post Code"; Text[20])
        {
            Caption = 'Post Code';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint."Post Code" where("Waypoint Id" = field("Waypoint Id")));
        }

        field(12; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint."Country/Region Code" where("Waypoint Id" = field("Waypoint Id")));
        }

        field(13; "Longitude"; Decimal)
        {
            Caption = 'Longitude';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint.Longitude where("Waypoint Id" = field("Waypoint Id")));
        }

        field(14; "Latitude"; Decimal)
        {
            Caption = 'Latitude';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Waypoint.Latitude where("Waypoint Id" = field("Waypoint Id")));
        }

        field(15; "Stop"; Boolean)
        {
            Caption = 'Stop';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Route No.", "Line No.")
        {
            Clustered = true;
        }

        key(""; "Route No.", "Sorting No.")
        {

        }
    }

    trigger OnInsert()
    begin
        if "Sorting No." = 0 then
            "Sorting No." := "Line No." / 1000;
    end;

}
