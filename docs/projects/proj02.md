# Análisis Sintáctico

<p align="center">
  <img src="/img/parser.png" alt="Parser" width="200"/>
</p>


En esta asignación ustedes van a escribir un parser para COOL. La asignación hace uso de dos herramientas: el generador de parser JCup y el paquete de Java con las clases que representan los nodos de un árbol sintáctico. La salida de su parser va a ser un árbol sintáctico abstracto o AST por sus siglas en inglés. Van a construir un AST utilizando acciones semánticas del generador de parser JCup.

Ustedes van a necesitar consultar la estructura sintáctica de COOL, que se encuentra en la figura 1 del manual de referencia[^3] así como otras partes también. La documentación de JCup está disponible en línea[^2]. La documentación del paquete tree también está disponible en línea[^1]. Ustedes van a necesitar la información del paquete tree para esta y futuras asignaciones.

Hay mucha información en este documento, y necesitan saber la mayoría para poder escribir un parser funcional. Por favor lean este documento detenida y cautelosamente poniéndole mucha atención a los detalles.


## 1. Archivos y Directorios

Para empezar, creen el directorio **PA2** en su carpeta que contendrá todas las demás fases como se explicó [aquí](/projects/proj00/) y dentro de esa carpeta en una terminal (<kbd>CTRL</kbd><kbd>+</kbd><kbd>T</kbd>) escriban lo siguiente:

```sh
make -f /usr/class/cs143/assignments/PA3J/Makefile
```

Este comando va a copiar un número de archivos en su directorio que han creado. Algunos de los archivos que van a ser copiados van a ser de solo lectura (representando a estos con archivos que realmente son enlaces simbólicos hacia otros archivos). Ustedes no deberían de editar estos archivos. De hecho, si ustedes modifican estos archivos, van a encontrar imposible terminar y completar esta asignación. Vean las instrucciones en el archivo README. Los únicos archivos que tienen permitido modificar para esta asignación son:

* [x] **cool.cup**: Este archivo contiene un esqueleto que describe un parser para COOL. La sección de declaraciones está casi completa, pero van a necesitar agregar alguna que otra declaración para definir nuevos **no terminales**. Nosotros les hemos dado ya los nombres y tipos de declaración para los terminales de la gramática. Ustedes tienen que agregar declaraciones de precedencia también. La sección de reglas, sin embargo, está incompleta. Les hemos proveído algunas partes para algunas reglas. Ustedes no deberían de modificar este código para tener una solución funcional, pero está permitido que lo modifiquen si ustedes desean. Por favor, no asuman que alguna regla particular dada está completa.
* [x] **good.cl y bad.cl**: Estos archivos prueban algunas características de la gramática de COOL. Pueden modificar estos archivos como ustedes quieran para probar su parser.
* [x] **README**: Este archivo contiene instrucciones detalladas para la asignación, así como también un número de recomendaciones útiles. Realmente este archivo no lo van a modificar, pero es bueno mencionar que lo tienen que leer.

!!! warning "Advertencia"
    No modifiquen ningún archivo que no se menciona en el listado, cuando se evalue la asignación únicamente se va a probar el archivo **cool.cup** en un nuevo entorno.


## 2. Probando el Parser

Ustedes van a necesitar un lexer completamente funcional para probar el parser. Pueden utilizar su propio analizador léxico del proyecto pasado o utilizar el lexer de coolc. Por default, el lexer de coolc es utilizado, para cambiar este comportamiento, cambien el archivo ejecutable **lexer** (que es un enlace simbólico en su directorio de proyecto) con su propio lexer. No asuman automáticamente que el lexer que utilicen está libre de errores. Algunos bugs latentes en el analizador léxico pueden generar problemas misteriosos en el parser.

Ustedes van a correr su parser utilizando `./myparser`, un shell script que pega el parser con un analizador léxico (el de su elección). Noten que `./myparser` puede recibir una bandera -p para depurar el parser; utilizar esta bandera causa que un montón de información de lo que el parser está haciendo sea impreso en la terminal. JCup produce las tablas de parseo de una gramática LALR(1) bastante leíbles en un archivo llamado **cool.output**. Examinar este archivo a veces puede ser útil para depurar la definición del parser.

Ustedes deberían de probar este parser tanto en archivos bien definidos de COOL, como en malos para ver si todo está funcionando correctamente. Recuerden, los bugs en su parser se pueden manifestar en alguna otra parte más adelante. Su parser va a ser calificado utilizando nuestro analizador léxico, entonces si ustedes escogen utilizar unicamente su parser, sepan de antemano que esto está sucediendo en el autograder.

!!! tip "Recomendación"
    Nosotros les recomendamos utilizar el analizador léxico de coolc que viene por defecto, ya que este está menos propenso a errores, pero cuando ya tengan un parser funcional utilicen su propio analizar léxico para verificar que todo funcione bien.

## 3. Salida del Parser

Sus acciones semánticas deberían de construir un AST. La raíz (y solamente la raíz) del AST debería de ser de tipo `programc`. Para los programas que son parseados satisfactoriamente, la salida del parser es un listado del AST.

Para programas que contengan errores (léxicos o sintácticos), la salida son mensajes de error del parser. Nosotros les hemos proveído con una función que reporta errores imprimiendo los mensajes en un formato estándar; por favor **NO** modifiquen esto. Ustedes no deberían de invocar esta función directamente en las acciones semánticas; JCup automáticamente invoca a esta función cuando un error es detectado.

Para algunos constructs que puedan abarcar varias líneas de código, por ejemplo:

```python
foo(
  1,
  2,
  3
)
```

