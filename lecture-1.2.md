# Short Introductin to Parsing

This is a topic that we will study in much more detail next semester in Compiler Construction. 
Here we just need to know a few simple rules in order to translate linear syntax, such as `1+2*3` into a tree.

Why is it important to translate strings into trees? In a string such as `1+2+3+4+5*6` we first need to calculate `5*6`. 
This shows that the substring we need to compute first
can be arbitrarily far away from the first letter of the string. So how do we find this substring? The answer is by first converting
the string into a tree. Once we have the data in tree form the answer to such and similar questions is obvious.

*Exercise:* Transform `1+2*3'into a tree. 
 
 The rules according to which a string is transformed into a tree can be given in the form of a [context free grammar]() and are often written using [BNF](). A short BNF definition of a little language for a calculator could be
 
    Exp ::= Integer | Exp "+" Exp | Exp "*" Exp
    
 where `Integer` stands for any whole number in decimal notation. The symbols enclosed in "..." are part of the program (concrete syntax). The other symbols serve to guide the parsing.
 
*Exercise:* Show that `1+2-3` cannot be parsed by the grammar above. Can you modify the grammar so that this becomes possible?

*Exercise:* In the grammar above the string `1+2*3` can be parsed into two different trees. Write them down.
 
 We can modify the grammar so that `1+2*3` has only one parse tree.
 
    Exp     ::=     Exp     "+"     Exp1  | Exp 1
    Exp1    ::=     Exp1    "*"     Exp2  | Exp 2
    Exp2    ::=     Integer 

*Exercise:* Show that there is only one way to parse `1+2*3` in the second grammar. How do you parse `1+2+3+4`?

*Exercise:* Add rules for minus and division.

*Exercise:* Can you parse `(1+2)*3` ? How can you modify the grammar to account for such strings?

*Remark:* BNFC has a feature called coercions. Using this the grammar for the calculator looks as follows:

    Exp     ::=     Exp     "+"     Exp1  ;
    Exp1    ::=     Exp1    "*"     Exp2  ;
    Exp2    ::=     Integer ;
    
    coercions Exp 2

**Parsing Lambda Calculus** The abstract syntax of the lambda calculus can be described simply by

    Exp ::= "\" Id "." Exp | Exp Exp | Id 
    
 As in the arithmetic example, this does not take into account parenthesis. 
 
 *Exercise:* Show that `x y z` can be parsed in two different ways.
 
    Exp1 ::= "\" Id "." Exp1 ;
    Exp2 ::= Exp2 Exp3 
    Exp3 ::= Id ;

    coercions Exp 3 ;
    
 *Exercise:* Show that `x y z` has now only one parse tree.
 
 [LambdaNat.cf](https://github.com/alexhkurz/programming-languages-2019/blob/master/Lambda-Calculus/LambdaNat/grammar/LambdaNat.cf)
 
 **Answers to selected Exercises**
 
 The trees for `(1+2)*3`  and for `1+2*3` are, respectively,
 
         *            +
        / \          / \
       +   3        1   *
      / \              / \
     1   2            2   3
     
 
 **Homework:** 
 - Read the [BNF Converter Tutorial](http://bnfc.digitalgrammars.com/tutorial/bnfc-tutorial.html) up to and including Section "The deeper semantics of precedence levels: dummy labels".
  
 - Install [Haskell](https://www.haskell.org/) on your machine and run some programs in the [LambdaNat language](https://github.com/alexhkurz/programming-languages-2019/tree/master/Lambda-Calculus/LambdaNat). 
 
 - Write a program `plus_one.lc` in LambdaNat that adds +1 to a number. Test your program using the interpreter as in the previous item.
 
 - [Install BNFC](https://github.com/alexhkurz/programming-languages-2019/blob/master/BNFC-installation.md),  and parse some lambda expressions as in the [BNFC Self Check](https://github.com/alexhkurz/programming-languages-2019/blob/master/BNFC-example.md). Compare the abstract syntax trees produced by the parser with the parsing you have done by hand in the exercises above.

 