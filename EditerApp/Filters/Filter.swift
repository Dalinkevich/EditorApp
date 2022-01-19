//
//  Filter.swift
//  EditerApp
//
//  Created by Роман далинкевич on 22.12.2021.
//

import GPUImage

//MARK: FilterProtocol
protocol Filter {
    var name: String { get }
    func apply(forImage image: UIImage?) -> UIImage?
    func apply(forVideo gpuMovie: GPUImageMovie, withVideoView videoView: GPUImageView)
    func prepareExport(movieOutput: GPUImageMovieWriter, exportMovie: GPUImageMovie)
}

//MARK: Extension FilterProtocol
extension Filter {

    //MARK: Export function
    func export(asset: AVAsset, completion: @escaping ((URL?) -> ())){
        var assetSize: CGSize?
        asset.tracks.forEach {
            if $0.naturalSize.width > 0 && $0.naturalSize.height > 0 {
                assetSize = $0.naturalSize
                return
            }
        }
        
        let fileManager = FileManager()
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mov")
        try? fileManager.removeItem(at: outputURL)
        
        guard let size = assetSize,
              let movieOutput = GPUImageMovieWriter(movieURL: outputURL, size: size),
              let exportMovie = GPUImageMovie(asset: asset)
                else {
                    completion(nil)
                    
                    return
        }
        
        exportMovie.runBenchmark = true
        exportMovie.playAtActualSpeed = false
        movieOutput.completionBlock = {
            completion(outputURL)
        }
        
        movieOutput.shouldPassthroughAudio = true
        exportMovie.audioEncodingTarget = movieOutput
        exportMovie.enableSynchronizedEncoding(using: movieOutput)
        
        prepareExport(movieOutput: movieOutput, exportMovie: exportMovie)
        
        movieOutput.startRecording()
        exportMovie.startProcessing()
    }
}
