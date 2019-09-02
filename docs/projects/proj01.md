# Análisis Léxico

<p align="center">
  <img src="/img/lexer.png" alt="Lexer" width="200"/>
</p>

Para esta asignación, van a escribir un analizador léxico, también llamado lexer, utilizando un generador de analizadores léxicos llamado **JLex**. Ustedes van a describir el set de tokens para COOL en un formato adecuado y JLex va a generar el código de Java para reconocer tokens en programas escritos en COOL.


La documentación para todas las herramientas del proyecto van a estar disponibles en el material de apoyo del curso en el GES. Esto incluye los manuales de JLex[^1] (utilizado para esta asignación), la documentación para JCup (utilizado en la siguiente asignación), así como también el manual para el simulador SPIM[^4]. Ustedes deberían de trabajar en parejas o individualmente para este proyecto.


## 1. Introducción a JLex

JLex permite implementar un analizador léxico escribiendo expresiones regulares y establecer acciones cuando alguna secuencia de caracteres hace match con alguna de estas. JLex convierte estas reglas que ustedes van a definir en un archivo llamado **lexer.lex** en un archivo de Java con el código que implementa un autómata finito que puede reconocer estas expresiones regulares que ustedes especificaron en el archivo *lexer.lex*. Afortunadamente, no es necesario entender o incluso mirar lo que automáticamente genera JLex. Los archivos que entiende JLex estan estructurados de la siguiente manera:

```flex
%{
Declaraciones
%}
Definiciones
%%
Reglas
%%
Subrutinas de Usuario
```

Las secciones de **Declaraciones** y **Subrutinas de Usuario** son opcionales y les permite a ustedes escribir declaraciones y funciones de ayuda en Java. Las sección de *Definiciones* también es opcional, pero en general es bastante útil porque las definiciones les permiten a ustedes darle nombres a las expresiones regulares. Por ejemplo, la siguiente definición:

```java
DIGIT = [0-9]
```

Les permite definir un dígito. Aquí, **DIGIT** es el nombre que se le da a la expresión regular que hace match con cualquier caracter que esté entre 0 y 9. La siguiente tabla les da una vista general de expresiones regulares comunes que pueden ser especificadas en JLex.

| Expresión |                     Descripción                     |
|:---------:|:---------------------------------------------------:|
|     x     |                   el caracter "x"                   |
|    "x"    |      caracter "x", incluso si x es un operador.     |
|     \x    |      caracter ”x”, incluso si x es un operador.     |
|    [xy]   |                  el caracter x o y                  |
|   [x-z]   |                los caracteres x, y, z               |
|    [^x]   |              cualquier caracter menos x             |
|     .     |           cualquier caracter menos newline          |
|     ^x    |          caracter x al inicio de una linea          |
|    <y>x   |     caracter x cuando JLex esta en el estado <y>    |
|     x$    |           caracter x al final de una linea          |
|     x?    |              el caracter x es opcional              |
|     x*    |         el caracter x aparece 0 o más veces         |
|     x+    |         el caracter x aparece 1 o más veces         |
|    x\|y    |                    caracter x o y                   |
|    (x)    |                      caracter x                     |
|    x/y    | caracter x si y solo si es seguido de un caracter y |
|    {xx}   |          hace referencia a la definición xx         |
|   x{m,n}  |         caracter x aparece entre m y n veces        |


La parte más importante de su analizador léxico es la sección de reglas. Una regla en JLex especifica una acción a tomar si la entrada hace match con la expresión regular o definición al principio de la regla. La acción a tomar es especificada escribiendo código de Java regular. Por ejemplo, asumiendo que un dígito representa un token en nuestro lenguaje (noten que este no es el caso de COOL), la regla sería entonces:

```java
{DIGIT} {
  AbstractSymbol num = AbstractTable.inttable.addString(yytext());
  return new Symbol(TokenConstants.INT_CONST, num);
}
```

Esta regla guarda el valor del dígito en una variable global `:::java AbstractTable.inttable` y retorna el código apropiado para el token.

