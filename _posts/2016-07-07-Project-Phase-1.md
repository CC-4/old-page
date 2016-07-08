---
layout: post
title: "Project Phase 1"
comments: true
date:   2016-07-07 11:58:00 -0600
category: proyectos
numero: 1
descripcion: >
 Instrucciones para la fase 1 del compilador de COOL.
---
# Programming Assignment I

## 1. Overview of the Programming Project

Programming assignments I–IV will direct you to design and build a compiler for Cool. Each assignment will cover one component of the compiler:

* lexical analysis
* parsing
* semantic analysis
* code generation.

Each assignment will ultimately result in a working compiler phase which can interface with other phases.

For this assignment, you are to write a lexical analyzer, also called a scanner, using a _lexical analyzer generator_ (the Java tool is called _JLex_). You will describe the set of tokens for Cool in an appropriate input format, and the analyzer generator will generate the actual code (Java) for recognizing tokens in Cool programs.

On-line documentation for all the tools needed for the project will be made available on the “Project Resources” on the GES. This includes manuals for JLex (used in this assignment), the documentation for java cup (used in the next assignment), as well as the manual for the spim simulator.
You must work individually on this assignment (no collaboration in groups).

## 2. Introduction to JLex
JLex allows you to implement a lexical analyzer by writing rules that match on user-defined regular expressions and performing a specified action for each matched pattern. JLex compiles your rule file (e.g., “lexer.lex”) to Java source code implementing a finite automaton recognizing the regular expressions that you specify in your rule file. Fortunately, it is not necessary to understand or even look at the automatically generated (and often very messy) file implementing your rules. Rule files in JLex are structured as follows:
```JLex
%{
Declarations
%}
Definitions
%%
Rules
%%
User subroutines
```
The Declarations and User subroutines sections are optional and allow you to write declarations and helper functions in Java. The Definitions section is also optional, but often very useful as definitions allow you to give names to regular expressions. For example, the definition
```JLex
DIGIT = [0-9]
```
allows you to define a digit. Here, `DIGIT` is the name given to the regular expression matching any single character between 0 and 9. The following table gives an overview of the common regular expressions that can be specified in _JLex_:

|Expression|               Description                    |
|---------|:----------------------------------------------|
|`x`      | the character "x"                             |
|`"x"`    | an "x", even if x is an operator.             |
|`\x`     | an ”x”, even if x is an operator.             |
|`[xy]`   | the character x or y.                         |
|`[x-z]`  | the characters x, y or z.                     |
|`[^x]`   | any character but x.                          |
|`.`      | any character but newline.                    |
|`^x`     | an x at the beginning of a line.              |
|`<y>x`   | an x when Lex is in start condition y.        |
|`x$`     | an x at the end of a line.                    |
|`x?`     | an optional x.                                |
|`x*`     | 0,1,2, ... instances of x.                    |
|`x+`	  | 1,2,3, ... instances of x.                    |
|`x`&#124;`y`| an x or a y.                               |
|`(x)`    | an x.                                         |
|`x/y`	| an x but only if followed by y.                 |
|`{xx}`	| the translation of xx from the definitions section. |
|`x{m,n}`	| m through n occurrences of x                |

The most important part of your lexical analyzer is the rules section. A rule in _JLex_ specifies an action to perform if the input matches the regular expression or definition at the beginning of the rule. The action to perform is specified by writing regular Java source code. For example, assuming that a digit represents a token in our language (note that this is not the case in Cool), the rule:

```JLex
{DIGIT} {
    AbstractSymbol num = AbstractTable.inttable.addString(yytext());
    return new Symbol(TokenConstants.INT_CONST, num);
}
```

records the value of the digit in the global variable `AbstractTable.inttable` and returns the appropriate token code. (See Section 5 for a more detailed discussion of the global variable `AbstractTable.inttable` and see Section 4.2 for a discussion of the `AbstractTable.inttable` used in the above code fragment.)

An important point to remember is that if the current input (i.e., the result of the function call to `next_token()`) matches multiple rules, **JLex picks the rule that matches the largest number of characters.** For instance, if you define the following two rules

```JLex
[0-9]+      { // action 1 }
[0-9a-z]+   { // action 2 }
```
and if the character sequence `2a` appears next in the file being scanned, then action `2` will be performed since the second rule matches more characters than the first rule. If multiple rules match the same number of characters, then the rule appearing first in the file is chosen.

When writing rules in JLex, it may be necessary to perform different actions depending on previously encountered tokens. For example, when processing a closing comment token, you might be interested in knowing whether an opening comment was previously encountered. One obvious way to track state is to declare global variables in your declaration section, which are set to true when certain tokens of interest are encountered. JLex also provides syntactic sugar for achieving similar functionality by using state declarations such as:

