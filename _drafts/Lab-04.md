---
layout: post
title: "Conociendo Cup"
comments: false
date:   2016-08-05 11:10:00 -0600
category: lab
numero: 4
descripcion: >
 En este laboratorio aprenderan a emplear Cup; el analizador lexico que utilizaran en la fase 2 de su proyecto.
---
## Tabla de contenido:
* [1. Introducción](#introduccion)
* [2. Ejercicio 1](#ejercicio-1---lexer)
* [3. Ejercicio 2](#ejercicio-2---parser)


## 1. Introducción:

Descarguen todos los archivos del siguiente repositorio:

```
git clone https://github.com/CC-4/lab4.git
```

Ahora que han terminado la fase 1 de su proyecto, saben utilizar JLex para el analisis lexico de una cadena de caracteres. Como han visto en clase,
el analisis sintactico se basa en gramaticas, y tiene algoritmos muy bien definidos para poder ser implementado. Para prepararlos para la 
fase 2, utilizaremos una herramienta llamada CUP, que funciona para analizar la sintaxis de un texto dado. 

Al igual que JLex, Cup cuenta con una seccion donde se colocan las funciones que se copiaran a la clase generada; en este laboratorio no utilizaremos esta 
funcionalidad, pero les sera util para su proyecto. Luego existe una lista de simbolos terminales, como los parentesis, los digitos, etc., seguido de 
una lista de simbolos no terminales. Tanto los simbolos terminales como los no terminales pueden tener un tipo definido:

```
terminal PLUS, MINUS, MULT;
terminal Integer INTEGER;
terminal Float FLOAT;
```
Luego pueden especificar una precedencia. Por ejemplo, una multiplicacion se debe hacer antes que una suma. Para este tipo de precedencia deben 
emplear "precedence left", como en el siguiente ejemplo:

```
precedence left PLUS, MINUS;
precedence left TIMES;
```

Seguido de eso, van todas las reglas de produccion. Siguiendo la siguiente sintaxis, donde RESULT es la derivacion usando bottom-up parsing.

```
parent_expr ::= LPAREN expr:e RPAREN {: RESULT=e; :};
```

## 2. Ejercicio 1 - Lexer

La gramática con la que trabajaremos es la siguiente:

```
S ::= S expr_part | expr_part;
expr_part ::= expr ;
expr ::= exprI | exprF
exprI ::= I + I 
    | I - I
    | I * I
    | I / I
    | I % I
    | (I)
exprF ::= I + F
    | F + I
    | F + F
    | I - F
    | F - I
    | F - F
    | I * F
    | F * I
    | F * F
    | I / F
    | F / I
    | F / F
    | I ^ F
    | F ^ I
    | F ^ F
    | sin I
    | sin F
    | cos I
    | cos F
    | tan I
    | tan F
    | (F)

# donde I es un entero y F es un float. Ustedes deben implementar las expresiones regulares para ambos tipos de datos.
```

Para la primer parte deben completar el archivo calculator.lex generando los tokens necesarios para una calculadora con operaciones 
basicas y que maneje tanto floats como enteros. Note que las funciones trigonometricas no son case sensitive, 
por lo que "sin" y "sIN" son aceptadas de igual manera. Esta es la lista de tokens que debe tener:

```shell
SEMI
PLUS
MINUS
TIMES
DIVI
LPAREN
RPAREN
POW
REM
SIN
COS
TAN
INTEGER
FLOAT
```

Si analizan la gramatica, pueden ver que una expresion puede ser una expresion entera, o una expresion de punto flotante. Mas adelante veran que esta 
gramatica se puede simplificar dejando la distincion entre enteros y floats al analizador sematico. 

## 3. Ejercicio 2 - Parser

Para la segunda parte, ustedes deben completar el archivo calculator.cup, agregando las reglas de derivacion bottom-up. puede agregar tantos 
simbolos no terminales como quiera, pero no pueden modificar ninguno de los simbolos terminales. Una vez agregadas todas las reglas de derivacion, pueden 
compilar su archivo de la siguiente manera:

```shell
~$ sh make.sh
```

y para correrlo:

```shell
~$ sh calculator.sh
```

Asi se debera ver al probarlo:

```shell
2 + 2;
= 4;
4 * cos(0.41e1 ^ 2);
= -3.830638;
```


Una vez terminado, suban los archivos .cup y .lex al ges comprimidos en una carpeta .zip.