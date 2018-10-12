---
layout: post
title: "Project Phase 4"
comments: true
date:   2016-10-09 11:58:00 -0600
category: proyectos
numero: 4
descripcion: >
 Instrucciones para la fase 4(Code Generation) del compilador de COOL.
---

# Proyecto Fase 4 (Code Generation)

## 1. Introducción

En esta tarea, ustedes van a implementar un generador de código para COOL. Cuando hayan terminado satisfactoriamente esta parte, ustedes van a tener un compilador de COOL totalmente funcional.

El generador de código hace uso del _Abstract Syntax Tree_ (AST) construido durante la fase 2 del proyecto (Parser) y la fase 3 del proyecto (Semantic). Su generador de código debería de producir código de ensamblador, que implementa cualquier programa de COOL correcto, para la arquitectura **RISC-V**.

Aquí en esta fase no hay recuperación de errores, en la generación de código ya podemos estar seguros de que cualquier programa erroneo de COOL ya ha sido detectado en las fases anteriores del compilador (Lexer, Parser, Semantic).

Así como en la fase de análisis semántico, esta última parte tiene decisiones de diseño que ustedes tienen que pensar para lograr completarlo. Su programa va estar correcto si el código generado funciona correctamente, ¿cómo lo van a lograr? ustedes tienen que ver que camino seguir, que decisiones tomar, que técnicas utilizar, etc. Les recomendamos algunos convenios que nosotros creemos les van a hacer la vida más fácil, pero no estan obligados a seguir nuestras recomendaciones. Esta última parte, comparte mucha de la infrastructure de la fase anterior. **POR FAVOR, EMPIECEN LUEGO**.

Es algo bastante importante que para que ustedes puedan lograr generar código correctamente, ustedes tengan claro ya el compartamiento interno de COOL, como interactura con el runtime system (traphandler.s) y el código generado. El compartamiento esperado de los programas de COOL están definidos en las operaciones semánticas de COOL que están definidas en las sección 13 del manual de referencia de COOL. Recuerden que esta solo es una especificación del significado del lenguaje, no como se implementan. La interfaz entre el runtime system (traphandler.s) y el código generado está dado en _traphandler.s_ y _Cool Runtime System_. Revisen esos documentos y archivos para que tengan una clara visión de todos los requerimientos del runtime system en el código generado. Hay un montón de información en esta asignación y en los documentos mencionados, y ustedes tienen que saber de estos para poder generar código de manera correcta. _Por favor lean cuidadosamente_ para entender a detalle todo y luego pueden optar por utilizar ingeniería inversa utilizando el compilador de **coolc-rv** que ya está completo para ver lo que deberían generar ustedes.


## 2. Archivos y Directorios

Como ustedes no van a generar código ensamblador de MIPS, sino de **RISC-V**, necesitamos preparar el ambiente de trabajo instalando el simulador de RISC-V **V-Sim** e instalando el compilador ya completo **coolc-rv**, para esto ustedes tienen dos opciones:

##### Wget

```
wget -O coolc-rv https://git.io/fxf6i && chmod +x coolc-rv && . ./coolc-rv && rm coolc-rv
```

##### cURL

```
curl https://git.io/fxf6i -L -o coolc-rv && chmod +x coolc-rv && . ./coolc-rv && rm coolc-rv
```

Solo tienen que utilizar alguno de los dos, el de su preferencia. Luego que se haya ejecutado el script, pueden probar si todo se ha instalado correctamente, primero si el simulador se instaló:

```
vsim -h
 _   __    _____
| | / /___/ __(_)_ _
| |/ /___/\ \/ /  ' \
|___/   /___/_/_/_/_/

RISC-V Assembler & Runtime Simulator

GPL-3.0 License
Copyright (c) 2018 Andres Castellanos
All Rights Reserved
See the file LICENSE for a full copyright notice

usage: vsim [options] <files>

available options:
  -bare         bare machine (no pseudo-ops)
  -debug        start the debugger
  -dump DUMP    dump machine code to a file
  -help         show this help message and exit
  -iset         print available RISC-V instructions and exit
  -nocolor      do not colorize output
  -notitle      do not print title and copyright notice
  -quiet        do not print warnings
  -start START  start program at global label (default: main)
  -usage USAGE  print usage of an instruction and exit
  -version      show the simulator version and exit
```

