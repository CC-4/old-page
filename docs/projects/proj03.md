# Análisis Semántico

<p align="center">
  <img src="/img/semant.png" alt="Semantic" width="200"/>
</p>

En está asignación, ustedes van a implementar el análisis semántico para COOL. Ustedes van a utilizar el AST construido por el parser para verificar si el programa está correcto semánticamente siguiendo la especificación de COOL. Su analizador semántico debería de rechazar programas erroneos; para programas que estén correctos, debería de reunir información que va a ser utilizada por el generador de código. La salida del analizador semántico va a ser un AST anotado utilizado por su generador de código.

Esta asignación tiene más libertad para tomar decisiones de diseño que las últimas dos asignaciones. Su programa va a ser correcto si puede verificar programas reflejando la especificación. No hay una sola solución para esta asignación, pero hay muchas malas maneras de implementarla. Hay un número de practicas estándar que creemos que hacen la vida más fácil, y los vamos a tratar de inculcar estas prácticas en ustedes. Sin embargo, lo que ustedes hagan es su responsabilidad, cualquier cosa que ustedes decidan hacer, estén preparados para justificarla y explicarla.

Ustedes van a necesitar referirse a las reglas de inferencia de tipos descritas en el manual de referencia de COOL[^2]. Ustedes también van a necesitar agregar métodos y atributos a los nodos del AST para esta fase. Las funciones que el paquete tree provee están documentadas en el Manual del código de soporte de COOL[^3].

Hay mucha información en este documento, y ustedes necesitan saber la mayoría de esta información para crear un analizador semántico funcional. Por favor lean esta asignación detenida y cuidadosamente. A alto nivel, su analizador semántico debería de poder lograr las siguientes tareas:

* [x] Ver todas las clases y construir un grafo de herencia.
* [x] Verificar que el grafo esté bien formado.
* [ ] Para cada clase:
    * [x] Atravesar el AST, reuniendo todas las declaraciones visibles en una tabla de símbolos.
    * [x] Verificar que los tipos de cada expresión sean correctos.
    * [x] Anotar el AST con tipos.


Esta lista de tareas podría no ser exhaustiva, es responsabilidad de ustedes de implementar la especificación descrita en el manual.


## 1. Archivos y Directorios

Para empezar, creen el directorio **PA3** en su carpeta que contendrá todas las demás fases como se explicó [aquí](/projects/proj00/) y dentro de esa carpeta en una terminal (<kbd>CTRL</kbd><kbd>+</kbd><kbd>T</kbd>) escriban lo siguiente:

```sh
make -f /usr/class/cs143/assignments/PA4J/Makefile
```

Este comando va a copiar un número de archivos en su directorio que han creado. Algunos de los archivos que van a ser copiados van a ser de solo lectura (representando a estos con archivos que realmente son enlaces simbólicos hacia otros archivos). Ustedes no deberían de editar estos archivos. De hecho, si ustedes modifican estos archivos, van a encontrar imposible terminar y completar esta asignación. Vean las instrucciones en el archivo README. Los únicos archivos que tienen permitido modificar para esta asignación son:

* [x] **cool-tree.java**: Este archivo contiene definiciones de los nodos del AST y es el archivo principal de su implementación. Ustedes van a necesitar agregar código para su analizador semántico en este archivo. El analizador semántico es llamado utilizando el método `smenat()` de la clase `programc`. No modifiquen las declaraciones existentes.
* [x] **ClassTable.java**: Esta clase es un placeholder para algunos métodos útiles (incluyendo reporte de errores e inicialización de las clases básicas). Pueden utilizar este archivo y mejorarlo para su analizador semántico.
* [x] **TreeConstants.java**: Este archivo define algunos AbstractSymbol útiles.
* [x] **good.cl y bad.cl**: Estos archivos prueban algunas características semánticas de COOL. Ustedes deberían de agregar tests que aseguren que good.cl tome en cuenta combinaciones semánticas legales (tantas como se puedan) y en bad.cl lo contrario combinaciones semánticas ilegales. No es posible tomar en cuenta todas estas combinaciones en un solo archivo, ustedes son responsables de cubrir la mayoría de estas. Expliquen sus pruebas en estos archivos y pongan cualquier comentario en el archivo README.
* [x] **SemantErrors.java**: Este archivo contiene métodos que generan los errores correspondientes para el análisis semántico.
* [x] **README**: Este archivo contiene instrucciones detalladas para la asignación, así como también un número de recomendaciones útiles. En este archivo deberían de colocar el diseño de su implemetanción y porque su solución es correcta.

## 2. Atravesar el AST

Como resultado de la asignación 2, su parser construye un AST. El método `dump_with_types`, definido en la mayoría de nodos del AST, ilustra como atravesar el AST y reunir información de el. Esto refleja un estilo de algoritmo recursivo para atravesar el árbol. Esto es bastante importante, porque es una manera natural de estructurar varios cálculos en un AST.

