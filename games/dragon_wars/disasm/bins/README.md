
binaries dumped by breaking into $c000 loader after each call to $c18b

saved and reconstructed from yape

all without loading address

in order:

- `title1000.bin`
    title picture
    loaded at `$1000`
    executed at `$1000`
    transfers bitmap to `$6000`, color maps to `$5800` and `$5c00`
    sets up gfx mode

- `subs0500.bin`
    main game code
    loaded at `$0500`
    contains partial copy of the loader and its setup code
    remaining part of the loader is transfered from `$5600` to `$ff20`

- `music8000.bin`
    title music
    loaded at `$8000`

- `util1000.bin`
    backup / transfer utility
    loaded at `$1000`
    executed at `$1000`
    returns to main code by jumping back to `$1800` setup (the one that detects drive and copies startup code to `$c000`)
