/* { dg-do assemble } */

x(x){            return 3 + x;}
a(x){int y[994]; return 3 + x;}
b(x){int y[999]; return 2*(x + 3);}
A(x){int y[9999];return 2*(x + 3);}
B(x){int y[9949];return 3 + x;}