y por último probando algún programita de COOL por ejemplo este:

```
--(main.cl)
class Main inherits IO {

  main(): Object {
    out_string("hello world")
  };

};
```

entonces podemos probar el compilador:

```
coolc-rv main.cl
vsim main.s
 _   __    _____
| | / /___/ __(_)_ _
| |/ /___/\ \/ /  ' \
|___/   /___/_/_/_/_/

RISC-V Assembler & Runtime Simulator

GPL-3.0 License
Copyright (c) 2018 Andres Castellanos
All Rights Reserved
See the file LICENSE for a full copyright notice

loaded: traphandler.s

hello worldCOOL program successfully executed

vsim: exit(0)
```

Ya con todo funcionando, para poder empezar, ustedes tienen que clonar el siguiente repositorio en algún lugar donde ustedes quieran trabajar:

```
git clone https://github.com/CC-4/RV-PA5J.git
```

Casi todos estos archivos han sido explicados en las fases anteriores del proyecto.

Esta es una lista de los archivos que ustedes tal vez quieran modificar. Ustedes ya tienen que estar familiarizados con la mayoría de archivos por las fases anteriores.


* `CgenClassTable.java` y `CgenNode.java`: Estos archivos proveen una implementación del grafo de herencia para el generador de código. Ustedes van a tener que completar `CgenClassTable` para poder construir su generador de código. Ustedes pueden utilizar el código que se les provee o pueden reemplazarlo con el suyo propio o con el que hicieron en la fase anterior.


* `StringSymbol.java`, `IntSymbol.java`, and `BoolConst.java` : Estos archivos proveen soporte para las constantes de COOL. Ustedes van a tener que completar el método para generar definiciones de estas constantes.


* `cool-tree.java` : Este archivo contiene la definición del los nodos del AST. Ustedes van a tener que añadir rutinas de generación de código `code(PrintStream)` para todas las expresiones en este archivo. **El generador de código es mandado a llamar, empezando por `code(PrintStream)` que está en la clase program**. Ustedes tal vez quieran añadir más métodos, pero no modifiquen los  métodos existentes que no tienen que modificar.


* `TreeConstants.java`: Como antes, este archivo define algunas constantes útiles, sientanse libres de añadir las suyas y lo que quieran.


* `CgenSupport.java`: Este archivo contiene soporte general para generar código. Van a encontrar una serie de funciones que se vuelven bastantes útiles para emitir instrucciones de RISC-V, aquí está todo lo que necesitan. Pueden añadir también las que ustedes quieran, pero no modifiquen nada de lo que ya está definido.


* `example.cl`: Este es su archivo de prueba para ver si lo que genera su generador de código funciona correctamente. Hagan bastantes pruebas con este archivo como lo requieran.


## 3. Diseño

Antes de continuar, les sugerimos que de verdad lean el documento The Cool Runtime System para que estén cómodos con los requerimientos que necesita implementar su generador de código impuestos por el runtime system. En consideración a su diseño, así a grandes rasgos, su generador de código deberá hacer las siguientes tareas:

1. Determinar y emitir código para las constantes globales, como los prototipos de objeto.
2.  Determinar y emitir código para las tablas globales, como la `class_nameTab`, la `class_objTab` y las dispatch tables.
3. Determinar y emitir código para la inicialización de los métodos y atributos de cada clase.
4. Determinar y emitir código para cada método de cada clase.

Hay varias maneras posibles para crear un generador de código. Una estrategia razonable es hacer el generador de código en dos pasadas. La primera pasada decide el layout para cada clase, particularmente el offset en donde cada atributo es guardado en un objeto. Utilizando esta información, la segunda pasada recursivamente visita cada feature y genera código de un stack machine para cada expresión.

Hay un número de cosas que ustedes tienen que mantener en mente mientras diseñan su generador de código:

