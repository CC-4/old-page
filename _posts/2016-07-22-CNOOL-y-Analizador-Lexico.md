---
layout: post
title: "CNOOL y Analizador Lexico"
comments: true
date:   2016-07-22 11:10:00 -0600
category: lab
numero: 2
descripcion: >
 En este lab implementaran la fase del analizador lexico para una version sin objetos de COOL. Lo llamaremos CNOOL "Classroom Not Object Oriented Language"
---

Un analizador lexico conforma la primer parte de un compilador. La funcion principal de un analizador lexico es tomar una cadena de caracteres y separarla 
en tokens. Cada uno de estos tokens representa un simbolo o expresion del lenguaje de programacion. 

Con el objetivo de ayudarlos en su proyecto, a lo largo de los labs implementaremos una version mas simple de COOL, dejando de lado los objetos y los comentarios.
Ademas de esto, existiran unicamente tres tipos basicos: String, Integer y Boolean. 

La gramatica que usaran es una version modificada de la gramatica de COOL, la llamaremos CNOOL:

	program ::= [feature]+
	feature::= ID([formal[,formal]*]) : TYPE {expr};
	formal::= ID : TYPE
	expr::=   ID <- expr
			| ID([expr[,expr]*])		
			| ID : TYPE [<- expr]
			| {[expr;]+}
			| expr + expr 
			| expr - expr 
			| expr * expr
			| expr / expr
			| ~ expr
			| expr < expr
			| expr <= expr 
			| expr = expr
			| not expr
			| (expr)
			| ID
			| integer
			| string
			| true
			| false

Para reciclar los archivos que ya tienen instalados en su maquina virtual, emplearemos el mismo comando que deben utilizar para el proyecto 1:

make -f /usr/class/cs143/assignments/PA2J/Makefile

De todos los archivos que se copiaran, unicamente deben modificar cool.lex, y agregar las expresiones regulares necesarias para que se generen los tokens de la 
gramatica. Por razones de funcionamiento, no modificaremos el archivo TokenConstants.java, que contiene todos los tokens necesarios para el proyecto. Para 
facilitar la implementacion, retiraremos los comentarios y los strings multilinea, asi como el soporte para el caracter '\n' de ellos. 