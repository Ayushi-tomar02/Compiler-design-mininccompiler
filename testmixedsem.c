int a;
float b = 10.7;
char ch = 'a';
string s = "Ayushi";

int c = 12.4;              // semantic: type mismatch (int ← float)

a = b + 5;                 // semantic: type mismatch (int ← float)

if (a > 0) {               
    a = 5;
}

int y;
int y;                     // semantic: redeclaration

x = y + 3;                 // semantic: x undeclared

int p;
int q = p + 2;             // semantic: p uninitialized

string str;
str = 10;                  // semantic: type mismatch (string ← int)