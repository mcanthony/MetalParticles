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
    
    var evenMassFrequencyMultiplier: Float = -0.45
    var evenMassAmplitudeMultiplier: Float = -0.65
    
    var evenSpinFrequencyMultiplier: Float = 0.35
    var evenSpinAmplitudeMultiplier: Float = 0.25
    
    var evenRadiusFrequencyMultiplier: Float = 0.4
    var evenRadiusAmplitudeMultiplier: Float = 0.1
    
    // odd...
    
    var oddMassFrequencyMultiplier: Float = 0.85
    var oddMassAmplitudeMultiplier: Float = 0.75
    
    var oddSpinFrequencyMultiplier: Float = 0.65
    var oddSpinAmplitudeMultiplier: Float = 0.25
    
    var oddRadiusFrequencyMultiplier: Float = 0.6
    var oddRadiusAmplitudeMultiplier: Float = 0.15
}

