page 50105 "Waypoints"
{

    ApplicationArea = All;
    Caption = 'Waypoints';
    PageType = List;
    SourceTable = Waypoint;
    UsageCategory = Lists;
    CardPageId = "Waypoint Card";
    DataCaptionFields = Name, Address, City, Country;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec."Waypoint Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                }
                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

}
