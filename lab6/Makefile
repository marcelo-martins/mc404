main:
	arm-eabi-as lab6.s -o saidalab6.o
	arm-eabi-ld saidalab6.o -o saida_do_ligador -Ttext=0x77802000 -Tdata=0x77803000
	mksd.sh --so /home/specg12-1/mc404/simulador/dummyos.elf --user saida_do_ligador
	arm-sim --rom=/home/specg12-1/mc404/simulador/dumboot.bin --sd=disk.img
