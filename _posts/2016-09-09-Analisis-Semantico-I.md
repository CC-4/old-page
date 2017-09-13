---
layout: post
title: "Analisis Semantico Parte I"
comments: false
date:   2016-09-09 11:10:00 -0600
category: lab
numero: 7
descripcion: >
 En este laboratorio haremos el analisis semantico de un lenguaje bastante basico y realizaremos cosas que les ayudaran bastante en el proyecto, como el chequeo de ciclos en un grafo :D
---

## 1. Introducción:

En clase ya terminamos el tema de analisis semantico y es hora de ponerlo en practica con cosas que les ayudaran en su proyecto. El motivo de este laboratorio es que puedan ganar experiencia en como se hace el analisis semantico de un lenguaje y que posteriormente en sus proyectos plasmen estas ideas. En el laboratorio anterior se enteraron de como funcionaba la tabla de simbolos, en este la vamos a utilizar juntamente con otras herramientas y anotaremos el arbol de un lenguaje llamado **Viper** con los tipos correspondientes.

Antes de empezar, los archivos necesarios para completar este lab se encuentran en **github** por lo que tienen que hacer:

```shell
  ~$ git clone https://github.com/CC-4/lab7.git
```

## 1. Ciclos en el Grafo de Herencia:

En el proyecto de **_semantic analysis_** les piden verificar que el grafo de herencia de un
programa hecho en **COOL** este bien formado. Segun la definicion del manual de COOL un grafo
de herencia esta bien formado si ese grafo **NO** tiene ciclos, es decir, si hay una clase **A** esa clase **A** no puede heredar de **A** (de ella misma). Tampoco se puede que una clase **A** herede de una clase **B** y esa clase **B** herede de **B**. Para poder encontrar esos ciclos necesitamos diseñar un algoritmo **_recursivo_** y de eso se trata el primer ejercicio de este laboratorio. En el archivo **Graph.java** hay una funcion llamada **_hasCycles_** que tienen que completar para encontrar los ciclos de un grafo, pero antes expliquemos un poco de que trata esa clase **Graph.java**

```java
  // Funcion que tienen que llenar en la clase Graph
  // Esta funcion verifica si una clase tiene ciclos en su path de herencia
  public boolean hasCycles(String name) {
    ...
  }
```

Una buena idea para almacenar el grafo de **_herencia_** es usar un **hashtable** _(Creo que todo en este proyecto sale con hashtables)_, ya que podemos guardar una relacion hijo -> padre. Lo que hace el metodo de la clase **_addClass(String name, String parent)_**, es esto mismo, agrega al hashtable una clase de nombre **name** con su respectivo **parent**. En este caso estamos usando Strings en vez de AbstractSymbols solo para simplificar las cosas. Entonces si uno quiere saber si una clase tiene ciclos mandariamos a llamar al metodo hasCycles("algunaclase").

### 1.1 ¿Que tienen que hacer?

Ustedes tienen que diseñar un algoritmo **_recursivo_** que sea capaz de verificar si una clase tiene ciclos en su **_path_** de herencia. Para esto algunas aclaraciones:

1. Recuerden que estamos trabajando con Strings no con AbstractSymbols.
2. Tienen que asumir que en el tope de la jerarquia siempre estara object.
3. La clase padre de object es no_parent como en el proyecto.
4. object y no_parent siempre estaran en minuscula.
5. Una clase no puede heredar de ella misma o sus parents de ellos mismos.
6. NO hay circuitos cerrados de herencia (esto completa la no. 5).
7. Eventualmente name se volvera null? no? (verificar metodo get de una hashtable).
8. TIENE que ser recursivo (queda bastante simple asi, lo prometemos).

cuando tengan listo pueden probarlo con:

