interface "IMap Service Functions"
{
    #region Methods
    procedure GetLongitudeLatitude(RecId: RecordId; Address: Text; var Longitude: Decimal; var Latitude: Decimal)

    procedure LogRequest(ProcName: Text)
    #endregion Methods

    #region Eventpublishers
    procedure OnBeforeSendWebRequest(MapServiceFunction: Record "Map Service Function"; TargetUrl: Text; var WebResponse: Text; var Success: Boolean; var Handled: Boolean)
    procedure OnAfterSendWebRequest(MapServiceFunction: Record "Map Service Function"; TargetUrl: Text; var WebResponse: Text; var Success: Boolean)
    procedure OnBeforeCreateDataExch(MapServiceFunction: Record "Map Service Function"; var WebResponse: Text; var DataExch: Record "Data Exch."; var Handled: Boolean)
    procedure OnAfterCreateDataExch(MapServiceFunction: Record "Map Service Function"; var WebResponse: Text; var DataExch: Record "Data Exch.")
    procedure OnBeforeReadDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch."; var Handled: Boolean)
    procedure OnAfterReadDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")
    procedure OnBeforeProcessDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch."; var Handled: Boolean)
    procedure OnAfterProcessDataExch(MapServiceFunction: Record "Map Service Function"; var DataExch: Record "Data Exch.")

    #endregion Eventpublishers
}
