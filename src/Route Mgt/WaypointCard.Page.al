page 50106 "Waypoint Card"
{

    Caption = 'Waypoint Card';
    PageType = Card;
    SourceTable = Waypoint;
    DataCaptionFields = Name, Address, City, Country;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Id; Rec."Waypoint Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
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
                }

                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(RouteInfo)
            {
                Caption = 'Route Information';
                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = All;
                }
                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = All;
                }

                field("Google Place Id"; Rec."Google Place Id")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
            }
        }
        area(FactBoxes)
        {
            part("MapFactBox"; "Map FactBox")
            {
                ApplicationArea = All;
                //SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetLongLatt)
            {
                Image = Map;
                Caption = 'Update Latitude & Longitude';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.UpdateLatitudeLongitude();
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    var
        VariantHelper: variant;
    begin
        VariantHelper := Rec;
        CurrPage.MapFactBox.Page.SetRecordOrRecRefAndLongLat(VariantHelper, Rec.Longitude, Rec.Latitude);
    end;

}
