enum 50102 "Map Service Provider" implements "IMap Service Functions"
{
    Extensible = true;

    value(50106; GoogleMapsAPI)
    {
        Caption = 'Google Maps API';
        Implementation = "IMap Service Functions" = "Google Maps API";
    }

    value(50107; OpenStreetMap)
    {
        Caption = 'Open Street Map API';
        Implementation = "IMap Service Functions" = "Open Street Map API";
    }
}