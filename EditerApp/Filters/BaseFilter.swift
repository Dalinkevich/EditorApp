//
//  BaseFilter.swift
//  EditerApp
//
//  Created by Роман далинкевич on 22.12.2021.
//

import GPUImage

class BaseFilter: Filter {
    
    let name: String
    
    private let generateGpuFilter: () -> GPUImageFilter
    private let gpuFilter: GPUImageFilter
    private var movieOutput: GPUImageMovieWriter!
    private var exportMovie: GPUImageMovie!
    
    init(name: String, generateGpuFilter: @escaping () -> GPUImageFilter) {
        self.name = name
        self.generateGpuFilter = generateGpuFilter
        self.gpuFilter = generateGpuFilter()
    }
    
    //MARK: Applying a filter to an image
    func apply(forImage image: UIImage?) -> UIImage? {
        return gpuFilter.image(byFilteringImage: image)
    }
    
    //MARK: Applying a filter to a video
    func apply(forVideo gpuMovie: GPUImageMovie, withVideoView videoView: GPUImageView) {
        gpuMovie.removeAllTargets()
        gpuFilter.removeAllTargets()
        gpuFilter.addTarget(videoView as GPUImageInput)
        gpuMovie.addTarget(gpuFilter)
        gpuMovie.playAtActualSpeed = true
        gpuMovie.startProcessing()
    }
    
    //MARK: Export function
    func prepareExport(movieOutput: GPUImageMovieWriter, exportMovie: GPUImageMovie) {
        self.movieOutput = movieOutput
        self.exportMovie = exportMovie
        
        let filter = generateGpuFilter()
        
        exportMovie.addTarget(filter)
        filter.addTarget(movieOutput)
    }
}
