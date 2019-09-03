#source /home/specg12-2/mc404/simulador/set_path_player.sh

sdbico:
	# Para deletar execucoes antigas
	rm -f soul.o soul bico.o bico
	# Para compilar e ligar o seu programa.
	arm-eabi-as -g soul.s -o soul.o
	arm-eabi-as -g bico.s -o bico.o
	arm-eabi-ld soul.o -o soul -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0
	arm-eabi-ld bico.o -o bico -Ttext=0x77812000 -Tdata=0x77803000
	# Monte a imagem do cartão SD: (seu programa eh o SO)
	mksd.sh --so soul --user bico



sd:
	# Para deletar execucoes antigas
	rm -f soul.o soul faz_nada.o faz_nada
	# Para compilar e ligar o seu programa.
	arm-eabi-as -g soul.s -o soul.o
	arm-eabi-as -g faz_nada.s -o faz_nada.o
	arm-eabi-ld soul.o -o soul -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0
	arm-eabi-ld faz_nada.o -o faz_nada -Ttext=0x77812000 -Tdata=0x77803000
	# Monte a imagem do cartão SD: (seu programa eh o SO)
	mksd.sh --so soul --user faz_nada



player:
	# Antes de iniciar o simulador, você precisa abrir uma sessão do Player em outro terminal (faca o souce aqui tambem)
	player /home/specg12-1/mc404/simulador/simulador_player/worlds_mc404/simple.cfg
	#player /home/ec2016/ra183303/Documents/mc404/trab2/worlds_mc404/rondabola.cfg
mainrun:
	# Abra o simulador armsim_player com suporte ao GDB no primeiro terminal
	armsim_player --rom=/home/specg12-1/mc404/simulador/simulador_player/bin/dumboot.bin --sd=disk.img -g

gdbrun:
	# No terceiro terminal, conecte no simulador utilizando o GDB (faca source aqui tambem)
	arm-eabi-gdb soul

gdbrunbico:
	arm-eabi-gdb bico

gdbrunnada:
		arm-eabi-gdb faz_nada



#(gdb) target remote localhost:5000       # conecte no simulador
#(gdb) b soul.s:108               # substitua <linha> por uma linha dentro de IRQ_HANDLER
#(gdb) c                                  # execute ate encontrar um breakpoint
#(gdb) p *(int)0x77801800                 # quando parar no tratador de interrupcoes, imprima o conteudo do contador
#(gdb) c
#(gdb) ...



	#arm-eabi-as -g soul.s -o soul.o
	#arm-eabi-ld soul.o -o soul -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0
	# Monte a imagem do cartão SD: (seu programa eh o SO)
	#mksd.sh --so soul --user faz_nada


	#arm-eabi-as faz_nada.s -o faz_nada.o
	#arm-eabi-ld faz_nada.o -o faz_nada  -Ttext=0x77803000
