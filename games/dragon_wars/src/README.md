
# Dragon Wars repackaged

This is a stepping stone towards TCBM2SD version.

This is Dragon Wars loader repackaged to have all pieces in one single
file that you can load and run.

Data files loaded by the game loader are stored in `bins/` except for
title picture, from which we take only bitmap and color data.

Sectors occupied by these files in ProDOS format on the disk were freed,
the template disk is provided. These were tracks 2-9.

Result is compressed using Exomizer and put into memory in appropriate places
for faster startup.

UTILS can't return to the game because the return option only loads `:*` file
and relies on autostart feature to run it.
This could be mitigated by actually having an autostart file that would load
'DRAGON WARS' and run it. (or somehow injecting SHIFT+RUN/STOP keystroke after reset)

This supports 1551 (TCBM) only.

# Boot process

## boot.raw

`dragon wars` file, loads into `$0265`

That binary is split into following pieces

### boot0.bin

Loads into `$0265`, until vector for the next byte is intercepted and routes control to $0265.
That code continues loading bytes from that file but starting at `$1800`

### boot1.bin

Loads into `$1800`:

- Detects drive type, patches itself if drive is TCBM
- calls `B-E` to run drivecode from (18,2) (`1802.bin` for 1541) or (18,8) (`1808.bin` for 1551)
- Copies `$18BF` and 4 more pages to `$C000-$C313` (boot2.bin)
- Copies `$1C17` and 1 more page to `$5600-$5700` (boot3.bin)

### boot2.bin

Loads into `$C000-$C313`, intro and game loader

Before starting the game calls procedure at `$4E39` which copies `GetByte/SendByte` from `$5600` up to `$FF20` - just enough for these two 
Remaining part of the loader within game is embedded in `SUBS1`.

If 'U' is pressed, then instead of starting the game:

- `UTILS` will be loaded and started
- tool returns by jumping back into `$1800` - `boot1.bin`

### boot3.bin

Loads into `$5600-$574E`.

- called from boot2.s : `DoSectorOp` (`$5694`) and `ConvertBlockTmp` (`$56EC`) directly
- boot2.s writes to `BlockNumTmp` (`$5745/6`)

## bins/ files

These were dumped with YaPe with breaking after each load call.
Loaded in `boot3.bin` via `$C18B` called with X/Y pointing to ProDOS filename structure (<length>,"filename")

### TITLEPIC

This is loaded at `$1000` and copies from itself 8000 bytes of bitmap and 1000+1000 bytes of screen color RAM into `$5800-$7FFF`

### MUSIC

This is loaded at `$8000`, directly after bitmap

### SUBS1

This is loaded at `$0500`, must fit under `$5600` (because pieces of code are copied from there)

Game code, initialization is done by `boot3.bin`

Entry points:

```
$0400		General sector buffer

$3700-5		zeros

$3706		init, sets IRQ to $3725 and something in TED
$3725-$3744	IRQ (A/X/Y saved in LDA/LDX/LDY before RTI, saves stack and cycles)

$3745-$378E	zeros

$378F		STA $FF3E(select ROM) / JMP $FFF6 (RESET)

$3795		DoSectorOp (called from DoBlockOp)
$37C2		DoGetSector (dispatch from DoSectorOp)
$37B4		DoPutSector (dispatch from DoSectorOp)
$37CD		DoGetStatus (return C flag, C=0 -- OK)
$37DD		TrackSecNum (table, 32) right until $37ff=$ff ; number of sectors on each track

/$FD00-$FEFF I/O/
/$FF00-$FF20 TED/
$FF20		SendByte
$FF5A		GetByte
$FF9F		DoBlockOp	(external entry: from $4178 / $41F9 and more; this must be here)
$FFAF		ConvertBlockTmp	convert linear ProDOS block number to track & sector
$FFE4		SendParams
$FFF9/A		BlockNumTmp	storage, converted t&s
$FFFB		IOStatus	last status op
$FFFC/D		$0650	reset vector
$FFFE/F		$3725	irq vector (note that nmi in $fffa/b is unused)


///// DW gamecode

$405b		check for disk side ($F5DF)
$41D6		read block (X=lo/Y=hi) -> DoBlockOp

$4E39		called on game startup, copies device-specific `GetByte/SendByte` to $FF20-$FFF9

$F5DF		needed disk side (disk1=0, disk2=1 ... in block $0001 (1/1) in byte $00ff
		; required disk side number (starts with 0), checked at $405b

```

# Disk layout

## Template disk1

`dragon_wars_1_freeblocks.d64`

Freed in BAM sectors for `TITLEPIC`, `MUSIC`, `SUBS1` sectors (2,1)-(7,14) inclusive and deleted `dragon wars`
