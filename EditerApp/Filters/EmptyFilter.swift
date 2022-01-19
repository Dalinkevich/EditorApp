//
//  EmptyFilter.swift
//  EditerApp
//
//  Created by Роман далинкевич on 22.12.2021.
//

import GPUImage

class EmptyFilter: Filter {
    
    let name = ""
    
    private var movieOutput: GPUImageMovieWriter!
    private var exportMovie: GPUImageMovie!
    
    //MARK: Applying a filter to an image
    func apply(forImage image: UIImage?) -> UIImage? { return nil}
    
    //MARK: Applying a filter to a video
    func apply(forVideo gpuMovie: GPUImageMovie, withVideoView videoView: GPUImageView) {}
    
    //MARK: Export function
    func prepareExport(movieOutput: GPUImageMovieWriter, exportMovie: GPUImageMovie) {
        self.movieOutput = movieOutput
        self.exportMovie = exportMovie
        
        exportMovie.addTarget(movieOutput)
    }
}
