page 50111 "Route Card"
{

    Caption = 'Route';
    PageType = Document;
    SourceTable = "Route Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Route No."; Rec."Route No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Distance; Rec.Distance)
                {
                    ApplicationArea = All;
                }
                field(Durarion; Rec."Duration")
                {
                    ApplicationArea = All;
                }
                field("No. of Route Lines"; Rec."No. of Route Lines")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }

            part(RouteLines; "Route Lines Subform")
            {
                ApplicationArea = All;
                Editable = DynamicEditable;
                SubPageLink = "Route No." = FIELD("Route No.");
            }

        }

        area(FactBoxes)
        {
            part("MapFactBox"; "Map FactBox")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateRoute)
            {
                ApplicationArea = All;
                Caption = 'Calculate Route';
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.MapFactBox.Page.SetRouteXml(Rec.SerializeXml());
                end;
            }

            action(ExportGpx)
            {
                ApplicationArea = All;
                Caption = 'Export Gpx';
                Image = ExportElectronicDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }

            action(SerializeXml)
            {
                ApplicationArea = All;
                Caption = 'Show Xml';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ElectronicDoc;
                Visible = false;
                trigger OnAction()
                begin
                    Message(Rec.SerializeXml());
                end;
            }
        }
    }

    var
        DynamicEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
    end;


}
