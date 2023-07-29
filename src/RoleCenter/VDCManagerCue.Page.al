page 50102 "VDC Manager Cue"
{
    PageType = CardPart;
    SourceTable = "VDC Manager Cue";
    Caption = ' ';

    layout
    {
        area(content)
        {
            cuegroup(JobCueContainer)
            {
                Caption = 'Operations';
                //CuegroupLayout=Wide;
                //ShowCaption = false;
                field("Quotes"; Rec."Quotes")
                {
                    ApplicationArea = All;
                    Caption = 'Quotes';
                    DrillDownPageId = "Sales Quotes";
                    ToolTip = 'Quotes';
                }
                field("Open Jobs"; Rec."Open Jobs")
                {
                    ApplicationArea = All;
                    Caption = 'Open Jobs';
                    DrillDownPageId = "Job List";
                    ToolTip = 'Open Jobs';
                }

                field("Pending Sales Invoices"; Rec."Pending Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Sales Invoices';
                    DrillDownPageId = "Sales Invoice List";
                    ToolTip = 'Pending Sales Invoices';
                }

                field("Pending Sales Credit Memos"; Rec."Pending Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Sales Credit Memos';
                    DrillDownPageId = "Sales Credit Memos";
                    ToolTip = 'Pending Sales Credit Memos';
                }
            }

            cuegroup(RouteCueContainer)
            {
                Caption = 'Routes';

                field("Active Routes"; Rec."Active Routes")
                {
                    ApplicationArea = All;
                    Caption = 'Active Routes';
                    DrillDownPageId = "Routes";
                    ToolTip = 'Active Routes';
                }

                field("Waypoints"; Rec."Waypoints")
                {
                    ApplicationArea = All;
                    Caption = 'Waypoints';
                    DrillDownPageId = "Waypoints";
                    ToolTip = 'Waypoints';
                }
            }


            cuegroup(ResourceCueContainer)
            {
                Caption = 'Resources';
                //Visible = false;
                //CuegroupLayout=Wide;
                //ShowCaption = false;
                field("Available People"; Rec."Available People")
                {
                    ApplicationArea = All;
                    Caption = 'Available People';
                    DrillDownPageId = "Resource List";
                    ToolTip = 'Available People';
                }

                field("Available Vehicles"; Rec."Available Vehicles")
                {
                    ApplicationArea = All;
                    Caption = 'Available Vehicles';
                    DrillDownPageId = "Resource List";
                    ToolTip = 'Available Vehicles';
                }
            }
            /*
                        cuegroup(AccountingCueContainer)
                        {
                            Caption = 'Accounting';
                            field("Customers Outstanding Amount"; Rec."Customers Outstanding Amount")
                            {
                                ApplicationArea = All;
                                Caption = 'Customers Outstanding Amount';
                                DrillDownPageId = "Customer Ledger Entries";
                                ToolTip = 'Customers Outstanding Amount';
                            }

                        }*/
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                    CuesAndKpis: Codeunit "Cues And KPIs";
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }



    trigger OnOpenPage();
    begin
        Rec.InitCue();
        Rec.SetFilter("User ID Filter", UserId);
    end;

    var
        UserTaskManagement: Codeunit "User Task Management";
}