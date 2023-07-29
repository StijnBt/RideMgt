table 50107 "Map Service Function"
{
    Caption = 'Map Service Function';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Map Service Functions";
    LookupPageId = "Map Service Functions";

    fields
    {
        field(1; "Map Service Provider"; Enum "Map Service Provider")
        {
            Caption = 'Map Service Provider';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(4; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(5; "Table No."; Integer)
        {
            Caption = 'Table No.';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
            NotBlank = true;

            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;
        }
        field(6; Url; Text[100])
        {
            Caption = 'Url';
            DataClassification = ToBeClassified;
        }

        field(7; "Instructions Url"; Text[250])
        {
            Caption = 'Instructions Url';
            DataClassification = ToBeClassified;
        }

        field(8; "Data Exch. Def. Code"; Code[20])
        {
            Caption = 'Data Exchange Definition Code';
            DataClassification = ToBeClassified;
            TableRelation = "Data Exch. Def".Code;
        }

        field(9; "Intermediate Xml Download"; boolean)
        {
            Caption = 'Intermediate Xml Download';
            DataClassification = ToBeClassified;
        }

        field(10; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }

        field(11; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Map Service Provider", "Table No.", "Code")
        {
            Clustered = true;
        }
    }

}
