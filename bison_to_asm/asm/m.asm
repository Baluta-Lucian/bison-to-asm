bits 32
global start
extern exit
import exit msvcrt.dll
extern printf
import printf msvcrt.dll
extern scanf
import scanf msvcrt.dll

segment data use32 class=data

int_format DB "%d", 0

empty_line DB 0xA, 0x0

c DD 0

b DD 0

a DD 0



segment code use32 class=code


start:
mov EAX, a
push EAX
push dword int_format
call [scanf]
add ESP, 8

mov EAX, b
push EAX
push dword int_format
call [scanf]
add ESP, 8

mov EAX, c
push EAX
push dword int_format
call [scanf]
add ESP, 8

mov EAX, [b]
mov EBX, [c]
cdq
idiv EBX
mov [a], EAX

mov EAX, [c]
imul EAX, [c]
mov [b], EAX

mov EAX, [a]
push EAX
push dword int_format
call [printf]
add ESP, 8

push dword empty_line
call [printf]
add ESP, 4

mov EAX, [b]
push EAX
push dword int_format
call [printf]
add ESP, 8


push dword 0
call [exit]