* Su generador de código tiene que funcionar correctamente con el Runtime de COOL (traphandler.s), que es explicado a detalle en _Cool Runtime System Manual_.
* Ustedes tiene que tener claro como funciona la semántica operacional del runtime de COOL. La semántica es descrita informalmente en la primera parte del _Cool Reference Manual_, y una descripción precisa de cómo los programas de COOL deberían de comportarse está explicado en la sección 13 del manual de COOL.
* Deberían entender el set de instrucciones de RISC-V, y tener una vista general de las operaciones que se pueden efectuar con `V-Sim`.
* Ustedes tienen que decidir que invariantes su generador de código puede esperar u observar (es decir, qué registros se van a salvar, cuales se pueden sobreescribir, convenios, etc). Ustedes van a encontrar bastante útil ver la información que se les enseño en clase.


### 3.1 Runtime Error Checking

Al final del manual de COOL existe una lista de errores que pueden terminar un programa antes de lo esperado. De esta lista su generador de código debería de ser capaz de atrapar las primeras tres dispatch on void, case on void y missing branch e imprimir un mensaje de error antes de abortar. Atrapar errores de substring out of range y heap overflow is responsabilidad del runtime system que está en traphandler.s.

### 3.2 Garbage Collection

El equipo de CC-4 que tradujo el runtime de COOl de MIPS a RISC-V e implemento un simulador de RISC-V no implementó un garbage collector complejo como el original que está en el runtime de MIPS, debido al tiempo y porque ustedes realmente no van a implementar un Garbage Collection en este curso (ni los que hacen el codegen en la versión de MIPS) la cantidad de código que tienen que tener para que el GC funcione correctamente ya se las damos en el código base y no tienen que preocuparse por esto.

## 4. Testing y Debugging

Ustedes van a tener un lexer, parser y semantic totalmente funcional para probar su generador de código. Ustedes pueden utilizar de todas maneras sus fases anteriores si quieren. Ustedes van a tener que correr su generador de código utilizando `./mycoolc`, que es un script shell que pega el generador de código que ustedes están haciendo con el resto de fases. Tomen en cuenta que `mycoolc` puede tomar una bandera -c para debuggear el generador de código, utilizando esta bandera, setea la bandera debug a true, que esta en Flags.java. Agregar código para producir información de debugging es una tarea de ustedes si quieren utilizarlo.

### 4.1 V-Sim

El ejecutable de V-Sim `vsim` es el simulador para la arquitectura RISC-V donde pueden probar su generador de código. Tiene muchas funcionalidades que les permite examinar el estado de la memoria, simbolos globales y locales, registros, etc del programa. Ustedes también pueden poner breakpoints y hacer step de su programa. Para poder utilizar el debugger de V-Sim ustedes pueden hacer lo siguiente:

```
vsim -debug <archivo.>
>> help
Available commands:

help/?              - show this help message
exit/quit           - exit the simulator and debugger
!                   - execute previous command
showx               - print all RVI registers
showf               - print all RVF registers
print regname       - print register
memory address      - print 12 x 4 cells of memory starting at address
memory address rows - print rows x 4 cells of memory starting at address
globals             - print global symbols
locals filename     - print local symbols of a file
step/s               - step the program for 1 instruction
continue/c           - continue program execution without stepping
breakpoint/b address - set a breakpoint at address
clear                - clear all breakpoints
delete addr          - delete breakpoint at address
list                 - list all breakpoints
reset                - reset all state (regs, memory) and start again
```

La documentación de V-Sim la pueden encontrar [V-Sim](https://andrescv.github.io/V-Sim/).  


## 5. Autograding

El script que califica su proyecto, ya viene por defecto en los archivos bases que clonaron anteriormente. Cada vez que ustedes van ejecutar el autograder ustedes deberían hacer lo siguiente:

```shell
./pa4-grading.py
```

## 6. Documentos y Rerencias
* [The Tree package Javadoc](http://web.stanford.edu/class/cs143/javadoc/cool_ast/)
* [The Cool Reference Manual](http://web.stanford.edu/class/cs143/materials/cool-manual.pdf)
* [The Cool Runtime System](http://web.stanford.edu/class/cs143/materials/cool-runtime.pdf)
* [Tour of the Cool Support Code](http://web.stanford.edu/class/cs143/materials/cool-tour.pdf)
* [V-Sim Manual](https://andrescv.github.io/V-Sim/)
* [Documento auxiliar para Cgen(esp)](https://github.com/CC-4/RV-PA5J/raw/master/doc/CodeGen.pdf)
