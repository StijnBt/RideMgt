page 50100 "Ride Setup"
{
    Caption = 'Ride Setup';
    PageType = Card;
    SourceTable = "Ride Setup";
    UsageCategory = Documents;
    ApplicationArea = All;
    DeleteAllowed = false;

    layout
    {

        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Quote Expiration Formula"; Rec."Quote Expiration Formula")
                {
                    ApplicationArea = all;
                }

                field("Job G/L Account Billable"; Rec."Job G/L Account Billable")
                {
                    ApplicationArea = all;
                }
            }
        }
    }




    actions
    {
        /* area(Navigation)
        {
            action(JobTypes)
            {
                ApplicationArea = All;
                Caption = 'Job Types';
                Image = Setup;
                RunObject = Page "Job Types";
            }

            action(MapServiceProviders)
            {
                ApplicationArea = All;
                Caption = 'Map Service Providers';
                Image = Setup;
                RunObject = Page "Map Service Providers";
            }

        } */
    }

    trigger OnOpenPage()
    begin
        Rec.InitSetup();
    end;

}