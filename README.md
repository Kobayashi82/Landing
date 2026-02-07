
<div align="center">

![WIP](https://img.shields.io/badge/work%20in%20progress-yellow?style=for-the-badge)
![KerboScript](https://img.shields.io/badge/Kerbo%20Script-brown?style=for-the-badge)
![kOS](https://img.shields.io/badge/kOS-Autopilot-blue?style=for-the-badge)
![KSP](https://img.shields.io/badge/Kerbal-Space%20Program-orange?style=for-the-badge)

*Automated landing script with suicide burn maneuver*

</div>

<div align="center">
  <img src="/Landing.png">
</div>

# Suicide Burn

[README en Español](README_es.md)

`Landing` is an advanced landing autopilot script for `Kerbal Space Program` (KSP) written in `kOS` (Kerbal Operating System). It automates precision landing maneuvers, calculating the optimal burn altitude and executing controlled descents to designated landing pads or any surface location.    

`NOTES`: This README is only a template and does not represent the current state of the project. It is also not finished.

## ✨ Features

- `Automated Suicide Burn`: Calculates and executes the optimal burn altitude to minimize fuel consumption while ensuring a safe landing
- `Precision Landing`: Supports targeting specific landing pads or any surface location
- `Multiple Landing Pad Support`: Pre-configured landing pads with automatic pad selection
- `Real-time Trajectory Prediction`: Uses the Trajectories mod for accurate impact prediction
- `Intelligent Navigation`: 
  - Automatic trajectory correction during descent
  - PID-based steering control for precise landing
  - Adaptive throttle control based on altitude and vertical speed
- `Emergency Burn Detection`: Automatically triggers emergency burns if descent is too fast
- `Customizable Parameters`:
  - Extra altitude margin
  - Burn efficiency settings
  - Auto-slope adjustment
  - RCS, brakes, and landing gear control
- `Interactive Menu System`: Easy-to-use interface for configuring landing parameters
- `Real-time Display`: Shows critical information including:
  - Current altitude and impact time
  - Biome information
  - Impact altitude and distance
  - Burn status and throttle percentage

## 🖥️ Requirements

### Essential
- `Kerbal Space Program` with `kOS mod` installed
- `Trajectories mod` (for accurate impact prediction)
- `Biome mod` (for biome information display. Optional)

## 🔧 Installation

1. Install `kOS` mod for Kerbal Space Program
2. Install `Trajectories` mod
3. Clone or download this repository
4. Copy all `.ks` files to your KSP `Ships/Script` folder or load them onto your craft's kOS processor

## 🎮 Usage

```kerboscript
run landing.
```

### Parameters
1. `P_Pad` (string): Landing pad name or "Anywhere" (default: "Anywhere")
2. `P_ShowInfo` (boolean): Display information during descent (default: True)
3. `P_ExtraAlt` (number): Extra altitude margin in meters (default: 20)
4. `P_Efficiency` (number): Burn efficiency parameter (default: 300)
5. `P_AutoSlope` (string): Enable auto-slope adjustment - "Yes"/"No" (default: "Yes")
6. `P_RCS_ON` (string): Enable RCS - "Yes"/"No" (default: "Yes")
7. `P_BRAKES_ON` (string): Enable brakes - "Yes"/"No" (default: "Yes")
8. `P_GEAR_ON` (string): Enable automatic gear deployment - "Yes"/"No" (default: "Yes")
9. `P_MaxSlope` (number): Maximum acceptable slope (default: 5)
10. `P_MaxDistancePads` (number): Maximum distance to landing pads in meters (default: 80000)

### Interactive Menu Controls

When the menu is displayed:
- `Left/Right Arrow Keys`: Cycle through available landing pads
- `A`: Increase extra altitude margin
- `Shift+A`: Decrease extra altitude margin
- `E`: Increase burn efficiency
- `Shift+E`: Decrease burn efficiency
- `S`: Toggle auto-slope adjustment
- `R`: Toggle RCS
- `G`: Toggle landing gear auto-deployment
- `B`: Toggle brakes
- `D`: Set destination (when applicable)
- `Enter`: Start the landing sequence

## ⚙️ Configuration

### Custom Pad List

Pads are stored in `Pads.ks` as triplets: name, coordinates, body name.

```kerboscript
cPads:Add("My Custom Pad").
cPads:Add("12.345678, -98.765432").
cPads:Add("Kerbin").
```

### Tuning Parameters

- `Extra Altitude`: Increase for more safety margin, decrease for fuel efficiency
- `Efficiency`: Higher values trigger burns earlier (safer but less fuel efficient)
- `Auto-Slope`: Enables automatic terrain slope detection and adjustment

## 🧪 How It Works

### State Machine

SBurn uses a state machine to manage the landing sequence:

1. `MENU`: Display configuration menu and wait for user input
2. `PREPARE_BURN`: Configure ship systems and prepare for descent
3. `THROTTLE`: Navigate and correct trajectory toward target
4. `AERO`: Execute suicide burn during aerodynamic phase
5. `GROUND`: Final approach and touchdown control
6. `FINALIZE`: Clean up and restore ship control

### Burn Calculation

The script calculates the ideal burn altitude using:
- Current vertical velocity
- Available thrust-to-weight ratio
- Gravity of the celestial body
- Configured efficiency and extra altitude parameters
- Ground speed for trajectory correction

### Navigation System

For precision landing:
- Uses PID controllers for position and velocity control
- Calculates optimal pitch and heading to target
- Adjusts steering during burn to maintain accuracy
- Switches to vertical descent when close to target

## Project Structure

- `SBurn.ks`: Main entry point and parameter handling
- `StateMachine.ks`: State machine implementation
- `Menu.ks`: Interactive menu system
- `Display.ks`: Real-time information display
- `Navigation.ks`: Navigation and PID control logic
- `Utils.ks`: Utility functions and calculations
- `LaunchPads.ks`: Landing pad database and management
- `Pads.ks`: Landing pad coordinate definitions
- `Mira.ks`: Additional utility functions

## 📚 Troubleshooting

### Trajectories Not Found
- Ensure the `Trajectories` mod is installed and active
- The script will wait until `Trajectories` is available

### No Available Thrust
- Check that your engines are active and have fuel
- Verify staging is correctly configured

### Landing Off-Target
- Increase the Efficiency parameter for earlier burns
- Reduce Extra Altitude if overshooting
- Check that RCS is enabled for fine control

## 📄 License

This project is licensed under the WTFPL – [Do What the Fuck You Want to Public License](http://www.wtfpl.net/about/).

---

<div align="center">

**🚀 Desarrollado por Kobayashi82 🚀**

*"No Kerbals were harmed in the making of this script"*

</div>
