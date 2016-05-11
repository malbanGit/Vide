JFLAGS=-classpath ../../../..
JAVA=java $(JFLAGS)
JAVAC=javac $(JFLAGS)
JAVADOC=javadoc
JLEXFLAGS=-q
JLEX=jflex

.SUFFIXES:
.SUFFIXES: .lex .java
.SUFFIXES: .java .class

.PHONY: all
all: compile

.PHONY: clean
clean: classesclean

.PHONY: allclean
allclean: compileclean

.PHONY : compile
compile: javafiles classes

.PHONY: compileclean
compileclean: classesclean javafilesclean

LEXFILES=$(wildcard *.lex)
.PHONY: javafiles
javafiles: $(LEXFILES:.lex=.java)
	@# Write a bash script that will compile the files in the todo list
	@echo "#!/bin/bash" > tempCommand	
	@# If the todo list doesn't exist, don't compile anything
	@echo "if [ -e tempChangedLexFileList ]" >> tempCommand
	@echo "then" >> tempCommand
	@# Make sure each file is only on the todo list once.
	@echo "sort tempChangedLexFileList | uniq  > tempChangedLexFileListUniq" >> tempCommand
	@echo "FILES=\`cat tempChangedLexFileListUniq\`" >> tempCommand
	@# Compile the files.
	@echo "echo Make: Compiling: $$ FILES" >> tempCommand
	@echo "$(JLEX) $$ FILES" >> tempCommand
	@echo "for file in $$ FILES" >> tempCommand
	@echo "do" >> tempCommand
	@# Each generated java file needs to be compiled by the java compiler.
	@echo "echo \"$$ {file%.lex}.java\" >> tempChangedJavaFileList" >> tempCommand
	@echo "done" >> tempCommand
	@echo "fi" >> tempCommand
	@# Remove extra spaces in the script that follow the dollar signs.
	@sed "s/\$$ /\$$/" tempCommand > tempCommand.sh
	@# Make the script executable.
	@chmod +x tempCommand.sh
	@# Call the script
	@./tempCommand.sh
	@rm -f tempCommand tempCommand.sh tempChangedLexFileList tempChangedLexFileListUniq *~

.lex.java:
	@#for each changed lex file, add it to the todo list.
	@echo "$<" >> tempChangedLexFileList

.PHONY: javafilesclean
javafilesclean: 
	@echo Make: Removing generated Lexer java files.
	@rm -f `find . -name "*.lex" | sed s/.lex/.java/`

JAVAFILES=$(wildcard *.java)
.PHONY: classes
classes: javafiles $(JAVAFILES:.java=.class)
	@# Write a bash script that will compile the files in the todo list
	@echo "#!/bin/bash" > tempCommand	
	@# If the todo list doesn't exist, don't compile anything
	@echo "if [ -e tempChangedJavaFileList ]" >> tempCommand
	@echo "then" >> tempCommand
	@# Make sure each file is only on the todo list once.
	@echo "sort tempChangedJavaFileList | uniq  > tempChangedJavaFileListUniq" >> tempCommand
	@echo "FILES=\`cat tempChangedJavaFileListUniq\`" >> tempCommand
	@# Compile the files.
	@echo "echo Make: Compiling: $$ FILES" >> tempCommand
	@echo "$(JAVAC) $$ FILES" >> tempCommand
	@echo "fi" >> tempCommand
	@# Remove extra spaces in the script that follow the dollar signs.
	@sed "s/\$$ /\$$/" tempCommand > tempCommand.sh
	@# Make the script executable.
	@chmod +x tempCommand.sh
	@# Call the script
	@./tempCommand.sh
	@rm -f tempCommand tempCommand.sh tempChangedJavaFileList tempChangedJavaFileListUniq

.java.class:
	@#for each changed java file, add it to the todo list.
	@echo "$<" >> tempChangedJavaFileList

.PHONY: classesclean
classesclean: junkclean
	@echo Make: Removing Lexer class files
	@rm -f *.class

.PHONY: junkclean
junkclean:
	@echo Make: Removing Lexer detritus.
	@rm -f *.bak *~ ~* core temp*
