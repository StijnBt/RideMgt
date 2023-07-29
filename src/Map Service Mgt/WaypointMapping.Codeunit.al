codeunit 50108 "Waypoint Mapping"
{
    TableNo = "Data Exch.";
    trigger OnRun()
    var
        Waypoint: Record Waypoint;
    begin
        MapWaypoint(Rec, Waypoint);
    end;

    procedure MapWaypoint(DataExch: Record "Data Exch."; var Waypoint: Record "Waypoint")
    var
        DataExchField: Record "Data Exch. Field";
        CurrLineNo: Integer;
    begin
        DataExchField.SetAutoCalcFields("Data Exch. Def Code");

        DataExchField.SetRange("Data Exch. No.", DataExch."Entry No.");
        IF DataExchField.IsEmpty then
            exit;

        CurrLineNo := -1;
        If DataExchField.FindSet() then
            repeat
                IF CurrLineNo <> DataExchField."Line No." then begin
                    CurrLineNo := DataExchField."Line No.";
                    UpdateWaypoint(Waypoint, DataExchField);
                end;
            Until DataExchField.Next = 0;

    end;

    local procedure UpdateWaypoint(var Waypoint: Record Waypoint; DataExchField: Record "Data Exch. Field"): Boolean
    var
        RecRef: RecordRef;
    begin
        Clear(Waypoint);

        RecRef.GetTable(Waypoint);
        if not SetFields(RecRef, DataExchField) then
            exit(false);

        RecRef.SetTable(Waypoint);

        Commit();
        exit(true);
    end;

    local procedure SetFields(var RecRef: RecordRef; DataExchangeField: Record "Data Exch. Field"): Boolean
    var
        Waypoint: Record "Waypoint";
        FldRef: fieldref;
    begin
        IF not AssignValue(RecRef, Waypoint.FieldNo("Waypoint Id"), DataExchangeField, '') then
            exit(false);

        if not RecRef.Find('=') then;


        AssignValue(RecRef, Waypoint.FieldNo(Address), DataExchangeField, '');
        AssignValue(RecRef, Waypoint.FieldNo("Address 2"), DataExchangeField, '');
        AssignValue(RecRef, Waypoint.FieldNo("City"), DataExchangeField, '');
        AssignValue(RecRef, Waypoint.FieldNo("Post Code"), DataExchangeField, '');
        AssignValue(RecRef, Waypoint.FieldNo("County"), DataExchangeField, '');
        AssignValue(RecRef, Waypoint.FieldNo("Country/Region Code"), DataExchangeField, '');
        AssignValue(RecRef, Waypoint.FieldNo("Latitude"), DataExchangeField, 0);
        AssignValue(RecRef, Waypoint.FieldNo("Longitude"), DataExchangeField, 0);
        AssignValue(RecRef, Waypoint.FieldNo("Google Place Id"), DataExchangeField, 0);

        IF Not RecRef.Insert(TRUE) then
            exit(RecRef.Modify(TRUE));

        exit(true);
    end;


    [TryFunction]
    local procedure AssignValue(var RecRef: RecordRef; FieldNo: Integer; DefinitionDataExchField: Record "Data Exch. Field"; DefaultValue: Variant)
    var
        DataExchField: Record "Data Exch. Field";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        ProcessDataExch: Codeunit "Process Data Exch.";
        TempAmountsToNegate: Record Integer Temporary;
    begin
        IF GetFieldValue(DefinitionDataExchField, FieldNo, DataExchField) AND
            DataExchFieldMapping.GET(
                DataExchField."Data Exch. Def Code",
                DataExchField."Data Exch. Line Def Code",
                RecRef.Number,
                DataExchField."Column No.",
                FieldNo
            ) then begin
            ProcessDataExch.SetField(RecRef, DataExchFieldMapping, DataExchField, TempAmountsToNegate);
            ProcessDataExch.NegateAmounts(RecRef, TempAmountsToNegate);
        END;

    end;

    local procedure GetFieldValue(DefinitionDataExchField: Record "Data Exch. Field"; FieldNo: Integer; VAR DataExchField: Record "Data Exch. Field"): Boolean
    var
        ColumnNo: Integer;
    begin
        IF not GetColumnNo(FieldNo, DefinitionDataExchField, ColumnNo) then
            exit(False);

        DataExchField.SETRANGE("Data Exch. No.", DefinitionDataExchField."Data Exch. No.");
        DataExchField.SETRANGE("Data Exch. Line Def Code", DefinitionDataExchField."Data Exch. Line Def Code");
        DataExchField.SETRANGE("Line No.", DefinitionDataExchField."Line No.");
        DataExchField.SETRANGE("Column No.", ColumnNo);
        DataExchField.SETAUTOCALCFIELDS("Data Exch. Def Code");
        IF DataExchField.FINDFIRST THEN
            EXIT(TRUE);

        exit(false);
    end;

    local procedure GetColumnNo(FieldNo: Integer; DataExchField: Record "Data Exch. Field"; VAR ColumnNo: Integer): Boolean
    var
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
    begin
        DataExchFieldMapping.SetRange("Data Exch. Def Code", DataExchField."Data Exch. Def Code");
        DataExchFieldMapping.SetRange("Data Exch. Line Def Code", DataExchField."Data Exch. Line Def Code");
        DataExchFieldMapping.SetRange("Table ID", Database::"Waypoint");
        DataExchFieldMapping.SetRange("Field ID", FieldNo);
        IF NOT DataExchFieldMapping.FindFirst() then
            exit(false);

        ColumnNo := DataExchFieldMapping."Column No.";
        exit(true);
    end;


}
