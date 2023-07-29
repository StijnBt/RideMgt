table 50101 "VDC Manager Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[250])
        {

            DataClassification = ToBeClassified;
        }
        field(2; "Quotes"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = const(Quote)));
        }

        field(3; "Open Jobs"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Job" where(Status = const(Open)));
        }

        field(4; "Available People"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(Resource where(Blocked = const(false), Type = const(Person), Capacity = filter(> 0), "Date Filter" = field("Date Filter")));
        }

        field(5; "Available Vehicles"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(Resource where(Blocked = const(false), Type = const(Machine), Capacity = filter(> 0), "Date Filter" = field("Date Filter")));
        }

        field(9; "Pending Sales Invoices"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice)));
        }

        field(10; "Pending Sales Credit Memos"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = const("Credit Memo")));
        }

        field(40; "Active Routes"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Route Header" where(Blocked = const(false)));
        }

        field(41; "Waypoints"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Waypoint");
        }

        /*
        field(11; "Customers Outstanding Amount"; Decimal)
        {
            Caption = 'Customers Outstanding Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cust. Ledger Entry"."Remaining Amount");
        }*/

        field(100; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }

        field(101; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }

    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }


    /// <summary> 
    /// Description for InitCue.
    /// </summary>
    procedure InitCue();
    begin
        reset();
        if get() then
            exit;

        Init();
        Insert(true);
    end;

}