```JLex
%state COMMENT
```
which can be set to true by writing `yybegin(COMMENT)`. To perform an action only if an opening comment was previously encountered, you can predicate your rule on COMMENT using the syntax:

``` JLex
<COMMENT> reg_exp {
    // action
}
```
There is also a special default state called `YYINITIAL` which is active unless you explicitly indicate the beginning of a new state(using `yybegin(STATE)`). You might find this syntax useful for various aspects of this assignment, such as error reporting. We strongly encourage you to read the documentation on JLex linked from the Project Resources section on the GES before writing your own lexical analyzer.

## 3. Files and Directories
To get started, create a directory where you want to do the assignment and execute one of the following commands in that directory. You should type:

```shell
make -f /usr/class/cs143/assignments/PA2J/Makefile
```
Note that even though this is the first programming assignment, the directory name is PA2. Future assignments will also have directories that are one more than the assignment number–please don’t get confused! This situation arises because we are skipping the usual first assignment in this offering of the course. This command will copy a number of files to your directory. Some of the files will be copied read-only (using symbolic links). You should not edit these files. In fact, if you make and modify private copies of these files, you may find it impossible to complete the assignment. See the instructions in the README file. The files that you will need to modify are:

* `cool.lex`
This file contains a skeleton for a lexical description for Cool. There are comments indicating where you need to fill in code, but this is not necessarily a complete guide. Part of the assignment is for you to make sure that you have a correct and working lexer. Except for the sections indicated, you are welcome to make modifications to our skeleton. You can actually build a scanner with the skeleton description, but it does not do much. You should read the JLex manual to figure out what this description does do. Any auxiliary routines that you wish to write should be added directly to this file in the appropriate section (see comments in the file).
* `test.cl` This file contains some sample input to be scanned. It does not exercise all of the lexical specification, but it is nevertheless an interesting test. Feel free to modify this file to test your scanner.
• `README` This file contains detailed instructions for the assignment as well as a number of useful tips.
Although these files are incomplete as given, the lexer does compile and run. To build the lexer, you must type:

```shell
make lexer
```

## 4. Scanner Results
In this assignment, you are expected to write JLex rules that match on the appropriate regular expressions defining **valid tokens in Cool as described in Section 10 and Figure 1 of the Cool manual** and perform the appropriate actions, such as returning a token of the correct type, recording the value of a lexeme where appropriate, or reporting an error when an error is encountered. Before you start on this assignment, make sure to read Section 10 and Figure 1 of the Cool manual; then study the different tokens defined in `TokenConstants.java`. Your implementation needs to define JLex rules that match the regular expressions defining each token defined in `TokenConstants.java` and perform the appropriate action for each matched token. For example, if you match on a token `BOOL_CONST`, your lexer has to record whether its value is true or false; similarly if you match on a `TYPEID` token, you need to record the name of the type. Note that not every token requires storing additional information; for example, only returning the token type is sufficient for some tokens like keywords.

Your scanner should be robust—it should work for any conceivable input. For example, you must handle errors such as an `EOF` occurring in the middle of a string or comment, as well as string constants that are too long. These are just some of the errors that can occur; see the manual for the rest.

You must make some provision for graceful termination if a fatal error occurs. Core dumps or uncaught exceptions are unacceptable.

### 4.1 Error Handling
All errors should be passed along to the parser. You lexer should not print anything. Errors are communicated
to the parser by returning a special error token called `ERROR`. (Note, you should ignore the
token called error [in lowercase] for this assignment; it is used by the parser in PA3.) There are several
requirements for reporting and recovering from lexical errors:

* When an invalid character (one that can’t begin any token) is encountered, a string containing just
that character should be returned as the error string. Resume lexing at the following character.
* If a string contains an unescaped newline, report that error as `"Unterminated string constant"`
and resume lexing at the beginning of the next line—we assume the programmer simply forgot the
close-quote.
* When a string is too long, report the error as `"String constant too long"` in the error string
in the `ERROR` token. If the string contains invalid characters (i.e., the null character), report this
as `"String contains null character"`. In either case, lexing should resume after the end of the
string. The end of the string is defined as either
    1. the beginning of the next line if an unescaped newline occurs after these errors are encountered;
    or
    2. after the closing " otherwise.
* If a comment remains open when `EOF` is encountered, report this error with the message `"EOF
in comment"`. Do not tokenize the comment’s contents simply because the terminator is missing.
Similarly for strings, if an `EOF` is encountered before the close-quote, report this error as `"EOF in
string constant"`.
* If you see `"*)"` outside a comment, report this error as `" Unmatched *)"`, rather than tokenzing it
as `*` and `)`.

