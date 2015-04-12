//
//  MicrophoneProcessor.swift
//  MetalParticles
//
//  Created by Aurelius Prochazka on 4/11/15.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

class MicrophoneProcessor: AKInstrument {

    // Instrument Properties
    var microphoneGainForAnalysis = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    var microphoneGainForHeadphones  = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 2.0)
    
    var delayFeedback = AKInstrumentProperty(value: 0.8, minimum: 0.0, maximum: 0.99)
    var delayBalance = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    var reverbFeedback = AKInstrumentProperty(value: 0.8, minimum: 0.0, maximum: 0.99)
    
    // Auxilliary Outputs
    var auxilliaryOutput = AKAudio()

    override init() {
        super.init()

        addProperty(microphoneGainForAnalysis)
        addProperty(microphoneGainForHeadphones)
        addProperty(delayFeedback)
        addProperty(reverbFeedback)
        addProperty(delayBalance)
        
        // Instrument Definition
        let mic = AKAudioInput()
        let scaledMicForAnalysis = mic.scaledBy(microphoneGainForAnalysis)
        let scaledMic = mic.scaledBy(microphoneGainForHeadphones)
        let leftDelay  = AKDelay(input: scaledMic, delayTime: akp(0.1),  feedback: delayFeedback)
        let rightDelay = AKDelay(input: scaledMic, delayTime: akp(0.15), feedback: delayFeedback)
        let leftMix  = AKMix(input1: scaledMic, input2: leftDelay,  balance: delayBalance)
        let rightMix = AKMix(input1: scaledMic, input2: rightDelay, balance: delayBalance)
        let mix2 = AKStereoAudio(leftAudio: leftMix, rightAudio: rightMix)
        let stereoReverb = AKReverb(stereoInput: mix2)
        stereoReverb.feedback = reverbFeedback
        setStereoAudioOutput(stereoReverb)

        auxilliaryOutput = AKAudio.globalParameter()
        assignOutput(auxilliaryOutput, to:scaledMicForAnalysis)
    }
}


