//
//  ContentView.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import SwiftUI
import GridStack

let days: [Day] = [
	Day1.init(),
	Day2.init(),
	Day3.init(),
	Day4.init(),
	Day5.init(),
	Day6.init(),
	Day7.init(),
	Day8.init(),
	Day9.init(),
	Day10.init(),
	Day11.init(),
	Day12.init(),
	Day13.init(),
	Day14.init(),
	Day15.init(),
	Day16.init(),
	Day17.init(),
	Day18.init(),
	Day19.init(),
	Day20.init(),
	Day21.init(),
	Day22.init(),
	Day23.init(),
	Day24.init(),
	Day25.init(),
	AllDays.init(),
]

class AllDays: Day
{
	override func execute(output: ContentView)
	{
		var out = output
		out.Clear()
		out.canClear = false
		
		let startTime = CACurrentMediaTime()

		for d in 0..<days.count-1 {
			let day = days[d]
			day.execute(output: out)
		}
		
		let timeElapsed = Int((CACurrentMediaTime() - startTime) * 1000000) // in μs

		out.Print(message: "Total Execution time is \( formatTime(time: timeElapsed) )\n\n\n")
		out.canClear = true
	}
}
	
struct TintOverlay: View {
  var body: some View {
	ZStack {
	  Text(" ")
	}
	.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
	.background(Color.black)
  }
}

struct ContentView: View {
	@State var text = ""
	@State var running = false
	
    var body: some View {
		GeometryReader { geometry in
			ZStack {
				Image("background")
				  .resizable()
				  .aspectRatio(geometry.size, contentMode: .fit)
				  .overlay(TintOverlay().opacity(0.5))
				  .edgesIgnoringSafeArea(.all)
				VStack {
					GridStack(minCellWidth: 67, spacing: 0, numItems: days.count) {
						index, cellWidth in
						Button("Day \(index+1)",
							   action: { executeDay(index: index) })
							.frame(width: cellWidth, height: 32)
							.disabled(running)
					}
					.frame(idealWidth: 500, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight:100, alignment: .topLeading)
				ScrollView {
					Text(text)
					  .lineLimit(1000)
					  .padding(10)
					  .background(Color.clear)
					  .foregroundColor(.white)
					  .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width, maxHeight: .infinity, alignment: .topLeading)
					}
				}
			}
		}
	}

	var canClear = true
	
	func Clear() {
		if canClear {
			text = ""
		}
	}
	
	func Print(message: String) {
		if Thread.isMainThread {
			if text.count == 0 {
				text = message
			} else {
				text = text + "\n" + message
			}
		} else {
			DispatchQueue.main.sync { Print(message: message) }
		}
	}
	
	func executeDay(index: Int) {
		running = true
		
		let group = DispatchGroup()
				
		group.enter()
		DispatchQueue.global().async {
			days[index].execute(output: self)
			group.leave()
		}
		group.notify(queue: .main) {
			running = false
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ContentView()
		}
    }
}
