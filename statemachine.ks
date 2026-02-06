
Global StateMachine is Lexicon().

Function CreateStateMachine {
    Local SM is Lexicon().
    
    // Estados del sistema
    SM:Add("current_state", "MENU").
    SM:Add("finished", False).
    
    // Variables de control
    SM:Add("start_program", False).
    SM:Add("show_program", True).

    Return (SM).
}

Function UpdateStateMachine {
    Local state is StateMachine["current_state"].
    
	If		(state = "MENU")			StateShowMenu().
    Else If (state = "PREPARE_BURN")	StatePrepareBurn().
    Else If (state = "THROTTLE")		StateNavigation().
    Else If (state = "AERO")			StateSuicideBurn().
    Else If (state = "GROUND")			StateLanding().
    Else If (state = "FINALIZE")		StateFinalize().
}

// ====
// MENU
// ====
Function StateShowMenu {
    LoadLaunchPads().
	ShowMenu().
	If (Pad <> "Anywhere") { Wait 0.1. Addons:TR:SetTarget(LaunchPad). Wait 0.1. }
	PrintInfo("Initialize").
    Set StateMachine["current_state"] to "PREPARE_BURN".
}

// ============
// PREPARE_BURN
// ============
Function StatePrepareBurn {
    Set Ship:Control:PilotMainThrottle to 0.

    // Until (VerticalSpeed < -10) PrintInfo(). 

    If (RCS_ON = "Yes")	RCS On.
    Else				RCS Off.

    If (GEAR_ON = "Yes") When (ImpactTime() < GEAR_ON_Time) Then Gear On. 

    SAS Off. 
    Lock Steering to SRFRetrograde.

    Set StateMachine["current_state"] to "THROTTLE".
}

// ==========
// NAVIGATION
// ==========
Function StateNavigation {
    Navigate_Throttle().

	Set StateMachine["current_state"] to "AERO".
}

// ============
// SUICIDE_BURN
// ============
Function StateSuicideBurn {
    Navigate_Aero().

	Set StateMachine["current_state"] to "GROUND".
}

// =======
// LANDING
// =======
Function StateLanding {
    Navigate_Ground().

	Set StateMachine["current_state"] to "FINALIZE".
}

// ========
// FINALIZE
// ========
Function StateFinalize {
    PrintInfo("Finalize").
    Unlock Throttle.
    Unlock Steering.
    SAS On.
    Wait 2.
    SAS Off.
    RCS Off.
    Brakes Off.

    Set StateMachine["finished"] to True.
}


Function ImpactTime {
    If		(Addons:TR:Available = True and Addons:TR:HasImpact = True)		Return (Addons:TR:TimeTillImpact).
    Else If (VerticalSpeed < 0)												Return (ABS(TrueRadar / VerticalSpeed)).
    Else																	Return (0).
}
