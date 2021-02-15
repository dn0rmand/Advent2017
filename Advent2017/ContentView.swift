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
]

struct ContentView: View {
	@State var text = ""
	
    var body: some View {
		VStack {
			GridStack(minCellWidth: 67,
					  spacing: 0,
					  numItems: 25) {
				index, cellWidth in
				Button("Day \(index+1)",
					   action: { days[index].execute(output: self) })
					.frame(width: cellWidth, height: 32)
		   }
			Text(text)
			.id("Results")
				  .lineLimit(1000)
				  .padding(10)
				  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		}
    }
	
	func Clear() {
		text = ""
	}
	
	func Print(message: String) {
		if text.count == 0 {
			text = message
		} else {
			text = text + "\n" + message
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
