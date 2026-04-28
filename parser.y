%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);
extern int line;

/* FLAGS */
int syntaxErrorFlag = 0;

/* ERROR STORAGE */
typedef struct {
    int line;
    char msg[100];
} Error;

Error lexErrors[100], synErrors[100], semErrors[100];
int lexCount=0, synCount=0, semCount=0;
int errorCount = 0;

/* ERROR FUNCTIONS */
void addLexError(int l, const char *msg){
    lexErrors[lexCount].line=l;
    strcpy(lexErrors[lexCount++].msg,msg);
    errorCount++;
}

void addSynError(int l, const char *msg){
    synErrors[synCount].line=l;
    strcpy(synErrors[synCount++].msg,msg);
    errorCount++;
    syntaxErrorFlag = 1;
}

void addSemError(int l, const char *msg){
    semErrors[semCount].line=l;
    strcpy(semErrors[semCount++].msg,msg);
    errorCount++;
}

/* SYMBOL TABLE */
typedef struct {
    char name[50];
    char type[10];
    int initialized;
} Symbol;

Symbol symtab[100];
int symcount=0;

int lookup(char *s){
    for(int i=0;i<symcount;i++)
        if(strcmp(symtab[i].name,s)==0) return i;
    return -1;
}

void insert(char *name,char *type){
    if(lookup(name)!=-1){
        if(!syntaxErrorFlag)
            addSemError(line,"Redeclaration of variable");
        return;
    }
    strcpy(symtab[symcount].name,name);
    strcpy(symtab[symcount].type,type);
    symtab[symcount].initialized=0;
    symcount++;
}

/* TYPE CHECK */
char* checkType(char* t1,char* t2){
    if(!t1 || !t2) return NULL;

    if(strcmp(t1,t2)==0) return t1;

    if((strcmp(t1,"int")==0 && strcmp(t2,"float")==0) ||
       (strcmp(t1,"float")==0 && strcmp(t2,"int")==0))
        return "float";

    if(!syntaxErrorFlag)
        addSemError(line,"Type mismatch in expression");

    return t1;
}

/* ================= AST ================= */

typedef struct node {
    char label[20];
    struct node *left, *right;
} node;

node* createNode(char* label, node* left, node* right){
    node* n = malloc(sizeof(node));
    strcpy(n->label,label);
    n->left = left;
    n->right = right;
    return n;
}

node* root = NULL;

/* ================= DAG ================= */

node* createDAG(node* root){
    if(!root) return NULL;

    root->left = createDAG(root->left);
    root->right = createDAG(root->right);

    if(root->left && root->right &&
       strcmp(root->left->label, root->right->label) == 0 &&
       root->left->left == root->right->left &&
       root->left->right == root->right->right){
        return root->left;
    }

    return root;
}

/* ================= IR ================= */

void printAST(node* root,int lvl){
    if(!root) return;
    for(int i=0;i<lvl;i++) printf("  ");
    printf("%s\n",root->label);
    printAST(root->left,lvl+1);
    printAST(root->right,lvl+1);
}

void printPostfix(node* root){
    if(!root) return;
    printPostfix(root->left);
    printPostfix(root->right);
    printf("%s ",root->label);
}

int tempCount=0;

char* newTemp(){
    char* t=malloc(10);
    sprintf(t,"t%d",tempCount++);
    return t;
}

char* generateTAC(node* root){
    if(!root) return NULL;

    if(!root->left && !root->right)
        return root->label;

    char* l=generateTAC(root->left);
    char* r=generateTAC(root->right);

    char* t=newTemp();
    printf("%s = %s %s %s\n",t,l,root->label,r);

    return t;
}

/* PRINT */
void printSymbolTable(){
    printf("\n===== SYMBOL TABLE =====\n");
    printf("Name\tType\tInitialized\n");

    for(int i=0;i<symcount;i++){
        printf("%s\t%s\t%d\n",
            symtab[i].name,
            symtab[i].type,
            symtab[i].initialized);
    }
}

void printErrors(){
    printf("\n===== LEXICAL ERRORS =====\n");
    for(int i=0;i<lexCount;i++)
        printf("Line %d : LEXICAL ERROR : %s\n",lexErrors[i].line,lexErrors[i].msg);

    printf("\n===== SYNTAX ERRORS =====\n");
    for(int i=0;i<synCount;i++)
        printf("Line %d : SYNTAX ERROR : %s\n",synErrors[i].line,synErrors[i].msg);

    if(!syntaxErrorFlag){
        printf("\n===== SEMANTIC ERRORS =====\n");
        for(int i=0;i<semCount;i++)
            printf("Line %d : SEMANTIC ERROR : %s\n",semErrors[i].line,semErrors[i].msg);
    }
}
%}

/* UNION */
%union {
    char* str;
    struct {
        char* type;
        struct node* node;
    } exprAttr;
}

