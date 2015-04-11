//
//  AudioParticlesConfig.swift
//  MetalParticles
//
//  Created by Simon Gladman on 11/04/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//
//  Configuration for two gravity wells - inner North and South ('even') and
//  outer East and West ('odd').

struct AudioParticlesConfig
{
    // even...
    
    var evenMassFrequencyMultiplier: Float = -0.055
    var evenMassAmplitudeMultiplier: Float = -0.125
    
    var evenSpinFrequencyMultiplier: Float = 0.325
    var evenSpinAmplitudeMultiplier: Float = 0.2
    
    var evenRadiusFrequencyMultiplier: Float = 0.7
    var evenRadiusAmplitudeMultiplier: Float = 0.5
    
    // odd...
    
    var oddMassFrequencyMultiplier: Float = 0.13
    var oddMassAmplitudeMultiplier: Float = 0.075
    
    var oddSpinFrequencyMultiplier: Float = 0.395
    var oddSpinAmplitudeMultiplier: Float = 0.275
    
    var oddRadiusFrequencyMultiplier: Float = 0.3
    var oddRadiusAmplitudeMultiplier: Float = 0.15
}

