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
	stmfd sp!, {lr}
	ldr r0,=titulo
	bl puts
	

/* Asignación de datos*/
.data
.align 2

	
/*Variables*/
almacen:	.word 0

/*Mensajes para mostrar en pantalla*/
titulo: 			.asciz "Universidad del Valle de Guatemala \nLaboratorio 1 \nCorrimiento de Bit \nAutores: Diego Crespo y Martín España \n"
opciones: 			.asciz "---------------- \nMenu de opciones \n---------------- \n1. Iniciar secuencia: Corrimiento del bit activo \n2. Iniciar secuencia: Corrimiento del bit inactivo \n3. Salir... \n"
opciones_uno: 		.asciz "---------------- \nCorrimiento del Bit Activo \n---------------- \n1. Terminar secuencia... \n2. Salir del programa..."
opciones_dos: 		.asciz "---------------- \nCorrimiento del Bit Inactivo \n---------------- \n1. Terminar secuencia... \n2. Salir del programa..."


















	