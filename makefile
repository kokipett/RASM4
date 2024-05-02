all:
  as -o String_toLowerCase.o String_toLowerCase.s
  as -o String_equals.o String_equals.s
  as -o String_equalsIgnoreCase.o String_equalsIgnoreCase.s
  as -o String_substring_1.o String_substring_1.s
  as -o String_indexOf_3.o String_indexOf_3.s

	as -g rasm4.s -o rasm4.o
	ld  -o rasm4 --entry=_main /usr/lib/aarch64-linux-gnu/libc.so rasm4.o FreeNodes.o Delete_string.o edit_String.o String_toLowerCase.o String_equals.o String_equalsIgnoreCase.o String_substring_1.o String_indexOf_3.o save.o search.o Input_textFile.o FileToList.o Input_keyboard.o View_strings.o  ../obj/String_length.o ../obj/getstring.o ../obj/int64asc.o ../obj/ascint64.o ../obj/putstring.o ../obj/String_copy.o ../obj/putch.o -dynamic-linker /lib/ld-linux-aarch64.so.1


.PHONY:	clean

clean:
	 rm -f *.o run *~
