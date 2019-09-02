# Recursive Descent Parsing (RDP)

<p align="center">
  <img src="/img/rdp.gif" alt="RDP"/>
</p>

En este laboratorio aprenderan a implementar un recursive descent parser para
una gramática simple.

## 1. Introducción

En las últimas clases ustedes vieron el tema de **_recursive descent parsing (RDP para simplificar)_**, aprendieron que es un tipo de parser predictivo y que entra en la categoría de top-down parsing. También vieron de forma general un algoritmo para implementarlo y en este laboratorio lo pondremos en práctica.

Como el nombre sugiere, un  **_recursive descent parser_** usa funciones recursivas para implementar un parser predictivo. La idea central es que cada **_no-terminal_** en la gramática es representado por una de esas funciones recursivas. Cada función entonces mira el siguiente _token (1 token de lookahead)_ para poder escoger así, una de las producciones de algún **_no-terminal_**. De esta manera es como vamos analizando la entrada y construyendo nuestro árbol **sintáctico** _(si es que la entrada tiene una sintáxis correcta, de lo contrario desplegaríamos algún error)_.

**Recuerden que**:

1. Un analizador léxico _(lexer)_ convierte texto _(raw-text)_ en un stream de tokens.
2. Un analizador sintáctico _(parser)_ convierte el stream de tokens en un AST.

De forma gráfica esos 2 pasos los podemos ver asi:

<p align="center">
  <img src="/img/lexerparser.png" alt="Parser y Lexer"/>
</p>

En este laboratorio realizaremos **una calculadora con un par de operaciones** e iremos un paso más adelante al implementar un **_intérprete_**, es decir no crearemos un árbol sintáctico sino que evaluaremos online las expresiones.


## 2. Gramática

La gramática con la que trabajaremos es la siguiente:

```sh
S ::= E;
E ::= E + E
  |   E - E
  |   E * E
  |   E / E
  |   E % E
  |   E ^ E
  |   - E
  |   (E)
  |   number

# number en nuestro caso significara un double
```

Esta gramática tiene un gran **problema** para nuestro **RDP**, si se recuerdan por lo visto en clase, sufre de un problema llamado **_left-recursion_**. Una de las desventajas de este tipo de parsers es que las gramáticas con las que puede trabajar son aquellas que no son recursivas hacia la izquierda y claramente esta lo es,  `E ::= E + E` por ejemplo. Así que lo que necesitamos hacer de **primero** es transformar nuestra gramática para que no tenga este problema, teniendo en cuenta siempre que el lenguaje que describe nuestra nueva gramatica _G1_ es el mismo que describe nuestra gramática _G_ original, es decir:

$$L(G1) = L(G)$$

## 3. Lexer

Para el primer ejercicio de este laboratorio, ustedes van a implementar el lexer para la gramática de nuestra calculadora utilizando **JLex**. El motivo principal de esto es para que sigan ganando práctica con esta herramienta, que surgan dudas y que los ayude a empezar/avanzar con el proyecto **_(Esperamos que la gran mayoría de personas no esté todavía en la situación de "empezar" el proyecto todavía...)_**.

Para empezar clonen el siguiente repositorio de Github Classroom:

```shell
https://classroom.github.com/a/90lt-vz3
```

Dentro del repositorio van a encontrar un archivo llamado **_lexer.lex_**, en ese archivo ustedes tienen que definir el lexer para la gramática. Dentro de ese archivo hay en forma de comentarios algunas instrucciones para guiarlos.

### 3.1 Clase Token

En el directorio de trabajo hay una clase llamada **Token** que nos va a servir para representar los tokens de la gramática y es el tipo de objeto que tenemos que devolver dentro de las acciones del lexer. Esta clase tiene 2 constructores:

1. **Token(int id, String val)**
2. **Token(int id)**

