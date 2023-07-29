codeunit 50101 "Serializer"
{
    procedure SerializeRecordXml(RecordVar: Variant; var RootXmlNode: XmlElement) XmlDoc: XmlDocument
    var
        FieldTable: Record "Field";
        DataTypeManagement: Codeunit "Data Type Management";
        TypeHelper: Codeunit "Type Helper";
        ChildXmlNode: XmlElement;
        FldRef: FieldRef;
        RecRef: RecordRef;
        FieldTxt: Text;
        FieldVar: Variant;
    begin
        if not DataTypeManagement.GetRecordRef(RecordVar, RecRef) then
            exit;


        FieldTable.Reset();
        FieldTable.SetRange(TableNo, RecRef.Number);
        FieldTable.SetRange(ObsoleteState, FieldTable.ObsoleteState::No);
        FieldTable.SetFilter(FieldName, '<>%1', '@*system*');

        if not FieldTable.FindSet() then
            exit;

        XmlDoc := XmlDocument.Create();
        RootXmlNode := XmlElement.Create(EscapeXmlChar(FieldTable.TableName));

        repeat
            Clear(FieldTxt);
            if DataTypeManagement.FindFieldByName(RecRef, FldRef, FieldTable.FieldName) then begin
                if FieldTable.Class = FieldTable.Class::FlowField then
                    FldRef.CalcField();

                FieldVar := FldRef.Value;

                //if not (FieldVar.IsCode or FieldVar.IsText or FieldVar.IsBoolean or FieldVar.IsGuid) then
                //    TypeHelper.Evaluate(FieldVar, FieldTxt, '', 'nl-BE')
                //else

                if FieldVar.IsBoolean then begin
                    if FldRef.Value then
                        FieldTxt := 'true'
                    else
                        FieldTxt := 'false';
                end else
                    FieldTxt := Format(FldRef.Value);

                ChildXmlNode := XmlElement.Create(EscapeXmlChar(FieldTable.FieldName), '', EscapeXmlChar(FieldTxt));
                RootXmlNode.Add(ChildXmlNode);
            end;

        until FieldTable.Next() = 0;

        XmlDoc.Add(RootXmlNode);

    end;





    procedure EscapeXmlChar(XmlAsText: Text): Text
    begin
        XmlAsText := ConvertStr(XmlAsText, ' ', '_');
        XmlAsText := ConvertStr(XmlAsText, '&', '_');
        XmlAsText := ConvertStr(XmlAsText, '/', '_');
        XmlAsText := ConvertStr(XmlAsText, '\', '_');

        exit(XmlAsText);
    end;
}
