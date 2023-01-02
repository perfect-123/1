//
//  ContentView.swift
//  Light
//
//  Created by Perfect Ackah on 11/14/22.
//

import SwiftUI

struct Particle {
    //CGPoint is the x and y coordinate
    //Date.now.timeIntervalSinceReferenceDate + 1 means that the time should be recorded after 1 second of somehting.
    // we will use this ensure the particle dies after one second of creation
    let position: CGPoint
    let deathDate = Date.now.timeIntervalSinceReferenceDate + 1.5
}

class ParticleSystem{
    var particles = [Particle]()
    var position = CGPoint.zero
    
    func update(date: TimeInterval){
        particles = particles.filter {$0.deathDate > date}
            particles.append(Particle(position: position))
        }
    }

struct ContentView: View {
    @State private var particleSystem = ParticleSystem()
    
    var body: some View {
        TimelineView(.animation) {
            timeline in
            Canvas {ctx, size in
                let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                particleSystem.update(date: timelineDate)
                
                ctx.blendMode = .plusLighter
//                ctx.blendMode = .plusLighter
                ctx.addFilter(.blur(radius: 10))
                
                for particle in particleSystem.particles {
                    ctx.opacity = particle.deathDate - timelineDate
                    ctx.fill(Circle().path(in: CGRect(x:particle.position.x - 16, y: particle.position.y - 16, width: 32, height: 32)), with: .color(.cyan))
                }
                
            }
            
        }.gesture(DragGesture(minimumDistance: 0)
            .onChanged{ drag in
                particleSystem.position = drag.location
            })
        .edgesIgnoringSafeArea(.all)
        .background(.black)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
