//
//  ContentView.swift
//  Spirograph
//
//  Created by David Bailey on 11/06/2021.
//

import SwiftUI

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat

    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b

        while b != 0 {
            (a, b) = (b, a % b)
        }

        return a
    }

    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let innerRadius = CGFloat(innerRadius)
        let outerRadius = CGFloat(outerRadius)
        let distance = CGFloat(distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(
            2 * CGFloat.pi * outerRadius / CGFloat(divisor)
        ) * amount

        var path = Path()

        for theta in stride(from: CGFloat.zero, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(
                difference / outerRadius * theta
            )
            var y = difference * sin(theta) - distance * sin(
                difference / outerRadius * theta
            )

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

struct ContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1
    @State private var hue = 0.6

    var body: some View {
        VStack {
            Text("Spirograph")
                .fontWeight(.bold)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()

            Spirograph(
                innerRadius: Int(innerRadius), outerRadius: Int(outerRadius),
                distance: Int(distance), amount: amount
            )
            .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
            .frame(width: 300, height: 300)

            Spacer()

            Group {
                HStack {
                    Text("Inner radius: \(Int(innerRadius))")
                    Slider(value: $innerRadius, in: 10 ... 150, step: 1)
                }
                HStack {
                    Text("Outer radius: \(Int(outerRadius))")
                    Slider(value: $outerRadius, in: 10 ... 150, step: 1)
                }
                HStack {
                    Text("Distance: \(Int(distance))")
                    Slider(value: $distance, in: 1 ... 150, step: 1)
                }
                HStack {
                    Text("Amount: \(Int(amount * 100))%")
                    Slider(value: $amount)
                }
                HStack {
                    Text("Color")
                    Slider(value: $hue)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
