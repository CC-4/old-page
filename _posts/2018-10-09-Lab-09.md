---
layout: post
title: "CodeGen - Introducción"
comments: false
date:   2018-10-09 11:10:00 -0600
category: lab
numero: 9
descripcion: >
 En este laboratorio vamos a generar codigo MIPS para un lenguaje visto en clase.
---

## 1. Introducción:

El objetivo de este laboratorio es generar código en base a una gramatica simple vista en los periodos de clase, la cual solo tiene definiciones de funciones, operaciones matematicas y condiciones. Se les proporciona el codigo base: el lexer, parser y AST. Tambien ya esta hecho el analisis semantico. Ustedes solo tienen que agregar el codigo necesario, siguiendo los lineamientos vistos en clase.

Antes de empezar, los archivos necesarios para completar este lab se encuentran en **Github Classroom**:

```shell
  https://classroom.github.com/a/WDLZWS1C
```

## 2. Gramatica:

```
  P -> D P | D
  D -> def id(ARGS) = E;
  ARGS -> id, ARGS | id | lambda
  E -> int | id | if E = E then E else E | E + E | E - E | id(E,...,E)
```

## 3. Ejercicio:

Para poder realizar esta fase se debe recorrer el AST de forma similar a como lo hizo con el analisis semantico, se le proporciona una clase CgenSupport.java la cual tiene varias funciones que le permiten generar código de MIPS de una forma más simple.

> NOTA: todos los archivos que desee compilar deben tener una función main la cual será llamada para
iniciar su programa cuando lo ejecute con el comando ./run archivo.s

Para poder compilar el código usted debe escribir en la terminal el comando **make compiler**, y para ejecutarlo lo
debe realizar de la siguiente forma **./compiler archivo** al momento de ejecutarlo se guardara un archivo con el mismo nombre pero con extensión .s con el código de MIPS.

tree.java en este archivo se encuentra la clase **_Program_** que cuenta con un método llamado cgen
el cual es el punto de inicio de la generación de codigo.

Cuando lo completen lo pueden probar asi:

```shell
  ~$ make compiler
  ./compiler test.p
  ./run test.s
  MARS 4.5  Copyright 2003-2014 Pete Sanderson and Kenneth Vollmar

  55
```
