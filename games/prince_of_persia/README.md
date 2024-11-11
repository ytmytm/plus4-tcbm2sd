
Prince of Persia patched for TCBM protocol (YaPe and TCBM2SD) and TCBM2SD fastloader

by Maciej 'YTM/Elysium' Witkowiak

# Source

Prince of Persia from https://plus4world.powweb.com/software/Prince_of_Persia

# Notes



## Tools

KickAss

Exomizer

c1541 (from VICE)

## Makefile

`make` prepares everything and generates new disk images `prince-tcbm.d81` and `prince-tcbmfast.d81`.

Note that it's not usable with emulators because it's not meant for 1581.
`D81` is just data container, the loader uses TCBM protocol: like 1551/TCBM2SD.

Some of the files can be moved to a `D64` image for debug.

## `boot.bin`

Decrunched `prince` file, stripped from intro, starts from BASIC.

## IOLib defaults

Fastloader at `$0700`, with no decruncher.

## Patches

`tcbm2sdloader.asm` is a TCBM protocol loader, works with YaPe (1551 IEC emulation) and TCBM2SD.

`tcbm2sdloaderfast.asm` uses TCBM fastload protocol, works with TCBM2SD only.

Neither of them supports `writebyte` nor `readbyte`, so they are not suitable for decrunchers.

Look into the patch for Alpharay for an example how to patch for TCBM protocol (fastloader is not possible without exceeding 256 bytes).
