rm -f drv1551.bin drv1551.o
ca65 -t none -I ../inc drv1551.s
ld65 -C drv1551.cfg -o drv1551.bin drv1551.o
diff drv1551.bin ../bin/drv1551-original.bin
