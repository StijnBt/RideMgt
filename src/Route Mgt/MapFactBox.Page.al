page 50108 "Map FactBox"
{

    Caption = 'Map';
    PageType = CardPart;
    Extensible = true;
    UsageCategory = None;


    layout
    {
        area(Content)
        {
            usercontrol(Map; "Geo Map")
            {
                ApplicationArea = All;

                trigger OnControlReady()
                begin
                    ControllIsReady := true;
                    SetMapProvider();
                end;

                trigger OnControlInitialized()
                begin
                    Sleep(100);
                    SetLongLatControl();

                    if RouteXml <> '' then
                        CurrPage.Map.calculateGoogleRoute(RouteXml);
                end;

                trigger OnSendRouteDetails(Route: Text)
                var
                    text1: Text;
                begin
                    //Route.WriteTo(text1);
                    Message(Route);
                end;
            }
        }
    }

    var
        RecRef: RecordRef;
        ControllIsReady: Boolean;
        MapProviderSet: Boolean;
        Longitude: Decimal;
        Latitude: Decimal;
        MapServiceProviderEnum: Enum "Map Service Provider";
        RouteXml: Text;

    procedure SetRecordOrRecRefAndLongLat(var RecorRecRef: Variant; Long: Decimal; Lat: decimal)
    begin
        SetRecordOrRecRef(RecorRecRef);
        SetLongLat(Long, Lat);
    end;

    procedure SetRecordOrRecRef(var RecorRecRef: Variant)
    begin
        if RecorRecRef.IsRecord then
            RecRef.GetTable(RecorRecRef)
        else
            RecRef := RecorRecRef;
    end;

    procedure SetLongLat(Long: Decimal; Lat: decimal)
    begin
        Longitude := Long;
        Latitude := Lat;

        SetLongLatControl();
    end;

    procedure SetRouteXml(RouteXml1: Text)
    begin
        RouteXml := RouteXml1;

        SetRouteControl()
    end;

    local procedure SetRouteControl()
    begin
        if not ControllIsReady then
            exit;

        case MapServiceProviderEnum of
            MapServiceProviderEnum::GoogleMapsAPI:
                CurrPage.Map.calculateGoogleRoute(RouteXml);
            else
                OnSetSetJsonArrayControl(RouteXml);
        end;
    end;

    local procedure SetLongLatControl()
    begin
        if not ControllIsReady or ((Longitude = 0) and (Latitude = 0)) then
            exit;

        case MapServiceProviderEnum of
            MapServiceProviderEnum::GoogleMapsAPI:
                CurrPage.Map.setGoogleLonglat(Format(Longitude, 0, 2), Format(Latitude, 0, 2));
            MapServiceProviderEnum::OpenStreetMap:
                CurrPage.Map.setLeafletLongLat(Format(Longitude, 0, 2), Format(Latitude, 0, 2));
            else
                OnSetLongLatControl(Longitude, Latitude)
        end;
    end;

    local procedure SetMapProvider()
    var
        MapServiceProvider: Record "Map Service Provider";
        MapServiceMgt: Codeunit "Map Service Mgt.";
    begin
        if (not ControllIsReady) or MapProviderSet then
            exit;

        MapServiceProviderEnum := MapServiceMgt.GetDefaultProvider();

        MapServiceProvider.Get(MapServiceProviderEnum);

        case MapServiceProviderEnum of
            MapServiceProviderEnum::GoogleMapsAPI:
                CurrPage.Map.initGoogleMap(MapServiceProvider."API Key");
            MapServiceProviderEnum::OpenStreetMap:
                CurrPage.Map.initLeaflet();
            else
                OnSetMapProvider();
        end;

        MapProviderSet := true;
    end;


    [IntegrationEvent(true, false)]
    local procedure OnSetLongLatControl(var Longitude: Decimal; var Latitude: Decimal)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnSetMapProvider()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnSetSetJsonArrayControl(JsonArr: Text)
    begin
    end;

}
