---
layout: post
title:  "Laboratorio MIPS"
date:   2018-09-25
category: lab
numero: 8
description: >
    Introducción a MIPS
---

#### Objetivos
* Practicar utilizar MIPS y MARS
       
#### Introducción a MIPS y MARS
Los siguientes ejercicios utilizan un simulador de MIPS llamado MARS, que provee una buena interfaz gráfica de debbuging para el código. Pueden correr MARS en sus propias computadoras bajando el archivo jar en el siguiente [link](http://courses.missouristate.edu/kenvollmar/mars/MARS_4_5_Aug2014/Mars4_5.jar). Van a necesitar tener instalado Java en su computadora, o pueden utilizar (si no lo tienen instalado) esto para instalarlo (Únicamente en linux Ubuntu 14.04 LTS):
    
```bash
    # Para ver si ya esta instalado
    $ java -version
    java version "1.7.0_91"
    OpenJDK Runtime Environment (IcedTea 2.6.3) (7u91-2.6.3-0ubuntu0.14.04.1)
    OpenJDK 64-Bit Server VM (build 24.91-b01, mixed mode)

    # Si no aparece lo de arriba
    # Esto instala el java runtime environment y el compilador de java
    $ sudo apt-get install openjdk-7-jdk
```

Pueden correr MARS utilizando lo siguiente:

```
    $ java -jar Mars4_5.jar
```

#### Detalles básicos de MIPS
* Los programas de MIPS van en un archivo de texto con extensión .s
* Los programas deberían de llevar un label "main:" que se utilizara como punto de inicio
* Los programas deberían de terminar con "li $v0 10" seguido de un "syscall"
* Las labels terminan con dos puntos
* Los comentarios empiezan con numeral
* No pueden poner mas de una instrucción por linea

#### Recordatorio de assembler

Uno de los requisitos de CC4 es dominar los temas de CC3, incluyendo programar en assembler. MIPS es una arquitectura RISC por lo cual es muy fácil de utilizar. Algunas instrucciones que debería conocer hasta el momento son:

```asm
  lw $t1 0($sp)     # obtiene el contenido del stack (memoria) y lo coloca en el registro
  sw $a0 0($sp)     # guarda el contenido del registro en el stack (memoria)
  
  li $t1 5          # coloca un número en el registro
  la $t1 foo        # coloca en el registro la dirección que foo representa
  
  add $t3 $t1 $t2   # suma dos registros y los guarda en $t3
  addiu $sp $sp 4   # realiza una suma del registro con el inmediato, el resultado se trata como unsigned
  
  j label           # salta hacia alguna etiqueta en el código
  jal label         # salta hacia alguna etiqueta y guarda la dirección de retorno en $ra
  jr $ra            # salta hacia la dirección contenida en el registro
  
  beq $t1 $t2 foo   # si $t1 y $t2 son iguales, realiza un salto hacia foo
```

Cuando realizamos llamadas a funciones en assembler debemos ser cuidadosos de no perder las direcciones de retorno. Este y otros datos deben ser guardados en el stack al inicio de la llamada y restaurados cuando esta termina.

MIPS utiliza este convenio: $aX llevan los argumentos, $v0 lleva el valor de retorno, $tX son temporales cuyo valor puede perderse, $sX sobreviven a llamadas, $sp es el puntero hacia el stack, $ra contiene la dirección de retorno.

Veamos un ejemplo de ciclo:
```asm
.data

.text
init:
	li $t0 0              # i
	li $t1 10             # max
conditional:
	bge $t0 $t1 endLoop   # saltamos si i >= max
instructions:
	move $a0 $t0          # syscall 1 para imprimir el valor actual de i
	li $v0 1
	syscall
step:
	addi $t0 $t0 1        # i++
	j conditional         # regresamos al condicional, el condicional indica si continuamos iterando o si terminamos el ciclo
endLoop:
	nop                   # nop = no operation
```

Veamos un programa de ejemplo con llamadas recursivas:
```asm
j main                # queremos que nuestro punto de inicio sea main

.data
msg:	.asciiz "El resultado es: "

.text
main:                 # este sera el punto de inicio
	li $a0 5            # colocamos en $a0 el argumento que enviaremos
	jal factorial       # llamamos a la funcion
	move $s0 $v0        # protegemos el valor
	
	la $a0 msg          # cargamos la dirección donde está nuestro mensaje
	li $v0 4            # syscall 4 imprime una cadena de caracteres
	syscall
	
	move $a0 $s0        # recuperamos el valor que protegimos
	li $v0 1            # syscall 1 imprime un entero
	syscall
	
	li $v0 10           # syscall 10 termina la ejecución del programa
	syscall

factorial:
  # $a0 trae el resultado
  # $v0 sera usado para devolver el resultado
  # $ra tiene la dirección de retorno
  # $sp apunto hacia el tope del stack
	
	bne $a0 $0 notZero      # comparamos contra el registro que está alambrado a tierra
	li $v0 1                # cuando arg != 0, saltaremos hacia el resto de la función, en el caso contrario estamos listos para devolver un valor
	jr $ra                  # tras colocar el resultado en $v0, saltamos de vuelta
	
 notZero:
	addi $sp $sp -8         # protegemos algunos valores en el stack, usamos -8 para pedir dos words de espacio
	sw $s0 0($sp)           # si vamos a usar $s0 en nuestra llamada, debemos proteger su viejo contenido antes
	sw $ra 4($sp)           # guardamos la dirección de retorno para saber hacia donde volver en caso que se hagan más llamadas
	
	move $s0 $a0            # protegemos el argumento pues nos servirá más adelante
	
	addi $a0 $a0 -1         # preparamos el argumento para la siguiente llamada
	jal factorial           # llamamos
	
	mul $v0 $v0 $s0         # multiplicamos fact(n-1) * n
	
	lw $s0 0($sp)           # restauramos el viejo valor de $s0, desde afuera de la función no se notó si algún cambio sucedió
	lw $ra 4($sp)           # restauramos la dirección de retorno
	addi $sp $sp 8          # una vez que ya restauramos todo lo necesario, devolvemos los dos words que habíamos pedido
	
	jr $ra                  # saltamos
```

### Ejercicio 1: fibonacci.s
Fibonacci es junto con factorial el ejemplo clásico de llamadas recursivas. Implemente la función Fibonacci en assembler.

### Ejercicio 2: hanoi.s
Otra función recursiva. Traduzca a MIPS el siguiente código que sirve para resolver el juego de torres de Hanoi.
```c
void hanoi(int NumeroDeDiscos, int T_Origen, int T_Destino, int T_Alterna){
  if(NumeroDeDiscos == 1) {
    printf(" mueva el disco de la torre: "); printf("%i",T_Origen);
        printf(" hacia la torre: "); printf("%i",T_Destino); printf("\n");
  }     else {
    hanoi(NumeroDeDiscos - 1, T_Origen, T_Alterna, T_Destino);
        hanoi(1, T_Origen, T_Destino, T_Alterna);
        hanoi(NumeroDeDiscos - 1, T_Alterna, T_Destino, T_Origen);
  }
}
```

### Ejercicio 3: syscall.s
Consulte la documentación que se encuentra en Material de Apoyo en el GES. Realice un programa que lee del teclado un número y una cadena de caracteres. Imprima la cadena la cantidad de veces que su número le indica.

