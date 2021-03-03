//
//  Duet.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/27/21.
//

import Foundation

protocol DuetBaseContext {
	func ip() -> Int
	func move(offset: Int)
	func registers(key: String) -> Int
	func registers(key: String, value: Int)
	func Send(value: Int)
	func Receive(reg: DuetValue) -> Bool
}

protocol DuetValue {
	func getValue(_ context: DuetBaseContext) -> Int
	func setValue(_ context: DuetBaseContext, _ value: Int)
	func toString() -> String
}

enum Duet {
	typealias BaseContext = DuetBaseContext
	typealias Value = DuetValue
	
	enum OpCode {
		case snd, set, add, sub, mul, mod, rcv, jgz, jnz, nop
	}

	class NumberValue: Value {
		var _value: Int
		
		init(_ value: Int) { _value = value }
		
		func getValue(_ context: BaseContext) -> Int {
			return _value
		}
		
		func setValue(_ context: BaseContext, _ value: Int) {}
		
		func toString() -> String {
			return "\(_value)"
		}
	}

	class RegisterValue: Value {
		var register: String
		
		init(_ register: String)
		{
			self.register = register
		}
		
		func getValue(_ context: BaseContext) -> Int
		{
			return context.registers(key:register);
		}
		
		func setValue(_ context: BaseContext, _ value: Int)
		{
			context.registers(key: register, value: value)
		}
		
		func toString() -> String {
			return register
		}
	}

	class Instruction
	{
		var opCode: OpCode
		var value1: Value
		var value2: Value
		
		func toString(_ context: BaseContext) -> String {
			switch opCode {
				case .snd:
					return "\(context.ip()): snd <- \(value1.getValue(context))"
					
				case .set:
					return "\(context.ip()): \(value1.toString()) = \(value2.getValue(context))"
					
				case .add:
					return "\(context.ip()): \(value1.toString()) = \(value1.getValue(context) + value2.getValue(context))"
					
				case .sub:
					return "\(context.ip()): \(value1.toString()) = \(value1.getValue(context) - value2.getValue(context))"

				case .mul:
					return "\(context.ip()): \(value1.toString()) = \(value1.getValue(context) * value2.getValue(context))"

				case .mod:
					return "\(context.ip()): \(value1.toString()) = \(value1.getValue(context) % value2.getValue(context))"

				case .rcv:
					return "\(context.ip()): rcv -> \(value1.toString())"
					
				case .jgz:
					if value1.getValue(context) > 0 {
						return "\(context.ip()): goto \(context.ip() + value2.getValue(context))"
					} else {
						return "\(context.ip()): nop"
					}
			
				case .jnz:
					if value1.getValue(context) != 0 {
						return "\(context.ip()): goto \(context.ip() + value2.getValue(context))"
					} else {
						return "\(context.ip()): nop"
					}

				default:
					return "nop"
			}
		}
		
		func execute(_ context: BaseContext) -> Int {
			switch opCode {
				case .snd:
					context.Send(value: value1.getValue(context))
					break
					
				case .set:
					value1.setValue(context, value2.getValue(context))
					break
					
				case .add:
					let v = value1.getValue(context) + value2.getValue(context)
					value1.setValue(context, v)
					break
					
				case .sub:
					let v = value1.getValue(context) - value2.getValue(context)
					value1.setValue(context, v)
					break
					
				case .mul:
					let v = value1.getValue(context) * value2.getValue(context)
					value1.setValue(context, v)
					break
					
				case .mod:
					let v = value1.getValue(context) % value2.getValue(context)
					value1.setValue(context, v)
					break
					
				case .rcv:
					if !context.Receive(reg: value1) {
						return 0
					}
					break
					
				case .jgz:
					if value1.getValue(context) > 0 {
						return value2.getValue(context)
					}
					break
			
				case .jnz:
					if value1.getValue(context) != 0 {
						return value2.getValue(context)
					}
					break
				
				case .nop:
					break
					
				default:
					Assert(false, "Invalid Opcode")
			}
			
			return 1
		}

		init(_ opCode: OpCode, _ value1: Value, _ value2: Value)
		{
			self.opCode = opCode
			self.value1 = value1
			self.value2 = value2
		}

		init(_ opCode: OpCode)
		{
			self.opCode = opCode
			value1 = NumberValue(0)
			value2 = NumberValue(0)
		}
	}

	class Context : BaseContext {
		private var _ip: Int
		private var _registers: [String:Int]
		
