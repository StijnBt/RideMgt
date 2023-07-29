page 50110 "Routes"
{

    ApplicationArea = All;
    Caption = 'Routes';
    PageType = List;
    SourceTable = "Route Header";
    UsageCategory = Lists;
    CardPageId = "Route Card";

    layout
    {
        area(content)
        {
            repeater(General)
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
        }
    }

}
