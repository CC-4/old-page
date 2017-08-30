---
layout: post
title: "Project Phase 2"
comments: true
date:   2016-07-27 11:58:00 -0600
category: proyectos
numero: 2
descripcion: >
 Instrucciones para la fase 2 del compilador de COOL.
---

# Programming Assignment II

## 1. Introduction

In this assignment you will write a parser for Cool. The assignment makes use of two tools: the parser generator (the Java tool is called CUP) and a package for manipulating trees. The output of your parser will be an abstract syntax tree (AST). You will construct this AST using semantic actions of the parser generator.

**You certainly will need to refer to the syntactic structure of Cool, found in Figure 1 of The Cool Reference Manual (as well as other parts)**. The documentation for CUP is available online. The documentation of the tree package for the Java version is available online. You will need the tree package information for this and future assignments.

There is a lot of information in this handout, and you need to know most of it to write a working parser. _Please read the handout thoroughly._

**You must work individually on this assignment (no collaboration in groups).**

## 2. Files and Directories

To get started, create a directory where you want to do the assignment and execute one of the following commands in that directory.  For Java, type:

```
make -f /usr/class/cs143/assignments/PA3J/Makefile
```
(notice the “J” in the path name). This command will copy a number of files to your directory. Some of the files will be copied read-only (using symbolic links). You should not edit these files. In fact, if you make and modify private copies of these files, you may find it impossible to complete the assignment. **See the instructions in the README file.** The files that you will need to modify are:


* `cool.cup` : This file contains a start towards a parser description for Cool. The declaration section is mostly complete, but you will need to add additional type declarations for new nonterminals you introduce. We have given you names and type declarations for the terminals. You might also need to add precedence declarations. The rule section, however, is rather incomplete. We have provided some parts of some rules. You should not need to modify this code to get a working solution, but you are welcome to if you like. However, do not assume that any particular rule is complete.
* `good.cl` and `bad.cl`: These files test a few features of the grammar. Feel free to modify these files to test your parser.
* `README`: This file contains detailed instructions for the assignment as well as a number of useful tips.


## 3. Testing the Parser
You will need a working scanner to test the parser. You may use either your own scanner or the coolc scanner. By default, the coolc scanner is used; to change this behavior, replace the lexer executable (which is a symbolic link in your project directory) with your own scanner. Don’t automatically assume that the scanner (whichever one you use!) is bug free—latent bugs in the scanner may cause mysterious problems in the parser.

**You will run your parser using myparser**, a shell script that “glues” together the parser with the scanner. Note that myparser takes a -p flag for debugging the parser; using this flag causes lots of information about what the parser is doing to be printed on stdout. **CUP produce a human-readable dump of the LALR(1) parsing tables in the cool.output file. Examining this dump may sometimes be useful for debugging the parser definition**.

You should test this compiler on both good and bad inputs to see if everything is working. Remember, bugs in your parser may manifest themselves anywhere.

Your parser will be graded using our lexical analyzer. Thus, even if you do most of the work using your own scanner you should test your parser with the coolc scanner before turning in the assignment.

## 4. Parser Output
Your semantic actions should build an AST. The root (and only the root) of the AST should be of type program. For programs that parse successfully, the output of parser is a listing of the AST.

For programs that have errors, the output is the error messages of the parser. We have supplied you with an error reporting routine that prints error messages in a standard format; please do not modify it. You should not invoke this routine directly in the semantic actions; CUP automatically invokes it when a problem is detected.

For constructs that span multiple lines, you are free to set the line number to any line that is part of the construct. Do not worry if the lines reported by your parser do not exactly match the reference compiler. Also, your parser need only work for programs contained in a single file—don’t worry about compiling multiple files.

## 5. Error Handling
You should use the error pseudo-nonterminal to add error handling capabilities in the parser. The purpose of error is to permit the parser to continue after some anticipated error. It is not a panacea and the parser may become completely confused. See the CUP documentation for how best to use error. To receive full credit, your parser should recover in at least the following situations:

* If there is an error in a class definition but the class is terminated properly and the next class is syntactically correct, the parser should be able to restart at the next class definition.
* Similarly, the parser should recover from errors in features (going on to the next feature), a let binding (going on to the next variable), and an expression inside a {...} block.

Do not be overly concerned about the line numbers that appear in the error messages your parser generates. If your parser is working correctly, the line number will generally be the line where the error occurred. For erroneous constructs broken across multiple lines, the line number will probably be the last line of the construct.

## 6. The Tree Package
The documentation of the tree package for Cool abstract syntax trees is available on the GES project resources. You will need most of that information to write a working parser.

## 7. Remarks

You may use precedence declarations, but only for expressions. Do not use precedence declarations blindly (i.e., do not respond to a shift-reduce conflict in your grammar by adding precedence rules until it goes away).

The Cool let construct introduces an ambiguity into the language (try to construct an example if you are not convinced). The manual resolves the ambiguity by saying that a let expression extends as far to the right as possible. Depending on the way your grammar is written, this ambiguity may show up in your parser as a shift-reduce conflict involving the productions for let. If you run into such a conflict, you might want to consider solving the problem by using a CUP feature that allows precedence to be associated with productions (not just operators). See the CUP documentation for information on how to use this feature.

Since the `mycoolc` compiler uses pipes to communicate from one stage to the next, any extraneous characters produced by the parser can cause errors; in particular, the semantic analyzer may not be able to parse the AST your parser produces. **Since any prints left in your code will cause you to lose many points, please make sure to remove all prints from your code before submitting the assignment.**

## 8. Notes for the Java version of the assignment
You must declare CUP “types” for your non-terminals and terminals that have attributes. For example, in the skeleton cool.cup is the declaration:

```
nonterminal programc program;
```
This declaration says that the non-terminal program has type programc.

It is critical that you declare the correct types for the attributes of grammar symbols; failure to do so virtually guarantees that your parser won’t work. You do not need to declare types for symbols of your grammar that do not have attributes.

The javac type checker complains if you use the tree constructors with the wrong type parameters. If you fix the errors with frivolous casts, your program may throw an exception when the constructor notices that it is being used incorrectly. Moreover, CUP may complain if you make type errors.

## 9. Autograding 
You should download the script in the same folder where you executed the make command: 
```shell
wget http://raw.githubusercontent.com/CC-4/cc-4.github.io/master/proyectos/scripts/pa2-grading.pl
chmod +x pa2-grading.pl
```

Every time you want to execute the autograder you should use:
```shell
./pa2-grading.pl
```


## Documents
* [The Tree package Javadoc](http://web.stanford.edu/class/cs143/javadoc/cool_ast/)
* [Java CUP Manual](http://www2.cs.tum.edu/projects/cup/manual.html)
* [The Cool Reference Manual](http://web.stanford.edu/class/cs143/materials/cool-manual.pdf)
* [Tour of the Cool Support Code](http://web.stanford.edu/class/cs143/materials/cool-tour.pdf)
* [SPIM Manual](http://web.stanford.edu/class/cs143/materials/SPIM_Manual.pdf)
