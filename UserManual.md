# TCBM2SD 1.3 User's Manual

### <a name='byMaciejYTMElysiumWitkowiak'></a>by Maciej 'YTM/Elysium' Witkowiak

## <a name='Tableofcontents'></a>Table of contents

<!-- vscode-markdown-toc -->
* [Introduction](#Introduction)
* [Installation](#Installation)
* [Cartridge ROM](#CartridgeROM)
* [Paddle mode](#Paddlemode)
* [Hardware configuration(TODO)](#HardwareconfigurationTODO)
* [SD card organization](#SDcardorganization)
* [Autostart/boot feature](#Autostartbootfeature)
* [Listing directory](#Listingdirectory)
* [Loading and saving files](#Loadingandsavingfiles)
* [Wildcards](#Wildcards)
* [Supported file types](#Supportedfiletypes)
* [Disk images](#Diskimages)
* [Next/Previous buttons for disk swapping](#NextPreviousbuttonsfordiskswapping)
* [BASIC 3.5 disk commands](#BASIC3.5diskcommands)
* [Sending DOS commands and reading back status](#SendingDOScommandsandreadingbackstatus)
* [Supported commands](#Supportedcommands)
* [Changing device number (hardware or software)](#Changingdevicenumberhardwareorsoftware)
* [Utility commands for fastloader](#Utilitycommandsforfastloader)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Operation'></a>Operation

### <a name='Introduction'></a>Introduction

TCBM2SD simulates behavior of a 1551 disk drive. It's not capable of emulating the drive's CPU, but it does response to a subset of commands just like 1551 would.

### <a name='Installation'></a>Installation

With the power off insert the tcbm2sd cartridge into the expansion port of C16/C116/Plus4.

### <a name='CartridgeROM'></a>Cartridge ROM

There is a socket for a 32K (27E257) or 64K (27E512) EPROM/EEPROM for cartridge functionality.

The 32K ROM will appear for the system as both cartridge 1 and cartridge 2. Its startup message will appear twice, but usually this is not a problem.

The bottom half of 64K ROM will appear as cartridge 2, the top half as cartridge 1.

### <a name='Paddlemode'></a>Paddle mode

If during power on a cable to a real 1551 is connected (if pin 16 on the TCBM2SD TCBM connector is shorted to GND) then Arduino will disable itself and TCBM2SD will become a paddle cartridge replacement: emulating behavior of the original PLA and 6523T chips.

The same will happen if during power-on the `PREV` button is held down.

This has no effect on the TCBM2SD cartridge ROM functionality - you will still have access to both C1 and C2 ROMs.

### <a name='HardwareconfigurationTODO'></a>Hardware configuration(TODO)

There is a number of jumpers that you can cut or short to enable/disable features.

### <a name='SDcardorganization'></a>SD card organization

Keep in mind that Arduino has only about 70 characters for the whole path, so try to keep the names short.

TCBM2SD automatically converts ASCII to PETSCII.

If the filename is longer than 16 characters the short (8.3) name will be used instead.

When not within a disk image absolute and relative paths are supported. For example:
```
DLOAD"/GAMES/A/AC/ACE.PRG
SCRATCH "FILES/FILE.PRG
```

### <a name='Autostartbootfeature'></a>Autostart/boot feature

The `BOOT.T2SD` file from the SD card's root folder will be loaded whenever the computer tries to load file named `*` (like after pressing `SHIFT+RUN/STOP`).

It can by any file of your choice, but I recommend [loader/boot.t2sd](Directory Browser 1.2 (TCBM2SD)) patched for fast loading of the files and directory listings.

Thanks to Géza Eperjessy, the author of 'Directory browser', I got access to its source code and I could change the code directly to support fast protocol when TCBM2SD is detected in response to `UI` command.

*Hint: this feature can be used for autostarting software released on SD cards*

### <a name='Listingdirectory'></a>Listing directory

Standard commands work as expected:
```
LOAD"$",8
DLOAD"$
DIRECTORY
```
and
```
@$
```
with JiffyDOS.

### <a name='Loadingandsavingfiles'></a>Loading and saving files

Standard `LOAD`, `DLOAD`, `SAVE` and `DSAVE` commands work:

```
DLOAD"FILE.PRG
DSAVE"MYFILE
SAVE"PROGRAM",8
```

### <a name='Wildcards'></a>Wildcards

Wildcards are supported for loading data:
```
DLOAD"F*
DLOAD"FI??S
```

and with disk commands:
```
SCRATCH "F*
OPEN15,8,15,"CD:DI*":CLOSE15
```

### <a name='Supportedfiletypes'></a>Supported file types

Extensions are needed only for disk images. For TCBM2SD each file is either a `PRG` file (data) or a `DIR` (folder or disk image). Therefore you can drop `.PRG` extensions from files on the SD card and use those four characters.

### <a name='Diskimages'></a>Disk images

TCBM2SD supports disk images: D64/D71/D81/D80/D82.

The disk images are treated like directories. You enter them using `CD` command and exit with `CD..` or `CD`&larr; to go to the parent folder. You don't have to specify full name, wildcards work too.

Disk images are read-only. You can't `SAVE` or `DSAVE` files when within a disk image.

The exception to this is block-write using utility command (see below), that is used by GEOS driver.

### <a name='NextPreviousbuttonsfordiskswapping'></a>Next/Previous buttons for disk swapping

Starting with revision 1.2 TCBM2SD is equipped with two buttons to switch between disk images within current folder. This is a bit similar to SD2IEC disk swap lists.

TCBM2SD doesn't require from you to create any list.

After pressing `NEXT` button the firmware will scan next 20 files within current folder starting from the current image and check if any of them is a supported disk image. If yes - that image will become active. If no, there will be no disk change.

After pressing `PREV` button the firmware will scan 20 files back from the current disk image file and check if any of them is a supported disk image. If yes - that image will become active. If no, there will be no disk change.

It means that you can switch to next/previous disk images within the current folder, but you will never accidently leave the disk image mode.

This is especially useful with multi-disk games (Lykia or Bard's Tale III) that require disk swapping during the game.

If you are not within a disk image and press `NEXT`, then firmware will try to enter the first available disk image in the current folder.

### <a name='BASIC3.5diskcommands'></a>BASIC 3.5 disk commands

BASIC commands that alias CBM DOS commands are supported:

#### <a name='DIRECTORY'></a>DIRECTORY

List the current directory: `DIRECTORY`

Wildcards are not supported here, the listing will always contain all files.

When outside the disk image the disk header name will show the current folder's name.

The number of free blocks out of disk image is always reported as `9999` no matter how much space is available on your SD card.

Within disk images the real number of free blocks is reported, even though the disk images are read only.

#### <a name='SCRATCH'></a>SCRATCH

Remove a file from the disk: `SCRATCH <filename>`

#### <a name='RENAME'></a>RENAME

Rename a file: `RENAME <oldname> TO <newname>`

### <a name='SendingDOScommandsandreadingbackstatus'></a>Sending DOS commands and reading back status

TCBM2SD like any CBM DOS compatible device (1541, 1551, SD2IEC, ...) uses channel 15 for disk commands.

In BASIC you can send a command using this sequence:
```
OPEN 15,8,15,"<disk command>":CLOSE15
```
or
```
OPEN 15,8,15:PRINT#15,"<disk command>":CLOSE15
```
The status can be checked using `DS` and `DS$` variables:
```
PRINT DS$
00, OK,00,00
```
With JiffyDOS it's simpler using DOS wedge:
```
@<disk command>
@
00, OK,00,00
```

### <a name='Supportedcommands'></a>Supported commands

| Command | Example | Description |
|---|---|---|
| `CD<relative path>` | `CD:GAMES` | Change current directory to folder `GAMES` within current path |
| `CD<absolute path>` | `CD:/GAMES` | Change current directory to folder `GAMES` within card's root folder |
| `CD<disk image>` | `CD:DISK.D64` | Enter disk image. `DLOAD"*` will now load the first file from image's directory |
| `CD/` | `CD/` | Got to cards' root folder. `DLOAD"*` will now load `/BOOT.T2SD` |
| `CD..` | `CD..` | Exit disk image or enter parent folder. `DLOAD"*` will now load `/BOOT.T2SD` |
| `CD`&larr; | `CD`&larr; | Exit disk image or enter parent folder. `DLOAD"*` will now load `/BOOT.T2SD` |
| `S:<filename>` | `S:MYFILE.PRG` | Remove the file. If using wildcards only the first matching file will be removed |
| `R:<new>=<old>` | `R:NEWFILE=OLDFILE` | Rename a file |
| `MD:<dir name>` | `MD:GAMES` | Create an empty directory in current folder |
| `RD:<dir name>` | `RD:GAMES` | Remove a directory. It must be empty |
| `I` | `I`| Initialize SD card interface after card eject/insert if the card's slot doesn't have a sensor |
| `UI` | `UI` | Trigger startup status `73, TCBM2SD BY YTM 2024,00,02` |
| `UJ` | `UJ` | Trigger startup status `73, TCBM2SD BY YTM 2024,00,02` |

Notes about retuned status messages:

1. Any unrecognized command will result in status `99, UNKNOWN,00,00`
2. The last two numbers in the startup message are major/minor version. I don't expect to ever change major version. Minor version was changed when significant new features were added: from `00` to `01` with disk image support and to `02` with fastload utility commands
3. `S`cratch can only remove one file at a time, even with wildcards

### <a name='Changingdevicenumberhardwareorsoftware'></a>Changing device number (hardware or software)

The device number can be changed permanently by cutting/shorting jumpers or using a software method.

With the software method the new device number will be saved in Arduino's EEPROM memory and will survive power off. It will be active until changed again.

From BASIC issue the DOS command:
```
OPEN 15,8,15,"U0>"+CHR$(<device number>):CLOSE 15
```
The `<device number>` must be 8 or 9.

If you own a C128D/C128DCR/1571/1581 you will recognize that it's exactly the same command as for 1571/1581.

### <a name='Utilitycommandsforfastloader'></a>Utility commands for fastloader

These commands are not useful in an interactive mode. Their purpose is to enable additional features for software patched to support TCBM2SD fast load/save protocol.

These commands try to follow the syntax of Burst Utility Commands known from 1571/1581 DOS.

Fast load/save protocol is defined by its software implementation within game patches, GEOS TCBM2SD driver and embedded loader.

TCBM2SD is compatible with standard TCBM protocol as implemented by Commodore in Plus/4 ROM. However the hardware is capable with much more.

| device | bytes/second | times 1541 |
|---|---|---|
| 1541 (CBM) | 430 | 1x |
| 1551 (CBM) | 1600 | 4x |
| TCBM2SD (CBM) | 3100 | 7x |
| 1541 (JiffyDOS) | 4445 | 10x |
| TCBM2SD (fast) | 9300 | 21x |

I took [Directory Browser v1.2](https://plus4world.powweb.com/software/Directory_Browser) and patched it to use a faster protocol, a bit similar to [Warpload 1551](https://plus4world.powweb.com/software/Warpload_1551).

Since Arduino Micro Pro is much faster than a Plus/4 (8MHz vs 1MHz) it would be hard to rely on the timing, so in my version of the fast protocol both sides need to test if the other end has confirmed receiving the data.

The fastload protocol should be used only if there is TCBM2SD device on the other end. This can be detected by checking if disk status after `UI` command contains `TCBM2SD` string.

#### <a name='Fastloadchannel16'></a>Fastload (channel 16)

Fast protocol is enabled when everything is prepared like for load (`OPEN` channel 0 and send the filename) but after the `TALK` call as a secondary address we send `0x70` instead of `0x60` to talk on channel 16 rather than 0.

Check out also the other files from [loader/](loader/) folder. I can't publish full source code (it's not mine), but you will find pieces of code I altered in 't2s-...' files. That also includes the TCBM2SD detection part.

#### <a name='FastloadU0filename'></a>Fastload (U0, filename)

Command: `U0+chr$(31)+<filename>`

Send contents of `<filename>` using fast transfer protocol. The transfer will not stop until whole file is sent.

```
command:
	.byte "U0", $1f
	.byte "FILENAME"
```
The example code for this is in the firmware that loads `/BOOT.T2SD`: [loader/loader.asm](loader/loader.asm)

#### <a name='FastloadU0tracksector'></a>Fastload (U0, track & sector)

Command: `U0+chr$(63)+chr$(track)+chr$(sector)`

Same as above, but loads the data starting with initial track and sector numbers instead of searching for a file name. The transfer will not stop until whole file is sent. This works only within disk images.

```
command:
	.byte "U0", $3f
track:	.byte 17
sector:	.byte 1
```

The example code for this is here: [loader/loaderts.asm](loader/loaderts.asm)

#### <a name='Fastblockread'></a>Fast block read

Command: `U0+chr$(0)+chr$(track)+chr$(sectors)+chr$(number-of-blocks-to-read)`

Description: Fast load consecutive sectors starting with initial track and sector. The transfer will not stop until number of blocks is exhausted. That parameter must be equal to 1 or more. This works only within disk images. You will get as many sectors as needed, they will be read from following tracks if necessary (just like the data is arranged within disk image file).

The example code for both block read and save can be found in [loader/block-rw.asm](loader/block-rw.asm).
This is a simple utility that can load a single sector (directory header) to screen ram (`$0C00`) and the buffer (`$2000`) or write data from the buffer into the directory header.

There is also GEOS TCBM2SD driver that reads and writes single sectors.

#### <a name='Fastblocksave'></a>Fast block save

Command: `U0+chr$(2)+chr$(track)+chr$(sectors)+chr$(number-of-blocks-to-read)`

Description: Fast save consecutive sectors starting with initial track and sector. The transfer will not stop until number of blocks is exhausted. That parameter must be equal to 1 or more. This works only within disk images. You will get as many sectors as needed, they will be read from following tracks if necessary (just like the data is arranged within disk image file).

The example code for both block read and save can be found in [loader/block-rw.asm](loader/block-rw.asm).