* Recall from lecture that this phase of the compiler only catches a very limited class of errors. **Do not
check for errors that are not lexing errors in this assignment**. For example, you should not
check if variables are declared before use. Be sure you understand fully what errors the lexing phase
of a compiler does and does not check for before you start.

### 4.2 String Table
Programs tend to have many occurrences of the same lexeme. For example, an identifier is generally
referred to more than once in a program (or else it isn’t very useful!). To save space and time, a common
compiler practice is to store lexemes in a _string table_. We provide a string table implementation for Java. See the following sections for the details.

There is an issue in deciding how to handle the special identifiers for the basic classes (**Object**, **Int**,
**Bool**, **String**), `SELF_TYPE`, and `self`. However, this issue doesn’t actually come up until later phases of
the compiler—the scanner should treat the special identifiers exactly like any other identifier.
Do not test whether integer literals fit within the representation specified in the Cool manual—simply
create a Symbol with the entire literal’s text as its contents, regardless of its length.

### 4.3 Strings
Your scanner should convert escape characters in string constants to their correct values. For example,
if the programmer types these eight characters:
<center>
![String1]({{ site.url }}/proyectos/strings1.png)
</center>

your scanner would return the token STR CONST whose semantic value is these 5 characters:

<center>
![String2]({{ site.url }}/proyectos/strings2.png)
</center>

where `\n` represents the literal ASCII character for newline.

Following specification on page 15 of the Cool manual, you must return an error for a string containing
the literal null character. However, the sequence of two characters

<center>
![String_null1]({{ site.url }}/proyectos/strings_null1.png)
</center>

is allowed but should be converted to the one character

<center>
![String_null2]({{ site.url }}/proyectos/strings_null2.png)
</center>

### 4.4 Other Notes
Your scanner should maintain the variable `curr_lineno` that indicates which line in the source text is
currently being scanned. This feature will aid the parser in printing useful error messages.
You should ignore the token `LET_STMT`. It is used only by the parser (PA3). Finally, note that
if the lexical specification is incomplete (some input has no regular expression that matches), then the
scanners generated by _JLex_ do undesirable things. _Make sure your specification is complete_

## 5 Notes for the Java Version of the assignment

* Each call on the scanner returns the next token and lexeme from the input. The value returned by the
method `CoolLexer.next_token` is an object of class `java_cup.runtime.Symbol`. This object has
a field representing the syntactic category of a token (e.g., integer literal, semicolon, the if keyword,
etc.). The syntactic codes for all tokens are defined in the file TokenConstants.java. The component,
the semantic value or lexeme (if any), is also placed in a `java_cup.runtime.Symbol` object. The
documentation for the class `java_cup.runtime.Symbol` as well as other supporting code is available
on the course web page. Examples of its use are also given in the skeleton.
* For class identifiers, object identifiers, integers, and strings, the semantic value should be of type
AbstractSymbol. For boolean constants, the semantic value is of type java.lang.Boolean. Except for errors (see below), the lexemes for the other tokens do not carry any interesting information. Since
the value field of class `java_cup.runtime.Symbol` has generic type `java.lang.Object`, you will need
to cast it to a proper type before calling any methods on it.
* We provide you with a _string table_ implementation, which is defined in `AbstractTable.java`. For the
moment, you only need to know that the type of string table entries is `AbstractSymbol`.
* When a lexical error is encountered, the routine `CoolLexer.next_token` should return a
`java_cup.runtime.Symbol` object whose syntactic category is `TokenConstants.ERROR` and
whose semantic value is the error message string. **See Section 4 for information on how to construct
error messages.**

## 6. Testing the Scanner
There are at least two ways that you can test your scanner. The first way is to generate sample inputs
and run them using lexer, which prints out the line number and the lexeme of every token recognized
by your scanner. The other way, when you think your scanner is working, is to try running `.\mycoolc` to
invoke your lexer together with all other compiler phases (which we provide). This will be a complete
Cool compiler that you can try on any test programs.

## Documents
* [JFlex Manual](http://www.cs.princeton.edu/~appel/modern/java/JLex/)
* [The Cool Reference Manual](http://web.stanford.edu/class/cs143/materials/cool-manual.pdf)
* [Tour of the Cool Support Code](http://web.stanford.edu/class/cs143/materials/cool-tour.pdf)
* [SPIM Manual](http://web.stanford.edu/class/cs143/materials/SPIM_Manual.pdf)
