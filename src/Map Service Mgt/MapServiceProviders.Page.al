page 50107 "Map Service Providers"
{

    ApplicationArea = All;
    Caption = 'Map Service Providers';
    PageType = List;
    SourceTable = "Map Service Provider";
    UsageCategory = Lists;
    DataCaptionFields = "Map Service Provider";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Map Service Provider"; Rec."Map Service Provider")
                {
                    ApplicationArea = All;
                }
                field(Default; Rec."Default Provider")
                {
                    ApplicationArea = all;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Some services require to identify yourself by an API Key. Mostly for billing purposes';
                }

                field(Referer; Rec.Referer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Some services require to identify yourself by a Referer header. Example: https://www.example.com';
                }

                field("No. of Functions"; Rec."No. of Functions")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Geocoding Function"; Rec."Geocoding Function")
                {
                    ApplicationArea = All;
                }

                field("Reverse Geocoding Function"; Rec."Reverse Geocoding Function")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(MapServiceProvFunctions)
            {
                Caption = 'Functions';
                Image = Setup;
                RunObject = Page "Map Service Functions";
                RunPageLink = "Map Service Provider" = field("Map Service Provider");
                ApplicationArea = all;
            }
        }
    }

}
