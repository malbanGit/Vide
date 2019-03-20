asscmp -gloxff tasm tscmpe
asxscn tasm.lst
asscmp -gloxff tlnk tscmpe
aslink -u tlnk
asxscn -i tlnk.rst
