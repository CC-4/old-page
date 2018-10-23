---
layout: post
title:  "MIPS 2"
date:   2018-10-23
category: lab
numero: 10
description: >
    MIPS Parte II
---

#### Objetivos
* Practicar utilizar MIPS y MARS
* Utilizar la directiva .space para crear arreglos o tablas
       
#### Introducción a MIPS y MARS
Los siguientes ejercicios utilizan un simulador de MIPS llamado MARS, que provee una buena interfaz gráfica de debbuging para el código. Pueden correr MARS en sus propias computadoras bajando el archivo jar en el siguiente [link](http://courses.missouristate.edu/kenvollmar/mars/MARS_4_5_Aug2014/Mars4_5.jar). Van a necesitar tener instalado Java en su computadora, o pueden utilizar (si no lo tienen instalado) esto para instalarlo (Únicamente en linux Ubuntu 14.04 LTS):
    
Recuerde que para correr MARS utiliza el comando:

```
    $ java -jar Mars4_5.jar
```

Utilizaremos la directiva .space que será fundamental al momento de generar código para los objetos.

#### Más detalles sobre MIPS
* El área de .text contiene código, el área de .data contiene datos
* Existen más directivas, como .space que reserva un espacio de memoria
* La directiva .align obliga al espacio que se pide a estar alineado a memoria
* La instrucción 'la $reg label' permite cargar una dirección hacia un registro, no importa si la dirección corresponde a código o datos

#### Ejemplo básico

```asm
.data
  miEspacio:  .space 100    # pedimos 100 bytes de memoria, usaremos miEspacio para identificar dónde quedó el espacio
  
.text
  la $t1 miEspacio          # t1 contiene la dirección
  li $s0 10
  li $s1 20
  
  sw $s0 0($t1)             # guardamos un valor en miEspacio[0], es decir miEspacio será un arreglo y usaremos la primera casilla
  sw $s1 4($t1)             # guardamos un valor en miEspacio[1], es decir segunda casilla
```

Para comprobar que se guardó lo que queríamos podemos revisar que dirección tiene $t1 en el panel derecho, luego buscar esta dirección en la memoria y ver su contenido.

### Ejercicio 1: array.s
Cree un arreglo de ocho casillas, en cada casilla guarde el valor ascii correspondiente a cada uno de los números de su carnet.

### Ejercicio 2: heap.s
Los syscall nos ayudan a realizar programas más poderosos. Usaremos el syscall 9 para pedir memoria de forma dinámica, obtendremos algo de memoria en el heap. (Note que al usar .space la memoria que MARS nos da está en el área estática, funciona para ejemplos, pero necesitamos heap para el proyecto)

Haga un programa que:
* Pida al usuario un número en la consola
* Reserve esa cantidad de words en memoria
* En el primer word reservado, coloque el resultado de factorial(1); segundo word, factorial(2); etc.

Responda en un comentario dentro de su archivo: Por qué necesitamos un syscall para pedir memoria en el heap? Por qué no puede haber una directiva para pedir esto de una vez cuando estamos escribiendo nuestro programa?

Syscalls reference: [link](http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html)
