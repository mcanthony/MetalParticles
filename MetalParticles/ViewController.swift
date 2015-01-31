//
//  ViewController.swift
//  MetalParticles
//
//  Created by Simon Gladman on 17/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit
import Metal
import QuartzCore
import CoreData

class ViewController: UIViewController
{
    
    var kernelFunction: MTLFunction!
    var pipelineState: MTLComputePipelineState!
    var defaultLibrary: MTLLibrary! = nil
    var device: MTLDevice! = nil
    var commandQueue: MTLCommandQueue! = nil
    
    let imageView =  UIImageView(frame: CGRectZero)
    let markerWidget = MarkerWidget(frame: CGRectZero)

    var errorFlag:Bool = false
    
    var threadGroupCount:MTLSize!
    var threadGroups:MTLSize!

    // 10^7 | 10000000 = prime count = 664,579
    var primeNumbers = [PrimeNumber](count: 1000000, repeatedValue: PrimeNumber(numericValue: 0, isPrime: -1))
    var cpuPrimeNumbers = [PrimeNumber](count: 1000000, repeatedValue: PrimeNumber(numericValue: 0, isPrime: -1))

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for i in 0 ..< primeNumbers.count
        {
            primeNumbers[i].numericValue = Float(i + 1)
            cpuPrimeNumbers[i].numericValue = Float(i + 1)
        }
        
        runMetal()
        
        runCPU()
    }

    
    final func runCPU()
    {
        let frameStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = findPrimeNumbers()
        
        println("----------")
        
        println("Swift solve time: frametime:" + NSString(format: "%.6f", CFAbsoluteTimeGetCurrent() - frameStartTime))
        println("Swift found \(result.filter({$0.isPrime == 1}).count) prime numbers");
    }

    final func findPrimeNumbers() -> [PrimeNumber]
    {
       var resultdata =  [PrimeNumber](count:cpuPrimeNumbers.count, repeatedValue: PrimeNumber(numericValue: 0, isPrime: -1))
        
        for (id: Int, primeNumber: PrimeNumber) in enumerate(cpuPrimeNumbers)
        {
            let thisNumber = Int(primeNumber.numericValue)
            let sqrtThisNumber = Int(sqrt(primeNumber.numericValue + 1))
            
            var isPrime = true
            
            for (var i = 2; i <= sqrtThisNumber; i++)
            {
                if (thisNumber % i == 0)
                {
                    isPrime = false;
                    break;
                }
            }
            
            resultdata[id].numericValue = Float(thisNumber);
            resultdata[id].isPrime =  isPrime ? 1 : 0;
            
        }
        
        return resultdata
    }
    
    //-------

    final func runMetal()
    {
        setUpMetal()
        
        let frameStartTime = CFAbsoluteTimeGetCurrent()

        let result = metalFindPrimeNumbers()
 
        println("----------")
        
        println("Metal solve time: frametime:" + NSString(format: "%.6f", CFAbsoluteTimeGetCurrent() - frameStartTime))
        println("Metal found \(result.filter({$0.isPrime == 1 }).count) prime numbers");
    }

    final func setUpMetal()
    {
        device = MTLCreateSystemDefaultDevice()
        
        if device == nil
        {
            errorFlag = true
            return
        }
        else
        {
            defaultLibrary = device.newDefaultLibrary()
            commandQueue = device.newCommandQueue()
            
            threadGroupCount = MTLSize(width:32,height:1,depth:1)
            threadGroups = MTLSize(width:(primeNumbers.count + 31) / 32, height:1, depth:1)
        }
    }
    
    final func metalFindPrimeNumbers() -> [PrimeNumber]
    {
        kernelFunction = defaultLibrary.newFunctionWithName("particleRendererShader")
        pipelineState = device.newComputePipelineStateWithFunction(kernelFunction!, error: nil)

        let commandBuffer = commandQueue.commandBuffer()
        let commandEncoder = commandBuffer.computeCommandEncoder()
        
        commandEncoder.setComputePipelineState(pipelineState)
        
        let particleVectorByteLength = primeNumbers.count * sizeofValue(primeNumbers[0])
        
        var buffer: MTLBuffer = device.newBufferWithBytes(&primeNumbers, length: particleVectorByteLength, options: nil)
        commandEncoder.setBuffer(buffer, offset: 0, atIndex: 0)
        
        var inVectorBuffer = device.newBufferWithBytes(&primeNumbers, length: particleVectorByteLength, options: nil)
        commandEncoder.setBuffer(inVectorBuffer, offset: 0, atIndex: 0)
 
        var resultdata = [PrimeNumber](count:primeNumbers.count, repeatedValue: PrimeNumber(numericValue: 0, isPrime: -1))

        var outVectorBuffer = device.newBufferWithBytes(&resultdata, length: particleVectorByteLength, options: nil)
        commandEncoder.setBuffer(outVectorBuffer, offset: 0, atIndex: 1)
      
        commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        
        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
       
        var data = NSData(bytesNoCopy: outVectorBuffer.contents(),
        length: primeNumbers.count*sizeof(PrimeNumber), freeWhenDone: false)

        var finalResultArray = [PrimeNumber](count: primeNumbers.count, repeatedValue: PrimeNumber(numericValue: 0, isPrime: -1))
        
        data.getBytes(&finalResultArray, length:primeNumbers.count * sizeof(PrimeNumber))
    
        return finalResultArray
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct PrimeNumber
{
    // booleans didn't work well between swift and metal, so I used a float, isPrime:
    //  -1 = don't know
    //  1.0 = is a prime
    //  0.0 = is a composite
    
    var numericValue: Float = 0
    var isPrime: Float = -1
}

