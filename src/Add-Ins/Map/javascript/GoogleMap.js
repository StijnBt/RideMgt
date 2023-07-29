let ctrlGoogleMarker;
let ctrlGoogleMap;
let directionsService;
let directionsRenderer;

function initGoogleMap(apiKey){
    var script = document.createElement('script');
    script.src = 'https://maps.googleapis.com/maps/api/js?key=' + apiKey + '&callback=initMap';
    script.defer = true;

    document.head.appendChild(script);

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnControlInitialized", []);
}

function initMap() {
    directionsService = new google.maps.DirectionsService();
    directionsRenderer = new google.maps.DirectionsRenderer();

    ctrlGoogleMap = new google.maps.Map(document.getElementById("controlAddIn"), {
        center: { lat: 47.6424858, lng: -122.1367486 },
        zoom: 16
    });

    directionsRenderer.setMap(ctrlGoogleMap);
};

function setGoogleLongLat(long, lat) {
       
    if (!isNull(ctrlGoogleMarker))
   	    ctrlGoogleMarker.setMap(null); 

    ctrlGoogleMap.setCenter(new google.maps.LatLng(lat,long));
    
    ctrlGoogleMarker = new google.maps.Marker({
        position: new google.maps.LatLng(lat,long)
      });

    ctrlGoogleMarker.setMap(ctrlGoogleMap);
}

function calculateGoogleRoute(routeXml){
    var start;
    var end;
    const waypts = [];

    parser = new DOMParser();
    xmlDoc = parser.parseFromString(routeXml, "text/xml");

    routeLines = xmlDoc.getElementsByTagName("Route_Line");


    for (var i = 0; i < routeLines.length; i++) {

        var stopAtWp = (routeLines[i].getElementsByTagName('Stop')[0].firstChild.nodeValue === 'true');
        var latitude = parseFloat(routeLines[i].getElementsByTagName('Latitude')[0].firstChild.nodeValue.replace(',','.'));
        var longitude = parseFloat(routeLines[i].getElementsByTagName('Longitude')[0].firstChild.nodeValue.replace(',','.'));
        var LatLng = new google.maps.LatLng(latitude,longitude);

      


        if (i == 0){
            start = LatLng;
        } 
        
        if (i == (routeLines.length - 1)){
            end = LatLng
        }

        waypts.push({
            location: LatLng,
            stopover: stopAtWp
        })
            
    }
    

    directionsService.route({
        origin: start,
        destination: end,
        waypoints: waypts,
        avoidTolls: false,
        avoidHighways: false,
        optimizeWaypoints: true,
        drivingOptions: {
            departureTime: new Date(Date.now()),
            trafficModel: 'optimistic'
        },
        travelMode: google.maps.TravelMode.DRIVING
    }, function (response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            directionsRenderer.setDirections(response);

            alert(response.stringify());

            //var OnSendRouteDetails = getALEventHandler('OnSendRouteDetails', false);
            //OnSendRouteDetails(response.routes[0]);
        } else {
            window.alert('Directions request failed due to ' + status);
        }
    });
}