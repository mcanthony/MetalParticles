//
//  ViewController.swift
//  MetalParticles
//
//  Created by Simon Gladman on 17/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//
//  Reengineered based on technique from http://memkite.com/blog/2014/12/30/example-of-sharing-memory-between-gpu-and-cpu-with-swift-and-metal-for-ios8/
//
//  Thanks to https://twitter.com/atveit for tips - espewcially using float4x4!!!
//  Thanks to https://twitter.com/warrenm for examples, especially implemnting matrix 4x4 in Swift
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import UIKit

class ViewController: UIViewController, ParticleLabDelegate
{
    var particleLab: ParticleLab!
    
    var gravityWellAngle: Float = 0
    
    let analyzer: AKAudioAnalyzer
    let microphone: Microphone
    
    let floatPi = Float(M_PI)
    
    let amplitudeThreshold: Float = 0.0015
    let audioParticlesConfig = AudioParticlesConfig()
    var evenRadius: Float = 0
    var oddRadius: Float = 0
  
    required init(coder aDecoder: NSCoder) {
        microphone = Microphone()
        analyzer = AKAudioAnalyzer(audioSource: microphone.auxilliaryOutput)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AKOrchestra.addInstrument(microphone)
        AKOrchestra.addInstrument(analyzer)
        microphone.start()
        analyzer.start()
        
        view.backgroundColor = UIColor.blackColor()

        if view.frame.height < view.frame.width
        {
            particleLab = ParticleLab(width: Int(view.frame.width * 2), height: Int(view.frame.height * 2))
            particleLab.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        }
        else
        {
            particleLab = ParticleLab(width: Int(view.frame.height * 2), height: Int(view.frame.width * 2))
            particleLab.frame = CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width)
        }
        
        view.layer.addSublayer(particleLab)
 
        particleLab.showGravityWellPositions = false
        
        particleLab.particleLabDelegate = self

    }
    
    var isRunning: Bool = true
    {
        didSet
        {
            particleLab?.isRunning = isRunning
        }
    }

    func particleLabDidUpdate()
    {
        let amplitude = analyzer.trackedAmplitude.value
        let frequency = analyzer.trackedFrequency.value
        
        let oddMass = amplitude > amplitudeThreshold ?
            (frequency * audioParticlesConfig.oddMassFrequencyMultiplier) + (amplitude * audioParticlesConfig.oddMassAmplitudeMultiplier) :
            0.05
        
        let oddSpin = amplitude > amplitudeThreshold ?
            (frequency * audioParticlesConfig.oddSpinFrequencyMultiplier) + (amplitude * audioParticlesConfig.oddSpinAmplitudeMultiplier) :
            0.5
        
        let evenMass = amplitude > amplitudeThreshold ?
            (frequency * audioParticlesConfig.evenMassFrequencyMultiplier) + (amplitude * audioParticlesConfig.evenMassAmplitudeMultiplier) :
            0.05
        
        let evenSpin = amplitude > amplitudeThreshold ?
            (frequency * audioParticlesConfig.evenSpinFrequencyMultiplier) + (amplitude * audioParticlesConfig.evenSpinAmplitudeMultiplier) :
            0.5
        
        gravityWellAngle = gravityWellAngle + 0.01 + amplitude
        
        let normalisedFrequency = frequency / 5000
        
        let targetColors = UIColor(hue: CGFloat(normalisedFrequency), saturation: 1, brightness: 1, alpha: 1).getRGB()
        particleLab.particleColor = ParticleColor(
            R: (particleLab.particleColor.R * 19 + targetColors.redComponent) / 20,
            G: (particleLab.particleColor.G * 19 + targetColors.greenComponent) / 20,
            B: (particleLab.particleColor.B * 19 + targetColors.blueComponent) / 20,
            A: 1.0)
        
        
        let newEvenRadius = 0.15 +
                            ((normalisedFrequency) * audioParticlesConfig.evenRadiusFrequencyMultiplier) +
                            ((amplitude) * audioParticlesConfig.evenRadiusAmplitudeMultiplier)
        
        let newOddRadius =  0.25 +
                            ((normalisedFrequency) * audioParticlesConfig.oddRadiusFrequencyMultiplier) +
                            ((amplitude) * audioParticlesConfig.oddRadiusAmplitudeMultiplier)
        
        evenRadius = ((evenRadius * 19) + newEvenRadius) / 20
        oddRadius = ((oddRadius * 19) + newOddRadius) / 20
        
        
        particleLab.setGravityWellProperties(gravityWell: .One,
            normalisedPositionX: 0.5 + oddRadius * cos(1.3 * gravityWellAngle),
            normalisedPositionY: 0.5 + oddRadius * sin(1.3 * gravityWellAngle),
            mass: oddMass,
            spin: oddSpin
        )
        
        particleLab.setGravityWellProperties(gravityWell: .Two,
            normalisedPositionX: 0.5 + evenRadius * sin(gravityWellAngle + floatPi * 0.5),
            normalisedPositionY: 0.5 + evenRadius * cos(gravityWellAngle + floatPi * 0.5),
            mass: evenMass,
            spin: evenSpin
        )
        
        particleLab.setGravityWellProperties(gravityWell: .Three,
            normalisedPositionX: 0.5 + oddRadius * cos(1.3 * gravityWellAngle + floatPi),
            normalisedPositionY: 0.5 + oddRadius * sin(1.3 * gravityWellAngle + floatPi),
            mass: oddMass,
            spin: oddSpin
        )
        
        particleLab.setGravityWellProperties(gravityWell: .Four,
            normalisedPositionX: 0.5 + evenRadius * sin(gravityWellAngle + floatPi * 1.5),
            normalisedPositionY: 0.5 + evenRadius * cos(gravityWellAngle + floatPi * 1.5),
            mass: evenMass,
            spin: evenSpin
        )
    }
    
    override func supportedInterfaceOrientations() -> Int
    {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}







