
# Dragon Wars

Origin: https://plus4world.powweb.com/software/Dragon_Wars

## disasm

Loader / intro disassembly effort

## repack

Title picture, music, utilities ('U' on title screen), loader all packaged into a single file for LOAD & RUN.

Like *Bard's Tale III* this game also uses ProDOS loader (inherited from Apple 2) with
disks and linear block numbers translated into 1541's track and sectors.

Unlike *Bard's Tale III* there was no effort to implement interleave, so loader is painfully slow (also on C64).

## src

Game patched for TCBM2SD fastloader. Use TCBM2SD buttons NEXT/PREV to switch among disk images.

Utilities will start but will not work - maybe that will be patched in the future too (but it has very little use).

