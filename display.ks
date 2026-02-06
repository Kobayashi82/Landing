
Function PrintInfo {
    Parameter PMode is "".

    If (ShowInfo = False) Return.

    If (PMode = "Initialize") { ClearScreen.
        Set Mode to "Armed".
        Print "                   SUICIDE BURN                   " at (0, 2).
        Print "  .=============================================. " at (0, 4).
        Print "  | Mode:                | Impact Time:         | " at (0, 5).
        Print "  |---------------------------------------------| " at (0, 6).
        Print "  | Biome:               | Impact Alt:          | " at (0, 7).
        Print "  |---------------------------------------------| " at (0, 8).
        Print "  | Burning in:          | Impact Dist:         | " at (0, 9).
        Print "  |=============================================| " at (0, 10).
        If (EmergencyBurn = True) Print "             ¡ ¡ ¡ EMERGENCY BURN ! ! !           " at (0, 15).
        Print "  By: Kobayashi " at (34, 34).
    }
	
	If (PMode = "Finalize") { ClearScreen.
        Print "                   SUICIDE BURN                   " at (0, 2).
        Print "             .======================.             " at (0, 4).
        Print "             | Altitude:            |             " at (0, 5).
        Print "             |----------------------|             " at (0, 6).
        Print "             | Biome:               |             " at (0, 7).
        Print "             |======================|             " at (0, 8).
        Print "                                                  " at (0, 9).
        Print "                                                  " at (0, 10).
        Print "  By: Kobayashi " at (34, 34).

        If (Addons:Biome:Available = True)			Set IBiome to Addons:Biome:At(Ship:Body, Ship:GeoPosition).
		Else										Set IBiome to "Unknow".

        Print FormatDistance(Ship:Bounds:BottomAlt, 1) at (26, 5).
		Print IBiome + Spacer(IBiome:Length, 13) at (22, 7).
    }

	If (PMode <> "Initialize" and PMode <> "Finalize") {
        If (Addons:TR:Available = True and NoTR = False) {
            If (Addons:TR:HasImpact = True) {
                Set LocalImpactTime					to Round(Addons:TR:TimeTillImpact).
                Set TImpact							to LocalImpactTime + " s.".
                Set AImpact							to FormatDistance(Addons:TR:ImpactPos:TerrainHeight, 1).
                Set DImpact							to FormatDistance(Addons:TR:ImpactPos:Distance, 1).

                If (SBurning = False)				Set ABurn to FormatDistance(MAX(TrueAltitude - (BurnAlt), 0), 1).
                Else								Set ABurn to MAX(MIN(Round(Throttle * 100), 100), 0) + "%".

                If (Addons:Biome:Available = True)	Set IBiome to Addons:Biome:At(Ship:Body, Addons:TR:ImpactPos).
                Else								Set IBiome to "Unknow".
            } Else {
                Set LocalImpactTime					to 0.
                Set TImpact							to LocalImpactTime + " s.".
                Set AImpact							to FormatDistance(Ship:GeoPosition:TerrainHeight, 1).
                Set DImpact							to FormatDistance(Ship:GeoPosition:Distance, 1).

                If (SBurning = False)				Set ABurn to FormatDistance(MAX(Ship:GeoPosition:Distance - ExtraAlt - BurnAlt, 0), 1).
                Else								Set ABurn to MAX(MIN(Round(Throttle * 100), 100), 0) + "%".

                If (Addons:Biome:Available = True)	Set IBiome to Addons:Biome:At(Ship:Body, Ship:GeoPosition).
                Else								Set IBiome to "Unknow".
            }
        } Else {
            If (VerticalSpeed < 0)					Set LocalImpactTime to Round(ABS(Ship:GeoPosition:Distance - ExtraAlt / VerticalSpeed)).
            Else									Set LocalImpactTime to 0.

            Set TImpact								to LocalImpactTime + " s.".
            Set AImpact								to FormatDistance(Ship:GeoPosition:TerrainHeight, 1).
            Set DImpact								to FormatDistance(Ship:GeoPosition:Distance, 1).

            If SBurning = False						Set ABurn to FormatDistance(MAX(Ship:GeoPosition:Distance - ExtraAlt - BurnAlt, 0), 1).
            Else									Set ABurn to MAX(MIN(Round(Throttle * 100), 100), 0) + "%".

            If (Addons:Biome:Available = True)		Set IBiome to Addons:Biome:At(Ship:Body, Ship:GeoPosition).
            Else									Set IBiome to "Unknow".
        }

        Print Mode + Spacer(Mode:Length, 13) at (11, 5).			Print TImpact + Spacer(TImpact:Length, 8) at (40, 5).
        Print IBiome + Spacer(IBiome:Length, 13) at (11, 7).		Print AImpact + Spacer(AImpact:Length, 8) at (40, 7).
        Print ABurn + Spacer(ABurn:Length, 8) at (17, 9).			Print DImpact + Spacer(DImpact:Length, 8) at (40, 9).
    }
}
