//
//  FiltersFabric.swift
//  EditerApp
//
//  Created by Роман далинкевич on 22.12.2021.
//

import GPUImage

//MARK: Filters
class FiltersFabric {
    
    static func getFilters() -> [Filter] {
       
        //MARK: Origin imagety
        let origin = BaseFilter(name: "ORIGIN") {
            let f1 = GPUImageFilter()
            return f1
            
        }
        //MARK: RGB Filter
        let colorAdjustments = BaseFilter(name: "RGB") {
            let f1 = GPUImageRGBFilter()
            f1.green = 1
            f1.blue = 2

            return f1
        }
        //MARK: Horror Filter
        let horror = GroupFilter(name: "HORROR") {
            let f1 = GPUImageZoomBlurFilter()
            f1.blurSize = 1.85
            let f2 = GPUImageGrayscaleFilter()
            let f3 = GPUImageContrastFilter()
            f3.contrast = 1.5
            let f4 = GPUImageGammaFilter()
            f4.gamma = 2.5
            
            f1.addTarget(f2)
            f2.addTarget(f3)
            f3.addTarget(f4)
            
            return [f1, f2, f3, f4]
        }

        //MARK: Pixel Filter
        let visualEffects = BaseFilter(name: "PIXEL") {
            let f1 = GPUImagePixellateFilter()
            f1.fractionalWidthOfAPixel = 0.013
            
            return f1
        }
        
        //MARK: Swirl Filter
        let visualEffectsCombination = GroupFilter(name: "SWIRL") {
            let f1 = GPUImageSwirlFilter()
            f1.radius = 4
            let f2 = GPUImageGammaFilter()
            f2.gamma = 2.5
            
            f1.addTarget(f2)
            
            return [f1, f2]
        }
        
        let filters: [Filter] = [
            origin,
            colorAdjustments,
            horror,
            visualEffects,
            visualEffectsCombination
        ]

        return filters
    }
}

