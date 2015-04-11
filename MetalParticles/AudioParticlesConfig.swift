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
    
    var evenMassFrequencyMultiplier: Float = 0.055
    var evenMassAmplitudeMultiplier: Float = 0.125
    
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
    
    mutating func setNormalisedValue(param: AudioParticlesConfigFieldNames, value: Float)
    {
        switch param
        {
        case .evenMassFrequencyMultiplier:
            evenMassFrequencyMultiplier = value / 2
        case .evenMassAmplitudeMultiplier:
            evenMassAmplitudeMultiplier = value / 2
        case .evenSpinFrequencyMultiplier:
            evenSpinFrequencyMultiplier = value / 2
        case .evenSpinAmplitudeMultiplier:
            evenSpinAmplitudeMultiplier = value / 2
        case .evenRadiusFrequencyMultiplier:
            evenRadiusFrequencyMultiplier = value
        case .evenRadiusAmplitudeMultiplier:
            evenRadiusAmplitudeMultiplier = value
            
        case .oddMassFrequencyMultiplier:
            oddMassFrequencyMultiplier = value / 2
        case .oddMassAmplitudeMultiplier:
            oddMassAmplitudeMultiplier = value / 2
        case .oddSpinFrequencyMultiplier:
            oddSpinFrequencyMultiplier = value / 2
        case .oddSpinAmplitudeMultiplier:
            oddSpinAmplitudeMultiplier = value / 2
        case .oddRadiusFrequencyMultiplier:
            oddRadiusFrequencyMultiplier = value
        case .oddRadiusAmplitudeMultiplier:
            oddRadiusAmplitudeMultiplier = value
        }
    }
    
    func getNormalisedValue(param: AudioParticlesConfigFieldNames) -> Float
    {
        let returnValue: Float
        
        switch param
        {
        case .evenMassFrequencyMultiplier:
            returnValue = evenMassFrequencyMultiplier * 2
        case .evenMassAmplitudeMultiplier:
            returnValue = evenMassAmplitudeMultiplier * 2
        case .evenSpinFrequencyMultiplier:
            returnValue = evenSpinFrequencyMultiplier * 2
        case .evenSpinAmplitudeMultiplier:
            returnValue = evenSpinAmplitudeMultiplier * 2
        case .evenRadiusFrequencyMultiplier:
            returnValue = evenRadiusFrequencyMultiplier * 1
        case .evenRadiusAmplitudeMultiplier:
            returnValue = evenRadiusAmplitudeMultiplier * 1
            
        case .oddMassFrequencyMultiplier:
            returnValue = oddMassFrequencyMultiplier * 2
        case .oddMassAmplitudeMultiplier:
            returnValue = oddMassAmplitudeMultiplier * 2
        case .oddSpinFrequencyMultiplier:
            returnValue = oddSpinFrequencyMultiplier * 2
        case .oddSpinAmplitudeMultiplier:
            returnValue = oddSpinAmplitudeMultiplier * 2
        case .oddRadiusFrequencyMultiplier:
            returnValue = oddRadiusFrequencyMultiplier * 1
        case .oddRadiusAmplitudeMultiplier:
            returnValue = oddRadiusAmplitudeMultiplier * 1
        }
        
        return returnValue
    }
}

enum AudioParticlesConfigFieldNames: String
{
    case evenMassFrequencyMultiplier = "🔴 Mass frequency"
    case evenMassAmplitudeMultiplier = "🔴 Mass amplitude"
    
    case evenSpinFrequencyMultiplier = "🔴 Spin frequency"
    case evenSpinAmplitudeMultiplier = "🔴 Spin amplitude"
    
    case evenRadiusFrequencyMultiplier = "🔴 Radius frequency"
    case evenRadiusAmplitudeMultiplier = "🔴 Radius amplitude"

    case oddMassFrequencyMultiplier = "🔵 Mass frequency"
    case oddMassAmplitudeMultiplier = "🔵 Mass amplitude"
    
    case oddSpinFrequencyMultiplier = "🔵 Spin frequency"
    case oddSpinAmplitudeMultiplier = "🔵 Spin amplitude"
    
    case oddRadiusFrequencyMultiplier = "🔵 Radius frequency"
    case oddRadiusAmplitudeMultiplier = "🔵 Radius amplitude"
}