# Verilog-Based Interactive Morse Code Training System on Cyclone V

## Overview
This project implements a complete Morse code training system on the Intel Cyclone V FPGA (DE0-CV). It combines secure user authentication, timed gameplay, random word selection, Morse decoding, match checking, scoring, and VGA text display. The design is fully modular and written in Verilog using FSMs, counters, LFSRs, debounced inputs, and ROM-based word storage.

---

## System Architecture

### Module Groups
- **Authentication System**
  - Identification module (ID check FSM)
  - Password module (password check FSM using ROM_PSWD)
  - Unified `PassBtn` input with internal gating via `CheckPassword`

- **Morse Decoder**
  - 4-entry button sequence per letter (0 = gap, 1 = dot, 3 = dash)
  - MorseDecoder outputs ASCII letter + `ready` pulse
  - Load4x2bit and ModeRotator for sequence handling

- **Game Control**
  - GameController FSM handles states: Idle → Word → Input → Match → Score → GameOver  
  - Integrates timers, RNG, and VGA updates
  - Score tracking and multi-letter word matching

- **Timers**
  - 1s, 100ms, and 1ms timers  
  - LFSR-based timing where required  
  - digitTimer for countdown (00–99)

- **Random Word Selection**
  - 17-bit LFSR (1ms) with selectable mode  
  - Generates pseudo-random index for word ROM

- **Word ROM**
  - Unified 30-word ROM (10 per difficulty: Easy/Medium/Hard)
  - 2-bit difficulty selector + 4-bit index
  - ASCII output to both game logic and VGA renderer

- **VGA Text Renderer**
  - Displays current word, decoded letters, and score
  - Shows final results at GameOver
  - Driven by updated `rand` and `Points`

---

## Features

- User authentication with ROM-based ID and password check  
- Timed 2-minute Morse code challenge  
- 4-bit Morse sequence per letter with real decoder  
- Letter-by-letter match checking with LED feedback  
- Randomized word selection using LFSR  
- VGA display for words, input status, and score  
- Training-style scoring (points per correct match)  
- Full top-level integration with debounced buttons, LEDs, RNG, display, and FSMs  

---

## File Structure

| Module | Description |
|--------|-------------|
| `Identification.sv` | ID authentication FSM |
| `Password.sv` | Password FSM + DoneChecking signal |
| `ROM_ID.sv` / `ROM_PSWD.sv` | ROM-based ID/password storage |
| `MorseDecoder.sv` | Converts 0/1/3 sequence → ASCII |
| `Load4x2bit.sv` | Handles 4-press input loading |
| `GameController.sv` | Main gameplay FSM |
| `digitTimer.sv` | Countdown timer (99→00) |
| `LFSRNG.sv` | Random word index generator |
| `VGA_TextRenderer.sv` | VGA display module |
| `TopModule.sv` | Full system integration |

(*Names based on your actual modules as saved in memory.*)

---

## Hardware Requirements
- DE0-CV development board (Cyclone V 5CEBA4F23C7N)
- 7-segment display (onboard)
- VGA monitor
- Buttons and switches on the FPGA board
- Quartus Prime + ModelSim

---

## Build Instructions

### Compile & Program
1. Open the project in **Quartus Prime**  
2. Assign pins based on DE0-CV board constraints  
3. Compile the full project  
4. Program the board using USB-Blaster  

### Simulation (Optional)
- Simulate subsystems using ModelSim testbenches:
  - Authentication TB  
  - Decoder TB  
  - GameControl TB  
  - Timer TB  

---

## Future Improvements
- Add sound output for Morse playback  
- Add multi-word challenges with streak scoring  
- Expand ROM to 100+ words  
- Add pause/resume functionality  
- Store high scores in internal RAM  

---

## Author
Mohammad Alkildar  
University of Houston — FPGA & Embedded Systems
