pageextension 50101 "Job Task Lines Subform Ext" extends "Job Task Lines Subform"
{

    layout
    {
        addafter(Description)
        {
            field("Quote No."; Rec."Quote No.")
            {
                ApplicationArea = All;
            }
        }

        modify("WIP-Total")
        {
            Visible = true;
        }

    }
}
