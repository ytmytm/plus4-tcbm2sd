
Lykia and Lykia Prologue patched for TCBM protocol (YaPe and TCBM2SD)

by Maciej 'YTM/Elysium' Witkowiak

# Note

This games doesn't seem to work with 6502 CPU.

# Source

Lykia SD2IEC version from https://plus4world.powweb.com/software/Lykia (Final version)

# Notes

## Tools

KickAss

Exomizer

c1541 (from VICE)

## Makefile

`make` prepares everything and generates new disk images:

- `lykia_prologue-tcbm.d81`
- `lykia_disk1-tcbm.d81`
- `lykia_disk2-tcbm.d81`
- `lykia_disk3-tcbm.d81`
- `lykia_disk4-tcbm.d81`

There is nothing on disk 3, it's copied as-is.

Note that it's not usable with emulators because it's not meant for 1581.
`D81` is just data container, the loader uses TCBM protocol: like 1551/TCBM2SD.

Some of the files can be moved to a `D64` image for debug.

## `boot[0,1,2,4].bin`

Decrunched `!!entrance!!` file, starts from BASIC.

Disk 3 doesn't have a loader - it's just a pretty picture.

## IOLib defaults

Library init at `$6000`

Fastloader at `$0200`

Exomizer decruncher at `$0300-$04xx`.

## Patches

Patches for all disks are identical - same code and addresses.

There is not enough space to fit full TCBM code for `startload` and `readbyte` (for decruncher) within 256 bytes.
Since byte loader is now shorter, part of `$036D-$0385` space is used for `startload`.

`writebyte` protocol for filename is not supported, decruncher calls `$0210` with filename in X/Y (like `startload`).

TCBM2SD Arduino firmware maps $5E character (<-) into $7F (~) even on disk images, so we have to do that as well.
