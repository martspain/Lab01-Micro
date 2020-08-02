/* 
**********

Laboratorio 1

Universidad Del Valle de Guatemala

Autores:
- Diego Crespo			Carné: 
- Martín España 		Carné: 19258

Fecha de creación: 02/08/2020

Versión: 1.0

**********

Programa para simular corrimiento de bit actvo e inactivo utilzando 
los GPIO de la Raspberry Pi

**********
*/

.text
.align 2
.global main
.type main,%function

/*Inicio del programa*/
main:
	/*Se almacena el link register en el stack*/
	stmfd sp!, {lr}
	
	/*Se muestra el banner*/
	ldr r0,=titulo
	bl puts
	
	/*Se inicializa la bandera del boton a cero*/
	mov r0, #0
	ldr r1,=ciclo_activo
	str r0,[r1]
	
	/*Configuraion de los puertos GPIO*/
	
	/*Se obtiene la direccion virtual*/
	bl GetGpioAddress
	
	/*Puerto 17 salida (prende el primer led)*/
	mov r0,#17
	mov r1,#1
	bl SetGpioFunction

	/*Puerto 27 salida (prende el segundo led)*/ 
	mov r0,#27
	mov r1,#1
	bl SetGpioFunction
	
	/*Puerto 22 salida (prende el tercer led)*/
	mov r0,#22
	mov r1,#1
	bl SetGpioFunction

	/*Puerto 16 entrada (recibe la entrada del boton*/ 
	mov r0,#16
	mov r1,#0
	bl SetGpioFunction
	
menu:
	/*Se encienden los puertos 17, 27 y 22*/
	mov r0,#17
	mov r1,#1
	bl SetGpio
	
	/**/
	mov r0,#27
	mov r1,#1
	bl SetGpio
	
	/**/
	mov r0,#22
	mov r1,#1
	bl SetGpio
	
	/*Se muestra el menu principal*/ 
	ldr r0,=opciones
	bl puts
	
	/*Se solicita la opcion al usuario y se almacena en variable 'almacen' */
	ldr r0,=decimal
	ldr r1,=almacen
	bl scanf
	
	/*Se carga el valor de 'almacen' en r4*/
	ldr r4,=almacen
	ldr r4,[r4]
	
	/*Se compara r4 con las posibles opciones y se redirige el flujo del programa a la etiqueta correspondiente*/
	cmp r4, #1
	beq activeSecuence
	
	cmp r4, #2
	beq inactiveSecuence
	
	cmp r4, #3
	beq exitProgram
	
	b showError
	
