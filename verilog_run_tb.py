# COE18B045 - G S Santhosh Raghul
# COE18B048 - Shresta M

from subprocess import call
import os


directory={'AND': 'logic_unit','OR': 'logic_unit','NOR': 'logic_unit','NAND': 'logic_unit','XOR': 'logic_unit','XNOR': 'logic_unit','NOT': 'logic_unit', 'ADD': 'int_adder', 'SUB': 'int_adder','MULT': 'int_mult','FADD': 'float_adder', 'FMULT':'float_mult'}
logic_op={'AND':'0','OR':'1', 'NOR':'2', 'NAND':'3', 'XOR':'4', 'XNOR':'5', 'NOT':'6', 'COMP':'7'}

def run(opn,operand1,operand2):

	cwd = os.getcwd()

	os.chdir(cwd+f'/{directory[opn]}')

	if opn in logic_op:
		with open(f"logic_tb.v",'r') as file:
			filedata = file.read()
	else:
		with open(f"{opn}.v",'r') as file:
			filedata = file.read()

	filedata = filedata.replace('_operand1', hex(operand1)[2:])
	filedata = filedata.replace('_operand2', hex(operand2)[2:])
	if opn in logic_op:
		filedata = filedata.replace('_operation',logic_op[opn])

	with open("tb.v",'w') as files:
		files.write(filedata)

	with open("verilog_output.txt",'w') as fp:
		call(["iverilog","tb.v"])
		call(["./a.out"],stdout=fp)

	f = open("verilog_output.txt", "r")
	op = f.readline().split(' ')[-2]
	os.remove("verilog_output.txt")
	os.remove("tb.v")
	os.remove("a.out")
	os.chdir("..")

	return int(op[-8:],16)