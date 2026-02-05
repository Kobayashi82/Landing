// ===============================================
// SUICIDE BURN - FUNCIONES DE UTILIDAD
// ===============================================

// .=========.
// | GET TWR |
// |=========|

Function GetTWR {
    Parameter Mode is "CUR". 
    Parameter Numeric is False. 
    Parameter CalcAlt is Ship:Altitude.

    Set mThrust to 0. 
    Set cThrust to 0.
    List Engines in EngList.

    For Eng in EngList {
        Set cThrust to cThrust + Eng:Thrust.
        If (Eng:Ignition = True and Eng:Flameout = False) {
            Set mThrust to mThrust + Eng:MaxThrust * (Eng:ThrustLimit / 100).
        }
    }

    If (Numeric = True) {
        Set cThrust to Round(cThrust / ((Ship:Body:MU / (Ship:Body:Radius + CalcAlt )^2) * Ship:Mass), 2).
        Set mThrust to Round(mThrust / ((Ship:Body:MU / (Ship:Body:Radius + CalcAlt )^2) * Ship:Mass), 2).
    } Else {
        Set cThrust to Round(cThrust / ((Ship:Body:MU / (Ship:Body:Radius + CalcAlt )^2) * Ship:Mass), 2) + "".
        If (cThrust:Length = 3) Set cThrust to cThrust + "0".
        If (cThrust:Length = 1) Set cThrust to cThrust + ".00".
        Set mThrust to Round(mThrust / ((Ship:Body:MU / (Ship:Body:Radius + CalcAlt )^2) * Ship:Mass), 2) + "".
        If (mThrust:Length = 3) Set mThrust to mThrust + "0".
        If (mThrust:Length = 1) Set mThrust to mThrust + ".00".
    }

    If (Mode = "CUR") Return (cThrust).
    If (Mode = "MAX") Return (mThrust).
}

// |=================|
// | FORMAT DISTANCE |
// |=================|

Function FormatDistance { 
    Parameter Value, Decimals is 0.

    If (Value < 1000) { 
        Return (Max(Round(Value), 0) + " m.").
    } Else If (Value < 100000) {
        Local Result to Max(Round(Value / 1000, Decimals), 0) + "".
        If (Decimals > 0) { 
            If (Result:Contains(".") = False) { 
                Return (Result + "." + "0000000000":SubString(0, Decimals) + " km.").
            } Else {
                Return (Result + " km.").
            }
        } Else { 
            Return (Result + " km.").
        }
    } Else { 
        Return (Max(Round(Value / 1000), 0) + " km.").
    }
}

// .=========.
// | VARIOUS |
// |=========|

Function MaxVertDecel {
    If (Velocity:Surface:MAG = 0 or AvailableThrust = 0) Return (0).
    If (GroundSpeed > ABS(VerticalSpeed * 2)) {
        Return (GroundSpeed^2 / (2 * ((AvailableThrust / Mass) * (2 * (GroundSpeed / Velocity:Surface:MAG) + 1) / 3 - (Body:MU / Body:Radius^2)))).
    } Else {
        Return (VerticalSpeed^2 / (2 * ((AvailableThrust / Mass) * (2 * (-VerticalSpeed / Velocity:Surface:MAG) + 1) / 3 - (Body:MU / Body:Radius^2)))).
    }
}

Function ShipStatus {
    If (Ship:Status = "Landed" or Ship:Status = "PreLaunch") Return ("Landed").
    If (Ship:Status = "Splashed") Return ("Splashed").
    Return ("Flying").
}

Function Spacer {
    Parameter StringLength, SpaceLength.
    Local Spaces is "                                                  ":Substring(0, Max(Min(SpaceLength, 50), 0)).

    If (StringLength >= SpaceLength) Return ("").
    Return (Spaces:Substring(StringLength, Spaces:Length - StringLength)).
}

Function CardVel {
    Local Vect is Ship:Velocity:Surface.
    Local EastVect is VCRS(UP:Vector, North:Vector).
    Local EastComp is ScalarProj(Vect, EastVect).
    Local NorthComp is ScalarProj(Vect, North:Vector).
    Local UpComp is ScalarProj(Vect, UP:Vector).

    Return (V(EastComp, UpComp, NorthComp)).
}

Function ScalarProj {
    Parameter a, b.

    If (b:MAG = 0) Return (1).
    Return (VDot(a, b) * (1 / b:MAG)).
}

// .=====================================================================.
// |                             GEO-POSITION                            |
// |=====================================================================|

Function GetHeading {
    Parameter cVessel, cVector.
    Set cHeading to ArcTan2(VDOT(cVector, VCRS(cVessel:Up:Vector, cVessel:North:Vector)), VDOT(cVector, cVessel:North:Vector)).

    If (cHeading < 0)	Return (cHeading + 360).
    Else				Return (cHeading).
}

Function GeoPositionDistance {
    Parameter GeoPos1, GeoPos2, Radius is Body:Radius.

    If (GeoPos2 + "" = "Impact") {
        If (Addons:TR:HasImpact = True)	Return ((GeoPos1:Position - Addons:TR:ImpactPos:Position):MAG).
        Else							Return (9999999).
    }

    Local A is Sin((GeoPos1:Lat - GeoPos2:Lat) / 2)^2 + Cos(GeoPos1:Lat) * Cos(GeoPos2:Lat) * Sin((GeoPos1:Lng - GeoPos2:Lng) / 2)^2.
    Return (Radius * Constant:PI * ArcTan2(SQRT(A), SQRT(1 - A)) / 90).
}

Function GeoDir {
    Parameter Geo1, Geo2.

    Return (ArcTan2 (Geo1:LNG - Geo2:LNG, Geo1:LAT - Geo2:LAT)).
}

Function GeoPositionImpact {
    Parameter GeoPos.

    If (Addons:TR:HasImpact = True)	Return ((GeoPos:Position - Addons:TR:ImpactPos:Position):MAG).
    Else							Return (9999999).
}

Function GeoPositionBearing {
    Parameter GeoPos1, GeoPos2.

    Return (Mod(360 + ArcTan2(Sin(GeoPos2:Lng - GeoPos1:Lng) * Cos(GeoPos2:Lat), Cos(GeoPos1:Lat) * Sin(GeoPos2:Lat) - Sin(GeoPos1:Lat) * Cos(GeoPos2:Lat) * Cos(GeoPos2:Lng - GeoPos1:Lng)), 360)).
}

Function GeoPositionAt {
    Parameter GeoPos, cDistance, cBearing is Mod(360 - LatLng(90,0):Bearing, 360).
    Local Lat is ArcSin(Sin(GeoPos:Lat) * Cos((cDistance * 180) / (Body:Radius * Constant:PI)) + Cos(GeoPos:Lat) * Sin((cDistance * 180) / (Body:Radius * Constant:PI)) * Cos(cBearing)).
    Local Lng is 0. 

    If (ABS(Lat) <> 90)	Set Lng to GeoPos:Lng + ArcTan2(Sin(cBearing) * Sin((cDistance * 180) / (Body:Radius * Constant:PI)) * Cos(GeoPos:Lat), Cos((cDistance * 180)/(Body:Radius * Constant:PI)) - Sin(GeoPos:Lat) * Sin(Lat)).
    Return (LatLng(Lat, Lng)).
}