		var sent: Int
		var output: [Int]
		var input: (Value) -> (Bool)
		
		func ip() -> Int { return _ip }
		func move(offset: Int) { _ip += offset }
		
		func registers(key: String) -> Int {
			if let value = _registers[key] {
				return value
			}
			return 0
		}
		
		func registers(key: String, value: Int) {
			return _registers[key] = value
		}
		
		func Send(value: Int) {
			sent += 1
			output.append(value)
		}
		
		func Receive(reg: Value) -> Bool {
			return input(reg)
		}
		
		init(_ id: Int)
		{
			_registers = [String:Int]()
			
			_ip    = 0
			sent   = 0
			output = [Int]()
			input  = { return $0 is RegisterValue }
			
			registers(key: "p", value: id)
		}
	}

	class ContextSwitcher : BaseContext {
		private var a: Context
		private var b: Context
		
		func ip() -> Int {
			return a.ip()
		}
		
		func move(offset: Int) {
			a.move(offset: offset)
		}
		
		func Receive(reg: Value) -> Bool {
			if deadLock {
				move(offset: 1000)
				return false
			}
			
			if count > 0 {
				reg.setValue(a, pop())
				return true
			} else {
				// don't advance and switch context
				Switch()
				return false
			}
		}
		
		func Send(value: Int) {
			a.Send(value: value)
		}
		
		func registers(key: String) -> Int {
			return a.registers(key: key)
		}

		func registers(key: String, value: Int) {
			a.registers(key: key, value: value)
		}

		func Switch() {
			(a, b) = (b, a)
		}
		
		var deadLock : Bool {
			get { return a.output.count == 0 && b.output.count == 0 }
		}
		
		var count: Int {
			get { return b.output.count }
		}
		
		func pop() -> Int {
			return b.output.remove(at: 0)
		}
		
		init(_ a: Context, _ b: Context) {
			self.a = a
			self.b = b
		}
	}

	class Program {
		var instructions: [Instruction]
		
		func getValue(_ parser: Parser) -> Value
		{
			if parser.Peek().isLetter {
				let register = parser.getToken()
				return RegisterValue(register)
			} else {
				let value = parser.getNumber()
				return NumberValue(value)
			}
		}
		
		init(_ input: [String])
		{
			instructions = [Instruction]()
			
			for line in input {
				let parser = Parser(input: line)
				var instruction: Instruction
				
				switch parser.getToken() {
					case "snd":
						instruction = Instruction(.snd)
						instruction.value1 = RegisterValue(parser.getToken())
						break
					case "set":
						instruction = Instruction(.set)
						instruction.value1 = RegisterValue(parser.getToken())
						instruction.value2 = getValue(parser)
						break
					case "add":
						instruction = Instruction(.add)
						instruction.value1 = RegisterValue(parser.getToken())
						instruction.value2 = getValue(parser)
						break
					case "sub":
						instruction = Instruction(.sub)
						instruction.value1 = RegisterValue(parser.getToken())
						instruction.value2 = getValue(parser)
						break
					case "mul":
						instruction = Instruction(.mul)
						instruction.value1 = RegisterValue(parser.getToken())
						instruction.value2 = getValue(parser)
						break
					case "mod":
						instruction = Instruction(.mod)
						instruction.value1 = RegisterValue(parser.getToken())
						instruction.value2 = getValue(parser)
						break
					case "rcv":
						instruction = Instruction(.rcv)
						instruction.value1 = RegisterValue(parser.getToken())
						break
					case "jgz":
						instruction = Instruction(.jgz)
						instruction.value1 = getValue(parser)
						instruction.value2 = getValue(parser)
						break
					case "jnz":
						instruction = Instruction(.jnz)
						instruction.value1 = getValue(parser)
						instruction.value2 = getValue(parser)
						break
					default:
						Assert(false, "invalid opcode")
						instruction = Instruction(.nop)
						break
				}
				
				instructions.append(instruction)
			}
		}

		func run(_ context: BaseContext, willExecute: (Instruction) -> ()) {
			while context.ip() >= 0 && context.ip() < instructions.count {
				let ip = context.ip()
				let i  = instructions[ip]
				willExecute(i)
				let offset = i.execute(context)
				context.move(offset:offset)
			}
		}

		private func beforeExecute(_ instruction: Instruction) {
			
		}
		
		func run(_ context: BaseContext) {
			run(context, willExecute: beforeExecute)
		}
	}
}
