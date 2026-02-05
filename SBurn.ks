
Parameter P_Pad is "Anywhere".
Parameter P_ShowInfo is True.
Parameter P_ExtraAlt to 20.
Parameter P_Efficiency to 300.
Parameter P_AutoSlope to "Yes".
Parameter P_RCS_ON to "Yes".
Parameter P_BRAKES_ON to "Yes".
Parameter P_GEAR_ON to "Yes".
Parameter P_MaxSlope to 5.
Parameter P_MaxDistancePads to 80000.

Global Pad to P_Pad.
Global ShowInfo to P_ShowInfo.
Global ExtraAlt to P_ExtraAlt.
Global Efficiency to P_Efficiency.
Global AutoSlope to P_AutoSlope.
Global RCS_ON to P_RCS_ON.
Global BRAKES_ON to P_BRAKES_ON.
Global GEAR_ON to P_GEAR_ON.
Global GEAR_ON_Time to 5.
Global MaxSlope to P_MaxSlope.
Global MaxDistancePads to P_MaxDistancePads.

Global TrueAltitude is 0.
Global TrueRadar is 0.
Global BurnAlt is 0.
Global SBurning is False.
Global PrepSBurn is False.
Global EmergencyBurn is False.
Global Mode is "Armed".
Global NoTR is false.

// PIDs de control
Global EastVelPID is 0.
Global EastPosPID is 0.
Global NorthVelPID is 0.
Global NorthPosPID is 0.
Global Throttle_PID is 0.

// Variables de navegación
Global SteeringDir is 0.
Global SteeringPitch is 0.
Global CardVelCached is V(0, 0, 0).

// Variables auxiliares de velocidad
Global GroundSpeed is 0.
Lock GroundSpeed to Ship:GroundSpeed.

RunOncePath("StateMachine").
RunOncePath("Utils").
RunOncePath("LaunchPads").
RunOncePath("Menu").
RunOncePath("Display").
RunOncePath("Navigation").

Set StateMachine to CreateStateMachine().

Until (StateMachine["finished"]) {
    UpdateStateMachine().
	Wait 0.1.
}
