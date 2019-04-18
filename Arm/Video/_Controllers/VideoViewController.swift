//
//  VideoViewController.swift
//  Arm
//
//  Created by Dan on 17.03.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    let mediaURL = "rtsp://192.168.0.183/abc"

    @IBOutlet weak var videoView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    var testTimer: Timer!

    deinit {
        testTimer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMediaPLayer()
        
        testTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] _ in
            self?.lookForCodesInScene()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mediaPlayer.play()
    }

    func setupMediaPLayer() {
        mediaPlayer.delegate = self
        mediaPlayer.drawable = videoView
        mediaPlayer.media = VLCMedia(url: URL(string: mediaURL)!)
    }
    
    func lookForCodesInScene() {
        print("ahoj")
        
        //let videoImage = UIImage(view: self.view) //videoView.asImage()
        
        guard let view = mediaPlayer.drawable as? UIView else { return }
        
        let size = view.frame.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let rec = view.frame
        view.drawHierarchy(in: rec, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if let unwrappedImage = image, let features = QRDetector.detectQRCode(unwrappedImage), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                print("detected")
                print(row.messageString ?? "nope")
            }
        }
        
    }

}

extension VideoViewController: VLCMediaPlayerDelegate {

    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if mediaPlayer.state == .stopped {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
