table 50106 "Map Service Provider"
{
    Caption = 'Map Service Provider';
    DataClassification = ToBeClassified;
    LookupPageId = "Map Service Providers";
    DrillDownPageId = "Map Service Providers";

    fields
    {
        field(1; "Map Service Provider"; Enum "Map Service Provider")
        {
            Caption = 'Map Service Provider';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "API Key"; Text[250])
        {
            Caption = 'API Key';
            DataClassification = ToBeClassified;
        }

        field(4; "Referer"; Text[80])
        {
            Caption = 'Referer';
            DataClassification = ToBeClassified;
        }
        field(5; "Default Provider"; Boolean)
        {
            Caption = 'Default Provider';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Default Provider" then
                    CheckSingleDefaultProvider();
            end;
        }

        field(8; "No. of Functions"; Integer)
        {
            Caption = 'No. of Functions';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Map Service Function" where("Map Service Provider" = field("Map Service Provider")));
        }

        field(100; "Geocoding Function"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Geocoding Function';
            TableRelation = "Map Service Function".Code where("Map Service Provider" = field("Map Service Provider"));
            ValidateTableRelation = false;
        }

        field(101; "Reverse Geocoding Function"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reverse Geocoding Function';
            TableRelation = "Map Service Function".Code where("Map Service Provider" = field("Map Service Provider"));
            ValidateTableRelation = false;
        }
    }
    keys
    {
        key(PK; "Map Service Provider")
        {
            Clustered = true;
        }
    }

    local procedure CheckSingleDefaultProvider()
    var
        MapServiceProvider: Record "Map Service Provider";
        AlreadyDefaultProviderErr: Label '%1 is already marked as %2';
    begin
        MapServiceProvider.Reset();
        MapServiceProvider.SetRange("Default Provider", true);
        MapServiceProvider.SetFilter("Map Service Provider", '<>%1', "Map Service Provider");

        if MapServiceProvider.FindFirst() then
            Error(AlreadyDefaultProviderErr, MapServiceProvider."Map Service Provider", "Default Provider");
    end;





}
