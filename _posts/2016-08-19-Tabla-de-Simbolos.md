---
layout: post
title: "Tabla de Simbolos"
comments: false
date:   2016-08-18 11:10:00 -0600
category: lab
numero: 6
descripcion: >
 En este laboratorio aprenderan a implementar una tabla de simbolos como la que usaran en la fase 3 del proyecto.
---


## 1. Introducción:

Hemos terminado las primeras 2 fases de su proyecto, y ahora es donde empieza la verdadera batalla conta el dragon. En la fase 3 se encargaran 
de hacer el analisis semantico del compilador, osea, en pocas palabras, deben asignar un tipo a cada nodo del arbol generado en la fase 2, y asi 
terminar de capturar cualquier error o inconsistencia en el codigo a generar. Para realizar esta fase, ustedes deben implementar una tabla de simbolos 
en donde guardaran todas las variables declaradas para validar su existencia en base a su scope, y poder asignar un tipo a cada una. 

Para iniciar, ejecuten el comando para generar los archivos necesarios: 

```shell
 $~ make -f /usr/class/cs143/assignments/PA4J/Makefile
```


## 2. Tabla de Simbolos:

Estos son los archivos necesarios para implementar la fase 3 del proyecto, pero por ahora nos enfocaremos unicamente en <i>SymtabExample.java</i>. Vean que 
este archivo contiene un ejemplo de como funciona la tabla de simbolos: 

```
	SymbolTable map = new SymbolTable(); // se crea la tabla de sibolos.
	AbstractSymbol fred = AbstractTable.stringtable.addString("Fred"); // se crea un nuevo AbstractSymbol
	map.enterScope(); // se agrega un nuevo scope a la tabla. Notese que al crear la tabla, esta no contiene ningun scope
	map.addId(fred, new Integer(22)); // se agrega el simbolo a la tabla junto con un valor
	map.probe(fred) // busca y devuelve el valor asociado al simbolo en el scope actual, si no lo encuentra, devuelve null
	map.lookup(fred) // busca y devuelve el valor asociado al simbolo en todos los scopes, si no lo encuentra, devuelve null
	map.exitScope(); // elimina el ultimo scope creado.  

```

La tabla de simbolos (SymbolTable.java), en su implementacion, utiliza un stack para los scopes, y adicional al ejemplo que tienen en el archivo, 
estos son los metodos que contiene la clase:

```java
	public SymbolTable(): un constructor sin parametros que inicializa la tabla
	public void enterScope(): agrega un nuevo scope a la tabla, en forma de una HashTable
	public void exitScope(): elimina el ultimo scope agregado
	public void addId(AbstractSymbol id, Object info): agrega una entrada a la tabla en el scope mas reciente
	public Object lookup(AbstractSymbol sym): busca y devuelve el valor del simbolo. Busca unicamente en el scope mas reciente
	public Object probe(AbstractSymbol sym): busca en todos los scopes de la tabla. Devuelve el valor del simbolo mas reciente que encontro
	public String toString(): devuelve un String que representa la tabla

```

Vean que las entradas de la tabla de simbolos son pares (Key,Value), donde el valor es de tipo <i>Object</i>. En este lab, para simplificar la calificacion, 
ingresaremos unicamente valores de tipo <b>String</b>. 

Ahora que se han familiarizado un poco con la tabla de simbolos, es hora de modificar el archivo <i>SumtabExample.java</i>. Agregue a este un menú en el que 
se puedan realizar las siguientes operaciones: 

1. Agregar Símbolo
2. Agregar Scope
3. Borrar Scope
4. Buscar en el scope actual (devolver el valor almacenado con el símbolo)
5. Buscar en cualquier scope (devolver el valor almacenado con el símbolo)
6. Comparar el valor de 2 simbolos diferentes
7. Imprimir tabla de símbolos
8. Salir

Para compilar debe hacerlo con: 

```java
make symtab-example
```

Para ejecutarlo: 

```
./symtab-example
```

Una vez terminado todo, envien al GES un archivo <b>.zip</b> conteniendo unicamente el archivo <i>SymtabExample.java</i>