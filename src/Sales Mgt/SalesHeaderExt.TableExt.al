tableextension 50102 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Job Type Code"; Code[20])
        {
            Caption = 'Job Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Job Type";
        }
    }
}
