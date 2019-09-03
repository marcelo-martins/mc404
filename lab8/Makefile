run:
	arm-eabi-gcc mapa.c -S -o mapa.s
	arm-eabi-as mapa.s -o mapa.o
	arm-eabi-as dfs.s -o dfs.o
	arm-eabi-ld mapa.o dfs.o -o program -Ttext=0x77802000 -Tdata=0x77803000
	mksd.sh --so /home/specg12-1/mc404/simulador/dummyos.elf --user program
	arm-sim --rom=/home/specg12-1/mc404/simulador/dumboot.bin --sd=disk.img