activeSecuence:
	/*Se apagan los leds para prepararse para la secuencia*/
	mov r0,#17		
	mov r1,#0
	bl SetGpio
	
	mov r0,#27		
	mov r1,#0
	bl SetGpio
	
	mov r0,#22		
	mov r1,#0
	bl SetGpio
	
	
	buttonReader:
		/*Se verifica si el boton ha sido presionado o no*/
		ldr r6, =myloc
		ldr r0, [r6]		
		ldr r5,[r0,#0x34]	
		mov r7,#1			
		lsl r7,#16			
		and r5,r7 			

		/*Si el boton esta presionado hace lo siguiente*/
		teq r5,#0
		bne changeVariable
		
		/*Si no esta presionado se mantiene en el estado en que se encuentra*/
		ldr r0,=ciclo_activo
		ldr r0,[r0]
		
		cmp r0,#0
		beq buttonReader
		
		cmp r0,#1
		beq lightLoop
	
	changeVariable:
		ldr r0,=ciclo_activo
		ldr r0,[r0]
		
		cmp r0, #0
		beq activateCycle
		bne deactivateCycle
		
		activateCycle:
			ldr r1,=ciclo_activo
			mov r8, #1
			str r8, [r1]
			b lightLoop
			
		deactivateCycle:
			ldr r1,=ciclo_activo
			mov r8, #1
			str r8, [r1]
			b buttonReader
	
	lightLoop:
		mov r0,#17		
		mov r1,#1
		bl SetGpio
		bl delay
		
		mov r0,#17
		mov r1,#0
		bl SetGpio
		
		mov r0,#27
		mov r1,#1
		bl SetGpio
		bl delay
		
		mov r0,#27
		mov r1,#0
		bl SetGpio
		
		mov r0,#22
		mov r1,#1
		bl SetGpio
		bl delay
		
		mov r0,#22
		mov r1,#0
		bl SetGpio
		
		b buttonReader
	
inactiveSecuence:
	/*Se encienden los leds para prepararse para la secuencia*/
	mov r0,#17		
	mov r1,#1
	bl SetGpio
	
	mov r0,#27		
	mov r1,#1
	bl SetGpio
	
	mov r0,#22		
	mov r1,#1
	bl SetGpio
	
	buttonReaderTwo:
		/*Se verifica si el boton ha sido presionado o no*/
		ldr r6, =myloc
		ldr r0, [r6]		
		ldr r5,[r0,#0x34]	
		mov r7,#1			
		lsl r7,#16			
		and r5,r7 			

		/*Si el boton esta presionado hace lo siguiente*/
		teq r5,#0
		bne changeVariableTwo
		
		/*Si no esta presionado se mantiene en el estado en que se encuentra*/
		ldr r0,=ciclo_activo
		ldr r0,[r0]
		
		cmp r0,#0
		beq buttonReaderTwo
		
		cmp r0,#1
		beq lightLoopTwo
	
	changeVariableTwo:
		ldr r0,=ciclo_activo
		ldr r0,[r0]
		
		cmp r0, #0
		beq activateCycleTwo
		bne deactivateCycleTwo
		
		activateCycleTwo:
			ldr r1,=ciclo_activo
			mov r8, #1
			str r8, [r1]
			b lightLoopTwo
			
		deactivateCycleTwo:
			ldr r1,=ciclo_activo
			mov r8, #1
			str r8, [r1]
			b buttonReaderTwo
	
	lightLoopTwo:
		mov r0,#17		
		mov r1,#0
		bl SetGpio
		bl delay
		
		mov r0,#17
		mov r1,#1
		bl SetGpio
		
		mov r0,#27
		mov r1,#0
		bl SetGpio
		bl delay
		
		mov r0,#27
		mov r1,#1
		bl SetGpio
		
		mov r0,#22
		mov r1,#0
		bl SetGpio
		bl delay
		
		mov r0,#22
		mov r1,#1
		bl SetGpio
		
		b buttonReaderTwo

showError:
	/*Se muestra el mensaje de error*/
	ldr r0,=mensaje_error
	bl puts
	
	/*Se vuelve al menu principal*/
	b menu
	
exitProgram:
	mov r0,#0
	mov r3,#0
	ldmfd sp!,{lr}
	bx lr

delay:
	mov r0, #0x4000000 
sleepLoop:
	subs r0,#1
	bne sleepLoop 
	mov pc,lr
 
 
/* Asignación de datos*/
.data
.align 2
.global myloc

	
/*Variables*/
myloc:				.word 0
almacen:			.word 0
ciclo_activo:		.word 0

/*Mensajes para mostrar en pantalla*/
titulo: 			.asciz "_____________________________________ \n \nUniversidad del Valle de Guatemala \nLaboratorio 1 \nCorrimiento de Bit \nAutores: Diego Crespo y Martín España \n_____________________________________"
opciones: 			.asciz "---------------- \nMenu de opciones \n---------------- \n1. Iniciar secuencia: Corrimiento del bit activo \n2. Iniciar secuencia: Corrimiento del bit inactivo \n3. Salir... \n"
opciones_uno: 		.asciz "---------------- \nCorrimiento del Bit Activo (Secuencia Activa) \n---------------- Continuar secuencia \n2. Terminar secuencia... \n3. Salir del programa..."
opciones_dos: 		.asciz "---------------- \nCorrimiento del Bit Inactivo (Secuencia Activa) \n---------------- \n1. Terminar secuencia... \n2. Salir del programa..."
mensaje_error:		.asciz "ERROR :::: DEBE INGRESAR UNA OPCION VALIDA "
decimal:			.asciz "%d"
string: 			.asciz "%s"
char:				.asciz "%c"


















	