controladdin "Geo Map"
{
    RequestedHeight = 300;
    RequestedWidth = 300;
    MinimumHeight = 250;
    MinimumWidth = 250;
    MaximumHeight = 500;
    MaximumWidth = 500;
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;


    StyleSheets = './src/Add-Ins/Map/css/GoogleStyleSheet.css', 'https://unpkg.com/leaflet@1.7.1/dist/leaflet.css';
    StartupScript = './src/Add-Ins/Map/javascript/Start.js';
    Scripts = './src/Add-Ins/Map/javascript/GoogleMap.js', './src/Add-Ins/Map/javascript/LeafletMap.js', './src/Add-Ins/Map/javascript/Helper.js', 'https://unpkg.com/leaflet@1.7.1/dist/leaflet.js';

    event OnControlReady();
    event OnControlInitialized();
    event OnSendRouteDetails(route: Text);

    #region Google Maps Functions    
    procedure initGoogleMap(apiKey: Text);
    procedure setGoogleLongLat(long: Text; lat: Text);
    procedure calculateGoogleRoute(xmlroute: Text);
    #endregion Google Maps Functions

    #region Open Street Map Functions
    procedure initLeaflet();
    procedure setLeafletLongLat(long: Text; lat: Text)
    #endregion Open Street Map Functions

}