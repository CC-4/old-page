---
layout: post
title: "Optimizaciones"
comments: false
date:   2018-10-30 11:10:00 -0600
category: lab
numero: 11
descripcion: >
 Veremos un poco sobre como funcionan las optimizaciones mas simples en un arbol ya generado.
---

## 1. Introducción:

El objetivo de este laboratorio es preparar el <b>AST</b> para la generación de código, aplicandole la optimización de <b>Constant Folding</b>.

Antes de empezar, obtener los archivos desde Github Classroom:

```shell
https://classroom.github.com/a/R0yujQOt
```

## 2. Descripción:

  En lugar de generar código de forma directa, realizaremos una de las optimizaciones mas simples: aplicaremos <b>Constant Folding</b> a la
  gramatica empleada en el laboratorio anterior, la cual solo tiene definiciones de funciones, operaciones matematicas y condiciones. En los archivos que 
  descargaron, se les proporciona el codigo base del <b>lexer</b>, <b>parser</b> y <b>AST</b> para que ustedes puedan agregar el código necesario para 
  implementar las optimizaciones. Esta es la gramatica:

```
  P -> D P | D
  D -> def id(ARGS) = E;
  ARGS -> id, ARGS | id | lambda
  E -> int | id | if E = E then E else E | E + E | E - E | id(E,...,E)
```

## 3. Ejercicio:

Para poder realizar esta fase, ustedes deben recorrer el <b>AST</b> de forma similar a la fase de semant, y la de cgen. El archivo que deben modificar es 
<b>cool-tree.java</b>, en la clase <b>Main</b>. Ahi deben implementar el metodo llamado <i>optimize</i>, el cual es su punto de inicio. Ademas de esto, son
libres de modificar cualquier otra clase que deseen, como <i>hint</i>, otra clase que les seria util, podria ser <b>TreeNode.java</b>. Una vez implementada
la función, si tienen el siguiente fragmento de código:

```shell
  def foo() = 2 + 3
```

 su programa debera optimizarlo, operando la suma y luego escribiendo una unica constante, de la siguente manera: 

```shell
  def foo() = 5
```

tomen en cuenta que para las llamadas a funciones tambien pueden realizar optimizaciones:

```shell
  foo(2*i,3*3)
```

lo cual deberian cambiarlo a:

```shell
  foo(2*i,9)
```
El output de su código debe ser el <b>AST</b> optimizado  por  lo  que  las  operaciones matemáticas entre constantes  deben aparecer como una sola constante 
(usted no debe preocuparse por desplegar el <b>AST</b> esto ya lo hace el código que se le proporciona, usted solo debe modificar la estructura del <b>AST</b>).

## 4. Autograder:

Para comprobar que su código funciona correctamente, pueden escribir <b>make check</b>:

```shell
  echo '#!/bin/sh' >> lab11
  echo 'java -classpath /home/volant360/Documents/Lab11/try/lib/java-cup-11a.jar:.:`dirname $0` Lab11 $*' >> lab11
  chmod 755 lab11
  python grading.py
  ##################### Autograder #######################
         +1 (test3.test)
         +1 (test2.test)
         +1 (test5.test)
         +1 (test4.test)
         +1 (test1.test)

  -> All ok
  +------------------------------------------------------+
  |                                            Score: 5/5|
  +------------------------------------------------------+

```
