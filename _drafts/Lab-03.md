---
layout: post
title: "Recursive Descent Parsing (RDP)"
comments: false
date:   2016-07-29 11:10:00 -0600
category: lab
numero: 3
descripcion: >
 En este laboratorio aprenderan a implementar un recursive descent parser para
 una gramática simple.
---
## Tabla de contenido:
* [1. Introducción](#introduccin)
* [2. Gramática](#gramtica)
* [3. Ejercicio 1](#ejercicio-1---lexer)
* [4. Ejercicio 2](#ejercicio-2---parser)


## 1. Introducción:

En las ultimas clases ustedes vieron el tema de **_recursive descent parsing (RDP para simplificar)_**, aprendieron que es un tipo de parser predictivo y que entra en la categoria
de top-down parsing. Tambien vieron de forma general un algoritmo para implementarlo y en este
laboratorio lo pondremos en practica.

Como el nombre sugiere, un  **_recursive descent_** usa funciones recursivas para implementar un parser predictivo. La idea central es que cada **_no-terminal_** en la gramática es representado por una de esas funciones recursivas. Cada funcion entonces mira el siguiente _token (1 token de lookahead)_ para poder escoger asi, una de las producciones de algun **_no-terminal_**. De esta manera es como vamos analizando la entrada y construyendo nuestro arbol **sintactico** _(si es que la entrada tiene una sintaxis correcta, de lo contrario mandariamos algun error)_.

**Recuerden que:**

1. Un analizador lexico _(lexer)_ convierte texto _(raw-text)_ en un stream de tokens.
2. Un analizador sintactico _(parser)_ convierte el stream de tokens en un arbol sintactico.

De forma gráfica esos 2 pasos los podemos ver asi:

<p><img src="/assets/imgs/figura1.jpg" alt="figura1" style="display:block; margin: 0 auto;"></p>

En este laboratorio realizaremos **una calculadora con un par de operaciones** e iremos un paso más adelante al implementar un **_interprete_**, es decir no crearemos un arbol sintactico sino que evaluaremos online las expresiones.

## 2. Gramática

La gramática con la que trabajaremos es la siguiente:

```
S ::= E;
E ::= E + E
    | E - E
    | E * E
    | E / E
    | E % E
    | E ^ E
    | - E
    | (E)
    | number

# number en nuestro caso significara un double
```

Esta gramática tiene un gran **problema** para nuestro **RDP**, si se recuerdan por lo visto en clase, sufre de un problema llamado **_left-recursion_**. Una de las desventajas de este tipo de parsers es que las gramáticas con las que puede trabajar son aquellas que no son recursivas hacia la izquierda y claramente esta lo es,  `E ::= E + E` por ejemplo. Asi que lo que necesitamos hacer de **primero** es transformar nuestra gramática para que no tenga este problema, teniendo en cuenta siempre que el lenguaje que describe nuestra nueva gramatica _G1_ es el mismo que describe nuestra gramática _G_ original, es decir:

$$ L(G1) = L(G) $$

> Esto lo veremos durante el lab

## 3. Ejercicio 1 - Lexer

Para el primer ejercicio de este laboratorio, ustedes van a implementar el lexer para la gramática de nuestra calculadora utilizando **JLex**. El motivo principal de esto es para que sigan ganando práctica con esta herramienta, que surgan dudas y que los ayude a empezar/avanzar con el proyecto **_(Esperamos que la gran mayoria de personas no este en la fase de "empezar" el proyecto todavia ...)_**.

Para empezar clonen el siguiente repositorio en algun lugar donde quieran trabajar:

```shell
~$ git clone https://github.com/CC-4/lab3.git
```

Dentro de la carpeta de trabajo **_lab3_** van a encontrar un archivo llamado **_lexer.lex_**, en ese archivo ustedes tienen que definir el lexer para la gramática. Dentro de ese archivo hay en forma de comentarios algunas instrucciones para guiarlos.

### 3.1 Clase Token

En la carpeta de trabajo hay una clase llamada **Token** que nos va a servir para representar los tokens de la gramática y es el tipo de objeto que tenemos que devolver dentro de las acciones del lexer. Esta clase tiene 2 constructores:

1. **Token(int id, String val)**
2. **Token(int id)**

Dentro de esta clase tambien estan definidos los IDs que representan cada token y tienen que hacer uso de esos cuando encuentren un token. En ese archivo tambien estan definidos otros métodos _(Con su documentacion respectiva)_ que pueden ser utiles para la siguiente parte del lab.

**Ejemplo:**

```java
// Asi se veria en la parte de acciones del archivo .lex
<YYINITIAL>{SEMI}   { return new Token(Token.SEMI);             }
<YYINITIAL>{NUMBER} { return new Token(Token.NUMBER, yytext()); }
```

Cuando tengan listo mas de algo, pueden probar lo que hicieron utilizando el siguiente comando:

```shell
~$ make lexer
~$ ./lexer "2 + 2;"
NUMBER : 2
+
NUMBER : 2
;
```

## 4. Ejercicio 2 - Parser

Para el segundo y ultimo ejercicio de este lab ustedes implementaran un recursive descent parser. Esta gramática es bastante simple y practicamente se trata solo de expresiones aritmeticas. Parsear expresiones de este tipo con recursive descent tiene 2 problemas:

1. **En como obtener un arbol sintactico que siga la precedencia y la asociatividad de los operadores.**
2. **En como hacerlo eficientemente cuando hay muchos niveles de precedencia.**

En clase ustedes vieron la clasica solucion para el primer problema, que a pesar de que es bastante buena y elegante, no resuelve el segundo problema. En este lab les vamos a enseñar una tecnica llamada **_"Shunting Yard Algorithm"_** que es más eficiente y resuelve el 1ero y 2do problema, la base de este algoritmo se encuentra hasta en las **_calculadoras chicleras_**.

### 4.1 Clase Parser

En el directorio de trabajo van a encontrar un archivo llamado **_Parser.java_**, en este archivo es donde ustedes tienen que implementar el parser. Practicamente lo que tienen que hacer es crear una plantilla con funciones recursivas de la gramatica que modificamos _(Unos pasos más atras)_. Aquí hay unas funciones que les pueden ser util como **term**.

**Ejemplo:**

Si nuestra gramática empieza de esta manera `S ::= E;` podriamos implementarlo de la siguiente manera.

```java
boolean S() {
    return E() && term(Token.SEMI);
}

boolean E() {
    ...
}
```

> Mas sobre esto en el lab.

### 4.2 Shunting Yard Algorithm

La idea del algoritmo **_shunting yard_** es mantener los operadores en un stack hasta que todos los operandos han sido parseados. Los operandos se mantienen en un segundo stack. El algoritmo shunting yard puede utilizarse directamente para evaluar las expresiones mientras son parseadas **_(como un interprete, que es lo que vamos hacer)_**. Practicamente es convertir la entrada en notación polaca inversa _(infix a postfix)_.

La idea central del algoritmo es mantener los operadores en el stack ordenados por precedencia **_(la precedencia mas baja en el fondo del stack y la mas alta en el tope del stack)_**, por lo menos en la ausencia de parentesis. Antes de meter un operador en el stack de operadores, todos los operadores que tienen mayor precedencia son sacados del stack. Sacar un operador del stack de operadores consiste en remover el operador y sus operandos del stack de operandos, evaluar, y meter el resultado en el stack de operandos. Al final de una expresion los operadores que quedan son sacados y evaluados con sus respectivos operandos.

La siguiente tabla ilustra el proceso para un input : **x * y + z.** El stack se va llenando a la izquierda.

* **push(a)**    : hace push de a en el stack de operandos
* **pushOp(op)** : hace push de un operador en el stack de operadores
* **pre(op)**    : devuelve precedencia de un operador

|Lo que queda del input|Stack de Operandos| Stack de operadores | Siguiente Accion |
|:--------------------:|:----------------:|:-------------------:|:----------------:|
|      x * y + z       |                  |                     |   push(x)        |
|      * y + z         |            x     |                     |   pushOp(*)      |
|      y + z           |            x     |                *    |   push(y)        |
|      + z             |          y x     |                *    |   push(+) como pre(+) < pre(*) sacamos * y evaluamos, push((x * y) = A) |     
|      z               |            A     |                +    |   push(z)        |
|      empty           |          z A     |                +    |                  |

Para nuestra gramática la precedencia es la siguiente de mayor a menor:

1. **"()"**
2. **"- (unary)"**
3. **"^"**
4. **"* / %"**
5. **"+ -"**

dentro del archivo ustedes que tienen que terminar el codigo donde dice `/*TODO CODIGO AQUI*/`.

para probar su codigo:

```shell
~$ make parser
./parser
>>> 2 + 2;
4.0
>>>
```
