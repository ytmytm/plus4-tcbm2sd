
Bard's Tale III patched for TCBM protocol (YaPe and TCBM2SD) and TCBM2SD fastloader

by Maciej 'YTM/Elysium' Witkowiak

# Source

Csory's version version from https://plus4world.powweb.com/software/Bards_Tale_III 

# Notes

Only boot disk required changes.

This version is fixed to disk device #8.

## Tools

KickAss

Exomizer

c1541 (from VICE)

## Makefile

`make` prepares everything and generates new disk image `bardstale3-tcbm.d64` and zips it together with original disks 2-4 (Character, Dungeon A, Dungeon B).

## `boot0.s`

Decompiled autostart. It loads into vector area and loads rest of the data without closing the LOAD.

## `boot1.s`

Startup program. Contains loader code that goes from `$1C00-$1DFF` to `$C800-$CBFF`.

## `boot2.s`

Loader itself, cut from the middle of `boot1.bin`.

## `bardstale3-tcbmfast.asm` Patch

Patch is applied over `boot1.bin` and changes startup slightly: there is no more detection of 1541/1551 and part of autostart (`boot0.s`) are included
to have a file that can be loaded and `RUN` from BASIC.

Patch intercepts calls to Prodos loader and redirects it to patch at `$C800` to read/write single sectors.

Fast block read/write code taken from my earlier GEOS patch.
