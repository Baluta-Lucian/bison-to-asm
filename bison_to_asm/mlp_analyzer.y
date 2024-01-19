%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern void yyerror(const char *s);
extern int yylineno;
extern char* yytext;

char variables[20][9]; // lista cu isntructiuni din segmentul de date
int variableNumber = 0;

char instructions[40][300]; // lista cu instructiuni din segmentul de cod
int instructionNumber = 0;

void appendVariable(char variableName[]){
    sprintf(variables[variableNumber], "%s DD 0\n", variableName);
    variableNumber++;
}

void appendInstruction(char instruct[]){
    strcpy(instructions[instructionNumber], instruct);
    instructionNumber++;
}

void addBrackets(char* new, char* old) {
    strcpy(new, "[");
    strcat(new, old);
    strcat(new, "]");
}


void createOperation(char* result, char* first_arg, char* second_arg, char* operation) {
    char op = operation[0];
    char instruct[300];
    if(op == '+'){
        sprintf(instruct, "mov EAX, %s\nadd EAX, %s\nmov [%s], EAX\n", first_arg, second_arg, result);
    }
    if(op == '-'){
        sprintf(instruct, "mov EAX, %s\nsub EAX, %s\nmov [%s], EAX\n", first_arg, second_arg, result);
    }
    if(op == '*'){
        sprintf(instruct, "mov EAX, %s\nimul EAX, %s\nmov [%s], EAX\n", first_arg, second_arg, result);
    }
    if(op == '/'){
        sprintf(instruct, "mov EAX, %s\nmov EBX, %s\ncdq\nidiv EBX\nmov [%s], EAX\n", first_arg, second_arg, result);
    }
    appendInstruction(instruct);
}

%}



%token<varname> ID
%token<varname> CONST
%token INCLUDE
%token LT
%token GT
%token IOSTREAM
%token USING
%token NAMESPACE
%token STD
%token INT
%token MAIN
%token RETURN
%token CIN
%token COUT
%token SCIN
%token SCOUT
%token<varname> ENDL
%token<op> MINUS
%token<op> PLUS
%token<op> MUL
%token<op> DIV
%token<op> OPERATOR
%token MOD
%token SPARAN
%token EPARAN
%token SBRACE
%token EBRACE
%token ASSIGN
%token SEMICOLON
%token COMMA
%token<varname> ZERO 


%start program
%union {
    char varname[9];
    char op[9];
}

%%
program: lista_importuri USING NAMESPACE STD SEMICOLON INT MAIN SPARAN EPARAN SBRACE lista_instructiuni RETURN CONST SEMICOLON EBRACE
lista_importuri: import | import lista_importuri
import: INCLUDE LT IOSTREAM GT

lista_instructiuni: instructiune lista_instructiuni | instructiune
instructiune: intrare | iesire | declarare | atribuire

intrare: CIN SCIN ID SEMICOLON {
    char instruct[300];
    sprintf(instruct, "mov EAX, %s\npush EAX\npush dword int_format\ncall [scanf]\nadd ESP, 8\n", $3);
    appendInstruction(instruct);
}

iesire: COUT SCOUT ID SEMICOLON {
    char instruct[300];
    sprintf(instruct, "mov EAX, [%s]\npush EAX\npush dword int_format\ncall [printf]\nadd ESP, 8\n", $3);
    appendInstruction(instruct);
}
| COUT SCOUT CONST SEMICOLON {
    char instruct[300];
    sprintf(instruct, "mov EAX, [%s]\npush EAX\npush dword int_format\ncall [printf]\nadd ESP, 8\n", $3);
    appendInstruction(instruct);
}
| COUT SCOUT ENDL SEMICOLON {
    char instruct[300];
    sprintf(instruct, "push dword empty_line\ncall [printf]\nadd ESP, 4\n", $3);
    appendInstruction(instruct);
}

atribuire: 
    ID ASSIGN ID SEMICOLON {
        char instruct[300];
        sprintf(instruct, "mov EAX, [%s]\nmov [%s], EAX\n", $3, $1);
        appendInstruction(instruct);

    }
    | ID ASSIGN CONST SEMICOLON  {
        char instruct[300];
        sprintf(instruct, "mov EAX, $3\nmov [%s], EAX\n", $1);
        appendInstruction(instruct);
    }
    | ID ASSIGN ID OPERATOR ID SEMICOLON {
        char aux1[10];
        addBrackets(aux1, $3);
        char aux2[10];
        addBrackets(aux2, $5);
        createOperation($1, aux1, aux2, $4);
    }
    | ID ASSIGN CONST OPERATOR CONST SEMICOLON {
        createOperation($1, $3, $5, $4);
    }
    | ID ASSIGN ID OPERATOR CONST SEMICOLON {
        char aux[10];
        addBrackets(aux, $3);
        createOperation($1, aux, $5, $4);
    }
    | ID ASSIGN CONST OPERATOR ID SEMICOLON {
        char aux[10];
        addBrackets(aux, $5);
        createOperation($1, $3, aux, $4);
    }


declarare: tip_de_date lista_id SEMICOLON
tip_de_date: INT
lista_id: ID {appendVariable($1);}| ID COMMA lista_id{appendVariable($1);}

%%

void yyerror(const char *s) {
    printf("syntax error: %s at line:  %d\n", yytext, yylineno);
}

int main() {
    yyparse();
    printf("\n");
    printf("bits 32\n");
    printf("global start\n");
    printf("extern exit\n");
    printf("import exit msvcrt.dll\n");
    printf("extern printf\n");
    printf("import printf msvcrt.dll\n");
    printf("extern scanf\n");
    printf("import scanf msvcrt.dll\n");

    printf("\nsegment data use32 class=data\n");
    printf("\nint_format DB \"%%d\", 0\n");
    printf("\nempty_line DB 0xA, 0x0\n");
    printf("\n");

    for(int i = 0; i < variableNumber; i++){
        printf("%s\n", variables[i]);
    }

    printf("\n\nsegment code use32 class=code\n\n");
	printf("\nstart:\n");

    for(int i = 0; i < instructionNumber; i++){
        printf("%s\n", instructions[i]);
    }

    printf("\n");
    printf("push dword 0\n");
	printf("call [exit]");

    printf("\n\n");

    return 0;
}
