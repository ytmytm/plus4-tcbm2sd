# TCBM2SD by Maciej 'YTM/Elysium' Witkowiak

CBM 1551 paddle replacement and/or mass storage using an SD card interfacing with the Commodore C16/116/Plus4 simulating a TCBM bus 1551 disk drive

It's enough to quickly and easily load file-based programs though it is not as feature rich as sd2iec.

<img src="media/01.pcb-top.png" width=640 alt="tcbm2sd PCB Top view">

## Features

### Paddle replacement

- PLA 251641-3 and 6523T (28 pin triport) integrated into a single CPLD
- low part count: CPLD, 3.3V voltage regulator and four capacitors
- improved PLA equations make the paddle occupy only 8 I/O addresses
  - FEF0-FEF7 for device 8
  - FEC0-FEC7 for device 9
- passthrough for all 50 signals of the expansion port

### 1551 drive simulation

- DLOAD and DSAVE support
- transfer at about 3100b/s (a little bit less than JiffyDOS 1541, twice as fast as 1551 (1600b/s))
- device number stored permanently in EEPROM
- disk commands:
  - change dir `CD<directory>`, `CD<leftarrow>` or `CD..`, `CD/`
  - remove file `S:<filename>`
  - change device number: `U0>+chr$(<devnum>)` with `<devnum>` = 8 or 9
- limited support for full paths (when filename starts with `/`)
  - you can DLOAD a file from root folder from anywhere in the filesystem, e.g. file browser: `DLOAD"/FB16`
- compatible with file browsers: FileBrowser 1.6 and Directory Browser 1.2

### tcbm2sd or sd2tcbm?

This is not a sd2iec port, just a simple 1551 simulator. There is no support for disk images.
This is more like Tapecart - a loader for file-based programs rather than sd2iec.

If a proper sd2iec port to TCBM bus ever appears it should be named sd2tcbm.

Another microcontroller must be used because ATmega328 from Arduino Micro Pro doesn't have enough flash space for sd2iec port.

Note that for development another daughterboard (or a ready to use uC module) can be used. All the signals of TCBM bus, 3.3V power and SPI connection to SD card are exposed in Micro Pro footprint.

## KiCad project

Project files for Kicad 6.0 are in [this folder](tcbm2sd).

## Schematic

A PDF plot of schematic is available here: [tcbm2sd/plots/tcbm2sd.pdf](tcbm2sd/plots/tcbm2sd.pdf) for preview.

## PCB

Gerber files for manufacturing are in [tcbm2sd/plots/](tcbm2sd/plots) folder.

## Parts

To be soldered:

- 1x XC9572-VQ64 CPLD
- 4x 0.1uF capacitor (0805 footprint)
- 50 pin edge connector (optional), straight or right angle

The first revision of PCB was meant primarily as a development platform, so it relies on cheap, ready to use modules:

- AMS1117 3.3V power supply module with 3 pins
- SD card 3.3V adapter
- Arduino Mini Pro with ATmega328P 3.3V or its clone, e.g. SparkFun DEV-11114

If all you want is a paddle replacement then only the power supply module is needed.

### Arduino Mini Pro A4/SDA pin

Clones of Arduino Mini Pro may have different placement of A4/A5/A6/A7 pins. We use only A4.

On some clones `A4` may be labeled as `SDA` (then `A5` is `SCL`). This is fine.

If A4/A5 pins were moved from the inside row to a different place then solder a short piece of wire between module's `A4` and PCB pad marked `DEV` (next one to `A5`). A4 is the only one used.

### Edge connector

This cartridge has a passthrough connector. All 50 pins are connected, even three normally unused ones.
You can solder a 50-pin edge connector.

If it's a right-angle one then the next cartridge is positioned normally with label on the top.

If it's a straight one, then the next cartridge label must point towards computer (so that you see it).

Thanks to the improved PLA equations only 8 actually used I/O addresses are used at a time.

## Firmware

### CPLD source code

### CPLD flashing

... hdl/Fake6523.jed

### Arduino flashing

... tcbm2sd_arduino/tcbm2sd/tcbm2sd.ino

// IDE: Arduino Mini w/ ATmega328 (3.3.V)
// in case of flashing problem change in Arduino/hardware/arduino/avr/boards.txt
// or home folder: Arduino15\packages\arduino\hardware\avr\1.8.6\boards.txt
// from: mini.menu.cpu.atmega328.upload.speed=115200
//   to: mini.menu.cpu.atmega328.upload.speed=57600

## Credits

Open264cart
Fake6523
LittleSixteen
Open264cart case
