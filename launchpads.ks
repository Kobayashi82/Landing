
Global LaunchPads is List().
Global LaunchPad is LatLng(0, 0).
Global OriginalLaunchPad is LatLng(0, 0).
Global PadN is 0.

Function LoadLaunchPads {
    Set LaunchPads to List(). 

    If (Addons:TR:Available = True and Addons:TR:HasImpact = True) { 
        Set PadN to 0.

        AddTargetPad().
		AddKerbinPads().
        AddCustomPads().
        AddWaypoints().
        AddVessels().

        If (ShipStatus() = "Flying") {
            LaunchPads:Add("Anywhere").
            LaunchPads:Add(LatLng(0, 0)).
            LaunchPads:Add(Body:Name).
        }

        SelectInitialPad().
    }
}

Function AddKerbinPads {
	If (Ship:Body:Name <> "Kerbin") Return.
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-0.097207, -74.557672)) < MaxDistancePads)	{ LaunchPads:Add("LaunchPad"). 					LaunchPads:Add(LatLng(-0.097207, -74.557672)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-0.096808, -74.617447)) < MaxDistancePads)	{ LaunchPads:Add("Pad1"). 						LaunchPads:Add(LatLng(-0.096808, -74.617447)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-0.096767, -74.620048)) < MaxDistancePads)	{ LaunchPads:Add("Pad2"). 						LaunchPads:Add(LatLng(-0.096767, -74.620048)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-0.092562, -74.663084)) < MaxDistancePads)	{ LaunchPads:Add("HeliPad"). 					LaunchPads:Add(LatLng(-0.092562, -74.663084)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-1.519712, -71.899433)) < MaxDistancePads)	{ LaunchPads:Add("Island Airfield"). 			LaunchPads:Add(LatLng(-1.519712, -71.899433)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-1.523246, -71.911106)) < MaxDistancePads)	{ LaunchPads:Add("Island Airfield (Tower)"). 	LaunchPads:Add(LatLng(-1.523246, -71.911106)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-0.086810, -74.661199)) < MaxDistancePads)	{ LaunchPads:Add("KSC Pool"). 					LaunchPads:Add(LatLng(-0.086810, -74.661199)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(-6.056890,  99.471429)) < MaxDistancePads)	{ LaunchPads:Add("Round Range"). 				LaunchPads:Add(LatLng(-6.056890,  99.471429)).	LaunchPads:Add(Body:Name). }
    If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(20.663470,-146.420970)) < MaxDistancePads)	{ LaunchPads:Add("KSC 2"). 						LaunchPads:Add(LatLng( 20.66347,-146.420970)).	LaunchPads:Add(Body:Name). }
}

Function AddTargetPad {
    If (HasTarget = True and Target:Body:Name = Body:Name and GeoPositionDistance(Addons:TR:ImpactPos, Target:GeoPosition) < MaxDistancePads) { 
           LaunchPads:Add("'Target'"). 
           LaunchPads:Add(Target:GeoPosition). 
           LaunchPads:Add(Body:Name). 
    }
}

Function AddCustomPads {
    If (Exists("Pads") = True) { 
        Set cPads to List().
        Run Pads.
        From { Set cPadN to 0. } Until (cPadN > cPads:Length -3) Step { Set cPadN to cPadN + 3.} Do { 
            If (cPads[cPadN + 2] = Body:Name) { 
                If (GeoPositionDistance(Addons:TR:ImpactPos, LatLng(cPads[cPadN + 1]:Split(",")[0]:ToNumber, cPads[cPadN + 1]:Split(",")[1]:ToNumber)) < MaxDistancePads) { 
                    LaunchPads:Add(cPads[cPadN]).
                    LaunchPads:Add(LatLng(cPads[cPadN + 1]:Split(",")[0]:ToNumber, cPads[cPadN + 1]:Split(",")[1]:ToNumber)).
                    LaunchPads:Add(cPads[cPadN + 2]).
                }
            }
        }
    }
}

Function AddWaypoints {
    For cWaypoint in AllWaypoints() {
        If (cWaypoint:Body:Name = Ship:Body:Name) {
            If (GeoPositionDistance(Addons:TR:ImpactPos, cWaypoint:GeoPosition) < MaxDistancePads) {
                Set AddWaypoint to True.
                From { Set cPadN to 0. } Until (cPadN > LaunchPads:Length -3) Step { Set cPadN to cPadN + 3.} Do {
                    If (LaunchPads[cPadN] = cWaypoint:Name and LaunchPads[cPadN + 1] = cWaypoint:GeoPosition) {
                        Set AddWaypoint to False.
                        Break.
                    }
                }
                If (AddWaypoint = True) {
                    LaunchPads:Add("'" + cWaypoint:Name + "'").
                    LaunchPads:Add(cWaypoint:GeoPosition).
                    LaunchPads:Add(cWaypoint:Body:Name).
                }
            }
        }
    }
}

Function AddVessels {
    List Targets in AllTargets.

    For cTarget in AllTargets {
        If (cTarget:Body:Name = Body:Name) {
            If (GeoPositionDistance(Addons:TR:ImpactPos, cTarget:GeoPosition) < MaxDistancePads) {
                LaunchPads:Add("'" + cTarget:Name + "'").
                LaunchPads:Add(cTarget:GeoPosition).
                LaunchPads:Add(cTarget:Body:Name).
            }
        }
    }
}

Function SelectInitialPad {
    Set cPad to "".

    If (LaunchPads:Length > 0) {
        From { Set cPadN to 0. } Until (cPadN > LaunchPads:Length -3) Step { Set cPadN to cPadN + 3.} Do {
            If (LaunchPads[cPadN] = Pad) {
                Set PadN to cPadN.
                Set Pad to LaunchPads[cPadN].
                Set LaunchPad to LaunchPads[cPadN + 1].
                Set cPad to Pad.
                Break.
            }
        }
    }

    If (cPad = "" and Pad:Contains(",") = True) {
        Set GeoPosLat to Pad:Split(",")[0].
        Set GeoPosLng to Pad:Split(",")[1].
        Set GeoPos to LatLng(GeoPosLat:ToNumber, GeoPosLng:ToNumber).
        If (GeoPositionDistance(Ship:GeoPosition, GeoPos) < MaxDistancePads) {
            Set Pad to "'" + Round(GeoPos:Lat, 3)+ ", " + Round(GeoPos:Lng, 3) + "'".
            LaunchPads:Add(Pad).
            LaunchPads:Add(GeoPos).
            LaunchPads:Add(body:Name).
            Set PadN to LaunchPads:Length -3.
            Set LaunchPad to GeoPos.
            Set cPad to Pad.
        }
    }

    If (LaunchPads:Length = 0) {
        Set Pad to "No Pads".
    } Else {
        Set Pad to LaunchPads[LaunchPads:Length - 3].
        Set LaunchPad to LaunchPads[LaunchPads:Length - 2].
        Set OriginalLaunchPad to LaunchPad.
    }
}
