//
//  ViewController.swift
//  EditerApp
//
//  Created by Роман далинкевич on 21.12.2021.
//

import UIKit
import AVFoundation
import MobileCoreServices
import GPUImage
import MediaPlayer


class ViewController: UIViewController {

    var counter = 0
    
    //MARK: Outlets:
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var playerView: GPUImageView!
    @IBOutlet var videoLabel: UILabel!
    @IBOutlet var addVideoButton: UIButton!
    @IBOutlet var addMusicButton: UIButton!
    @IBOutlet var filtersView: FiltersView!
    @IBOutlet var turnButton: UIButton!
    
    //MARK: ImagePickerController
    private lazy var imagePickerController: UIImagePickerController = {
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.mediaTypes = ["public.movie"]
        ipc.delegate = self
        ipc.videoExportPreset = AVAssetExportPresetPassthrough
        return ipc
    }()
    
    //MARK: MediaPickerController
    private lazy var mediaPickerController: MPMediaPickerController = {
        let mpc = MPMediaPickerController(mediaTypes: .music)
        mpc.showsItemsWithProtectedAssets = false
        mpc.showsCloudItems = false
        mpc.allowsPickingMultipleItems = false
        mpc.delegate = self
        return mpc
    }()
    
    //MARK: ActivityIndicator
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.alpha = 0
        view.addSubview(ai)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        ai.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ai.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        ai.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        ai.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return ai
    }()
    
    //MARK: AssetStore
    private lazy var assetStore: AssetStoreProtocol = AssetStore(playerView: playerView) { [unowned self] in
        self.handleError()
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        filtersView.setup(with: assetStore)
        addVideoButton.layer.cornerRadius = 30
        addMusicButton.layer.cornerRadius = 30
    }
    
    //MARK: Hide elements
    private func setupLayout(hideElements: Bool = true) {
        let alpha: CGFloat = hideElements ? 0 : 1
        shareButton.alpha = alpha
        filtersView.alpha = alpha
        turnButton.alpha = alpha
    }
    
    //MARK: Error
    private func handleError(title: String = NSLocalizedString("Video processing error",
                                                               comment: "error alert title"),
                             message: String = NSLocalizedString("Please, try again",
                                                                 comment: "error alert message")) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: Add video
    @IBAction func addVideo(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Add Music
    @IBAction func addMusic(_ sender: Any) {
        present(mediaPickerController, animated: true, completion: {})
    }
    
    //MARK: Share button
    @IBAction func share(_ sender: Any) {
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
        assetStore.export { [unowned self] (outputURL: URL?) in
            DispatchQueue.main.async {
                if let url = outputURL {
                    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    self.present(activityViewController, animated: true, completion: nil)
                } else {
                    self.handleError()
                }
                self.activityIndicator.alpha = 0
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    //MARK: VideoView rotation function
    @IBAction func rotate(_ sender: Any) {
        counter += 1

        if counter == 1 {
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(90.0 * Double.pi / 180.0))
        } else if counter == 2 {
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(180.0 * Double.pi / 180.0))
        } else if counter == 3 {
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(270.0 * Double.pi / 180.0))
        } else if counter == 4 {
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(360.0 * Double.pi / 180.0))
            counter = 0
        }
    }
}

//MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.mediaURL] as? URL {
            assetStore.movieURL = url
            videoLabel.alpha = 0
            playerView.backgroundColor = .clear
            playerView.setBackgroundColorRed(0, green: 0, blue: 0, alpha: 0)
            setupLayout(hideElements: false)
            filtersView.update()
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

//MARK: MPMediaPickerControllerDelegate
extension ViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true) {
            guard let song = mediaItemCollection.items.first,
                let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else {
                    let title = NSLocalizedString("This song is not available", comment: "song error alert title")
                    let message = NSLocalizedString("Please, choose another song", comment: "song error alert message")
                    self.handleError(title: title, message: message)
                    return
            }
            self.assetStore.audioURL = url
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}
