import Foundation
import UIKit
import AVFoundation
import AVKit


enum DMSAdsPlayerStatus {
    case playing;
    case paused;
    case ended;
}

protocol DMSAdsPlayerViewDelegate {
    func playerViewReady(view:DMSAdsPlayerView);
}

class DMSAdsPlayerView : UIView, UIScrollViewDelegate, DMSAdsSplitViewDelegate {
    
  
    open var rootViewController:UIViewController?
    open var presentingViewController:UIViewController?
    
    
    public var senderPlayerView:DMSAdsPlayerView?
    
    private var _status:DMSAdsPlayerStatus?
    public var status: DMSAdsPlayerStatus? {
        set {
            updateStatus(status: newValue)
            self._status = newValue
        }
        get { return self._status }
    }
    
    private var actionButton:UIButton?
    private var closeButton:UIButton?
    private var speakerButton:UIButton?
    private var fullscreenButton:UIButton?


    
    private let buttonsSize:CGFloat = 35;
    private let actionButtonsSize:CGFloat = 50;
    private let topMargin:CGFloat = 100;
    private let buttonsTopMargin:CGFloat = 35;
    private let leastVisibleHeightWebView:CGFloat = 200;
    
    private var closeButtonTopConstraint:NSLayoutConstraint?
    
    private var isFullscreen = false;
    private var isPlayCalled = false;
    
    private var videoLayer:AVPlayerLayer?
    private var playerLayer:AVPlayer?

    private var topView:UIView?
    
    private var webUrl:String?

    public var delegate:DMSAdsPlayerViewDelegate?
    
    open func initAd(urlStr:String, webUrl:String, rootViewController:UIViewController) {
        
        self.layer.masksToBounds = true;
        self.webUrl = webUrl;
        
        let url = URL(string: urlStr)!;
        self.videoLayer = createLayer(url: url);
        self.rootViewController = rootViewController;
        setupWithLayer(layer: self.videoLayer!);
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tapGesture);
        
        setMuted(muted: true)
        
