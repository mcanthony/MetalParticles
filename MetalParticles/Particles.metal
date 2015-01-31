//
//  Particles.metal
//  MetalParticles
//
//  Created by Simon Gladman on 17/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//
//  Thanks to: http://memkite.com/blog/2014/12/15/data-parallel-programming-with-metal-and-swift-for-iphoneipad-gpu/

#include <metal_stdlib>
using namespace metal;

struct PrimeNumber
{
    float numericValue;
    float isPrime;
};


kernel void particleRendererShader(const device PrimeNumber *inPrimeNumbers [[ buffer(0) ]],
                                   device PrimeNumber *outPrimeNumbers [[ buffer(1) ]],
                                   uint id [[thread_position_in_grid]])
{
     int thisNumber = int(inPrimeNumbers[id].numericValue);
     int sqrtThisNumber = int( sqrt(inPrimeNumbers[id].numericValue + 1) ) ;
    
    bool isComposite = false;
    int idx = 2;
    
    while (idx <= sqrtThisNumber && !isComposite)
    {
        isComposite = (thisNumber % idx) == 0;
        
        idx++;
    }
    
    outPrimeNumbers[id] = PrimeNumber
    {
        .numericValue = inPrimeNumbers[id].numericValue,
        .isPrime = isComposite ? 0.0f : 1.0f
    };
    

}