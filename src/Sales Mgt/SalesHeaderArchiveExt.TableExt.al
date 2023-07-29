tableextension 50105 "Sales Header Archive Ext" extends "Sales Header Archive"
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
