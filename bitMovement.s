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
	
	/*Puerto 2 salida (prende el primer led)*/
	mov r0,#2
	mov r1,#1
	bl SetGpioFunction

	/*Puerto 3 salida (prende el segundo led)*/ 
	mov r0,#3
	mov r1,#1
	bl SetGpioFunction
	
	/*Puerto 4 salida (prende el tercer led)*/
	mov r0,#4
	mov r1,#1
	bl SetGpioFunction

	/*Puerto 12 entrada (recibe la entrada del boton*/ 
	mov r0,#12
	mov r1,#0
	bl SetGpioFunction
	
menu:
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
	beq activeLoop
	
	cmp r4, #2
	beq inactiveLoop
	
	b showError
	
activeLoop:
	/*Se enciende el GPIO 2*/
	mov r0,#2
	mov r1,#0
	bl SetGpio

	/*Se carga la memori virtual*/
	ldr r6, =myloc
 	ldr r0, [r6]		 
	ldr r5,[r0,#0x34]	
	mov r7,#1			
	lsl r7,#12			
	and r5,r7 			
	
	/*Si el boton se presiona se cambia de estado*/
	teq r5,#0 			
	movne r0,#2		
	movne r1,#1
	blne SetGpio
	blne delay 
	
	/*Se enciende el GPIO 3*/
	mov r0,#3
	mov r1,#0
	bl SetGpio

	/*Se carga la memori virtual*/
	ldr r6, =myloc
 	ldr r0, [r6]		 
	ldr r5,[r0,#0x34]	
	mov r7,#1			
	lsl r7,#12			
	and r5,r7 			
	
	/*Si el boton se presiona se cambia de estado*/
	teq r5,#0 			
	movne r0,#3		
	movne r1,#1
	blne SetGpio
	blne delay 
	
	/*Se enciende el GPIO 4*/
	mov r0,#4
	mov r1,#0
	bl SetGpio

	/*Se carga la memori virtual*/
	ldr r6, =myloc
 	ldr r0, [r6]		 
	ldr r5,[r0,#0x34]	
	mov r7,#1			
	lsl r7,#12			
	and r5,r7 			
	
	/*Si el boton se presiona se cambia de estado*/
	teq r5,#0 			
	movne r0,#4		
	movne r1,#1
	blne SetGpio
	blne delay 
	
	b activeLoop
	
inactiveLoop:
	/*Se apaga el GPIO 2*/
	mov r0,#2
	mov r1,#1
	bl SetGpio

	/*Se carga la memori virtual*/
	ldr r6, =myloc
 	ldr r0, [r6]		 
	ldr r5,[r0,#0x34]	
	mov r7,#1			
	lsl r7,#12			
	and r5,r7 			
	
	/*Si el boton se presiona se cambia de estado*/
	teq r5,#0 			
	movne r0,#2		
	movne r1,#0
	blne SetGpio
	blne delay 
	
	/*Se enciende el GPIO 3*/
	mov r0,#3
	mov r1,#1
	bl SetGpio

	/*Se carga la memori virtual*/
	ldr r6, =myloc
 	ldr r0, [r6]		 
	ldr r5,[r0,#0x34]	
	mov r7,#1			
	lsl r7,#12			
	and r5,r7 			
	
	/*Si el boton se presiona se cambia de estado*/
	teq r5,#0 			
	movne r0,#3		
	movne r1,#0
	blne SetGpio
	blne delay 
	
	/*Se enciende el GPIO 4*/
	mov r0,#4
	mov r1,#1
	bl SetGpio

	/*Se carga la memori virtual*/
	ldr r6, =myloc
 	ldr r0, [r6]		 
	ldr r5,[r0,#0x34]	
	mov r7,#1			
	lsl r7,#12			
	and r5,r7 			
	
	/*Si el boton se presiona se cambia de estado*/
	teq r5,#0 			
	movne r0,#4		
	movne r1,#0
	blne SetGpio
	blne delay 
	
	b inactiveLoop

showError:
	/*Se muestra el mensaje de error*/
	ldr r0,=mensaje_error
	bl puts
	
	/*Se vuelve al menu principal*/
	b menu

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
opciones: 			.asciz "---------------- \nMenu de opciones \n---------------- \n1. Iniciar secuencia: Corrimiento del bit activo \n2. Iniciar secuencia: Corrimiento del bit inactivo \n"
mensaje_error:		.asciz "ERROR :::: DEBE INGRESAR UNA OPCION VALIDA "
decimal:			.asciz "%d"
string: 			.asciz "%s"
char:				.asciz "%c"


















	