Dentro de esta clase también están definidos los IDs que representan cada token y tienen que hacer uso de ellos cuando encuentren un token. En ese archivo también están definidos otros métodos _(Con su documentación respectiva)_ que pueden ser útiles para la siguiente parte del laboratorio.

**Ejemplo:**

```java
// Asi se veria en la parte de acciones del archivo .lex
<YYINITIAL>{SEMI}   { return new Token(Token.SEMI);             }
<YYINITIAL>{NUMBER} { return new Token(Token.NUMBER, yytext()); }
```

Cuando tengan listo más de algo, pueden probar lo que hicieron utilizando el siguiente comando:

```shell
make lexer
./lexer "2 + 2;"
NUMBER : 2
+
NUMBER : 2
;
```

## 4. Parser

Para el segundo y último ejercicio de este laboratorio ustedes implementarán un **RDP**. Esta gramática es bastante simple y prácticamente se trata solo de expresiones aritméticas. Parsear expresiones de este tipo con recursive descent tiene 2 problemas:

1. En como obtener un árbol sintáctico que siga la precedencia y la asociatividad de los operadores.
2. En como hacerlo eficientemente cuando hay muchos niveles de precedencia.

En clase ustedes vieron la clásica solución para el primer problema, que a pesar de que es bastante buena y elegante, no resuelve el segundo problema. En este laboratorio les vamos a enseñar una técnica llamada **_"Shunting Yard Algorithm"_** que es más eficiente y resuelve el 1ero y 2do problema, la base de este algoritmo se encuentra hasta en las **_calculadoras chicleras_**.

### 4.1 Clase Parser

En el directorio de trabajo van a encontrar un archivo llamado **_Parser.java_**, en este archivo es donde ustedes tienen que implementar el parser. Prácticamente lo que tienen que hacer es crear una plantilla con funciones recursivas de la gramatica que modificamos _(Unos pasos más atras)_. Aquí hay unas funciones que les pueden ser útiles como **term**.

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

### 4.2 Shunting Yard Algorithm

La idea del algoritmo **_shunting yard_** es mantener los operadores en un stack hasta que todos los operandos han sido parseados. Los operandos se mantienen en un segundo stack. El algoritmo shunting yard puede utilizarse directamente para evaluar las expresiones mientras son parseadas **_(como un interprete, que es lo que vamos hacer)_**. De manera general es convertir la entrada en notación polaca inversa _(infix a postfix)_.

La idea central del algoritmo es mantener los operadores en el stack ordenados por precedencia **_(la precedencia más baja en el fondo del stack y la más alta en el top del stack)_**, por lo menos en la ausencia de paréntesis. Antes de meter un operador en el stack de operadores, todos los operadores que tienen mayor precedencia son sacados del stack. Sacar un operador del stack de operadores consiste en remover el operador y sus operandos del stack de operandos, evaluar, y meter el resultado en el stack de operandos. Al final de una expresión los operadores que quedan son sacados y evaluados con sus respectivos operandos.

La siguiente tabla ilustra el proceso para un input : **x * y + z.** El stack se va llenando a la izquierda.

* [x] **push(a)**    : hace push de a en el stack de operandos
* [x] **pushOp(op)** : hace push de un operador en el stack de operadores
* [x] **pre(op)**    : devuelve precedencia de un operador

<p align="center">
  <a href="/img/shuntingyard.png" target="_blank"><img src="/img/shuntingyard.png" alt="Shunting Yard"/></a>
</p>

Para nuestra gramática la precedencia es la siguiente de mayor a menor:

1. **"()"**
2. **"- (unary)"**
3. **"^"**
4. **"* / %"**
5. **"+ -"**

Dentro del archivo que tienen que modificar, ustedes tienen que llenar con código donde hay comentarios que dicen `/*TODO CODIGO AQUI*/`.

Para probar su RDP tienen que hacer lo siguiente:

```shell
make parser
./parser
>>> 2 + 2;
4.0
>>>
```
