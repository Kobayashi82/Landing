Function Navigate_Throttle {
	Lock TrueRadar to Ship:Bounds:BottomAltRadar.

	If Pad <> "Anywhere" {
		// Fase de Corrección con Motores - Posicionar el punto de impacto sobre el target
		If (Altitude > 7000) {
			Set TargetDistOld to 0.
			Set PrecisionThreshold to 50. // Umbral más realista
			Set MaxCorrectionTime to 25.  // Más tiempo para correcciones lejanas
			Set CorrectionStartTime to Time:Seconds.
			Set LastImprovementTime to Time:Seconds.
			
			Until (False) {
				If (Addons:TR:HasImpact = True) {
					Set TargetDist to GeoPositionDistance(LaunchPad, Addons:TR:ImpactPos).
				} Else { 
					Lock Throttle to 0. 
					Break. 
				}

				// Calcular dirección CORRECTA hacia el target (sin -180)
				Set SteeringDir to GeoPositionBearing(Addons:TR:ImpactPos, LaunchPad).
				
				// Trayectoria parabólica para destinos lejanos, control preciso para cercanos
				Local OptimalPitch is 0.
				If (TargetDist > 3000) {
					Set OptimalPitch to 45. // Trayectoria parabólica óptima para muy lejos
				} Else If (TargetDist > 1500) {
					Set OptimalPitch to MAX(25, MIN(40, 15 + (TargetDist / 100))). // Arco parabólico
				} Else If (TargetDist > 500) {
					Set OptimalPitch to MAX(15, MIN(30, 10 + (TargetDist / 100))). // Transición
				} Else If (TargetDist > 100) {
					Set OptimalPitch to MAX(5, MIN(20, TargetDist / 25)). // Control fino
				} Else {
					Set OptimalPitch to MAX(10, MIN(30, TargetDist / 5)). // Precisión final
				}
				Set SteeringPitch to OptimalPitch.
				
				Lock Steering to Heading(SteeringDir, SteeringPitch).

				// Control de throttle más agresivo y efectivo
				Local AlignmentAngle is VANG(Heading(SteeringDir, SteeringPitch):Vector, Ship:Facing:Vector).
				
				If (AlignmentAngle < 25) { // Más tolerante en alineación
					// Control de throttle para trayectoria parabólica balanceada
					Local ThrottleValue is 0.
					Local CurrentHorizontalSpeed is Ship:GroundSpeed.
					
					If (TargetDist > 2000) {
						// Para distancias muy grandes: throttle controlado para evitar exceso de velocidad
						Local MaxDesiredSpeed is MIN(400 + (TargetDist / 20), 600). // Velocidad máxima deseada
						If (CurrentHorizontalSpeed < MaxDesiredSpeed) {
							Set ThrottleValue to MIN(MAX((TargetDist / 3000) * (MaxDesiredSpeed - CurrentHorizontalSpeed) / 100, 0.3), 0.8).
						} Else {
							Set ThrottleValue to 0.1. // Throttle mínimo si ya va muy rápido
						}
					} Else If (TargetDist > 500) {
						// Distancias medias: throttle moderado
						Local MaxDesiredSpeed is MIN(200 + (TargetDist / 10), 400).
						If (CurrentHorizontalSpeed < MaxDesiredSpeed) {
							Set ThrottleValue to MIN(MAX(TargetDist / 1000, 0.2), 0.6).
						} Else {
							Set ThrottleValue to 0.1.
						}
					} Else {
						// Distancias cortas: throttle preciso
						Set ThrottleValue to MIN(MAX(TargetDist / 500, 0.1), 0.4).
					}
					
					Lock Throttle to ThrottleValue.
				} Else {
					Lock Throttle to 0.
				}

				// Mejorar el sistema de salida para evitar paradas prematuras
				If (TargetDist < PrecisionThreshold) { 
					Lock Throttle to 0. 
					Break. 
				}
				
				// Solo salir si la distancia está aumentando consistentemente
				If (TargetDist < TargetDistOld) {
					Set LastImprovementTime to Time:Seconds.
				}
				
				// Si no hay mejora en 8 segundos Y estamos cerca, salir
				If (Time:Seconds - LastImprovementTime > 8 and TargetDist < 200) {
					Lock Throttle to 0.
					Break.
				}
				
				// Timeout general más largo
				If (Time:Seconds - CorrectionStartTime > MaxCorrectionTime) {
					Lock Throttle to 0.
					Break.
				}
				
				Set TargetDistOld to TargetDist.
				Wait 0.05. // Update más frecuente
			}
			
			// Asegurar que el throttle esté en 0 al finalizar la corrección
			Lock Throttle to 0.
			Wait 1.
		}

		Set PrepSBurn to False.
		//When TrueRadar < 3000 Then { Lock TrueAltitude to Altitude - (ShipHeight + MAX(ExtraAlt, 5) + MAX(LaunchPad:TerrainHeight, 0)). }
		Set EastVelPID  to PIDLoop (3, 0.01, 0.0, -15, 15). Set EastPosPID  to PIDLoop (1700, 0, 100, -30, 30). Set EastPosPID:SetPoint  to LaunchPad:LNG.
		Set NorthVelPID to PIDLoop (3, 0.01, 0.0, -15, 15). Set NorthPosPID to PIDLoop (1700, 0, 100, -30, 30). Set NorthPosPID:SetPoint to LaunchPad:LAT.
	} Else {
		Lock TrueAltitude to Ship:Bounds:BottomAltRadar - ExtraAlt.
	}
}