Su tarea de programación en esta asignación es, primero atravesar el árbol, segundo manejar varias piezas de información que ustedes reunan del árbol y tercero utilizar esa información para forzar la semántica de COOL. Atravesar el árbol una vez se le suele llamar una "pasada". Ustedes probablemente van a necesitar hacer almenos dos pasadas sobre el AST para verificar todo.

Ustedes van a necesitar agregar información adicional en los nodos del AST. Para hacer esto, van a necesitar editar el archivo **cool-tree.java** directamente.

## 3. Herencia

Las relaciones de herencia especifican un grafo dirigido de dependencias de clases. Un requerimiento típico de la mayoría de lenguajes con herencia es que el grafo de herencia no tenga ciclos. Es responsabilidad de ustedes que su analizador semántico asegure esto. Una manera relativamente fácil de hacer esto, es construir una representación del grafo de tipos y luego verificar los ciclos. ¿Se recuerdan de cómo representabamos un grafo en CC2 y cómo podemos encontrar ciclos?

Adicionalmente, COOL tiene restricciones en heredar de las clases básicas (vean el manual[^2]). Es también un error si la clase `A` hereda de la clase `B` pero la clase `B` no está definida.

El esqueleto del proyecto incluye definiciones apropiadas de todas las clases básicas. Ustedes van a necesitar incorporar estas clases en el grafo de herencia. Les sugerimos que dividan su análisis semántico en dos pequeños componentes. Primero, verificar que el grafo de herencia esté bien definido, es aceptable abortar la compilación (después de imprimir los errores apropiados en consola, ¡por supuesto!). Segundo, verificar todas las demás condiciones semánticas. Es más fácil de implementar este segundo componente si uno sabe que el grafo de herencia y que este es correcto.

## 4. Scopes y Variables

Una gran porción del análisis semántico es manejar los nombres de variables. El problema en específico es determinar que declaración está activa para cada uso de una variable o identificador, especialmente cuando un nombre de variable puede ser reutilizado. Por ejemplo, si `i` es declarado en dos expresiones `let`, una anidada dentro de la otra, entonces en cualquier momento que `i` sea referenciado la semántica de COOL especifica que declaración de estas dos está activa. Es trabajo del analizador semántico guardar un registro de que declaración hace referencia a una variable.

Como se discutió en clase, una tabla de símbolos es una estructura de datos conveniente para manejar nombres de variable y scopes. Ustedes pueden utilizar nuestra implementación de una tabla de símbolos para este proyecto. Nuestra implementación provee métodos para entrar, salir y aumentar los scopes como sea posible. Ustedes son libres de implementar su propia tabla de símbolos también, es como ustedes prefieran.

Además del identificador `self`, que está implicitamente definido en cada clase, hay cuatro maneras que un objeto pueda ser introducido en COOL:

1. Definiciones de atributos de clase.
2. Parámetros formales en los métodos.
3. Expresiones let.
4. Los branches de un case.

Adicionalmente a los nombres de variables, hay nombres de métodos y nombres de clases. Es un error utilizar cualquier nombre que no tenga una declaración correspondiente. En este caso, sin embargo, el analizador semántico no debería de abortar la compilación después de descubrir este tipo de errores. Recuerden, ni los métodos, ni las clases, ni los atributos necesitan ser declarados antes de ser utilizados, esto es por ejemplo que dentro del método `main` se mande a llamar al método `foo` y este método esté declarado más abajo en el archivo. Piensen cómo esto afecta su análisis semántico.


## 5. Verificación de Tipos

La verificación de tipos es otra función principal del analizador semántico. El analizador semántico tiene que verificar que tipos validos sean declarados en donde sea requerido. Por ejemplo, los tipos de retorno de los métodos tienen que ser declarados. Utilizando esta información, el analizador semántico tiene que verificar también que la expresión dentro del método tiene un tipo válido de acuerdo a las reglas de inferencia. Las reglas de inferencia están detalladas en el manual de referencia de COOL[^2] y también fueron explicadas en clase.

Un problema difícil es que hacer si una expresión no tiene un tipo valido de acuerdo a las reglas. Primero, un error se debería de imprimir con el número línea y una descripción de que fue lo que estuvo mal.

!!! tip "Recomendación"
    Utilicen la clase de ayuda **SemantErrors.java** para imprimir los errores necesarios durante el análisis semántico.

Es relativamente fácil dar mensajes de error coherentes, porque generalmente es obvio que error es. Nosotros esperamos que ustedes den mensajes de error informativos de acuerdo a lo que se encuentra en **SemantErros.java**. Segundo, el analizador semántico tiene que tratar de recuperarse y continuar. Nostros si esperamos que su analizador semántico se recupere, pero no esperamos que evite errores en cascada. Un mecanismo de recuperación simple es asignar el tipo `Object` a cualquier expresión que no se le pueda dar un tipo (nostros utilizamos esto en coolc).

## 6. Interfaz con CodeGen

