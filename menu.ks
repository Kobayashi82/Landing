
Function ShowMenu {
	Set StartProgram to False.
	Set DisplayMenu to True.
	Set EmergencyEfficiency to 100.

	Until (StartProgram = True) {

		If (Addons:TR:Available = False) { ClearScreen.
			Print "                   SUICIDE BURN                   " at (0, 2).
			Print "     .======================================.     " at (0, 14).
			Print "     |        TRAJECTORIES NOT FOUND        |     " at (0, 15).
			Print "     |======================================|     " at (0, 16).
			Print "               Press 'ENTER' to exit              " at (0, 22).
			Print "  By: Kobayashi " at (34, 34).
			Until (False) { Wait 0.1.
				If (Addons:TR:Available = True) { Set DisplayMenu to True. Break. }
				If (Terminal:Input:HasChar and Terminal:Input:GetChar() = Terminal:Input:Enter) Reboot.
			}
		}

		If (AvailableThrust = 0) { ClearScreen.
			Print "                   SUICIDE BURN                   " at (0, 2).
			Print "     .======================================.     " at (0, 14).
			Print "     |           NO AVAILABLE THRUST        |     " at (0, 15).
			Print "     |======================================|     " at (0, 16).
			Print "               Press 'ENTER' to exit              " at (0, 22).
			Print "  By: Kobayashi " at (34, 34).
			Until (False) { Wait 0.1.
				If (AvailableThrust > 0) { Set DisplayMenu to True. Break. }
				If (Terminal:Input:HasChar and Terminal:Input:GetChar() = Terminal:Input:Enter) Reboot.
			}
		}

		If (ShipStatus <> "Flying") { ClearScreen.
			Print "                   SUICIDE BURN                   " at (0, 2).
			Print "             .======================.             " at (0, 4).
			Print "             | Altitude:            |             " at (0, 5).
			Print "             |----------------------|             " at (0, 6).
			Print "             | Biome:               |             " at (0, 7).
			Print "             |======================|             " at (0, 8).
			Print "               Press 'ENTER' to exit              " at (0, 22).
			Print "  By: Kobayashi " at (34, 34).

			If (Addons:Biome:Available = True)							Set IBiome to Addons:Biome:At(Ship:Body, Ship:GeoPosition).
			Else														Set IBiome to "Unknow".
			Print IBiome + Spacer(IBiome:Length, 13) at (22, 7).

			Until (False) { Wait 0.1.
				If (ShipStatus = "Flying") { Set DisplayMenu to True. Break. }
				Print FormatDistance(Ship:Bounds:BottomAlt, 1) at (26, 5).
				If (Terminal:Input:HasChar and Terminal:Input:GetChar() = Terminal:Input:Enter) Reboot.
			}
		}

		If		(Pad <> "Anywhere" and Addons:TR:HasImpact = True)	Lock TrueAltitude to MIN(Addons:TR:ImpactPos:Distance - ExtraAlt - (MAX(LaunchPad:TerrainHeight - Addons:TR:ImpactPos:TerrainHeight, 0)), LaunchPad:Distance - ExtraAlt).
		Else If (Addons:TR:HasImpact = True)						Lock TrueAltitude to Addons:TR:ImpactPos:Distance - ExtraAlt.
		Else														Lock TrueAltitude to Ship:GeoPosition:Distance - ExtraAlt.

		If (DisplayMenu = True) { ClearScreen. Set DisplayMenu to False. 
			Print "                   SUICIDE BURN                   " at (0, 2).
			Print "                                                  " at (0, 3).
			Print "  .=============================================. " at (0, 4).
			Print "  | Altitude:            | Impact Time:         | " at (0, 5).
			Print "  |---------------------------------------------| " at (0, 6).
			Print "  | Biome:               | Impact Alt:          | " at (0, 7).
			Print "  |---------------------------------------------| " at (0, 8).
			Print "  | Burning in:          | Impact Dist:         | " at (0, 9).
			Print "  |=============================================| " at (0, 10).
			Print "                                                  " at (0, 11).
			Print "     .======================================.     " at (0, 12).
			Print "     | (< >) PAD:                           |     " at (0, 13).
			Print "  .=============================================. " at (0, 14).
			Print "  | Terrain Alt:         | Distance:            | " at (0, 15).
			Print "  |---------------------------------------------| " at (0, 16).
			Print "  |  Biome:              | (D)                  | " at (0, 17).
			Print "  |=============================================| " at (0, 18).
			Print "                                                  " at (0, 19).
			Print "  .=============================================. " at (0, 20).
			Print "  | (A) Extra Alt:       | (E) Efficiency:      | " at (0, 21).
			Print "  |---------------------------------------------| " at (0, 22).
			Print "  | (S) Auto-Slope:      | (R) RCS:             | " at (0, 23).
			Print "  |---------------------------------------------| " at (0, 24).
			Print "  | (G) Gear:            | (B) Brakes:          | " at (0, 25).
			Print "  |=============================================| " at (0, 26).
			Print "               Press 'ENTER' to start             " at (0, 28).
			Print "  By: Kobayashi " at (34, 34).
		}

		If (Addons:TR:HasImpact = True) {
			Set TImpact			to Round(Addons:TR:TimeTillImpact) + " s.".
			Set ImpactPosition	to Addons:TR:ImpactPos.
		} Else {
			Set TImpact			to "0 s.".
			Set ImpactPosition	to Ship:GeoPosition.
		}

		Set AImpact	to FormatDistance(ImpactPosition:TerrainHeight, 1).
		Set DImpact	to FormatDistance(ImpactPosition:Distance, 1).
		Set BurnAlt	to ABS(MaxVertDecel()) + EmergencyEfficiency.
		Set ABurn	to FormatDistance(MAX(TrueAltitude - BurnAlt, 0), 1).

		If (Addons:Biome:Available = True)	Set IBiome to Addons:Biome:At(Ship:Body, ImpactPosition).
		Else								Set IBiome to "Unknown".

		If (Pad = "Anywhere") {
			Set APad to AImpact.
			Set DPad to DImpact.
			Set PadBiome to IBiome.
		} Else If (LaunchPad:Lat = 0 and LaunchPad:Lng = 0) {
			Set APad to "    -".
			Set DPad to "    -".
			Set PadBiome to IBiome.
		} Else {
			Set APad to FormatDistance(MAX(LaunchPad:TerrainHeight, 0), 1).
			Set DPad to FormatDistance(LaunchPad:Distance, 1).
			If (Addons:Biome:Available = True)	Set PadBiome to Addons:Biome:At(Ship:Body, LaunchPad).
			Else								Set PadBiome to "Unknown".
		}

		Print FormatDistance(Altitude, 1) + Spacer(FormatDistance(Altitude, 1):Length, 8) at (14, 5).	Print TImpact + Spacer(TImpact:Length, 8) at (40, 5).
		Print IBiome + Spacer(IBiome:Length, 13) at (11, 7).											Print AImpact + Spacer(AImpact:Length, 8) at (40, 7).
		Print ABurn + Spacer(ABurn:Length, 8) at (16, 9).												Print DImpact + Spacer(DImpact:Length, 8) at (40, 9).

		Print Pad + Spacer(Pad:Length, 26) at (18, 13).													Print "|   " at (44, 13).
		Print APad + Spacer(APad:Length, 8) at (17, 15).												Print DPad + Spacer(DPad:Length	, 7) at (38, 15).
		Print PadBiome + Spacer(PadBiome:Length, 13) at (12, 17).										// Free

		Print FormatDistance(ExtraAlt, 1) + Spacer(FormatDistance(ExtraAlt, 1):Length, 5) at (19, 21).	Print Round(100 - (Efficiency / 10)) + "%" + Spacer((Round(100 - (Efficiency / 10)) + "%"):Length, 5) at (43, 21).
		Print AutoSlope + Spacer(AutoSlope:Length, 5) at (20, 23).										Print RCS_ON + Spacer(RCS_ON:Length, 5) at (36, 23).
		Print GEAR_ON + Spacer(GEAR_ON:Length, 5) at (14, 25).											Print BRAKES_ON + Spacer(BRAKES_ON:Length, 5) at (39, 25).

		If (Terminal:Input:HasChar) {
			Set ch to Terminal:Input:GetChar().

			If (LaunchPads:Length > 0) {
				If (ch = Terminal:Input:LeftCursorOne) {
					If (PadN = -1)								Set PadN to 0.
					If (PadN = 0)								Set PadN to LaunchPads:Length - 3.
					Else										Set PadN to PadN - 3.
					Set Pad to LaunchPads[PadN].
					Set LaunchPad to LaunchPads[PadN + 1].
					Set OriginalLaunchPad to LaunchPad.
				}
			}

			If (LaunchPads:Length > 0) {
				If (ch = Terminal:Input:RightCursorOne) {
					If (PadN = -1)								Set PadN to LaunchPads:Length - 3.
					If (PadN = LaunchPads:Length - 3)			Set PadN to 0.
					Else										Set PadN to PadN + 3.
					Set Pad to LaunchPads[PadN].
					Set LaunchPad to LaunchPads[PadN + 1].
					Set OriginalLaunchPad to LaunchPad.
				}
			}

			If (UnChar(ch) = 97) {
				If 		(ExtraAlt < 50)							Set ExtraAlt to ExtraAlt + 1.
				Else If (ExtraAlt >= 50 and ExtraAlt < 500)		Set ExtraAlt to ExtraAlt + 10.
				Else If (ExtraAlt >= 500 and ExtraAlt < 9900)	Set ExtraAlt to ExtraAlt + 100.
				Else If (ExtraAlt >= 9900)						Set ExtraAlt to 10000.
			}

			If UnChar(ch) = 65 {
				If		(ExtraAlt > 500)						Set ExtraAlt to ExtraAlt - 100.
				Else If (ExtraAlt <= 500 and ExtraAlt > 50)		Set ExtraAlt to ExtraAlt - 10.
				Else If (ExtraAlt <= 50 and ExtraAlt > 0)		Set ExtraAlt to ExtraAlt - 1.
			}

			If (UnChar(ch) = 101) {
				If (Efficiency < 1000)							Set Efficiency to Efficiency + 100.
			}

			If (UnChar(ch) = 69) {
				If (Efficiency > 0)								Set Efficiency to Efficiency - 100.
			}

			If (ch = "s") {
				If (AutoSlope = "Yes")							Set AutoSlope to "No".
				Else											Set AutoSlope to "Yes".
			}

			If (ch = "r") {
				If (RCS_ON = "Yes")								Set RCS_ON to "No".
				Else											Set RCS_ON to "Yes".
			}

			If ch = "g" {
				If (GEAR_ON = "Yes")							Set GEAR_ON to "No".
				Else											Set GEAR_ON to "Yes".
			}

			If (ch = "b") {
				If (BRAKES_ON = "Yes")							Set BRAKES_ON to "No".
				Else											Set BRAKES_ON to "Yes".
			}

			If (ch = Terminal:Input:Enter) {
				Set StartProgram to True.
				If (Pad = "'Target'") {
					If (HasTarget = True) {
						Set Pad to "'" + Target:Name + "'".
						Set LaunchPad to Target:GeoPosition.
					} Else {
						Set Pad to "Anywhere".
						Set LaunchPad to LatLng(0.0, 0.0).
					}
				}
			}

			If (Terminal:Input:HasChar) Terminal:Input:Clear.
		}

		If (TrueAltitude < BurnAlt and (ABS(MaxVertDecel()) / (TrueAltitude - EmergencyEfficiency)) > 1) {
			Set Efficiency to EmergencyEfficiency.
			Set EmergencyBurn to True.
			Set StartProgram to True.
		}
	}
}
