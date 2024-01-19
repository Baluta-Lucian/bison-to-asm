./nasm.exe -f obj m.asm -o m.obj
./alink.exe -oPE -subsys console -entry start m.obj
./m.exe