este dispatch abarca 5 líneas, de la 1 a la 5, ustedes cuando construyan algún nodo que abarque múltiples líneas son libres de indicar a que número de línea pertence este nodo, siempre y cuando, el número esté en el rango que abarque el nodo, en el ejemplo anterior podría ser 1, 2, 3, 4 o 5. No se preocupen si las líneas reportadas por su parser no hacen match exactamente como el compilador de referencia coolc. También su parser solo debería de funcionar para programas que estén contenidos en un solo archivo. No se preocupen por compilar múltiples archivos.

!!! tip "Recomendación"
    Siempre que reporten el número de línea utilicen la función de ayuda `:::java curr_lineno()` que se encuentra en **cool.cup**.


## 4. Manejo de Errores

Ustedes deberían de utilizar el pseudo no terminal *error* para manejar errores en el parser. El propósito de *error* es permitirle al parser continuar después de un error anticipado. No es un ***panacea*** y el parser puede volverse completamente confuso. Vean la documentación de JCup[^2] para saber como utilizar *error* correctamente. Para recibir toda la nota, su parser debería de recuperarse por lo menos en las siguientes situaciones:

* [x] Si hay algún error en una definición de clase pero la clase es terminada correctamente y la siguiente clase está correcta sintácticamente, el parser debería de ser capaz de empezar de nuevo en la siguiente definición de clase.
* [x] Similarmente, el parser debería de recuperarse de errores en las características (yendo a la siguiente característica).
* [x] En un `let`, yendo a la siguiente variable.
* [x] En un bloque, yendo a la siguiente expresión.

No se preocupen demasiado por los números de línea que aparecen en los mensajes de error que su parser genera. Si su parser está funcionando correctamente, el número de línea generalmente va a ser la línea donde se encontró el error. Para constructs erroneos que abarquen múltiples líneas, el número de línea por lo general va a ser la última línea del construct.

## 5. Observaciones

Ustedes van a necesitar declaraciones de precedencia, pero solo para las expresiones. No utilicen declaraciones de precedencia ciegamente (es decir, no resuelvan un conflicto shift-reduce en su gramática agregando reglas de precedencia hasta que ya no aparezca).

El let de COOL introduce una ambiguedad en el lenguage (traten de construir un ejemplo si es que no están convencidos). El manual resuelve esta ambiguedad diciendo que el let se extiende a la derecha tanto como se pueda. Dependiendo de como su gramática sea escrita, esta ambiguedad puede aparecer en su parser como un conflicto shift-reduce involucrando las producciones del let. Si ustedes se encuentran en esta situación, talvez quieran considerar resolver el problema utilizando características de JCup que permitan que la precedencia sea asociada a las producciones (no solamente a los operadores). Vean la documentación de JCup[^2] para obtener información en como utilizar esta característica.

Dado que el compilador `./mycoolc` utiliza **pipes** para comunicar de una fase a la siguiente, cualquier caracter extraño producido por el parser puede causar errores, en particular, el analizador semántico no pueda analizar el AST que su parser produce. Dado que cualquier print utilizado en su código puede causar que pierdan errores, por favor asegúrense de remover cualquier print de su código antes de probar el autograder de esta asignación.


## 6. Notas de Java

Ustedes deberían de declarar "tipos" para sus no terminales y los terminales que tengan valor, por ejemplo, en el archivo **cool.cup** está la declaración:

```java
nonterminal programc program;
```

Esta declaración dice que el no terminal `program` tiene tipo `programc`.

Es crítico que ustedes declaren el tipo correcto para los atributos de los símbolos de la gramática, fallar en hacerlo virtualmente hace que su parser no funcione correctamente. Ustedes no necesitan declarar tipos para los símbolos de la gramática que no tengan atributos.

El chequeo de tipos del compilador de java **javac** se puede quejar si utilizan los constructores de los nodos del árbol con el tipo incorrecto. Si ustedes corrigen los errores con casting, su programa puede lanzar una excepción cuando el constructor note que está siendo utilizado con los tipos incorrectos. También, JCup se puede quejar si crean errores de tipos.


## 7. Autograder

Ustedes deberían de descargar el siguiente script en el mismo directorio donde tienen sus archivos de la segunda fase:

```sh
wget http://raw.githubusercontent.com/CC-4/cc-4.github.io/master/assets/projects/grading/pa2-grading.pl
chmod +x pa2-grading.pl
```

y ejecutar el siguiente comando:

```sh
./pa2-grading.pl
```

Esto califica su parser utilizando el analizador léxico de coolc. Si ustedes quieren probar su parser utilizando la fase 1:

```sh
wget http://raw.githubusercontent.com/CC-4/cc-4.github.io/master/assets/projects/grading/pa2-grading-all.sh
chmod +x pa2-grading-all.sh
```

y ejecutar el siguiente comando:

```sh
./pa2-grading-all.sh
```

## Referencias

[^1]: [The Tree Package](http://web.stanford.edu/class/cs143/javadoc/cool_ast/) - Javadoc del paquete Tree.
[^2]: [JCup Manual](http://www2.cs.tum.edu/projects/cup/manual.html) - Manual de JCup
[^3]: [The Cool Reference Manual](http://web.stanford.edu/class/cs143/materials/cool-manual.pdf) - Manual de COOL.
[^4]: [Tour of the Cool Support Code](http://web.stanford.edu/class/cs143/materials/cool-tour.pdf) - Manual del Código de Soporte de COOL.
[^5]: [SPIM Manual](http://web.stanford.edu/class/cs143/materials/SPIM_Manual.pdf) - Manual de SPIM.
[^6]: [JCup Java Manual](http://web.stanford.edu/class/cs143/javadoc/java_cup/index.html) - Javadoc de JCup
