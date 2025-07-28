
Dragon Wars patched for TCBM2SD fastloader

by Maciej 'YTM/Elysium' Witkowiak

# Source

Csory's version from https://plus4world.powweb.com/software/Dragon_Wars

# Notes

Only the boot disk required changes.

This version is fixed to disk device #8.

## Tools

KickAss

Exomizer

c1541 (from VICE)

## Makefile

`make` prepares everything and generates a new disk image `dragon_wars-tcbmfast.d64` and zips it together with the original disks 2-5.

## `boot2.s`

Decompiled intro. This source code is not used; the main source code patches it:

- nothing is loaded anymore; all loaded parts: TITLEPIC, MUSIC, SUBS1 (game) and UTILS are embedded into the main PRG
- therefore the loader at `$5600-5700` (boot3.s in disasm and repack folders) is not used anymore (which breaks UTILS)

## `dragon_wars-tcbmfast.asm`

This file combines the whole game code and intro. There is no detection of 1541/1551 anymore and the game is fixed to run from drive #8 - all due to fixed addresses of TCBM ports.

The whole ProDOS loader has been replaced by TCBM2SD code with fast block-read and block-write utility commands (`U0`).
This code fits almost perfectly into the gaps left by the original implementation.

Fast block read/write code was taken from my earlier GEOS patch with changes to optimize for size.

Unchanged data files loaded by the game loader are stored in `bins/` except for the title picture.

Sectors occupied by these files in ProDOS format on the disk (tracks 2-9) were freed.

# Boot process

The new program starts at `$5400` (segment `Startup`). It enables RAM access and copies low RAM data into place (SUBS1 was split into a section below `$0800` and the rest).
It also copies the fastloader into `$FF20-$FF3D` and `$FF40-$FFFF` from `$9F00`.

Then it calls a routine to set up the picture display and passes control to the original intro code.

The original intro has already been patched to not load anything and just start the game or utilities.

The utilities are broken at the moment - they expect the ProDOS loader to exist in the `$5600-$57FF` area (`boot3.s`), but this is not implemented.

The game calls a disk operation procedure at `$FF9F` with parameters in `DriveOp`, memory pointer in `BufferVec` and linear block number in `BlockNum`.
There are three operations: read/write/get status. With TCBM2SD they all succeed.

The linear block number is converted into D64 image track and sector and then the TCBM2SD utility command for block-read / block-write (initially implemented for GEOS) is called.

This code is highly optimized for size, but still very generic. It doesn't support drive #9 anymore though.

# Disk layout

## Template disk

`dragon_wars_1_freeblocks.d64`

Freed in BAM sectors for `TITLEPIC`, `MUSIC`, `SUBS1`, `UTILS` sectors (2,1)-(9,0) inclusive and deleted the former `dragon wars`
