pageextension 50102 "JobListExt" extends "Job List"
{
    layout
    {
        addafter("Bill-to Customer No.")
        {
            field("Bill-to Name"; Rec."Bill-to Name")
            {
                ApplicationArea = all;
            }
        }
        modify("% Completed")
        {
            Visible = true;
        }
        modify("% Invoiced")
        {
            Visible = true;

        }
    }
}
