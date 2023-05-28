//
//  PieView.swift
//  card_memory_game
//
//  Created by Enigma Kod on 28/05/2023.
//

import SwiftUI

struct PieView: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        
        path.addLine(to: center)

        return path
    }
}