```shell
  # asumiendo que estan en la carpeta del lab
  ~$ make cycles
  ./cycles
  # output esperado seria algo parecido a esto
  Test 1:

  A -- has cycles --> true
  main -- has cycles --> false
  object -- has cycles --> false

  Test 2:

  A -- has cycles --> true
  main -- has cycles --> false
  object -- has cycles --> false
  B -- has cycles --> true

  Test 3:

  A -- has cycles --> false
  main -- has cycles --> false
  object -- has cycles --> false
  C -- has cycles --> false
  B -- has cycles --> false

  Test 4:

  A -- has cycles --> true
  object -- has cycles --> false
  C -- has cycles --> true
  B -- has cycles --> true
```

## 2. Analisis Semantico del Lenguaje Viper

Para el ejercicio 2 haremos el analisis semantico de algunos nodos del lenguaje Viper, asi que los introduciremos a el un poco.

### 2.1 Lenguaje Viper

**Viper** es un lenguaje bastante basico _(casi no hace nada)_, es una mezcla media barata de python y C, pero tiene caracteristicas importantes para fines didácticos asi que lo estaremos utilizando en labs posteriores para terminar su analisis semantico y para entender **CodeGen**, por eso seria bueno que se acostumbren un poco al lenguaje. Ya que estamos bastante avanzados en el curso de compiladores no es necesario que les enseñemos como programar en el lenguaje, para eso existe la gramatica y [aqui](https://github.com/CC-4/ViperLanguage/blob/master/doc/grammar.pdf) la pueden ver  o tambien dentro de la carpeta del lab esta una subcarpeta llamada **doc** donde esta en formato PDF llamada **grammar**. Una vez hayan visto/entendido la gramatica, esto les parecera conocido:

```python
  def fibonacci(n:int): int {
      int x;
      if(n == 0) {
          x = 1;
      } else {
          x = n * fibonacci(n - 1);
      }
      return x;
  }
```

### 2.2 Reglas de inferencia del lenguaje Viper

**Viper** tiene pocas reglas de inferencia a comparacion de **COOL** y son menos complejas, sin embargo ayudan a entender bastante la dinamica de lo que tendrian que hacer en el proyecto, solo que sin objetos. Para ver estas reglas de inferencia pueden ir [aqui](https://github.com/CC-4/ViperLanguage/blob/master/doc/typerules.pdf) o en la carpeta del lab en la misma subcarpeta **doc** hay un documento llamado **typerules.pdf**. Lo importante es que en ese documento estan las reglas en el mismo formato que el manual de **COOL**, solo que en español y que son para el lenguaje **Viper** obviamente.

### 2.3 ¿Que tienen que hacer?

En la carpeta del lab hay un archivo **ViperTree.java** que tienen que modificar, tiene la misma estructura que el **cool-tree.java** de **COOL** _(bastante parecido a COOL no?)_. Este archivo tiene varias clases definidas que representan los nodos del lenguaje y que son los que utiliza el parser para construir el **AST**.

Para este laboratorio solo analizaremos los siguientes nodos:

1. Program
2. Function
3. Return
4. Declaration
5. While
6. IntConst
7. BoolConst
8. Id

En el lenguaje Viper existen statements y expressions, las expressions son las que tienen tipos y se les asigna un tipo por ende, y los statements solo utilizan expressions. Para asignar un tipo vean las funciones **semant** de los nodos **NoExpression** y **NoReturn** para ver como es que se le asigna un tipo a una expression utilizando la clase **Utils** y vean la clase **Type**. **Environments** es una clase que les servira bastante y es algo que deberian de hacer en su proyecto (?) asi que traten de entenderla y vean que hereda de **SymbolTable**.

> Mas sobre todo esto en el lab


### 2.4 Manejo de errores

1.- Cuando esten haciendo el analisis semantico de **Program** primero tienen que recorrer cada una de las funciones y guardarlas en la tabla de funciones utilizando un objeto de tipo Environments. Si una funcion se repite tienen que mandar un error semantico, de que la funcion esta definida varias veces utilizando **SemantErrors.functionMultiplyDefined(int lineno, String name)**, sino solo agregarla a la tabla. Si la funcion **"main"** no esta definida tienen que mandar un error semantico utilizando la funcion **SemantErrors.noMainFunction()**.

2.- Cuando esten haciendo el analisis semantico de **Function**, recuerden que como se pueden declarar parametros y variables dentro de una funcion esta crea un **scope** nuevo, utilicen **OM.enterScope()** para crear uno. Si la funcion se llama **"main"**, esta funcion no puede tener parametros definidos sino tienen que mandar un error semantico utilizando **SemantErrors.mainNoArguments(int lineno)** para verificar si tiene paremetros utilicen **formals.size()**. Recuerden que tienen que agregar los parametros formals al **scope** que acaban de crear. Para cada Statement llaman a semant. Para el **return** mandan a llamar a su metodo semant. Si hay un tipo declarado de retorno diferente de **void** y no hay un **return** entonces deben mandar el error semantico **SemantErrors.noReturn(int lineno, String name, Type t)**. Si el tipo declarado es **void** y hay un return tienen que mandar un error semantico **SemantErrors.noReturnExpected(int lineno)**. Si hay un tipo declarado distinto de **void** y hay un **return** pero con un tipo diferente mandar error **SemantErrors.diffReturnType(int lineno, String name, Type d, Type r)**. Cuando terminen de analizar cierrar el **scope** que crearon.

3.- Cuando hagan el analisis semantico de **Return** recuerden que el tipo de la expresion de retorno es el mismo del return.

4.- Cuando esten haciendo el analisis semantico de **Declaration** primero tienen que hacer semant de **init**. Verificar que la variable que se intenta declarar no este ya en el scope mas reciente, utilizar **OM.probe(String name)** si ya existe mandar error **SemantErrors.varMultiplyDefined(int lineno, String name)**, sino agregar al scope actual. Si, si se inicializo la variable verificar que **init** tenga el mismo tipo que el declarado sino mandar error **SemantErrors.diffInitType(int lineno, String name, Type d, Type i)**.

5.- Cuando esten haciendo el analisis semantico de  **While**  llamar a semant de **pred**, si **pred** no tiene tipo **bool** mandar error semantico **SemantErrors.whileNoBoolCondition(int lineno)**. Como el body del while son statements, esto permite crear variables entonces significa que el body crea un nuevo **scope**, antes de llamar a semant de cada statement crear un nuevo scope. Cuando terminen de analizar cierrar el **scope** que crearon.

6.- Analisis semantico de IntConst -> Parecido al analisis semantico de **NoExpression**

7.- Analisis semantico de BoolConst -> Parecido al analisis semantico de **NoExpression**

8.- Cuando esten haciendo el analisis semantico de **Id**, verificar que este en algun scope esa variable declarada, utilizar **OM.lookup(String name)**. Si si esta poner el tipo de la tabla de simbolos, sino mandar error **SemantErrors.undeclaredeVar(int lineno, String name)**.

> Mas sobre todo esto en el lab

### 2.5 Autograder

Si ustedes quieren saber si ejercicio es correcto:

```shell
  ~$ make check
  python grading.py
  ##################### Autograder #######################
       +1 (gooddeclaration.test)
       +1 (scopesbad.test)
       +1 (while.test)
       +1 (id.test)
       +1 (goodfunctions.test)
       +1 (functionsbad.test)
       +1 (scopes.test)
       +1 (redeclaration.test)
       +1 (declarationinit.test)
       +1 (functionredefined.test)
       +1 (types.test)
       +1 (bool.test)
       +1 (multiplewhiles.test)
       +1 (returndifftypes.test)
       +1 (multipledeclaration.test)
       +1 (whilegoodbody.test)
       +1 (int.test)
       +1 (returnwithvoid.test)
       +1 (basic.test)
       +1 (declarationbad.test)
       +1 (whilebadbody.test)
       +1 (redefinedformals.test)
       +1 (noreturn.test)
       +1 (nomain.test)
       +1 (mainwithargs.test)

  -> All ok
  +------------------------------------------------------+
  |                                          Score: 25/25|
  +------------------------------------------------------+
```

> Mas sobre todo esto en el lab