Function Navigate_Aero {
	If BRAKES_ON = "Yes" { Brakes On. } Else { Brakes Off. }
	Set IdealThrottle to 0.

	If Pad <> "Anywhere" Addons:TR:SetTarget(LaunchPad).
	Until VerticalSpeed > -5 { PrintInfo().
		If SBurning = False {
			If Addons:TR:Available = True {
				Set BurnAlt to (ABS(MaxVertDecel()) + Efficiency).
			} Else {
				Set BurnAlt to ABS(MaxVertDecel()) + MAX(Ship:GeoPosition:TerrainHeight, 0) + ((GroundSpeed / GetTWR ("MAX", True, 0)) * 10) + Efficiency.
			}
			If TrueAltitude < BurnAlt + 1000 {
				Set PrepSBurn to True.
				Lock Steering to SRFRetrograde.
			}
			If TrueAltitude < BurnAlt and IdealThrottle >= 1 {
				Set SBurning to True.
				Set Efficiency to 0.
				Lock Throttle to IdealThrottle.
				Set Mode to "Burning".
				Print "  | Throttle:            | Impact Dist:         | " at (0, 9).
				If Pad <> "Anywhere" { Lock Steering to Heading(SteeringDir, SteeringPitch). }
				If GroundSpeed > ABS(VerticalSpeed * 2) { Set ExtraAlt to ExtraAlt + 10. }
			}
		}

		Set IdealThrottle to ABS(MaxVertDecel() / (TrueAltitude - (Efficiency))).
		//---------------------------------------------------------------
		Set AngleMode to -1. // [0 for Pods], [-1 for Fuel Tanks] -- no deberia ser 1 en vez de 0 ?
		//---------------------------------------------------------------

		If Pad <> "Anywhere" { Set CardVelCached to CardVel(). SteeringPIDs().
			If SBurning = False and PrepSBurn = False {
				Set AdjustAngle to MIN((GeoPositionDistance(LaunchPad, "Impact") / 100) * 4, 70).

				If GroundSpeed < 1200 {
					Set LaunchPadVect to (LaunchPad:Position - Addons:TR:ImpactPos:Position):Normalized * AngleMode.
					Set RotateBy to Min((LaunchPad:Position - Addons:TR:ImpactPos:Position):MAG , AdjustAngle).
					Set SteeringVect to (Ship:Velocity:Surface * -1):Normalized * 40.
					Set LoopCount to 0.
					Until (RotateBy - VANG(SteeringVect, (Ship:Velocity:Surface * -1):Normalized)) < 3 {
						If VANG(SteeringVect, (Ship:Velocity:Surface * -1):Normalized) > RotateBy Break.
						Set LoopCount to LoopCount + 1.
						If LoopCount > 100 Break.
						Set SteeringVect to SteeringVect + LaunchPadVect.
					}
					Lock Steering to SteeringVect:Direction.
				}
			} Else If SBurning = True and VerticalSpeed > -20 and VerticalSpeed > MIN(-(TrueRadar / 2), -2) {
				Set Throttle_PID to PIDLoop(0.3, 0.3, 0.005, 0, 1).
				Lock Throttle to Throttle_PID:Update(Time:Seconds, VerticalSpeed). Break.
			}
			If SBurning = True {
				Print SteeringDir at (0, 0).
				Print SteeringPitch at (0, 1).
			}
		}
	}
}

Function Navigate_Ground {
	If Pad <> "Anywhere" { Set NoTR to True. Set SBurning to False.
		Set EastVelPID  to PIDLoop (3, 0.01, 0.0, -30, 30). Set EastPosPID  to PIDLoop (3000, 0, 100, -50, 50). Set EastPosPID:SetPoint  to LaunchPad:LNG.
		Set NorthVelPID to PIDLoop (3, 0.01, 0.0, -30, 30). Set NorthPosPID to PIDLoop (3000, 0, 100, -50, 50). Set NorthPosPID:SetPoint to LaunchPad:LAT.
	} Else { Lock Steering to SRFRetrograde. }

	Set Throttle_PID to PIDLoop(0.3, 0.3, 0.005, 0, 1).
	Lock Throttle to Throttle_PID:Update(Time:Seconds, VerticalSpeed).

	Until ShipStatus <> "Flying" { PrintInfo().
		If Pad <> "Anywhere" { Set CardVelCached to CardVel(). SteeringPIDs().
			Print SteeringDir at (0, 0).
			Print SteeringPitch at (0, 1).
			If GeoPositionImpact(LaunchPad) < 5 and GroundSpeed < 3 and ShipStatus <> "Landed" {
				Set Throttle_PID:SetPoint to MIN(-(TrueRadar / 2), -2).
			} Else {
				If Ship:Bounds:BottomAltRadar < LaunchPad:TerrainHeight + 5 { Set Throttle_PID:SetPoint to 1. } Else { Set Throttle_PID:SetPoint to 0. }
			}
		} Else {
			Set Throttle_PID:SetPoint to MIN(-(TrueRadar / 2), -2).
		}
	}
}

Function SteeringPIDs {
	Set EastVelPID:SetPoint  to EastPosPID:Update(Time:Seconds, Ship:GeoPosition:LNG).  Local EastVelPIDOut  is EastVelPID:Update(Time:Seconds, CardVelCached:X).
	Set NorthVelPID:SetPoint to NorthPosPID:Update(Time:Seconds, Ship:GeoPosition:LAT). Local NorthVelPIDOut is NorthVelPID:Update(Time:Seconds, CardVelCached:Z).

	Local SteeringDirNonNorm is ArcTan2(EastVelPID:Output, NorthVelPID:Output).
	If SteeringDirNonNorm >= 0 {
		Set SteeringDir to SteeringDirNonNorm.
	} Else {
		Set SteeringDir to 360 + SteeringDirNonNorm.
	}
	Set SteeringPitch to 90 - MAX(ABS(EastVelPID:Output), ABS(NorthVelPID:Output)).
}
