pageextension 50106 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    layout
    {
        modify("Work Type Code")
        {
            Visible = true;
            ApplicationArea = all;
        }

        moveafter("Unit of Measure Code"; "Work Type Code")

        modify("Unit of Measure Code")
        {
            Editable = (Rec.Type <> Rec.Type::Resource);
        }

        modify("Line Discount %")
        {
            Editable = (Rec.Type <> Rec.Type::Resource);
        }

        modify("Line Discount Amount")
        {
            Editable = (Rec.Type <> Rec.Type::Resource);
        }

        modify("Line Amount")
        {
            Editable = (Rec.Type <> Rec.Type::Resource);
        }

        modify("Location Code")
        {
            Visible = false;
        }

        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }

        modify("Qty. to Assign")
        {
            Visible = false;
        }

        modify("Qty. Assigned")
        {
            Visible = false;
        }
    }

    actions
    {
        addlast(processing)
        {
            action(InsertStdSalesCode)
            {
                ApplicationArea = All;
                Caption = 'Insert &Std. Sales Code';
                Image = ItemLines;
                trigger OnAction()
                begin
                    InsertStdSalesCode(true);
                end;
            }
        }

        modify(Dimensions)
        {
            Visible = false;
        }

        modify("&Line")
        {
            Visible = false;
        }
    }

    procedure InsertStdSalesCode(Unconditionally: Boolean)
    var
        TempStdCustSalesCode: Record "Standard Customer Sales Code" temporary;
        StandardSalesCode: Record "Standard Sales Code";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(Rec."Document Type", Rec."Document No.");

        if page.RunModal(Page::"Standard Sales Codes", StandardSalesCode) <> Action::LookupOK then
            exit;

        Clear(TempStdCustSalesCode);
        TempStdCustSalesCode.Init();
        TempStdCustSalesCode.Code := StandardSalesCode.Code;

        if SalesHeader."Sell-to Customer No." <> '' then
            TempStdCustSalesCode."Customer No." := SalesHeader."Sell-to Customer No."
        else
            TempStdCustSalesCode."Customer No." := SalesHeader."Sell-to Contact No.";

        TempStdCustSalesCode.ApplyStdCodesToSalesLines(SalesHeader, TempStdCustSalesCode);
    end;
}
