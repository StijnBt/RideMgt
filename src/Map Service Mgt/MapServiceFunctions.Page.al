page 50109 "Map Service Functions"
{
    Caption = 'Map Service Functions';
    PageType = List;
    SourceTable = "Map Service Function";
    PopulateAllFields = true;
    DataCaptionFields = "Map Service Provider", "Code";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Map Service Provider"; Rec."Map Service Provider")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }

                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }

                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Url; Rec.Url)
                {
                    ApplicationArea = All;

                }

                field("Intermediate Xml Download"; Rec."Intermediate Xml Download")
                {
                    ApplicationArea = all;
                    ToolTip = 'Download the generated xml used in final mapping. For debugging & mapping purposes.';
                }

                field("Data Exch. Def. Code"; Rec."Data Exch. Def. Code")
                {
                    ApplicationArea = all;
                }


                field("Instructions Url"; Rec."Instructions Url")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }

            }
        }
    }
}
