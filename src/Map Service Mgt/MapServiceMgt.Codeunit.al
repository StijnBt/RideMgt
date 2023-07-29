codeunit 50110 "Map Service Mgt."
{


    procedure GetMapServiceFunction(RecId: RecordId; MapServiceProvider: record "Map Service Provider"; var MapServiceFunction: record "Map Service Function"; MapFunction: Option Geocoding,ReverseGeocoding)
    var
        DataExchDef: Record "Data Exch. Def";
        MapServiceProviderEnum: Enum "Map Service Provider";
        NoFunctionFoundErr: Label 'No valid %1 found for %2';
        NotExistDataExchDefErr: Label '%1 %2 does not exist';
        FileTypeDataExchDefErr: Label '%1 of %2 %3 should be json';
    begin
        MapServiceFunction.Reset();
        MapServiceFunction.SetRange("Map Service Provider", MapServiceProvider."Map Service Provider");
        MapServiceFunction.SetRange("Table No.", RecId.TableNo);

        case MapFunction of
            MapFunction::Geocoding:
                MapServiceFunction.SetRange(Code, MapServiceProvider."Geocoding Function");
            MapFunction::ReverseGeocoding:
                MapServiceFunction.SetRange(Code, MapServiceProvider."Reverse Geocoding Function");
        end;

        MapServiceFunction.SetFilter("Data Exch. Def. Code", '<>%1', '');

        if not MapServiceFunction.FindFirst() then
            Error(NoFunctionFoundErr, MapServiceFunction.TableCaption, MapServiceProvider."Map Service Provider");

        if not DataExchDef.Get(MapServiceFunction."Data Exch. Def. Code") then
            Error(NotExistDataExchDefErr, DataExchDef.TableCaption, MapServiceFunction."Data Exch. Def. Code");
    end;

    procedure SendWebRequest(TargetUrl: Text; MapServiceFunction: Record "Map Service Function"; var WebResponse: Text) Success: Boolean
    var
        MapServiceProvider: Record "Map Service Provider";
        RESTHelperWLD: Codeunit "REST Helper WLD";
        Handled: Boolean;
    begin

        MapServiceProvider.Get(MapServiceFunction."Map Service Provider");

        RESTHelperWLD.Initialize('GET', TargetUrl);


        if MapServiceProvider.Referer <> '' then
            RESTHelperWLD.AddRequestHeader('Referer', MapServiceProvider.Referer);

        if not RESTHelperWLD.Send() then begin
            WebResponse := RESTHelperWLD.GetResponseReasonPhrase();
            Success := false;
        end else begin
            WebResponse := RESTHelperWLD.GetResponseContentAsText();
            Success := true;
        end;
    end;

    procedure CreateDataExch(RecId: RecordId; MapServiceFunction: record "Map Service Function"; WebResponse: Text; var DataExch: Record "Data Exch.")
    var
        DataExchDef: Record "Data Exch. Def";
        TempXMLBuffer: Record "XML Buffer" temporary;
        GetJsonStructure: Codeunit "Get Json Structure";
        FileManagement: Codeunit "File Management";
        XMLDOMManagement: Codeunit "XML DOM Management";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        Debug: Text;
    begin
        DataExchDef.Get(MapServiceFunction."Data Exch. Def. Code");

        TempBlob.CreateOutStream(OutStr);
        OutStr.WriteText(WebResponse);
        TempBlob.CreateInStream(InStr);

        IF DataExchDef."File Type" = DataExchDef."File Type"::Json then begin
            TempBlob.CreateOutStream(OutStr);

            if not GetJsonStructure.JsonToXML(InStr, OutStr) then
                GetJsonStructure.JsonToXMLCreateDefaultRoot(InStr, OutStr);

        end;

        AddPrimaryKeyToXml(RecId, TempBlob);

        if MapServiceFunction."Intermediate Xml Download" then
            FileManagement.BLOBExport(TempBlob, Format(CreateGuid()) + '.xml', true);

        Clear(InStr);
        TempBlob.CreateInStream(InStr);

        DataExch.InsertRec(MapServiceFunction."Code", InStr, DataExchDef."Code");
    end;


    procedure ReadDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    var
        DataExchDef: Record "Data Exch. Def";
    begin

        if not DataExchDef.get(MapServiceFunction."Data Exch. Def. Code") then
            Clear(DataExchDef);

        CODEUNIT.RUN(DataExchDef."Reading/Writing Codeunit", DataExch);
    end;

    procedure ProcessDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    var
        DataExchDef: Record "Data Exch. Def";
    begin

        if not DataExchDef.get(MapServiceFunction."Data Exch. Def. Code") then
            Clear(DataExchDef);

        DataExchDef.ProcessDataExchange(DataExch);
    end;

    procedure GetDefaultProvider(): Enum "Map Service Provider"
    var
        MapServiceProvider: Record "Map Service Provider";
    begin
        MapServiceProvider.reset();
        MapServiceProvider.setrange("Default Provider", true);

        if not MapServiceProvider.findfirst then
            Clear(MapServiceProvider);

        exit(MapServiceProvider."Map Service Provider")
    end;

    procedure GeneratePostCodeCity(var PostCodeCityText: Text[100]; var CountyText: Text[50]; City: Text[50]; PostCode: Code[20]; County: Text[50]; Country: Record "Country/Region")
    var
        DummyString: Text;
        OverMaxStrLen: Integer;
    begin
        //copy from Codeunit 365
        DummyString := '';
        OverMaxStrLen := MaxStrLen(PostCodeCityText);
        if OverMaxStrLen < MaxStrLen(DummyString) then
            OverMaxStrLen += 1;

        case Country."Address Format" of
            Country."Address Format"::"Post Code+City":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := DelStr(PostCode + ' ' + City, OverMaxStrLen)
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
            Country."Address Format"::"City+County+Post Code":
                begin
                    if (County <> '') and (PostCode <> '') then
                        PostCodeCityText :=
                          DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - StrLen(County) - 3) +
                          ', ' + County + ' ' + PostCode
                    else
                        if PostCode = '' then begin
                            PostCodeCityText := City;
                            CountyText := County;
                        end else
                            if (County = '') and (PostCode <> '') then
                                PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode;
                end;
            Country."Address Format"::"City+Post Code":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
            Country."Address Format"::"Blank Line+Post Code+City":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := DelStr(PostCode + ' ' + City, OverMaxStrLen)
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
        end;
    end;

    procedure AddPrimaryKeyToXml(RecId: RecordId; var TempBlob: Codeunit "Temp Blob")
    var
        XmlDoc: XmlDocument;
        XmlRootElmt: XmlElement;
        XmlElmt: XmlElement;
        RecRef: RecordRef;
        PrimaryKeys: Text;
        FieldTable: Record "Field";
        Fldref: FieldRef;
        FileManagement: Codeunit "File Management";
        OutStr: OutStream;
        InStr: InStream;
    begin
        RecRef.get(RecId);

        Clear(InStr);
        TempBlob.CreateInStream(InStr);

        FieldTable.Reset();
        FieldTable.SetRange(TableNo, RecRef.Number);
        FieldTable.SetRange(IsPartOfPrimaryKey, true);

        FieldTable.Ascending(false);


        if FieldTable.FindSet() then begin
            XmlDocument.ReadFrom(InStr, XmlDoc);
            XmlDoc.GetRoot(XmlRootElmt);
            repeat
                Fldref := RecRef.Field(FieldTable."No.");
                XmlElmt := XmlElement.Create(LowerCase(ConvertStr((FieldTable.FieldName), ' ', '_')));
                XmlElmt.Add(Fldref.Value);
                XmlRootElmt.AddFirst(XmlElmt);
            until FieldTable.Next() = 0;

            TempBlob.CreateOutStream(OutStr);
            XmlDoc.WriteTo(OutStr);

        end;

        TempBlob.CreateInStream(InStr);
    end;

    procedure GenerateEventId(): Text
    begin
        exit(TenantId() + '-' + CompanyName + copystr(CreateGuid(), 1, 8))
    end;

    procedure LogTelemetry(Message: Text; CustomDim1: text; CustomDimValue1: text; CustomDim2: text; CustomDimValue2: text)
    var
        CustDimension: Dictionary of [Text, Text];
    begin
        CustDimension.Add(CustomDim1, CustomDimValue1);
        CustDimension.Add(CustomDim2, CustomDimValue2);

        Session.LogMessage(GenerateEventId(), Message, Verbosity::Verbose, DataClassification::SystemMetadata, TelemetryScope::All, CustDimension);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Process Data Exch.", 'OnBeforeFormatFieldValue', '', false, false)]
    local procedure OnBeforeFormatFieldValue(var TransformedValue: Text; DataExchField: Record "Data Exch. Field"; var DataExchFieldMapping: Record "Data Exch. Field Mapping"; FieldRef: FieldRef; DataExchColumnDef: Record "Data Exch. Column Def"; var IsHandled: Boolean)
    var
        TypeHelper: Codeunit "Type Helper";
        Value: Variant;
        BigIntHelper: BigInteger;
    begin
        case FieldRef.Type of
            FieldType::BigInteger, FieldType::Integer:
                begin
                    Value := FieldRef.Value;

                    IsHandled := Evaluate(BigIntHelper, TransformedValue);

                    Value := BigIntHelper;

                    FieldRef.Value := Value;
                end;
        end;
    end;
}
