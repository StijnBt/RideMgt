let ctrlLeafletMarker;
let ctrlLeafletMap;

function initLeaflet(){

    //var placeholder = document.getElementById('controlAddIn'); 
    //ctrlLeafletMap = document.createElement('div');   
    //placeholder.appendChild(ctrlLeafletMap); //add object to place

    //alert("initLeaflet");

    ctrlLeafletMap = L.map('controlAddIn').setView([47.6424858,-122.1367486], 15);

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnControlInitialized", []);
}


function setLeafletLongLat(long, lat) {
        
    if (!isNull(ctrlLeafletMarker))
        ctrlLeafletMap.removeLayer(ctrlLeafletMarker);

    var center = [lat, long];
    ctrlLeafletMarker = new L.Marker(center, {draggable:false});

    L.tileLayer(
    'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 18
    }).addTo(ctrlLeafletMap);

    ctrlLeafletMarker.addTo(ctrlLeafletMap);
    ctrlLeafletMap.setZoom(16);
    ctrlLeafletMap.setView(center);
}