!!! note "Nota"
    Vean la sección [4](#4-notas-de-java) para una discusión más detallada de la variable global `:::java AbstractTable.inttable` y vean la sección [3.2](#32-tabla-de-strings) para una discusión sobre como `:::java AbstractTable.inttable` es utilizado en el código de arriba.


Un punto importante a recordar es que la entrada actual (es decir, el resultado de llamar a la función `:::java next_token()`) puede hacer match con múltiples reglas, JLex toma la regla que hace match con el mayor número de caracteres. Por ejemplo, si ustedes definieran las siguientes dos reglas:

```java
[0-9]+      { // action 1 }
[0-9a-z]+   { // action 2 }
```

y si la secuencia de caracteres "2a" aparece en el archivo que está siendo analizado, entonces la acción 2 va a tomarse, dado que la segunda regla hace match con más caracteres que la primer regla. Si múltiples reglas hacen match con la misma cantidad de caracteres, entonces la regla que aparece primero es la que se toma.

Cuando escriban reglas en JLex, va a ser necesario que se tomen diferentes acciones dependiendo de los tokens encontrados anteriormente. Por ejemplo, cuando esten procesando un token que representa el *cierre de un comentario*, a ustedes les va a interesar saber si un token que representa *abrir comentario* se ha encontrado anteriormente. Una forma obvia de tener registro de esto es declarar variables globales en la sección de declaraciones de JLex, que son cambiadas a verdadero cuando ciertos tokens de interés son encontrados. JLex también provee una sintáxis fácil (*syntatic sugar*) para poder lograr una funcionalidad similar utilizando declaraciones de estados como:

```java
%state COMMENT
```

que puede ser cambiado a `true` escribiendo `:::java yybegin(COMMENT)`. Para tomar una acción si y solo si un token que representa *abrir comentario* ha sido encontrado anteriormente. Pueden agregarle un predicado a su regla utilizando la siguiente sintáxis:

```java
<COMMENT> reg_exp {
  // action
}
```

Hay un estado default llamado `:::java YYINITIAL` que está activo a menos que ustedes explicitamente indiquen el inicio de un nuevo estado utilizando `:::java yybegin(STATE)`. Ustedes pueden encontrar útil esta sintaxis para varios aspectos de esta asignación, as como reportar errores. Nosotros les recomendamos que lean detenidamente la documentación de JLex que está en el material de apoyo del curso en el GES antes de empezar a escribir su analizador léxico.

## 2. Archivos y Directorios

Para empezar, creen el directorio **PA1** en su carpeta que contendrá todas las demás fases como se explicó [aquí](/projects/proj00/) y dentro de esa carpeta en una terminal (<kbd>CTRL</kbd><kbd>+</kbd><kbd>T</kbd>) escriban lo siguiente:

```sh
make -f /usr/class/cs143/assignments/PA2J/Makefile
```

Noten que a pesar que esta es la primera asignación, el directorio se llama **PA2**. Todas las asignaciones futuras van a tener un nombre de directorio que es un número mayor a la asignación. Esta situación sucede debido a que nos saltamos la primer asignación en este curso. Este comando va a copiar un número de archivos en su directorio que han creado. Algunos de los archivos que van a ser copiados van a ser de solo lectura (representando a estos con archivos que realmente son enlaces simbólicos hacia otros archivos). Ustedes no deberían de editar estos archivos. De hecho, si ustedes modifican estos archivos, van a encontrar imposible terminar y completar esta asignación. Vean las instrucciones en el archivo README. Los únicos archivos que tienen permitido modificar para esta asignación son:

* [x] **cool.lex**: Este archivo contiene un esqueleto para una descripción léxica de COOL. Hay comentarios que indican donde ustedes tienen que llenar con código, pero esto no es necesariamente una guía completa. Una parte de la asignación es que ustede se aseguren que tienen un analizador léxico funcional. Exceptuando las secciones indicadas, ustedes son libres de hacer modificaciones a su esqueleto. Ustedes, de hecho, pueden generar un lexer con el archivo base pero este no hace mucho todavía. Cualquier función de ayuda que ustedes deseen escribir tiene que ser añadida directamente a este archivo en la sección apropiada (vean los comentarios en el archivo).
* [x] **test.cl**: Este archivo contiene un programa de COOL ejemplo para que sea analizado. Este archivo no representa toda la especificación léxica del lenguaje COOL, pero de todas maneras es una prueba interesante. Siéntanse libres de modificar este archivo para probar su analizador léxico.
* [x] **README**: Este archivo contiene instrucciones detalladas para la asignación, así como también un número de recomendaciones útiles. Realmente este archivo no lo van a modificar, pero es bueno mencionar que lo tienen que leer.

!!! warning "Advertencia"
    No modifiquen ningún archivo que no se menciona en el listado, cuando se evalue la asignación únicamente se va a probar el archivo **cool.lex** en un nuevo entorno.


## 3. Resultados del Lexer

En esta asignación, ustedes tiene que escribir reglas de JLex que hagan match con las expresiones regulares apropiadas que definan los tokens validos en COOL así como se describe en la sección número 10 y figura 1 del manual de COOL[^2] y tomar las acciones apropiadas, así como retornar un token del tipo correcto, guardar el valor del lexema cuando sea necesario, o reportar un error cuando un error se encuentra. Antes de empezar con esta asignación, asegúrense de haber leído la sección 10 y la figura 1 del manual de COOL[^2], luego estudien los diferentes tokens que están definidos en el archivo **TokenConstants.java**. Su implementación necesita definir reglas de JLex que hagan match con las expresiones regulares definidas para cada token descrito en el archivo **TokenConstants.java** y tomar la acción apropiada para cada token. Por ejemplo, si ustedes hacen match del token `BOOL_CONST`, su analizador léxico tiene que guardar el su valor ya sea que sea `true` o `false`; similarmente si hacen match con el token `TYPEID`, ustedes van a tener que guardar el nombre del tipo. Noten que no todos los tokens requieren que se guarde información adicional; por ejemplo, es suficiente que solo se devuelva el tipo de token con el que se hizo match, así como cuando se hace match con algún keyword del lenguaje como `:::java class`.  

Su lexer debe de ser robusto, debería de funcionar con cualquier input. Por ejemplo, deberían de manejar errores como cuando se encuentra un caracter de `EOF` en medio de un string o comentario, así como también, como cuando se encuentra con un string que es demasiado largo. Estos son solo algunos de los errores que pueden ser encontrados, lean el manual[^2] para conocer el resto. Ustedes tienen que terminar su análisis de forma **elegante** si algún error fatal ocurre. Las excepciones no manejadas **NO** son aceptables.

### 3.1 Manejo de Errores

Todos los errores deberían de ser pasados al parser. Su lexer no debería de imprimir **NADA**. Los errores se comunican al parser retornando un token de error especial llamado `ERROR` junto con el mensaje de error.

!!! note "Nota"
    Ustedes berían de ignorar el token `error` definido tambien en **TokenConstants.java** y no el token `ERROR`
    para esta asignación ya que este es utilizado únicamente en el parser.

Hay varios requerimientos para reportar errores y recuperarse de errores léxicos:

* [x] Cuando un caracter inválido (alguno que no puede ser algún token) se encuentra, un string que contenga solo ese caracter debería de ser retornado como el error. Tienen que resumir el análisis con el siguiente caracter.
* [x] Si un string contiene un newline sin escape (`\\`), tienen que reportar el error como **"Unterminated string constant"** y resumir el análisis léxico al principio de la siguiente línea. Esto quiere decir que estamos asumiendo que el usuario simplemente olvido cerrar el string con una comilla.
* [x] Cuando un string es demasiado largo, tienen que reportar el error **"String constant too long"**. Si el string contiene caracteres inválidos (por ejemplo, el caracter nulo `\\0`), tienen que reportar esto como **"String contains null character"**. En cualquier caso, el análisis debería de continuar hasta el final del string. El final del string es definido tanto como:
    1. El principio de la siguiente línea si un newline es encontrado después de encontrar el error.
    2. Después de cerrar el string con `"`.
* [x] Si un comentario se queda abierto y se encuentra el caracter `EOF`, se tiene que reportar este error con **"EOF in comment"**. Por favor no tokenizen el contenido de los comentarios simplemente porque no se ha cerrado. Similarmente con los strings, si un `EOF` es encontrado, reporten el error como **"EOF in string constant"**.
* [x] Si miran un `*)` fuera de un comentario, tienen que reportar el error como **"Unmatched \*)"**, en vez de tokenizar esta secuencia de caracteres como `*` y como `)`.
* [x] Recuerden de las clases teóricas que en esta fase del compilador solo agarra una clase bien limitada de errores. No tomen en cuenta ni verifiquen errores que no son errores léxicos en esta asignación. Por ejemplo, no deberían de verificar si las variables han sido declaradas anteriormente. Asegúrense de entender que errores la fase de análisis léxico puede considerar y cuales no antes de empezar.


### 3.2 Tabla de Strings

Los programas tienden a tener muchas ocurrencias del mismo lexema. Por ejemplo, un identificar es generalmente referenciado múltiples veces dentro de un programa (de lo contrario no sería bastante útil). Para ahorrarnos un poco de espacio y tiempo, una práctica común en compiladores es guardar los lexemas en una tabla de strings. Nosotros les proveemos una implementación en Java para esto. Vean las siguientes secciones para más detalles.

Hay un problema en decidir como manejar los identificadores especiales para las clases básicas (Object, Int, Bool, String), SELF_TYPE y self. Sin embargo, estos no son un problema hasta en las fases posteriores del compilador. El lexer debería de tratar estos identificadores especiales exactamente como otro identificador cualquiera. No verifiquen que las literales enteras caben dentro de la representación especificada en el manual de COOL[^2]. Simplemente creen un **Symbol** con el literal completo como el contenido del token, sin importar su tamaño.


### 3.3 Strings

Su analizador léxico deberia de convertir los caracteres que se les antepone un caracter de escape en las constantes string a sus valores correctos. Por ejemplo, si el programador escribe los siguientes ocho caracteres:

<p align="center">
  <img src="/img/strings1.png" alt="Ejemplo strings 1">
</p>

Su analizador léxico va a retornar un token `STR_CONST` cuyo valor semántico es estos 5 caracteres:

<p align="center">
  <img src="/img/strings2.png" alt="Ejemplo strings 2">
</p>

Donde `\n` representa el caracter de newline de la tabla ASCII. Siguiendo la especificación de la página 15 del manual de COOL[^2], ustedes deberían de retornar un error para un string que contenga el caracter null. Sin embargo, la secuencia de estos dos caracteres:

<p align="center">
  <img src="/img/strings_null1.png" alt="Ejemplo strings 3">
</p>

Debería de ser convertida a un caracter:

<p align="center">
  <img src="/img/strings_null2.png" alt="Ejemplo strings 4">
</p>

### 3.4 Otras notas

Su analizador léxico debería de mantener una variable llamada **curr_lineno**, que indica que línea del archivo de entrada está siendo analizada. Esto va a ayudar al parser a imprimir mensajes de error útiles. Ustedes deberían de ignorar el token `LET_STMT`. Es utilizado únicamente por el parser. Finalmente, noten que si la especificación léxica está incompleta (algunas entradas no tienen expresiones regulares que hagan match), entonces el lexer generado por JLex va a realizar cosas no deseables. Asegúrense de que su especificación esté completa.

## 4. Notas de Java

* [x] Cada llamada al lexer retorna el siguiente token y lexema de la entrada. El valor retornado por el método `:::java CoolLexer.next_token` es un objeto de la clase `:::java java_cup.runtime.Symbol`. Este objeto tiene un campo que representa el tipo del token (por ejemplo si es un entero, punto y coma, dos puntos, etc). Los códigos sintácticos o los tipos de cada token están definidos en el archivo **TokenConstants.java**. El componente, el valor semántico o lexema (si el token tiene), también es colocado en el objeto `:::java java_cup.runtime.Symbol`. La documentación para la clase `:::java java_cup.runtime.Symbol` está disponible en las referencias[^5]. Algunos ejemplos también están en el archivo base.
* [x] Para los identificadores de clase, de objeto, enteros y strings, el valor semántico tiene que ser de tipo `:::java AbstractSymbol`. Para las constantes booleanas, el valor semántico es de tipo `:::java java.lang.Boolean`. Excepto para los errores (vean abajo), los lexemas para otros tokens no tienen ninguna información interesante. Dado que el campo value en la clase `:::java java_cup.runtime.Symbol` es de tipo Object, ustedes van a necesitar castear este valor antes de utilizarlo o utilizar métodos con el valor.
* [x] Nosotros les proveemos con una implementación para esto, que esta definida en el archivo **AbstractTable.java**. Por el momento, ustedes solo necesitan saber que el tipo de entrada a estas tablas es de tipo `:::java AbstractSymbol`.
* [x] Cuando un error léxico occura, la rutina `:::java CoolLexer.next_token` debería de retornar un `:::java java_cup.runtime.Symbol` cuyo tipo es `:::java TokenConstants.ERROR` y cuyo valor semántico es el mensaje de error.

## 5. Probando su Lexer

Hay al menos dos maneras en la que ustedes pueden probar su analizador léxico. La primer forma es generar archivos de entrada y correrlos utilizando su lexer, que imprime la línea y el lexema de cada token encontrado por su lexer. La otra forma, cuando piensen que su lexer esté funcionando correctamente, prueben correr `./mycoolc` para correr su lexer junto con otras fases del compilador (que nosotros les proveemos). Esto va a ser un compilador completo de COOL que pueden probar en cualquier programa.

## 6. Autograder

Ustedes deberían de bajar el siguiente script en el mismo directorio donde se encuentran sus archivos de la fase número 1.

```sh
wget http://raw.githubusercontent.com/CC-4/cc-4.github.io/master/assets/projects/grading/pa1-grading.pl
chmod +x pa1-grading.pl
```

Cada vez que quieran ejecutar el autograder deberían de hacer lo siguiente:


```sh
./pa1-grading.pl
```

## Referencias

[^1]: [JFlex Manual](http://www.cs.princeton.edu/~appel/modern/java/JLex/) - Manual de JLex.
[^2]: [The Cool Reference Manual](http://web.stanford.edu/class/cs143/materials/cool-manual.pdf) - Manual de COOL.
[^3]: [Tour of the Cool Support Code](http://web.stanford.edu/class/cs143/materials/cool-tour.pdf) - Manual del Código de Soporte de COOL.
[^4]: [SPIM Manual](http://web.stanford.edu/class/cs143/materials/SPIM_Manual.pdf) - Manual de SPIM.
[^5]: [JCup Java Manual](http://web.stanford.edu/class/cs143/javadoc/java_cup/index.html) - Javadoc de JCup
