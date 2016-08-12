---
layout: post
title: "Bottom-Up Parsing - SLR(1)"
comments: false
date:   2016-08-11 11:10:00 -0600
category: lab
numero: 5
descripcion: >
 En este laboratorio aprenderan a implementar un parser SLR(1)
---


## 1. Introducción:

En clase ustedes vieron la variedad de parsers que existen, desde predictivos hasta parsers bottom-up, y que gramáticas podían representar. En este laboratorio nos vamos a enfocar en los parsers **bottom-up** (ya que en el lab3 hicimos uno predictivo **_RDP_**) y en especifico en implementar un parser **SLR(1)**, esto nos va a dar una idea de como es que funciona **JCUP** internamente aunque sabemos que JCUP implementa un parser **LALR(1)**.

Antes de seguir leyendo el lab necesitan clonar el siguiente repositorio que contiene los archivos con los que vamos a trabajar:

```shell
 $~ git clone https://github.com/CC-4/lab5.git
```

_**NOTA:** Este es el ultimo lab sobre el tema de **análisis sintáctico**._

## 2. Gramática:

Vamos a estar trabajando con la siguiente gramática, que es parecida a la que utilizaron en el **laboratorio #4**, en este caso vamos a hablar de id como un numero double de java. Pongan mucha atención al numero de producción, porque este es el que vamos a utilizar a la hora de hacer un reduce.

1. \\( S \to E; \$\\)
2. \\( E \to E + T\\)
3. \\( E \to E - T\\)
4. \\( E \to T\\)
5. \\(T \to T * P\\)
6. \\(T \to T / P\\)
7. \\(T \to T \% P\\)
8. \\(T \to P\\)
9. \\(P \to F \wedge P\\)
10. \\(P \to F\\)
11. \\(F \to SIN A\\)
12. \\(F \to COS A\\)
13. \\(F \to TAN A\\)
14. \\(F \to A\\)
15. \\(A \to (E)\\)
16. \\(A \to id\\)

\\(Terminales \to\\) **; + - \* / % ^ SIN COS TAN ( ) id y el simbolo de EOF($)**


## 3. Ejercicio 1 - Construyendo la Tabla de Parseo (30%):

En clase les dejamos la **hoja de trabajo No. 2**, lo que tenían que hacer era encontrar el conjunto **FIRST y FOLLOW** y también construir el **AFD** para un parser **_SLR(1)_** dada la gramática de arriba, esa hoja representa un **20%** de este laboratorio. Como no podemos garantizar de que todos tengan bien su solución nosotros les vamos a proporcionar la siguiente para que puedan completar el lab:

