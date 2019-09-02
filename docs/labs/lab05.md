# Tabla de Símbolos

<p align="center">
  <img src="/img/st.gif" alt="Symbol Table"/>
</p>


En este laboratorio aprenderan a implementar una tabla de simbolos como la que usaran en la fase 3 del proyecto.


## 1. Introducción

Han terminado las primeras 2 fases de su proyecto, y ahora es donde empieza la verdadera batalla contra el dragon. En la fase 3 se encargarán de hacer el análisis semántico del compilador, es decir, en pocas palabras, deben asignar un tipo a cada nodo del árbol generado en la fase 2, y así terminar de capturar cualquier error o inconsistencia en el código o programa a compilar. Para realizar esta fase, ustedes deben implementar una tabla de símbolos en donde guardarán todas las variables declaradas para validar su existencia en base a su scope, y poder asignar un tipo a cada una.

Para iniciar, ejecuten el comando para generar los archivos necesarios:

```shell
 $~ make -f /usr/class/cs143/assignments/PA4J/Makefile
```

## 2. Tabla de Simbolos

Estos son los archivos necesarios para implementar la fase 3 del proyecto, pero por ahora nos enfocaremos únicamente en ***SymtabExample.java***. Veán que este archivo contiene un ejemplo de como funciona la tabla de símbolos:

```java
// se crea la tabla de sibolos.
SymbolTable map = new SymbolTable();
// se crea un nuevo AbstractSymbol
AbstractSymbol fred = AbstractTable.stringtable.addString("Fred");
// se agrega un nuevo scope a la tabla. Notese que al crear la tabla, esta no contiene ningun scope
map.enterScope();
// se agrega el simbolo a la tabla junto con un valor
map.addId(fred, new Integer(22));
// busca y devuelve el valor asociado al simbolo en el scope actual, si no lo encuentra, devuelve null
map.probe(fred)
// busca y devuelve el valor asociado al simbolo en todos los scopes, si no lo encuentra, devuelve null
map.lookup(fred)
// elimina el ultimo scope creado.  
map.exitScope();
```

La tabla de simbolos (**SymbolTable.java**), en su implementacion, utiliza un stack para los scopes, y adicional al ejemplo que tienen en el archivo,
estos son los metodos que contiene la clase:

```java
// un constructor sin parametros que inicializa la tabla
public SymbolTable()
// agrega un nuevo scope a la tabla, en forma de una HashTable
public void enterScope()
// elimina el ultimo scope agregado
public void exitScope()
// agrega una entrada a la tabla en el scope mas reciente
public void addId(AbstractSymbol id, Object info)
// busca y devuelve el valor del simbolo. Busca unicamente en el scope mas reciente
public Object probe(AbstractSymbol sym)
// busca en todos los scopes de la tabla. Devuelve el valor del simbolo mas reciente que encontro
public Object lookup(AbstractSymbol sym)
// devuelve un String que representa la tabla
public String toString()
```

Vean que las entradas de la tabla de símbolos son pares (Key,Value), donde el valor es de tipo ***Object***. En este laboratorio, para simplificar la calificación, ingresaremos únicamente valores de tipo ***String***.

Ahora que se han familiarizado un poco con la tabla de símbolos, es hora de modificar el archivo ***SymtabExample.java***. Agreguen a este un menú en el que se puedan realizar las siguientes operaciones:

1. [x] Agregar Símbolo
2. [x] Agregar Scope
3. [x] Borrar Scope
4. [x] Buscar en el scope actual (devolver el valor almacenado con el símbolo)
5. [x] Buscar en cualquier scope (devolver el valor almacenado con el símbolo)
6. [x] Comparar el valor de 2 simbolos diferentes
7. [x] Imprimir tabla de símbolos
8. [x] Salir

Para compilar su programa deben de hacer lo siguiente:

```shell
make symtab-example
```

Para ejecutarlo:

```shell
./symtab-example
```

Una vez terminado todo, envien al GES un archivo **.zip** conteniendo únicamente el archivo ***SymtabExample.java***
