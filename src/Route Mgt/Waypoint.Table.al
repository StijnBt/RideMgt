table 50105 "Waypoint"
{
    Caption = 'Waypoint';
    DataClassification = ToBeClassified;
    LookupPageId = "Waypoints";
    DrillDownPageId = "Waypoints";



    fields
    {
        field(1; "Waypoint Id"; Integer)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object ID" = filter(18 | 79 | 5050));

            trigger OnValidate()
            begin
                if "Table No." <> Database::"Company Information" then
                    exit;

                GetTableInformation()
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Table No." = const(18)) Customer else
            IF ("Table No." = const(79)) "Company Information" else
            IF ("Table No." = const(5050)) Contact;

            trigger OnValidate()
            begin
                if ("No." = '') or ("Table No." = 0) then
                    exit;

                GetTableInformation()
            end;
        }
        field(4; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Name 2"; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(7; "Address 2"; Text[100])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(9; "Post Code"; Text[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
        }
        field(10; County; Text[30])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(11; Country; Text[100])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }

        field(12; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;

            trigger OnValidate()
            var
                CountryRegion: Record "Country/Region";
            begin
                if not CountryRegion.get("Country/Region Code") then
                    Clear(CountryRegion);

                Country := CountryRegion.Name;
            end;


        }

        field(100; Latitude; Decimal)
        {
            Caption = 'Latitude';
            DataClassification = ToBeClassified;
            DecimalPlaces = 6 : 6;
        }
        field(101; Longitude; Decimal)
        {
            Caption = 'Longitude';
            DataClassification = ToBeClassified;
            DecimalPlaces = 6 : 6;
        }

        field(102; "Google Place Id"; Text[100])
        {
            Caption = 'Google Place Id';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Waypoint Id")
        {
            Clustered = true;
        }


    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, Address, City, Country)
        {

        }
    }

    local procedure ClearFields()
    begin
        Clear(Name);
        Clear(Address);
        Clear("Address 2");
        Clear(City);
        Clear("Post Code");
        Clear(County);
        Clear(Country);
    end;

    local procedure GetTableInformation()
    var
        Customer: Record Customer;
        Contact: Record Contact;
        CompanyInformation: Record "Company Information";
    begin
        case "Table No." of
            Database::Customer:
                begin
                    ClearFields();
                    Customer.get("No.");
                    Name := Customer.Name;
                    "Name 2" := Customer."Name 2";
                    Address := Customer.Address;
                    "Address 2" := Customer."Address 2";
                    City := Customer.City;
                    "Post Code" := Customer."Post Code";
                    County := Customer.County;
                    Validate("Country/Region Code", Customer."Country/Region Code");
                end;
            Database::Contact:
                begin
                    ClearFields();
                    Contact.get("No.");

                    Name := Contact.Name;
                    "Name 2" := Contact."Name 2";
                    Address := Contact.Address;
                    "Address 2" := Contact."Address 2";
                    City := Contact.City;
                    "Post Code" := Contact."Post Code";
                    County := Contact.County;
                    Validate("Country/Region Code", Contact."Country/Region Code");
                end;
            Database::"Company Information":
                begin
                    ClearFields();
                    CompanyInformation.get();
                    Name := CompanyInformation.Name;
                    "Name 2" := CompanyInformation."Name 2";
                    Address := CompanyInformation.Address;
                    "Address 2" := CompanyInformation."Address 2";
                    City := CompanyInformation.City;
                    "Post Code" := CompanyInformation."Post Code";
                    County := CompanyInformation.County;
                    Validate("Country/Region Code", CompanyInformation."Country/Region Code");

                end;
        end;

    end;

    procedure UpdateLatitudeLongitude()
    begin
        GetLatitudeLongitude();
    end;

    procedure GetLatitudeLongitude()
    var
        MapServiceMgt: Codeunit "Map Service Mgt.";
        IMapServiceFunctions: interface "IMap Service Functions";
    begin
        IMapServiceFunctions := MapServiceMgt.GetDefaultProvider();
        IMapServiceFunctions.GetLongitudeLatitude(Rec.RecordId, GetAddressUri(), Rec.Latitude, Rec.Longitude);
    end;

    procedure GetAddressUri() Result: Text
    var
        CountryRegion: Record "Country/Region";
        DotNet_Uri: Codeunit DotNet_Uri;
        MapMgt: Codeunit "Map Service Mgt.";
        PostCodeCityText: Text;
        CountyText: Text;
    begin

        if not CountryRegion.get(Country) then
            Clear(CountryRegion);


        if Address <> '' then
            Result += Address;

        if "Address 2" <> '' then begin
            if Result <> '' then
                Result += ', ' + "Address 2"
            else
                Result += "Address 2"
        end;

        MapMgt.GeneratePostCodeCity(PostCodeCityText, CountyText, City, "Post Code", County, CountryRegion);

        if PostCodeCityText <> '' then begin
            if Result <> '' then
                Result += ', ' + PostCodeCityText
            else
                Result += PostCodeCityText
        end;

        if CountryRegion.Name <> '' then begin
            if Result <> '' then
                Result += ', ' + CountryRegion.Name
            else
                Result += CountryRegion.Name
        end;




        DotNet_Uri.EscapeDataString(Result)
    end;

}
