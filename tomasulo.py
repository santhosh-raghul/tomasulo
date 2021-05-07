#!/usr/bin/env python3

# COE18B045 - G S Santhosh Raghul
# COE18B048 - Shresta M

# to run: 
# python3 tomasulo.py instructions.txt
# or
# ./tomasulo.py instructions.txt

# verilog module has been incorporated in verilog_run_tb.py which has been imported and called from this file

import os, sys, random
from verilog_run_tb import run

def check_if_number(x):
	return isinstance(x,int)

def log(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def to_hex(x):
	s=hex(x)[2:]
	return '0x'+(8-len(s))*'0'+s

def random_number():
	return random.randrange(0,2**32)

def to_string(d):
	s1='\t'
	s2='\t'
	for i in d:
		s1=s1+f'{i:10}\t'
		v=to_hex(d[i]) if check_if_number(d[i]) else d[i]
		s2=s2+f'{v:10}\t'
	return s1+'\n'+s2

# function to return key for any value
def get_key(value,d):
	for key in d:
		if d[key] == value:
			return key
	return None

class rs_cell:

	def __init__(self):
		#instruction attributes
		self.operation=None
		self.destination=None
		self.operand1=None
		self.operand2=None
		self.age=0 # the number of cyc inst has been waiting for the alu
		self.executing=False # if in alu
		self.cc_rem=0 # clk cyc remaining
		self.free=True # is the reservation station cell free?
		self.tag=None

  	#check if inst ready to dispatch
	def check_if_ready(self):
		return check_if_number(self.operand2) and check_if_number(self.operand1)

	# update age
	def increment_age(self):
		self.age+=1

	# alu simulation based on operation ip
	def evaluate(self):
		if self.operation =='ADD':
			#return int(self.operand1) + int(self.operand2)
			return run('ADD',int(self.operand1),int(self.operand2))

		elif self.operation =='SUB':
			# return int(self.operand1) - int(self.operand2)
			return run('SUB',int(self.operand1),int(self.operand2))
		elif self.operation =='MUL':
			# return int(self.operand1) * int(self.operand2)
			return run('MULT',int(self.operand1),int(self.operand2))
		elif self.operation == 'FADD':
			# return float(self.operand1 + self.operand2)
			return run('FADD',int(self.operand1),int(self.operand2))
		elif self.operation == 'FMUL':
			# return float(self.operand1 * self.operand2)
			return run('FMULT',int(self.operand1),int(self.operand2))

	def __str__(self):
		if self.free:
			return '| ░░░  | ░░░░░░░░░░ | ░░░░░░░░░░ |     free     |'
		op1=to_hex(self.operand1) if check_if_number(self.operand1) else self.operand1
		op2=to_hex(self.operand2) if check_if_number(self.operand2) else self.operand2
		status='dispatched' if self.executing else ' issued'
		if self.operation in ['NOT','COMP']:
			return f'| {self.operation:5s}| {str(op1):11s}| ░░░░░░░░░░ |  {status:^10s}  |'
		return f'| {self.operation:5s}| {str(op1):11s}| {str(op2):11s}|  {status:^10s}  |'

	def run(self):
		if self.executing and self.cc_rem!=-1:
			self.cc_rem-=1


class ls_buff:
	def __init__(self):
		self.ls_queue=[]
		self.mem=[12,34,23,17,69,81,77,51,54,90,4,58,38,86,70,73,75,42,46,54,82,76,21,93,5,63,81,72,92,93,37,7,28,29,88,9,93,4,92,85,51,22,70,93,74,68,99,83,99,24,59,98,37,42,25,42,55,76,73,31,53,67,75,35,89,48,89,16,12,60,29,35,87,57,72,62,93,82,9,36,64,66,84,68,39,83,71,63,44,90,4,81,19,34,48,89,39,5,2,12,40,48,64,65,19,32,59,65,61,91,45,47,34,66,39,39,50,27,30,60,8,66,56,24,81,89,84,29,69,83,1,39,30,63,46,16,74,93,5,44,96,92,99,65,9,44,31,95,7,58,90,86,79,21,15,87,88,66,84,84,74,4,90,31,93,61,44,79,38,84,23,13,62,26,82,13,30,37,97,65,74,35,99,86,77,9,34,45,72,95,63,93,19,12,20,9,31,3,95,59,29,85,9,71,23,56,57,91,26,79,14,67,38,61,75,34,13,83,44,11,77,28,54,31,77,47,26,77,64,5,70,8,8,38,86,86,58,8,76,5,11,32,36,62,79,48,46,75,18,81,60,76,37,44,54,22]
		self.index=0

	def check_if_ready(self):
		if self.ls_queue:
			if self.ls_queue[0][0]=='STR':
				return check_if_number(self.ls_queue[0][1]) and check_if_number(self.ls_queue[0][2][0])
			else:
				return check_if_number(self.ls_queue[0][2][0])
		return False

	def run(self,reg):
		inst=self.ls_queue.pop(0)
		if inst[0]=='LDR':
			return 'ldr',self.mem[int(sum(inst[2]))%len(self.mem)],inst[3]
		else:
			self.mem[int(sum(inst[2]))%len(self.mem)]=reg[inst[1]]
			return None,None,None

class tomasulo:

	def __init__(self,file_name,clock_cycles_per_instruction):

		self.cycles=0
		self.cc=clock_cycles_per_instruction

		with open(file_name) as f:
			self.instr_queue = f.read().splitlines()

		self.registers=dict([ (f'R{i}',random_number()) for i in range(10)])
		self.rat=dict([ (f'R{i}',f'R{i}') for i in range(10)])

		self.rs_add=[rs_cell(),rs_cell(),rs_cell()]
		self.rs_mul=[rs_cell(),rs_cell()]
		self.rs_fadd=[rs_cell(),rs_cell(),rs_cell()]
		self.rs_fmul=[rs_cell(),rs_cell()]
		self.rs_logic=[rs_cell(),rs_cell()]
		self.ls_buffer=ls_buff()

	def execute_one_cycle(self):

		self.cycles+=1
		broadcast_candidates=[]

		# execute any load or store here
		# LDR r5 r7 ['LDR', 'R5', ('R7',off)]
		# LDR r5 r7 ['LDR', 'R5', ('R7',0), 'ldr1']
		# LDR r5 r7+20 ['LDR', 'R5', ('R7',20), 'ldr1']
		# STR r4,r5+30
		if self.ls_buffer.check_if_ready():
			inst,value,tag=self.ls_buffer.run(self.registers)
			if inst:
				broadcast_candidates.append((value,tag))


		def dispatch(rs):

			next_inst=None
			curr_age=0
			for i,inst in enumerate(rs):
				if inst.check_if_ready() and inst.age >= curr_age and not inst.free:
					next_inst=i
					curr_age=inst.age
			alu_is_free=not any([inst.executing for inst in rs])
			if next_inst is not None and alu_is_free:
				# x=rs[next_inst] if next_inst is not None else 'None'
				rs[next_inst].executing=True
				rs[next_inst].cc_rem=self.cc[rs[next_inst].operation]

		dispatch(self.rs_add)
		dispatch(self.rs_mul)
		dispatch(self.rs_fadd)
		dispatch(self.rs_fmul)
		# dispatch(self.rs_shift,self.shift_alu)

		# issue
		def issue(rs,rat_label):
			for i in range(len(rs)):
				if rs[i].free:
					rs[i].free=False
					rs[i].age=0
					rs[i].operation=issue_inst[0]
					rs[i].destination=issue_inst[1]
					rs[i].operand1=self.rat[issue_inst[2]]
					if rs[i].operand1 in self.registers:
						rs[i].operand1=self.registers[rs[i].operand1]
					rs[i].operand2=0
					if rs[i].operation not in ['NOT','COMP']:
						rs[i].operand2=self.rat[issue_inst[3]]
						if rs[i].operand2 in self.registers:
							rs[i].operand2=self.registers[rs[i].operand2]
					rs[i].tag=rat_label+str(i)
					self.rat[rs[i].destination]=rs[i].tag
					self.instr_queue.pop(0)
					return

		def issue_ls():

			# LDR dst:r5 r7 ['LDR', 'R5', ('R7',off)]
			# LDR r5 r7 ['LDR', 'R5', ('R7',0), 'ldr1']
			# LDR r5 r7+20 ['LDR', 'R5', ('R7',20), 'ldr1']
			# STR src:r4,r5+30

			operation=issue_inst[0]
			a1=issue_inst[1]
			x=issue_inst[2].split('+')
			if len(x)==1:
				a2=[x[0],0]
			else:
				a2=[x[0],int(x[1])]

			a1= self.rat[a1] if operation=='STR' else a1
			a2[0]=self.rat[a2[0]]
			if a1 in self.registers and operation=='STR':
				a1=self.registers[a1]
			if a2[0] in self.registers:
				a2[0]=self.registers[a2[0]]

			if operation=='LDR':
				tag='ldr'+str(self.ls_buffer.index)
				self.ls_buffer.ls_queue.append([operation,a1,a2,tag])
				self.rat[a1]=tag
				self.ls_buffer.index+=1
			else:
				self.ls_buffer.ls_queue.append([operation,a1,a2])

			self.instr_queue.pop(0)


		if self.instr_queue:
			issue_inst=self.instr_queue[0].split()
			if issue_inst[0] in ['ADD','SUB']:
				issue(self.rs_add,'RS_A_')
			elif issue_inst[0] =='MUL':
				issue(self.rs_mul,'RS_M_')
			elif issue_inst[0] =='FADD':
				issue(self.rs_fadd,'RS_FA_')
			elif issue_inst[0] =='FMUL':
				issue(self.rs_fmul,'RS_FM_')
			elif issue_inst[0] in ['AND','OR','NOR','NAND','XOR','XNOR','NOT','COMP']:
				issue(self.rs_logic,'RS_L_')
			elif issue_inst[0] in ['LDR','STR']:
				issue_ls()

		# execute
		rs_list=[self.rs_fmul,self.rs_fadd,self.rs_mul,self.rs_add,self.rs_logic]
		for i,rs in enumerate(rs_list):
			for j,inst in enumerate(rs):
				rs_list[i][j].increment_age()
				if inst.executing:
					inst.run()
					if inst.cc_rem==-1:
						broadcast_candidates.append((i,j))

		# write
		if(broadcast_candidates):
			if check_if_number(broadcast_candidates[0][1]):
				# broadcasting from some reservation station
				station,cell=broadcast_candidates[0]
				result=rs_list[station][cell].evaluate()
				tag=rs_list[station][cell].tag
				# broadcast to reservation stations
				for rs in rs_list:
					for rs_cell_ in rs:
						if rs_cell_.operand1==tag:
							rs_cell_.operand1=result
						if rs_cell_.operand2==tag:
							rs_cell_.operand2=result
				# check rat and update register file
				key = get_key(tag,self.rat)
				if key is not None:
					self.registers[key]=result
					self.rat[key]=key
				# free reservation station
				rs_list[station][cell].free=True
				rs_list[station][cell].executing=False
			else:
				# broadcasting from load operation
				value,tag=broadcast_candidates[0]
				# broadcast to reservation stations
				for rs in rs_list:
					for rs_cell_ in rs:
						if rs_cell_.operand1==tag:
							rs_cell_.operand1=value
						if rs_cell_.operand2==tag:
							rs_cell_.operand2=value
				# check rat and update register file
				key = get_key(tag,self.rat)
				if key is not None:
					self.registers[key]=value
					self.rat[key]=key

	def print_status(self):

		print(f'Clock cycles done:  {self.cycles}')
		print(f'Instruction Queue:  {self.instr_queue}\n')
		print(f'Register Alias Table (RAT):\n{to_string(self.rat)}')
		print(f'Register File:\n\n{to_string(self.registers)}\n')
		print(f'Reservation Stations:\n')
		for label,rs in zip(['integer add/sub:','integer mult:','float add:','float mult:','logic:'],[self.rs_add,self.rs_mul,self.rs_fadd,self.rs_fmul,self.rs_logic]):
			print(f'\t{label}')
			for inst in rs:
				print(f'\t\t{inst}')

def main():

	if len(sys.argv)!=2:
		print(f'{sys.argv[0]}: invalid usage\ncorrect usage: {sys.argv[0]} file_name')
		sys.exit()

	filename = sys.argv[1]
	clock_cycles_per_instruction={'ADD':6,'MUL': 11,'SUB':6,'FADD':21 ,'FMUL' :24,'Logic' :1,'STR' : 2 ,'LDR' : 2 }
	tom=tomasulo(filename,clock_cycles_per_instruction)

	tom.print_status()
	print('\n'+'▂'*150+'\n')
	for i in range(100):
		tom.execute_one_cycle()
		tom.print_status()
		print('\n'+'▂'*150+'\n')

if __name__=="__main__":
	main()
