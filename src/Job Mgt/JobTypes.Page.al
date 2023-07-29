page 50104 "Job Types"
{

    ApplicationArea = All;
    Caption = 'Job Types';
    PageType = List;
    SourceTable = "Job Type";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Job Type Code"; Rec."Job Type Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field(Document; Rec.Document)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
