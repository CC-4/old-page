# CNOOL y Analizador Léxico

En este lab implementarán la primera fase de un compilador, un analizador léxico, para una version sin objetos de COOL. Lo llamaremos CNOOL ***Classroom Not Object Oriented Language***.

Un analizador léxico conforma la primer parte de un compilador. La función principal de un analizador léxico es tomar una cadena de caracteres y separarla en tokens. Cada uno de estos tokens representa un símbolo del lenguaje de programación.

Con el objetivo de ayudarlos en su proyecto, a lo largo de los labs implementaremos fases del proyecto en lenguajes más simples, como ahorita con CNOOL dejando de lado los objetos y los comentarios y diciendo que únicamente existen tres tipos básicos: String, Int y Bool.

La gramática que usarán es una versión modificada de la gramática de COOL, la llamaremos CNOOL:


```sh
program ::= [feature]+
feature ::= ID([formal[,formal]*]) : TYPE {expr};
formal  ::= ID : TYPE
expr    ::= ID <- expr
        |   ID([expr[,expr]*])    
        |   ID : TYPE [<- expr]
        |   {[expr;]+}
        |   expr + expr
        |   expr - expr
        |   expr * expr
        |   expr / expr
        |   ~ expr
        |   expr < expr
        |   expr <= expr
        |   expr = expr
        |   not expr
        |   (expr)
        |   ID
        |   integer
        |   string
        |   true
        |   false
```

Para reciclar los archivos que ya tienen instalados en su máquina, emplearemos el mismo comando que deben utilizar para el proyecto 1:


```sh
make -f /usr/class/cs143/assignments/PA2J/Makefile
```

De todos los archivos que se copiarán, únicamente deben de modificar **cool.lex**, y agregar las expresiones regulares necesarias para que se generen los tokens de la gramática. Por razones de funcionamiento, no modificaremos el archivo **TokenConstants.java**, que contiene todos los tokens necesarios para el proyecto. Para facilitar la implementación, retiraremos los comentarios y los strings multilínea, así como el soporte para el caracter ‘\n’ de ellos. Tienen consultar el manual de JLex[^1] para este laboratorio.

## Referencias

[^1]: [JFlex Manual](http://www.cs.princeton.edu/~appel/modern/java/JLex/) - Manual de JLex.
