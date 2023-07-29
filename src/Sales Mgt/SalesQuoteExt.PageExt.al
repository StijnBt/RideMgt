pageextension 50107 "Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Sell-to Customer Template Code")
        moveafter("Sell-to Customer Name"; "Sell-to Contact No.")
        moveafter(Status; "Work Description")

        addafter("Sell-to Contact No.")
        {
            field("Job Type Code"; Rec."Job Type Code")
            {
                ApplicationArea = All;
            }
        }

        modify(WorkDescription)
        {
            Visible = true;
            Importance = Standard;
        }

        modify("Sell-to Contact No.")
        {
            Importance = Promoted;
        }

        modify("Quote Valid Until Date")
        {
            Visible = true;
            Importance = Standard;
        }

        modify(Control1900383207)
        {
            Visible = true;
        }

        modify("Foreign Trade")
        {
            Visible = false;
        }

        modify("Due Date")
        {
            Visible = false;
        }

        modify("Shipment Date")
        {
            Visible = false;
        }

        modify("Journal Template Name")
        {
            Visible = false;
        }

        modify("Transaction Type")
        {
            Visible = false;
        }

        modify("Location Code")
        {
            Visible = false;
        }

        modify("Currency Code")
        {
            Visible = false;
        }

        modify("Shipping and Billing")
        {
            Visible = false;
        }

        modify(Control1903720907)
        {
            Visible = false;
        }

        modify(Control1907234507)
        {
            Visible = false;
        }

        modify(Control1902018507)
        {
            Visible = false;
        }

        modify(Control1900316107)
        {
            Visible = false;
        }

        modify(Control1906127307)
        {
            Visible = false;
        }

        modify(Control1907012907)
        {
            Visible = true;
        }
    }

    actions
    {
        addfirst(Create)
        {
            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'Finish Quote';
                Enabled = ((Rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> ''));
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = Completed;

                trigger OnAction()
                var
                    FinishQuote: Codeunit "Finish Quote";
                begin
                    FinishQuote.Run(Rec);
                end;
            }

            action(CreateJob)
            {
                ApplicationArea = All;
                Caption = 'Create Job';
                Enabled = ((Rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> ''));
                Image = MakeOrder;
                Promoted = false;
                ToolTip = 'Convert the sales quote to a job.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                        CODEUNIT.Run(CODEUNIT::"Sales to Job (Yes/No)", Rec);
                end;
            }
        }

        addfirst(processing)
        {

        }

        modify(PageInteractionLogEntries)
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category11;
        }


        modify(MakeOrder)
        {
            Visible = false;
            Promoted = false;
        }
        modify(MakeInvoice)
        {
            Promoted = false;
        }

        modify(Approval)
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
    }


}