[Solución Hoja de Trabajo 2](https://www.dropbox.com/s/h9eywz3mesgrbdb/LAB5-HT.pdf?dl=1)

Con eso podemos empezar a construir nuestra tabla de parseo. Lo primero que tenemos que hacer es abrir nuestro archivo **table.xlsx**, que esta en la carpeta del lab, esto tiene que abrir **libreoffice** ya que estamos trabajando en ubuntu y les tiene que aparecer algo así:


<img src="{{site.baseurl}}/assets/imgs/lab5-fig1.png" alt="figura1" style="width:100%">


Con la solución que les dimos ustedes tienen que llenar cada una de esas casillas de la siguiente manera:

* Para hacer un **shift** hacia un estado vamos a escribir **S(n) o s(n)** donde n representa un numero de estado.
* Para hacer un **reduce** vamos a escribir **R(k) o r(k)** donde k representa el numero de producción, siguiendo el orden de la gramática de arriba.
* Para hacer un **GoTo** hacia un estado vamos a escribir **G(n) o g(n)** donde n representa un numero de estado.
* Cuando queramos poner una acción de aceptar pondremos **ok o OK** en la casilla correspondiente.
* Para indicar **error** dejaremos vacía la casilla


Una vez hayan terminado guardan y cierran el archivo, _si les sale que si quieren seguir trabajando con el formato de Microsoft 2007-XML o algo parecido, le dan que si_. **_NO conviertan la extensión .xlsx a otra de libreoffice por favor_**. 

Si ustedes quieren ver esa tabla en código de java pueden convertir ese documento utilizando el siguiente comando:

```shell
 ~$ make ParseTable.java
```

Esto les va a generar un archivo ParseTable.java que define una clase ParseTable y que tiene la tabla de parseo que ustedes escribieron.

> \> Más sobre esto en el lab

Si ustedes quieren saber si su tabla esta bien pueden comprobarlo con el siguiente comando:

```shell
 ~$ make checkTable


 --> Su tabla de parseo es correcta ...
```

## 4. Lexer:

En esta ocasión ustedes **no van a implementar el lexer** ya que consideramos que son expertos en el uso de **JLEX**. Nosotros les vamos a dar un archivo **_lexer.lex_** que ya tiene las acciones para generar los simbolos/tokens de la gramática y que crea un archivo **_Lexer.java_** que implementa la clase **Lexer**. Solo hay 3 cosas que tienen que saber sobre el lexer: 

**1.** Si quieren probar el lexer pueden utilizar el siguiente comando:

```shell
 $~ make lexer
 $~ ./lexer "2.14124 + 12.4124 ^ 10;"
 ID = 2.14124
 +
 ID = 12.4124
 ^
 ID = 10
 ;
 $
```

**2.** Si ustedes tienen un objeto de tipo **Lexer** para obtener el siguiente symbol tienen que utilizar el siguiente método:

```java
 // Suponiendo que tienen un objeto de tipo Lexer llamado lexer
 Symbol next = lexer.next();
```

**3.** El lexer aunque haya consumido toda la entrada **NO** para, esto significa que siempre manda un symbol al utilizar el metodo de arriba, ese ultimo symbol que manda es el de EOF. 

## 5. Clase Symbol

En la carpeta del laboratorio hay una subcarpeta llamada **_utils_**, aqui van a encontrar un archivo llamado **_Symbol.java_** que implementa la clase **Symbol** que es con la que vamos a representar los tokens de la gramática y los simbolos gramáticales **(S, E, T, P, F, A)**. Este tipo de objeto es el que devuelve nuestro Lexer.

Esta clase tiene unas variables estaticas de tipo **int** que nos ayudan a representar cada uno de los tokens y simbolos con su respectivo **id**:

```java
 public static final int SEMI   =  0; // -> ;
 public static final int PLUS   =  1; // -> +
 public static final int MINUS  =  2; // -> -
 public static final int MULT   =  3; // -> *
 public static final int DIV    =  4; // -> /
 public static final int MOD    =  5; // -> %
 public static final int EXP    =  6; // -> ^
 public static final int SIN    =  7; // -> SIN
 public static final int COS    =  8; // -> COS
 public static final int TAN    =  9; // -> TAN
 public static final int LPAREN = 10; // -> (
 public static final int RPAREN = 11; // -> )
 public static final int ID     = 12; // -> id (number)
 public static final int EOF    = 13; // Final del string
 public static final int S      = 14; // simbolo gramatical S
 public static final int E      = 15; // simbolo gramatical E
 public static final int T      = 16; // simbolo gramatical T
 public static final int P      = 17; // simbolo gramatical P
 public static final int F      = 18; // simbolo gramatical F
 public static final int A      = 19; // simbolo gramatical A
 public static final int ERROR  = 20; // ERROR
```

para crear un Symbol hay 2 constructores:

1. **Symbol(int id)**
2. **Symbol(int id, String val)**

El ultimo no lo vamos a utilizar ya que solo el lexer lo utiliza para crear los Symbols que representan un **ID**. Dentro de la clase hay varios comentarios que documentan que hace cada cosa de lo que esta programado **(LEANLO)**.

> \> Mas sobre esto en el lab

## 6. Ejercicio 2 - Implementado un Parser SLR(1) (50%):

Ya teniendo la tabla de parseo podemos empezar a implementar nuestro parser SLR(1), primero tenemos que recordar como es el algoritmo para eso veamos la siguiente tabla de parseo en accion:

[Algoritmo Parser LR(k)](https://www.dropbox.com/s/rbgfi1mbgj48d3r/AlgoritmoSLR.pdf?dl=1)

Ya con eso en mente ustedes tienen que ver la manera de pasarlo a codigo en el archivo **Parser.java** para eso vamos a aclarar un par de cosas.


#### 6.1 Shift, Reduce, GoTo, Accept

Si ustedes vieron la tabla de parseo que se creo en codigo de java, posiblemente se dieron cuenta de que habian 4 metodos que creaban objetos de tipo Shift, Reduce, Accept, GoTo. esos objetos estan implementados en los archivos Shift.java, Reduce.java, Accept.java y Goto.java respectivamente dentro de la subcarpeta utils, ustedes tienen que revisar los comentarios de cada una de esas clases para entenderlas.

Para ver que tipo de accion es tendriamos que hacer algo como:

```java
 Object action = ParseTable.T[state][symbol];
 if(action instanceof Shift) {
	/* Codigo aqui */
 } else if (action instanceof Reduce) {
	/* Codigo aqui */
 } 
 ...
```


#### 6.2 tree Package

En la subcarpeta tree creamos un package que contienen los nodos que representan a nuestra gramatica, tenemos que utilizar estos para crear el AST.


> \> MAS SOBRE TODO ESTO EN EL LAB


Lo que tienen que hacer ahora es abrir Parser.java y llenar todo donde dice **/\*SU CODIGO AQUI\*/**

para probar su codigo:

```shell
 ~$ make
 ./parser
 >>> 2 + 2;
 = 4.0
 >>>
```







 