/* TOKENS */
%token <str> IDENTIFIER NUMBER STRING_LITERAL CHAR_LITERAL
%token INT FLOAT CHAR STRING
%token IF ELSE WHILE FOR
%token PLUS MINUS MUL DIV ASSIGN RELOP
%token SEMI LPAREN RPAREN LBRACE RBRACE

%type <str> type
%type <exprAttr> expr

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc RELOP
%left PLUS MINUS
%left MUL DIV

%%

program:
    program stmt
    | stmt
;

stmt:
      decl
    | assign
    | if_stmt
    | while_stmt
    | block
    | error SEMI { addSynError(line,"Invalid statement"); yyerrok; }
;

block:
    LBRACE program RBRACE
;

decl:
    type IDENTIFIER SEMI {
        insert($2,$1);
    }

    | type IDENTIFIER ASSIGN expr SEMI {
        insert($2,$1);
        int i=lookup($2);
        if(i!=-1 && !syntaxErrorFlag){
            if(strcmp(symtab[i].type,$4.type)!=0)
                addSemError(line,"Type mismatch in initialization");
            symtab[i].initialized=1;
        }
    }

    | type IDENTIFIER ASSIGN error SEMI {
        addSynError(line,"Missing expression in declaration");
        yyerrok;
    }
;

type:
      INT { $$="int"; }
    | FLOAT { $$="float"; }
    | CHAR { $$="char"; }
    | STRING { $$="string"; }
;

assign:
    IDENTIFIER ASSIGN expr SEMI {

        int i=lookup($1);

        if(i==-1 && !syntaxErrorFlag){
            addSemError(line,"Undeclared variable");
        } 
        else if(i!=-1 && !syntaxErrorFlag){
            if(strcmp(symtab[i].type,$3.type)!=0)
                addSemError(line,"Type mismatch in assignment");
            symtab[i].initialized=1;
        }

        root = createNode("=", createNode($1,NULL,NULL), $3.node);
    }

    | IDENTIFIER ASSIGN error SEMI {
        addSynError(line,"Missing expression after '='");
        yyerrok;
    }
;

if_stmt:
    IF LPAREN expr RPAREN stmt %prec LOWER_THAN_ELSE
    | IF LPAREN expr RPAREN stmt ELSE stmt
    | IF LPAREN error RPAREN {
        addSynError(line,"Invalid condition in if");
        yyerrok;
    }
;

while_stmt:
    WHILE LPAREN expr RPAREN stmt
;

expr:
      expr PLUS expr {
        $$.type = checkType($1.type,$3.type);
        $$.node = createNode("+",$1.node,$3.node);
      }
    | expr MINUS expr {
        $$.type = checkType($1.type,$3.type);
        $$.node = createNode("-",$1.node,$3.node);
      }
    | expr MUL expr {
        $$.type = checkType($1.type,$3.type);
        $$.node = createNode("*",$1.node,$3.node);
      }
    | expr DIV expr {
        $$.type = checkType($1.type,$3.type);
        $$.node = createNode("/",$1.node,$3.node);
      }
    | expr RELOP expr {
        $$.type = "int";
        $$.node = createNode("relop",$1.node,$3.node);
      }
    | IDENTIFIER {
        int i = lookup($1);

        if(i == -1 && !syntaxErrorFlag){
            addSemError(line,"Undeclared variable");
            $$.type = NULL;
        } else {
            $$.type = symtab[i].type;
        }

        $$.node = createNode($1,NULL,NULL);
    }
    | NUMBER {
        $$.type = $1;
        $$.node = createNode($1,NULL,NULL);
    }
    | STRING_LITERAL {
        $$.type = "string";
        $$.node = createNode("str",NULL,NULL);
    }
    | CHAR_LITERAL {
        $$.type = "char";
        $$.node = createNode("char",NULL,NULL);
    }
    | LPAREN expr RPAREN { $$ = $2; }
;

%%

int main(int argc, char* argv[]){

    int choice = 1;

    if(argc == 2){
        choice = atoi(argv[1]);
    }

    yyparse();

    printf("Total Errors: %d\n",errorCount);

    if(lexCount > 0 || synCount > 0){
        printErrors();
        return 0;
    }

    printErrors();

    if(semCount > 0){
        printSymbolTable();
        return 0;
    }

    printf("\n\n");

    if(choice==1){
        printf("===== IR (AST) =====\n");
        printAST(root,0);
    }
    else if(choice==2){
        printf("===== IR (DAG) =====\n");
        node* dagRoot = createDAG(root);
        printAST(dagRoot,0);
    }
    else if(choice==3){
        printf("===== IR (Postfix) =====\n");
        printPostfix(root);
        printf("\n");
    }
    else if(choice==4){
        printf("===== IR (TAC) =====\n");
        generateTAC(root);
        printf("\n");
    }

    return 0;
}

void yyerror(const char *s){}
