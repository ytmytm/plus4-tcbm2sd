
Run `./asm.sh` to reassemble `drv1551.bin` and compare it with `$9000-$9800` range dumped from original GEOS boot disk.

`drv1551.info` file is the config file for `da65` disassembler.

Large parts of code were simply copied from 1541 disk driver.

GEOS+4 uses part of disk driver space for `Add2`, `ReadFile`, `WriteFile` functions, but it seems that they can be moved around.
The `Add2` function is executed via jumptable and `ReadFile`, `WriteFile` use vectors.
