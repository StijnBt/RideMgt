tableextension 50101 "Job Task Ext." extends "Job Task"
{
    fields
    {
        field(50100; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Quote));
        }

    }
}
