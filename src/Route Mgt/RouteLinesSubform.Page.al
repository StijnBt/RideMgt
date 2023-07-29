page 50112 "Route Lines Subform"
{

    Caption = 'Route Lines Subform';
    PageType = ListPart;
    SourceTable = "Route Line";
    SourceTableView = sorting("Sorting No.");
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Route No."; Rec."Route No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }

                field("Sorting No."; Rec."Sorting No.")
                {
                    ApplicationArea = All;
                }
                field("Waypoint Id"; Rec."Waypoint Id")
                {
                    ApplicationArea = All;
                    TableRelation = Waypoint;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields(Address, "Address 2", City, Name, "Name 2", "Country/Region Code", "Post Code");
                    end;

                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = ((Rec.Longitude = 0) and (Rec.Latitude = 0));
                }

                field(Stop; Rec.Stop)
                {
                    ApplicationArea = All;
                    ToolTip = 'Marks an actual stop in stead of just passing through.';
                }

                field(Name2; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                }

                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                }

                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }

                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }

                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    var
        StyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        //Rec.CalcFields(Longitude, Latitude);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields(Longitude, Latitude);
    end;

}
