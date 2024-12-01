# TCBM2SD 1.3 Hardware and Firmware

### <a name='byMaciejYTMElysiumWitkowiak'></a>by Maciej 'YTM/Elysium' Witkowiak

## Table of contents

<!-- vscode-markdown-toc -->
* [KiCad project](#KiCadproject)
* [Schematic](#Schematic)
* [PCB](#PCB)
* [Parts](#Parts)
* [CPLD firmware](#CPLDfirmware)
* [Arduino firmware](#Arduinofirmware)
* [C16, C116, Plus/4 software](#C16C116Plus4software)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='KiCadproject'></a>KiCad project

Project files for Kicad 6.0 are in [this folder](tcbm2sd).

## <a name='Schematic'></a>Schematic

A PDF plot of schematic is available here: [tcbm2sd/plots/tcbm2sd.pdf](tcbm2sd/plots/tcbm2sd.pdf) for preview.

## <a name='PCB'></a>PCB

The first revision of PCB was meant primarily as a MVP demonstration and a development platform for software, so it relies on cheap, ready to use modules

<img src="media/01.pcb-top.png" width=640 alt="tcbm2sd PCB Top view">

Gerber files for manufacturing are in [tcbm2sd/plots/](tcbm2sd/plots) folder.

Starting with revision rev1.2 the PCB contains both kind of footprints - holes for ready to use modules or a set of SMD parts to be soldered directly. Except for CPLD chip all the parts are quite large (0805 footprint) for easy soldering by hand.

### <a name='Jumpers'></a>Jumpers

| Jumper | default | Description |
|--------|-----------------|-----------|
| JP1 | closed | if closed, then pass computer reset to Arduino |
| JP2 | n/c | choose hardware device number by shorting (2-3) for #8 or (1-2) for #9 |
| JP3 | (1-2) | choose software device number from Arduino A4 (1-2) or RXD/D1 (2-3) |
| JP4 | (1-2) | choose device number in software (1-2) or hardware (2-3) |

JP1, JP3 and JP4 default values are shorted by a thin trace under soldermask. If you want to change any of these settings you have to cut between the pads until connection is gone.

JP3 is meant for Arduino Mini Pro clones that would have A4 line missing or in a completely different place. Note that you have to change the definitions on the top of the sketch code too.

### <a name='PREVNEXTbuttons'></a>PREV/NEXT buttons

These buttons allow to switch to next/previous disk image within a folder. They work for all supported files: D64/D71/D81.

The PREV button signal serves also as a way to detect if TCBM cable is connected upon reset (pin 16 of TCBM connector shorted to GND).

NEXT button signal detects if the buttons are connected at all - if it's shorted to GND (pressed) upon Arduino reset then the button functionality is disabled.

## <a name='Parts'></a>Parts

Parts to be soldered directly:

- 1x XC9572XL-VQ64 CPLD
- 4x 0.1uF capacitor (0805 footprint)
- Arduino Mini Pro with ATmega328P 3.3V or its clone, e.g. SparkFun DEV-11114; unnamed clones usually have 'The Simple' text on bottom soldermask; there are two versions that differ by location of A6/A7 pins, both are supported

For the remaining parts of the circuit you can go with ready for use modules or solder SMD parts directly.

### <a name='Modules'></a>Modules

- AMS1117 3.3V power supply module with 3 pins, [such as this](media/AMS1117.jpg) often labeled as HW764; it usually comes with soldered angled pins, you need to replace them with straight ones
- SD card 3.3V adapter (3.3V VCC, with no level shifters) [like this one](media/SD.jpg)

### <a name='SMDparts'></a>SMD parts

The SMD BOM file with part names and can be find in the [releases](releases).

### <a name='ArduinoMiniProA4SDApin'></a>Arduino Mini Pro A4/SDA pin

Clones of Arduino Mini Pro may have different placement of A4/A5/A6/A7 pins.

On some clones `A4` may be labeled as `SDA` (then `A5` is `SCL`). This is fine.

If A4/A5 pins were moved from the inside row to a different place then solder a short piece of wire between module's `A4` and PCB pad marked `DEV` (next one to `A5`). `A4` is the only one required.

If `A4` is not available at all then you can modify the sketch to use `D1` (`RXD`) instead for DEV line and change JP3 jumper.

If you don't need software device number setting, you can permanently set the device number using JP2 and JP4.

## <a name='CPLDfirmware'></a>CPLD firmware

### <a name='CPLDsourcecode'></a>CPLD source code

Verilog source code can be found in [hdl](hdl/) folder. Apart from `.v` files there are also project files for [Xilinx ISE 14.7](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html).
If you want to modify them and rebuild `.jed` file, I highly recommend using Linux version, even with Windows WSL it's much easier to install and with fewer install/startup issues than the Windows version.

The code implements 4 parts:

1. PLA 251641-3 logic equations, updated to activate 6523T port only within 8 bytes indicated by the device input line
2. 8-bit, bidirectional port A of 6523T
3. 2-bit, bidirectional port B of 6523T (bits 0 and 1 - status from the drive)
4. 2-bit, bidirectional port C of 6523T (bit 7 (input from the drive) and bit 6 (output to the drive))

The 6523T code was based on a trimmed-down copy of [Fake6523](https://github.com/go4retro/Fake6523) and a [CIA implementation](https://github.com/niklasekstrom/cia-verilog/blob/master/cia.v).

The remaining, unused, bits of Ports B and C will probably behave in a different way than with a real 6323T. So far I didn't find it as an issue though.

### <a name='CPLDflashing'></a>CPLD flashing

JEDEC file with CPLD fimware is here: [hdl/Fake6523.jed](hdl/Fake6523.jed).

You don't need any special equipment to flash it. A Raspberry Pi and some jumper wires will be enough. If you can hold them more or less steady there is no need to solder any pin headers for JTAG connector.

| Signal | GPIO Header Pin | GPIO Name |
|--------|-----------------|-----------|
| GND | 6 or 9 or 14... | GND |
| TDO	| 13 | GPIO 27 |
| TDI	| 15 | GPIO 22 |
| TCK	| 11 | GPIO 17 |
| TMS	| 7  | GPIO 4 |
| 3.3V | 1 | 3.3V |

Command to test the connection and list JTAG devices (our XC9572 will be most likely device 0):
```
xc3sprog -c matrix_creator
```

<img src="media/90.detect-jtag.jpg" width=640 alt="CPLD detected">

Command to flash the firmware to device on position 0 (`-p 0`)
```
xc3sprog -c matrix_creator -v -p 0 Fake6523.jed
```

There is [an excellent reference about programming XC9500XL](https://anastas.io/hardware/2020/09/29/xc9500-cpld-raspberry-pi-xc3sprog.html) via JTAG with Raspberry Pi. Please read it for more details.

## <a name='Arduinofirmware'></a>Arduino firmware

### <a name='Arduinosourcecode'></a>Arduino source code

The source code of Arduino Mini Pro sketch is in [tcbm2sd_arduino/tcbm2sd/](tcbm2sd_arduino/tcbm2sd/) folder.

In Arduino IDE settings choose board named `Arduino Mini w/ Atmega328 (3.3V)`.

The only dependency (other than Arduino IDE) is [SDFat 2.2.3](https://github.com/greiman/SdFat) library (this code was developed when 2.2.3 was the latest available version). It's available directly from Arduino IDE library manager.

The disk image handling code is a trimmed down 'diskimage' library from CGTerm, by Per Olofsson.

### <a name='Arduinoflashing'></a>Arduino flashing

A basic USB-serial dongle (CH340G or similar) with 6 pins is enough to flash the firmware. Mind the pin labels (order may be reversed), but the connection is usually one to one (without any crossings) with one of the pins left unconnected.
This is the only time, when the 6 pins on the short side of Arduino Mini Pro board will be used.

| USB dongle pin | Arduino Mini pin |
|----------------|-------------|
| DTR            | DTR (next to RAW label) |
| RXD            | TX0         |
| TXD            | RX0         |
| VCC            | VCC         |
| CTS            | GND (not connected) |
| GND            | GND         |

**UPLOAD PROBLEMS**

Many Ardunio Mini Pro clones are sold with old bootloader flashed. That was the case for me. (They are also unable to use 115200 serial speed, but that's another story).
If you have trouble uploading the compiled code check if changing the upload speed from 115200 (new bootloader) to 57600 (old bootloader) helps.

Close the IDE and find you Arduino `boards.txt` settings file. On Windows it will be in `C:/Users/<user name>/AppData/Local/Arduino15/packages/arduino/hardware/avr/1.8.6/boards.txt`

Find there a line:
```
mini.menu.cpu.atmega328.upload.speed=115200
```
and change it to
```
mini.menu.cpu.atmega328.upload.speed=57600
```

Reopen the Arduino IDE and try again.

**WARNING**

1. Be sure to setup you USB dongle to 3.3V operation. They usually have a switch for that.
2. For development I have been reflashing Arduino code while cartridge was still connected to the computer. For this case make sure **to disconnect the VCC** line.

## <a name='C16C116Plus4software'></a>C16, C116, Plus/4 software

### <a name='Autostartbootfeature'></a>Autostart/boot feature

If the filename is a single '*' (like after pressing `SHIFT+RUN/STOP`) then a small loader will be sent to the computer. This loader will try to load and run file `BOOT.T2SD` from the SD card's root folder.

The source code for the loader is in [loader/loader.asm](loader) folder. You need [KickAssembler](https://www.theweb.dk/KickAssembler/) to rebuild it.

This code also serves as an example how to handle fastloader protocol.

The provided `Makefile` doesn't do much but it shows the order of commands:

Assemble the code:
```
java -jar Kickass.jar loader.asm
```
This saves `loader.prg`. To embed that binary into Arduino Micro flash we need to convert it to a C-style array and put into Arduino sketch folder:
```
xxd -i loader.prg ../tcbm2sd_arduino/tcbm2sd/loader.h
```

Then the Arduino code has to be recompiled and uploaded to the device.

### <a name='Directorybrowser1.2b'></a>Directory browser 1.2b

*(This serves only as an example of directly patching a binary file. The `BOOT.T2SD` that I publish is assembled from original source code.)*

The source code for the patch is in [loader/db12patch.asm](loader/db12patch.asm) file. You need [KickAssembler](https://www.theweb.dk/KickAssembler/) to rebuild it.

Assemble the patch and apply it over the binary
```
java -jar Kickass.jar db12patch.asm
```
This saves `db12b.prg` patched directory browser that can be put on an SD card to be `DLOAD`ed and executed.

### <a name='Games'></a>Games

Check the [games/](games/) subfolders. Each one has original disk images and the `Makefile` which applies patch over binaries to create a new disk image with game that can be loaded using standard TCBM protocol (`-tcbm`) or fastloader (`-tcbmfast`).

<!--- XXX Cartridges --->
