
# Ghosts'n'Goblins Arcade

Origin: https://plus4world.powweb.com/software/Ghosts_N_Goblins_Arcade_Version

## disasm


## repack


## src

The IOLib supports TCBM2SD but for some reason it's not detected. The program halts because no
valid drive/interface is datected.


We're just patching to skip over the detection procedure - it won't detect anything and we force
interface type TCBM with drive type TCBM2SD and current device number.
