
# TCBM2SD v1.4

## Changes

- Routed the 3.3 V `/RESET_3_3V` signal to the TCBM connector instead of the computer's 5 V `/RESET` signal.
- Added mirrored TCBM I/O address ranges for compatibility with the [Pi1551](https://github.com/ytmytm/Pi1551): `FEC0-FEC7` across `FEC0-FEDF` and `FEF0-FEF7` across `FEE0-FEFF`.
- Corrected the C1/C2 ROM-bank silkscreen labels.

## JLCPCB assembly notes

### SMD Manufacturing with JLCPCB

I was not able to correct the positioning issues in time. Make sure to use the JLCPCB online positioning tool to adjust:

- U1 has to be rotated 90 deg left (to match dot on chip with dot on PCB)
- C5 has to be rotated 180 degrees (to match the `+` on the capacitor with the `+` on the PCB)
- C6 has to be rotated 180 degrees (to match the `+` on the capacitor with the `+` on the PCB)
- SD card connector (XS) has to be shifted left several steps, it's easiest to control looking on the bottom of PCB to check if two pegs appear exactly in the center of the PCB holes near the edge of the board
