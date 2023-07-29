codeunit 50107 "Open Street Map API" implements "IMap Service Functions"
{
    var
        MapMgt: Codeunit "Map Service Mgt.";

    #region Methods
    procedure GetLongitudeLatitude(RecId: RecordId; AddressUri: Text; var Longitude: Decimal; var Latitude: Decimal)
    var
        MapServiceProvider: Record "Map Service Provider";
        MapServiceFunction: Record "Map Service Function";
        DataExch: Record "Data Exch.";
        WebResponse: Text;
    begin
        MapServiceProvider.get(MapServiceProvider."Map Service Provider"::GoogleMapsAPI);
        MapMgt.GetMapServiceFunction(RecId, MapServiceProvider, MapServiceFunction, 0);

        if not SendWebRequest(StrSubstNo(MapServiceFunction.Url, AddressUri), MapServiceFunction, WebResponse) then
            exit;

        CreateDataExch(RecId, MapServiceFunction, WebResponse, DataExch);

        ReadDataExch(MapServiceFunction, DataExch);

        ProcesDataExch(MapServiceFunction, DataExch);

        DataExch.Delete(true);

        LogRequest('GetLongitudeLatitude');
    end;

    [NonDebuggable]
    procedure LogRequest(ProcName: Text)
    var
        ApplicationMgt: Codeunit "Map Service Mgt.";
    begin
        ApplicationMgt.LogTelemetry(ProcName, 'provider', 'GoogleMaps', '', '');
    end;

    #endregion Methods

    #region Procedures
    local procedure SendWebRequest(TargetUrl: Text; MapServiceFunction: Record "Map Service Function"; var WebResponse: Text) Success: Boolean
    var
        Handled: Boolean;
    begin
        OnBeforeSendWebRequest(MapServiceFunction, TargetUrl, WebResponse, Success, Handled);

        if not Handled then
            Success := MapMgt.SendWebRequest(TargetUrl, MapServiceFunction, WebResponse);

        OnAfterSendWebRequest(MapServiceFunction, TargetUrl, WebResponse, Success);
    end;

    local procedure CreateDataExch(RecId: RecordId; MapServiceFunction: Record "Map Service Function"; WebResponse: Text; var DataExch: Record "Data Exch.")
    var
        Handled: Boolean;
    begin
        OnBeforeCreateDataExch(MapServiceFunction, WebResponse, DataExch, Handled);

        if not Handled then
            MapMgt.CreateDataExch(RecId, MapServiceFunction, WebResponse, DataExch);

        OnAfterCreateDataExch(MapServiceFunction, WebResponse, DataExch);
    end;

    local procedure ReadDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    var
        Handled: Boolean;
    begin
        OnBeforeReadDataExch(MapServiceFunction, DataExch, Handled);

        if not Handled then
            MapMgt.ReadDataExch(MapServiceFunction, DataExch);

        OnAfterReadDataExch(MapServiceFunction, DataExch);
    end;

    local procedure ProcesDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    var
        Handled: Boolean;
    begin
        OnBeforeProcessDataExch(MapServiceFunction, DataExch, Handled);

        if not Handled then
            MapMgt.ProcessDataExch(MapServiceFunction, DataExch);

        OnAfterProcessDataExch(MapServiceFunction, DataExch);
    end;

    #endregion Procedures

    #region Eventpublishers

    [IntegrationEvent(false, false)]
    procedure OnBeforeSendWebRequest(MapServiceFunction: Record "Map Service Function"; TargetUrl: Text; var WebResponse: Text; var Success: Boolean; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterSendWebRequest(MapServiceFunction: Record "Map Service Function"; TargetUrl: Text; var WebResponse: Text; var Success: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateDataExch(MapServiceFunction: Record "Map Service Function"; var WebResponse: Text; var DataExch: Record "Data Exch."; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCreateDataExch(MapServiceFunction: Record "Map Service Function"; var WebResponse: Text; var DataExch: Record "Data Exch.")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeReadDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch."; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterReadDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeProcessDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch."; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterProcessDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    begin
    end;
    #endregion Eventpublishers

}
