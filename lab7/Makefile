main:
	arm-eabi-as lab7.s -o arquivo_de_saida.o
	arm-eabi-ld arquivo_de_saida.o -o arquivo_de_saida_do_ligador -Ttext=0x77802000 -Tdata=0x77803000
	mksd.sh --so /home/specg12-1/mc404/simulador/dummyos.elf --user arquivo_de_saida_do_ligador
	arm-sim --rom=/home/specg12-1/mc404/simulador/dumboot.bin --sd=disk.img
