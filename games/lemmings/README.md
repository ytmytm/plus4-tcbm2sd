
Lemmings patched for TCBM protocol (YaPe and TCBM2SD) and TCBM2SD fastloader

by Maciej 'YTM/Elysium' Witkowiak

# Source

Lemmings from https://plus4world.powweb.com/software/Lemmings

# Notes

## Tools

KickAss

Exomizer

c1541 (from VICE)

## Makefile

`make` prepares everything and generates new disk images `lemmings-tcbm.d81` and `lemmings-tcbmfast.d81`.

## `boot.bin`

Decrunched `lemmings` file, starts from BASIC.

## IOLib defaults

Fastloader at `$0700`, with no decruncher.

## Patches

`tcbm2sdloader.asm` is a TCBM protocol loader, works with YaPe (1551 IEC emulation) and TCBM2SD.

`tcbm2sdloaderfast.asm` uses TCBM fastload protocol, works with TCBM2SD only.

Neither of them supports `writebyte` nor `readbyte`, so they are not suitable for decrunchers.

Look into the patch for Alpharay for an example how to patch for TCBM protocol (fastloader is not possible without exceeding 256 bytes).
