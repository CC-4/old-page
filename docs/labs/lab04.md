# Conociendo Cup

<p align="center">
  <img src="/img/cup_logo.gif" alt="JCup"/>
</p>

En este laboratorio aprenderán a utilizar JCup, el analizador sintáctico que utilizarán en la fase 2 de su proyecto.

## 1. Introducción

Descarguen todos los archivos del siguiente repositorio:

```
https://classroom.github.com/a/R9VITTN8
```

Ahora que han terminado la fase 1 de su proyecto, saben utilizar JLex para el análisis léxico de una cadena de caracteres. Como han visto en clase, el análisis sintáctico se basa en gramáticas, y tiene algoritmos muy bien definidos para poder ser implementado. Para prepararlos para la fase 2, utilizaremos una herramienta llamada JCup, que funciona para analizar la sintáxis de un texto dado.

Al igual que JLex, JCup cuenta con una sección en donde se colocan las funciones que posteriormente se copiarán en la clase generada, en este laboratorio no utilizaremos esta funcionalidad, pero les será útil para su proyecto. Luego existe una lista de símbolos terminales, como los paréntesis, los dígitos, etc., seguido de
una lista de símbolos no terminales. Tanto los símbolos terminales como los no terminales pueden tener un tipo definido:

```java
terminal PLUS, MINUS, MULT;
terminal Integer INTEGER;
terminal Float FLOAT;
```

Luego pueden especificar una precedencia. Por ejemplo, una multiplicación se debe hacer antes que una suma. Para este tipo de precedencia deben
emplear "precedence left", como en el siguiente ejemplo:


```java
precedence left PLUS, MINUS;
precedence left TIMES;
```

Seguido de eso, van todas las reglas de producción. Siguiendo la siguiente sintáxis, en donde `RESULT` es la derivación usando bottom-up parsing.

```java
parent_expr ::= LPAREN expr:e RPAREN {: RESULT = e; :};
```

## 2. Lexer

La gramática con la que trabajaremos es la siguiente:

```sh
S         ::= S expr_part
          |   expr_part ;
expr_part ::= expr ;
expr      ::= exprI | exprF
exprI     ::= I + I
          |   I - I
          |   I * I
          |   I / I
          |   I % I
          |   (I)
exprF     ::= I + F
          |   F + I
          |   F + F
          |   I - F
          |   F - I
          |   F - F
          |   I * F
          |   F * I
          |   F * F
          |   I / F
          |   F / I
          |   F / F
          |   I ^ F
          |   F ^ I
          |   F ^ F
          |   sin I
          |   sin F
          |   cos I
          |   cos F
          |   tan I
          |   tan F
          |   (F)

# donde I es un entero y F es un float.
```

Para la primer parte deben completar el archivo **calculator.lex** generando los tokens necesarios para una calculadora con operaciones básicas y que maneje tanto floats como enteros. Noten que las funciones trigonométricas no son case sensitive, por lo que "sin" y "sIN" son aceptadas de igual manera. Esta es la lista de tokens que debe tener:

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

Si analizan la gramática, pueden ver que una expresión puede ser una expresión entera, o una expresión de punto flotante. Más adelante verán que esta gramática se puede simplificar dejando la distinción entre enteros y floats al analizador semántico.

## 3. Parser

Para la segunda parte, ustedes deben completar el archivo **calculator.cup**, agregando las reglas de derivación bottom-up. Pueden agregar tantos símbolos no terminales como quieran, pero no pueden modificar ninguno de los símbolos terminales. Una vez agregadas todas las reglas de derivación, pueden compilar su archivo de la siguiente manera:

```shell
sh make.sh
```

y para correrlo:

```shell
sh calculator.sh
```

Así se deberá de ver al probarlo:

```shell
2 + 2;
= 4;
4 * cos(0.41e1 ^ 2);
= -1.807120;
```

!!! note "Nota"
    Noten que el argumento de las funciones trigonométricas está en radianes.


Una vez terminado, tienen que realizar un commit de los archivos .cup y .lex y subir al GES el link de su repositorio.


## Referencias

[^1]: [JCup Manual](http://www2.cs.tum.edu/projects/cup/manual.html) - Manual de JCup
[^2]: [JCup Java Manual](http://web.stanford.edu/class/cs143/javadoc/java_cup/index.html) - Javadoc de JCup
