
Pets Rescue patched for TCBM protocol (YaPe and TCBM2SD)

by Maciej 'YTM/Elysium' Witkowiak

# Note

Method is identical to Alpharay

# Source

Pets Rescue IEC version from https://plus4world.powweb.com/software/Pets_Rescue

# Notes

## Tools

KickAss

Exomizer

c1541 (from VICE)

## Makefile

`make` prepares everything and generates new disk image `petsrescue-tcbm.d81`.
Note that it's not usable with emulators because it's not meant for 1581.
`D81` is just data container, the loader uses TCBM protocol: like 1551/TCBM2SD.

Some of the files can be moved to a `D64` image for debug.

## `boot.bin`

Decrunched `!!boot!!` file, starts from BASIC.

## IOLib defaults

Library init at `$6000`

Fastloader at `$0200`

Exomizer decruncher at `$0300-$04xx`.

## Patches

There is not enough space to fit full TCBM code for `startload` and `readbyte` (for decruncher) within 256 bytes.
Since byte loader is now shorter, part of `$036D-$0385` space is used for `startload`.

`writebyte` protocol for filename is not supported, decruncher calls `$0210` with filename in X/Y (like `startload`).