        self.videoLayer?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor;
        self.status = .paused;
    
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
 
        
        if keyPath == #keyPath(AVPlayerItem.status) || keyPath == #keyPath(AVPlayer.status) {
            if (self.playerLayer?.currentItem?.asset.isPlayable ?? false) {
                delegate?.playerViewReady(view: self);
            }
            
        }
        
        
    }
    
    public func initWithExistingView(sender:DMSAdsPlayerView, topView:UIView, presentingViewController:UIViewController) {
        
        self.presentingViewController = presentingViewController;
        self.senderPlayerView = sender;
        self.topView = topView;
        self.topView?.addSubview(self);
        self.frame = CGRect(x: 0, y: 0, width: self.topView!.bounds.width, height: self.topView!.bounds.height);
        initWithExistingLayer(layer: sender.videoLayer!, player: sender.playerLayer!, presentingViewController: presentingViewController);
        
        
        
    }

    public func showFullscreen() {
        
        if let view = self.presentingViewController?.view {
            
            if self.superview != nil {
                self.removeFromSuperview();
            }
            view.addSubview(self);
            
            self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height);
            self.backgroundColor = UIColor.darkGray;
            
            self.isFullscreen = true;
            self.fullscreenButton?.isHidden = true;
            self.videoLayer?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor;
            self.videoLayer?.videoGravity = .resizeAspect;
        }
    }
    
    public func showSplitscreen() {
        if let view = self.presentingViewController?.view {
            let height =  self.topView!.bounds.height;
            if self.superview != nil {
                self.removeFromSuperview();
            }
            self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height);
            self.topView?.addSubview(self);
            self.fullscreenButton?.isHidden = false;
            self.videoLayer?.videoGravity = .resize
            self.isFullscreen = false;
            
        }
    }
    
    public func adjustForViewMode() {
        let landscape = UIDeviceOrientationIsLandscape(UIDevice.current.orientation);
        if landscape || self.isFullscreen {
            self.showFullscreen();
        } else {
            self.showSplitscreen();
        }
        
        if (landscape) {
            self.closeButtonTopConstraint?.constant = 10;
        } else {
            self.closeButtonTopConstraint?.constant = 10 + self.buttonsTopMargin;
        }
    }
    

    public func play() {
        self.isPlayCalled = true;
        self.playerLayer?.play()
        self.status = .playing;
    }
    
    public func pause() {
        
        self.playerLayer?.pause()
        self.status = .paused;
    }

    
 
    
    private func splitscreen() {
        if let view = self.presentingViewController?.view {
        
            let height =  self.topView!.bounds.height;
            if self.superview != nil {
                self.removeFromSuperview();
            }
            self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height);
            self.topView?.addSubview(self);
            self.fullscreenButton?.isHidden = false;
            self.videoLayer?.videoGravity = .resize
            self.isFullscreen = false;
           
        }
    }
    

    
    private func initWithExistingLayer(layer:AVPlayerLayer, player:AVPlayer, presentingViewController:UIViewController) {
        setupWithLayer(layer: layer);

        self.videoLayer = layer;
        self.playerLayer = player;
        self.status = .playing;
        self.presentingViewController = presentingViewController;
        
        setMuted(muted: false);
        
        createFullscreenButton()
        createCloseButton()
        
        
        
        
    }
    

    
    private func configLayer(layer:AVPlayerLayer) {
       NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.playerLayer?.currentItem)
 
        
        layer.videoGravity = .resize
        layer.frame = self.bounds;

        self.layer.insertSublayer(layer, at: 0);
    }
    
    


    private func setupWithLayer(layer:AVPlayerLayer) {
        
        
       
        configLayer(layer: layer);
        createActionButton()
        createSpeakerButton()
        
        
    }
    
    private func createLayer(url:URL) -> AVPlayerLayer {
        let asset = AVURLAsset(url: url);
        let playerItem = AVPlayerItem(asset: asset);
        
 
        self.playerLayer = AVPlayer(playerItem: playerItem);
        self.playerLayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
        self.playerLayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)
        let layer = AVPlayerLayer(player: self.playerLayer!);
        layer.backgroundColor = UIColor.white.cgColor
        return layer;
    }
    
    
    private func updateStatus(status:DMSAdsPlayerStatus?) {
        if status == nil {
            return;
        }
        
        self.actionButton?.isHidden = status == .playing;
        var actionImage:UIImage?
        switch (status!) {
        case .playing:
            actionImage = UIImage(named: "mmads_pause_ic");
            break;
        case .ended:
            actionImage = UIImage(named: "mmads_replay_ic");
            break;
        case .paused:
            actionImage = UIImage(named: "mmads_play_ic");
            break;
        }
        
        self.actionButton?.setImage(actionImage, for: .normal)
        
    }
    
    
 

 
    
    
    
    private func setMuted(muted:Bool) {
        self.playerLayer?.isMuted = muted;
        self.speakerButton?.setImage(muted ? UIImage(named: "mmads_muted_ic") : UIImage(named: "mmads_unmuted_ic"), for: .normal);
    }
    
 

    private func presentSplitScreen(){
        
        let vc = DMSAdsAdPresentationController();
        vc.urlString = self.webUrl;
        vc.contentView = self;
        self.rootViewController?.present(vc, animated: false, completion: nil);

    }
    
    @objc func toggleSpeakerState(_ sender:UIButton) {
        if let muted = self.playerLayer?.isMuted {
            setMuted(muted: !muted);
        }
    }
    
    
    @objc func fullscreenButtonClicked(_ sender:UIButton) {
        showFullscreen();
    }
    
    @objc func closeButtonClicked(_ sender:UIButton) {
        if self.isFullscreen && !UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            showSplitscreen();
        } else {
            self.presentingViewController?.dismiss(animated: false, completion: {
                if let videoLayerValue = self.videoLayer {
                    self.senderPlayerView?.configLayer(layer: videoLayerValue);
                    self.senderPlayerView?.setMuted(muted: true);
                }
            })
        }
    }
    
    
    @objc func didPressStatusChange(_ sender:UIButton) {
        if self.status == nil {
            return;
        }
        
        switch (self.status!) {
        case .playing:
            pause();
            break;
        case .ended:
            self.playerLayer?.seek(to: kCMTimeZero);
            play();
            break;
        case .paused:
            if !self.isPlayCalled && self.presentingViewController == nil {
                presentSplitScreen()
            }
            play();
            break;
        }
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        self.status = .ended;
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        
        play();
        presentSplitScreen();
        
    }
    

 
    
    private func createFullscreenButton() {
        let margin:CGFloat = 10;
        let view = createButton(size: self.buttonsSize);
        
        let trailing = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: margin)
        let top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin + self.buttonsTopMargin);
        
        self.addConstraints([trailing, top]);
        
        self.fullscreenButton = view;
        self.fullscreenButton?.setImage(UIImage(named: "mmads_fullscreen_ic"), for: .normal);
        self.fullscreenButton?.addTarget(self, action: #selector(fullscreenButtonClicked(_:)), for: .touchUpInside);
    }
    
    private func createCloseButton() {
        let margin:CGFloat = 10;
        let view = createButton(size: self.buttonsSize);
        view.backgroundColor = UIColor.darkGray;
        view.layer.cornerRadius = self.buttonsSize / 2.0;
        view.layer.masksToBounds = true;
        
        let leading = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: margin)
        let top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin + self.buttonsTopMargin);
        
        self.addConstraints([leading, top]);
        
        self.closeButton = view;
        
        self.closeButton?.setImage(UIImage(named: "mmads_close_ic"), for: .normal);
        self.closeButtonTopConstraint = top;
        
        self.closeButton?.addTarget(self, action: #selector(closeButtonClicked(_:)), for: .touchUpInside);
        
    }
    
    private func createSpeakerButton() {
        let margin:CGFloat = 10;
        let view = createButton(size: self.buttonsSize);
        
        let trailing = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: margin)
        let bottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: margin)
        
        self.addConstraints([trailing, bottom]);
        
        self.speakerButton = view;
        self.speakerButton?.addTarget(self, action: #selector(toggleSpeakerState(_:)), for: .touchUpInside);
    }
    
   
    
    private func createActionButton() {
        let view = createButton(size: self.actionButtonsSize);
        
        view.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        view.contentMode = UIViewContentMode.scaleToFill
        view.imageView?.tintColor = UIColor.white
      

        let centerXConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

        self.addConstraints([centerXConstraint, centerYConstraint]);
        
        self.actionButton = view;
        self.actionButton?.addTarget(self, action: #selector(didPressStatusChange(_:)), for: .touchUpInside);
    }
    

    private func createButton(size:CGFloat) -> UIButton {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size));
        self.addSubview(view);
        view.tintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: size)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: size)
        view.addConstraints([widthConstraint, heightConstraint])
        return view;
        
    }

    override func layoutSubviews() {
        self.videoLayer?.frame = self.layer.bounds;
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.presentingViewController == nil {
            return;
        }
        
    
        if let rate = self.playerLayer?.rate {
            if let status = self.status {
                if status == .playing && rate <= 0.0 {
                    pause()
                }
            }
        }
        
        self.actionButton?.isHidden = false;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.presentingViewController == nil {
            return;
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            if self.status == .playing {
                self.actionButton?.isHidden = true;
            }
        }
        
    }
    
    deinit {
        self.playerLayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status));
        self.playerLayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status));
        
    }
    
    
    //player check visibility
    //
   
  
 
    
    


}
