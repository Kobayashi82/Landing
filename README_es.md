
<div align="center">

![WIP](https://img.shields.io/badge/work%20in%20progress-yellow?style=for-the-badge)
![KerboScript](https://img.shields.io/badge/Kerbo%20Script-brown?style=for-the-badge)
![kOS](https://img.shields.io/badge/kOS-Autopilot-blue?style=for-the-badge)
![KSP](https://img.shields.io/badge/Kerbal-Space%20Program-orange?style=for-the-badge)


*Script de aterrizaje automatizado con maniobra de suicide burn*

</div>

<div align="center">
  <img src="/Suicide-Burn.png">
</div>

# Suicide Burn

[README in English](README.md)

`Suicide Burn` es un script avanzado de piloto automático de suicide burn para `Kerbal Space Program` (KSP) escrito en `kOS` (Kerbal Operating System). Automatiza maniobras de aterrizaje de precisión, calculando la altitud óptima de encendido y ejecutando descensos controlados a plataformas de aterrizaje designadas o a cualquier punto de la superficie.

`NOTAS`: Este README es solo una plantilla y no representa el estado actual del proyecto. Además, no está terminado.

## ✨ Características

- `Suicide Burn automatizado`: Calcula y ejecuta la altitud óptima de encendido para minimizar combustible y asegurar un aterrizaje seguro
- `Aterrizaje de precisión`: Soporta apuntar a plataformas específicas o cualquier ubicación en superficie
- `Soporte para múltiples plataformas`: Plataformas preconfiguradas con selección automática
- `Predicción de trayectoria en tiempo real`: Usa el mod Trajectories para predicción precisa de impacto
- `Navegación inteligente`:
  - Corrección automática de trayectoria durante el descenso
  - Control de dirección basado en PID para aterrizajes precisos
  - Control de aceleración adaptativo según altitud y velocidad vertical
- `Detección de burn de emergencia`: Activa automáticamente burns de emergencia si el descenso es demasiado rápido
- `Parámetros personalizables`:
  - Margen de altitud extra
  - Ajustes de eficiencia de burn
  - Ajuste automático de pendiente
  - Control de RCS, frenos y tren de aterrizaje
- `Sistema de menús interactivo`: Interfaz fácil de usar para configurar parámetros de aterrizaje
- `Pantalla en tiempo real`: Muestra información crítica incluyendo:
  - Altitud actual y tiempo de impacto
  - Información de bioma
  - Altitud y distancia de impacto
  - Estado de burn y porcentaje de aceleración

## 🖥️ Requisitos

### Esenciales
- `Kerbal Space Program` con `mod kOS` instalado
- `Mod Trajectories` (para predicción precisa de impacto)

### Opcionales
- `Mod de Biomas` (para mostrar información de biomas)

## 🔧 Instalación

1. Instala el mod kOS para Kerbal Space Program
2. Instala el mod Trajectories
3. Clona o descarga este repositorio
4. Copia todos los archivos `.ks` a tu carpeta `Ships/Script` de KSP o cárgalos en el procesador kOS de tu nave

## 🎮 Uso

### Uso básico

1. Lanza tu nave y consigue una trayectoria de descenso
2. Ejecuta el script principal:
   ```kerboscript
   RUNPATH("SBurn").
   ```

### Con parámetros

Puedes personalizar el comportamiento pasando parámetros:

```kerboscript
RUNPATH("SBurn", "LaunchPad", True, 20, 300, "Yes", "Yes", "Yes", "Yes", 5, 80000).
```

#### Parámetros (en orden):
1. `P_Pad` (string): Nombre de la plataforma o "Anywhere" (por defecto: "Anywhere")
2. `P_ShowInfo` (boolean): Mostrar información durante el descenso (por defecto: True)
3. `P_ExtraAlt` (number): Margen de altitud extra en metros (por defecto: 20)
4. `P_Efficiency` (number): Parámetro de eficiencia de burn (por defecto: 300)
5. `P_AutoSlope` (string): Activar ajuste automático de pendiente - "Yes"/"No" (por defecto: "Yes")
6. `P_RCS_ON` (string): Activar RCS - "Yes"/"No" (por defecto: "Yes")
7. `P_BRAKES_ON` (string): Activar frenos - "Yes"/"No" (por defecto: "Yes")
8. `P_GEAR_ON` (string): Activar despliegue automático del tren - "Yes"/"No" (por defecto: "Yes")
9. `P_MaxSlope` (number): Pendiente máxima aceptable (por defecto: 5)
10. `P_MaxDistancePads` (number): Distancia máxima a plataformas en metros (por defecto: 80000)

### Controles del menú interactivo

Cuando el menú está visible:
- `Flechas Izquierda/Derecha`: Cambiar entre plataformas disponibles
- `A`: Aumentar margen de altitud extra
- `Shift+A`: Disminuir margen de altitud extra
- `E`: Aumentar eficiencia de burn
- `Shift+E`: Disminuir eficiencia de burn
- `S`: Alternar ajuste automático de pendiente
- `R`: Alternar RCS
- `G`: Alternar despliegue automático del tren
- `B`: Alternar frenos
- `D`: Establecer destino (cuando aplique)
- `Enter`: Iniciar la secuencia de aterrizaje

## 🧪 Cómo funciona

### Máquina de estados

SBurn utiliza una máquina de estados para gestionar la secuencia de aterrizaje:

1. `MENU`: Muestra el menú de configuración y espera entrada del usuario
2. `PREPARE_BURN`: Configura sistemas de la nave y prepara el descenso
3. `THROTTLE`: Navega y corrige trayectoria hacia el objetivo
4. `AERO`: Ejecuta el suicide burn durante la fase aerodinámica
5. `GROUND`: Aproximación final y control de aterrizaje
6. `FINALIZE`: Limpieza y restauración del control de la nave

### Cálculo del burn

El script calcula la altitud ideal de encendido usando:
- Velocidad vertical actual
- Relación empuje/peso disponible
- Gravedad del cuerpo celeste
- Parámetros configurados de eficiencia y altitud extra
- Velocidad en superficie para corrección de trayectoria

### Sistema de navegación

Para aterrizajes de precisión:
- Usa controladores PID para posición y velocidad
- Calcula pitch y heading óptimos hacia el objetivo
- Ajusta la dirección durante el burn para mantener precisión
- Cambia a descenso vertical cuando está cerca del objetivo

## Estructura del proyecto

- `SBurn.ks`: Punto de entrada principal y manejo de parámetros
- `StateMachine.ks`: Implementación de la máquina de estados
- `Menu.ks`: Sistema de menú interactivo
- `Display.ks`: Pantalla de información en tiempo real
- `Navigation.ks`: Lógica de navegación y control PID
- `Utils.ks`: Funciones utilitarias y cálculos
- `LaunchPads.ks`: Base de datos y gestión de plataformas
- `Pads.ks`: Definiciones de coordenadas de plataformas
- `Mira.ks`: Funciones utilitarias adicionales

## ⚙️ Configuración

### Añadir plataformas personalizadas

Edita `Pads.ks` para agregar tus propias plataformas. El formato es un triplete de: nombre, cadena de coordenadas y nombre del cuerpo:

```kerboscript
cPads:Add("My Custom Pad").
cPads:Add("12.345678, -98.765432").
cPads:Add("Kerbin").
```

Ejemplo de `Pads.ks`:
```kerboscript
cPads:Add("Moon Base 1").
cPads:Add("4.30071551879227, 74.7929188603752").
cPads:Add("Mun").
```

### Ajuste de parámetros

- `Altitud extra`: Aumenta para más margen de seguridad, reduce para eficiencia de combustible
- `Eficiencia`: Valores mayores disparan burns antes (más seguro pero menos eficiente)
- `Auto-Slope`: Habilita detección automática de pendiente del terreno y ajuste

## 📚 Solución de problemas

### Trajectories no encontrado
- Asegúrate de que el mod Trajectories esté instalado y activo
- El script esperará hasta que Trajectories esté disponible

### No hay empuje disponible
- Verifica que tus motores estén activos y con combustible
- Comprueba que el staging esté configurado correctamente

### Aterrizaje fuera de objetivo
- Aumenta el parámetro Efficiency para burns más tempranos
- Reduce Extra Altitude si te pasas del objetivo
- Comprueba que el RCS esté habilitado para control fino

## 📄 Licencia

Este proyecto está licenciado bajo la WTFPL – [Do What the Fuck You Want to Public License](http://www.wtfpl.net/about/).

---

<div align="center">

**🚀 Desarrollado por Kobayashi82 🚀**

*"No Kerbals were harmed in the making of this script"*

</div>
