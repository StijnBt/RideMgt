pageextension 50100 "Job Card Ext" extends "Job Card"
{
    layout
    {
        modify("Project Manager")
        {
            Visible = false;
        }

        modify("Person Responsible")
        {
            Visible = false;
        }

        addafter("No.")
        {
            field("Job Type"; Rec."Job Type Code")
            {
                ApplicationArea = All;
            }
        }

        modify("WIP and Recognition")
        {
            Visible = false;
        }

        modify("Foreign Trade")
        {
            Visible = false;
        }

        addlast(General)
        {
            field("Sales Quote No."; Rec."Sales Quote No.")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.OnDrillDownSalesQuoteNo
                end;
            }
        }

    }

    actions
    {
        modify("W&IP")
        {
            Visible = false;
        }
    }
}
