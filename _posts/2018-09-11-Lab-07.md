---
layout: post
title: "Analisis Semantico Parte II"
comments: false
date:   2018-09-11 11:10:00 -0600
category: lab
numero: 7
descripcion: >
 Luego de un breve receso, cerramos esta sección con el analisis semantico de la segunda parte del lenguaje Viper.
---

## 1. Introducción:

Continuando con el tema de analisis semantico, terminaremos de analizar los nodos del arbol que dejamos incompletos, agregaremos verificaciones de errores
para estos, y finalmente haremos uso del tipo **NO_TYPE** para evitar una cascada de errores.

Antes de empezar, debemos obtener los archivos necesarios para este lab.

```shell
  https://classroom.github.com/a/tW3Bl81L
```

## 1. Continuando con el Analisis Semantico:

Para seguir con el analisis semantico de los nodos del arbol generado, les hemos proporcionado un esqueleto en **ViperTree.java**, con las 
implementaciones adecuadas del metodo <i>semant()</i>, por si acaso no lograron completar en su totalidad el laboratorio 7. Sin embargo, si lograron completar
todas las pruebas del laboratorio anterior, sientanse libres y motivados a usar ese codigo para esta parte.

Antes de empezar, vamos a ver el analisis del nodo <i>Declaration</i>, con la implementacion que les daremos:

```java
  public void semant(Environments OM) {
        if(OM.probe(name) != null){ //Si en el ambiente actual ya existe esta variable
            SemantErrors.varMultiplyDefined(this.getLineNumber(),this.name); //ERROR!!!
        }else{ //ahhh.... pero si no esta
            init.semant(OM); //hacemos el analisis de la inicializacion (recursivamente)
            OM.addId(name,type); //agregamos la variable al scope
            if(! init.getType().equals(this.type) && ! init.getType().equals(Utils.NO_TYPE)){//Si el tipo de la inicializacion no es correcto
                SemantErrors.diffInitType(init.getLineNumber(), this.name, type, init.getType()); //ERROR!!!
            }
        }
    }
```

Aqui hay un pequeño hint de la tercera parte del lab; noten como unicamente lanzamos error de tipo cuando los tipos son diferentes entre si, y el tipo
de la expresion de inicial es diferente a **NO_TYPE**

Ahora bien, para este lab deben analizar el resto de los nodos:

1. Assign
2. Print
3. If
4. StrConst
5. Plus
6. Minus
7. Mult
8. Div
9. Eq
10. Neq
11. Leq
12. Geq
13. Lt
14. Gt
15. And
16. Or 
17. Not
18. Call

Pueden parecer muchos, pero noten que hay varios nodos que se analizan de forma similar (casi igual, de hecho), como las operaciones aritmeticas, y
las comparaciones.


## 2. Atrapar Errores:

Recuerden que el analisis semantico es la ultima defensa de un compilador contra codigo incorrecto, asi que en esta parte, es muy importante terminar 
capturar todos los errores posibles poder generar codigo correcto. Igual que en el laboratorio anterior, deben implementar las verificaciones 
adecuadas en sus funciones. Los errores que deben capturar estan el en archivo <i>SemantErrors.java</i>.


## 3. NO_TYPE:

Recordemos aquella clase, hace mucho tiempo, donde hablamos de **NO_TYPE** para COOL. **NO_TYPE** es un tipo especial; es una clase que hereda de 
todas las demas en <i>COOL</i>. Esto permite evitar una cascada de errores que abrumarian a cualquier programador. Sin embargo, **NO_TYPE** degenera 
el arbol de herencia, ya que todos los nodos conectan a el. A pesar de esto, existe otra forma de implementar **NO_TYPE** para no tener que enfrentarse 
a los problemas de una estructura donde todos los nodos conecten con uno; y es con condiciones en casos especiales en su codigo (recuerden el **Hint**).
Para Vyper, y a falta de objetos, diremos que **NO_TYPE** puede operarse con cualquier dato. Veamos como funciona esto. Imaginen la siguiente funcion:

```java
	def main() : void{
		true + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10;
	}
```
Noten que intentar sumar un <i>boolean</i> con un numero daria un error, y con un error seria suficiente, sin embargo, este es el output generado cuando
no se maneja correctamente **NO_TYPE**:


```shell
	~$ ./semant bad_no_type.vyper 
	line 2: non-int arguments: bool Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	line 2: non-int arguments: notype Plus int
	Compilation halted due to static semantic errors.
```

Vean que lanzo 10 errores, 9 de ellos innecesarios. Ahora, cuando implementamos las propiedades de **NO_TYPE** en codigo: 

```shell
	~$ ./semant bad_no_type.vyper 
	line 2: non-int arguments: bool Plus int
	Compilation halted due to static semantic errors.
```

La cantidad de errores se redujo a uno, y con un codigo mas complejo seria mas facil de encontrar. Podria parecer un poco complicado, pero
hacer esta implementacion solo requiere unas cuantas lineas de codigo mas.

## 4. Autograder:

Para comprobar que su codigo funciona correctamente:

```shell
  ~$ make check
  python grading.py
  ##################### Autograder #######################
      +1 (noTypeRecovery1.test)
      +1 (undeclaredAssign.test)
      +1 (print.test)
      +1 (divWrongTypes.test)
      +1 (callWrongTypes.test)
      +1 (noTypeRecovery2.test)
      +1 (callUndeclaredFunction.test)
      +1 (call.test)
      +1 (arith.test)
      +1 (logicOperations.test)
      +1 (minusWrongTypes.test)
      +1 (multWrongTypes.test)
      +1 (comp1.test)
      +1 (whileWrongCond.test)
      +1 (assign.test)
      +1 (compWrongTypes2.test)
      +1 (ifWrongPred.test)
      +1 (comp2.test)
      +1 (plusWrongTypes.test)
      +1 (if.test)
      +1 (diffTypesAssign.test)
      +1 (andOrWrongTypes.test)
      +1 (noTypeRecovery3.test)
      +1 (compWrongTypes1.test)
      +1 (callWrongArgsNumber.test)
      +1 (notWrongType.test)

  -> All ok
  +------------------------------------------------------+
  |                                          Score: 26/26|
  +------------------------------------------------------+
```