Para que el analizador semántico funcione correctamente con el resto del compilador de COOL, algunas precauciones tienen que tomarse en cuenta para que la interfaz con el generador de código sea correcta. Nostros hemos adoptado una simple e ingenua interfaz para evitar reducir sus impulsos de creatividad en el análisis semántico. Sin embargo, una cosa más tienen que hacer. Para cada nodo expression, su campo de tipo tiene que ser cambiado al `Symbol` que fue inferido por su analizador semántico. Este `Symbol` debería de ser el resultado de utilizar el método `addString` en fases anteriores en la tabla `idtable`. La expresión especial `no_expr` tiene que ser asignada con el tipo `No_type` que es un símbolo predefinido en el esqueleto del proyecto.

## 7. Salida Esperada

Para programas que esten incorrectos semánticamente, la salida de su analizador semántico son mensajes de error. Nosotros esperamos de ustedes que se puedan recuperar de la mayoría de errores exceptuando errores de herencia. También se espera de ustedes que produzcan un mensajes de error informativos de acuerdo a **SemantErros.java** vean este archivo para imprimir los errores. Asumiendo que la herencia está bien formada, el analizador semántico debería de agarrar y reportar todos los errores semánticos en el programa.  

Para programas que estén correctos semánticamente, la salida es un AST anotado. Ustedes van a ser calificados si su analizador semántico anota correctamente el AST con tipos y cuando funcione correctamente con el generador de código de coolc.


## 8. Probando el Analizador

Van a necesitar un analizador léxico y sintáctico para probar su analizador semántico. Pueden utilizar sus implementaciones a estas fases o utilizar las que nosotros les proveemos. Por defecto, las que nosotros les proveemos son utilizadas, para cambiar este comportamiento tienen que cambiar los archivos `lexer` y `parser` con sus propias implementaciones. De todas maneras el autograder principal de este proyecto utiliza los analizadores del compilador de COOL **coolc**.

Ustedes pueden probar su analizador semántico utilizando `./mysemant`, que es un shell script que "pega" el analizador con las fases anteriores. Noten que `./mysemant` pueden tomar una bandera -s para depurar el analizador. Utilizar esta bandera hace que la bandera `debug` se cambie a verdadero, esta está definida en el archivo **Flags.java**. Agregar el código que hace la depuración es su responsabilidad. Vean el README para más detalles.

Una vez que estén bastante confiados de que su analizador está funcionando correctamente, tratan correr `./mycoolc` para invocar su analizador con todas las fases del compilador. Ustedes deberían de probar este compilador en archivos de entrada buenos y malos, para ver si funciona correctamente. Recuerden, los bugs en el análisis semántico pueden manifestarse en el código generado o solo cuando el programa compilado sea ejecutado con spim[^4].

## 9. Observaciones

El análisis semántico es la fase más larga y compleja hasta el momento del compilador. Nuestra solución es de aproximadamente 1,300 líneas de código bien documentadas en C++. Ustedes van a encontrar esta asignación fácil si se toman un tiempo para diseñar el verificador de tipos antes de programar. Pregúntense a ustedes mismos lo siguiente:

1. [x] ¿Qué requerimientos necesito verificar?
2. [x] ¿Cuándo necesito verificar un requerimiento?
3. [x] ¿Cuándo la información es requerida para verificar un requerimiento?
4. [x] ¿Dónde está la información que necesito para verificar un requerimiento?

Si ustedes pueden contestar estas preguntas para cada aspecto de COOL, implementar a solución debería de ser **AS EASY AS PIE**.

## 10. Autograder

Ustedes deberían de descargar el siguiente script en el mismo directorio donde tienen sus archivos de la tercera fase:

```sh
wget http://raw.githubusercontent.com/CC-4/cc-4.github.io/master/assets/projects/grading/pa3-grading.pl
chmod +x pa3-grading.pl
```

y ejecutar el siguiente comando:

```sh
./pa3-grading.pl
```

Esto califica su parser utilizando el analizador léxico de coolc. Si ustedes quieren probar su parser utilizando su fase 1 y 2:

```sh
wget http://raw.githubusercontent.com/CC-4/cc-4.github.io/master/assets/projects/grading/pa3-grading-all.sh
chmod +x pa3-grading-all.sh
```

y ejecutar el siguiente comando:

```sh
./pa3-grading-all.sh
```

## Referencias

[^1]: [The Tree Package](http://web.stanford.edu/class/cs143/javadoc/cool_ast/) - Javadoc del paquete Tree.
[^2]: [The Cool Reference Manual](http://web.stanford.edu/class/cs143/materials/cool-manual.pdf) - Manual de COOL.
[^3]: [Tour of the Cool Support Code](http://web.stanford.edu/class/cs143/materials/cool-tour.pdf) - Manual del Código de Soporte de COOL.
[^4]: [SPIM Manual](http://web.stanford.edu/class/cs143/materials/SPIM_Manual.pdf) - Manual de SPIM.
