table 50103 "Route Header"
{
    Caption = 'Route Header';
    DataClassification = ToBeClassified;
    DrillDownPageId = Routes;
    LookupPageId = Routes;

    fields
    {
        field(1; "Route No."; Code[20])
        {
            Caption = 'Route No.';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "No. of Route Lines"; Integer)
        {
            Caption = 'No. of Route Lines';
            FieldClass = FlowField;
            CalcFormula = count("Route Line" where("Route No." = field("Route No.")));
            Editable = false;
        }

        field(4; "Distance"; Decimal)
        {
            Caption = 'Distance';
            DataClassification = ToBeClassified;
        }

        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
        }

        field(6; "Duration"; Duration)
        {
            Caption = 'Durarion';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Route No.")
        {
            Clustered = true;
        }
    }

    procedure SerializeXml() SerializedText: Text
    var
        RouteLine: Record "Route Line";
        Serializer: Codeunit Serializer;
        XmlDoc: XmlDocument;
        RootXmlNode: XmlElement;
        LinesXmlNode: XmlElement;
        XmlLines: XmlElement;
    begin
        Serializer.SerializeRecordXml(Rec, RootXmlNode);


        RouteLine.Reset();
        RouteLine.SetRange("Route No.", Rec."Route No.");
        RouteLine.SetCurrentKey("Sorting No.");

        if RouteLine.FindSet() then begin
            XmlLines := XmlElement.Create('Lines');
            repeat
                Serializer.SerializeRecordXml(RouteLine, LinesXmlNode);
                XmlLines.Add(LinesXmlNode);
            until RouteLine.Next() = 0;
        end;

        RootXmlNode.Add(XmlLines);
        RootXmlNode.WriteTo(SerializedText);
    end;

}
