//
//  ConfigEditor.swift
//  MetalParticles
//
//  Created by Simon Gladman on 11/04/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ConfigEditor: UIScrollView
{
    var parameterWidgets = [ParameterWidget]()

    var configEditorDelegate: ConfigEditorDelegate?
    
    let view = UIView()
    
    override func didMoveToWindow()
    {
        backgroundColor = UIColor.grayColor()
        
        let parameters = [
            AudioParticlesConfigFieldNames.evenMassFrequencyMultiplier.rawValue,
            AudioParticlesConfigFieldNames.evenMassAmplitudeMultiplier.rawValue,
            AudioParticlesConfigFieldNames.evenSpinFrequencyMultiplier.rawValue,
            AudioParticlesConfigFieldNames.evenSpinAmplitudeMultiplier.rawValue,
            AudioParticlesConfigFieldNames.evenRadiusFrequencyMultiplier.rawValue,
            AudioParticlesConfigFieldNames.evenRadiusAmplitudeMultiplier.rawValue,
            AudioParticlesConfigFieldNames.oddMassFrequencyMultiplier.rawValue,
            AudioParticlesConfigFieldNames.oddMassAmplitudeMultiplier.rawValue,
            AudioParticlesConfigFieldNames.oddSpinFrequencyMultiplier.rawValue,
            AudioParticlesConfigFieldNames.oddSpinAmplitudeMultiplier.rawValue,
            AudioParticlesConfigFieldNames.oddRadiusFrequencyMultiplier.rawValue,
            AudioParticlesConfigFieldNames.oddRadiusAmplitudeMultiplier.rawValue
            ]
        
        addSubview(view)
        
        for (i: Int, paramName: String) in enumerate(parameters)
        {
            let parameterWidget = ParameterWidget(frame: CGRect(x: 10, y: i * 70, width: 280, height: 55))
            
            parameterWidget.fieldName = paramName
            parameterWidget.addTarget(self, action: "parameterChangeHandler:", forControlEvents: UIControlEvents.ValueChanged)
            view.addSubview(parameterWidget)
            parameterWidgets.append(parameterWidget)
        }
        
        view.frame = CGRect(x: 0, y: 0, width: 300, height: parameters.count * 70)
        
        contentSize = view.frame.size
    }

    func parameterChangeHandler(parameterWidget: ParameterWidget)
    {
        if let fieldName = AudioParticlesConfigFieldNames(rawValue: parameterWidget.fieldName!)
        {
            audioParticlesConfig.setNormalisedValue(fieldName, value: parameterWidget.value)
            
            configEditorDelegate?.audioParticlesConfigDidUpdate(audioParticlesConfig)
        }
    }
    
    var audioParticlesConfig = AudioParticlesConfig()
    {
        didSet
        {
            for parameterWidget in parameterWidgets
            {
                if let fieldName = AudioParticlesConfigFieldNames(rawValue: parameterWidget.fieldName!)
                {
                    parameterWidget.value = audioParticlesConfig.getNormalisedValue(fieldName)
                }
            }
        }
    }
    
}

protocol ConfigEditorDelegate
{
    func audioParticlesConfigDidUpdate(audioParticlesConfig: AudioParticlesConfig)
}