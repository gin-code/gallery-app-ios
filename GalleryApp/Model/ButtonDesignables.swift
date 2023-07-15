//
//  ButtonDesignables.swift
//  DogCafe
//
//  Created by Dilip Gurjar on 17/06/20.
//  Copyright © 2020 Dilip Gurjar. All rights reserved.
//

import UIKit

@IBDesignable
class DKButton: UIButton {

    // MARK: - IBInspectable properties
        private var _round = false
    
    /// mark circular button
    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }
    
    /// Renders vertical gradient if true else horizontal
    @IBInspectable public var verticalGradient: Bool = true {
        didSet {
            updateUI()
        }
    }

    /// Start color of the gradient
    @IBInspectable public var startColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }

    /// End color of the gradient
    @IBInspectable public var endColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }

    /// Border color of the view
    @IBInspectable public var borderColor: UIColor? = nil {
        didSet {
            updateUI()
        }
    }

    /// Border width of the view
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }

    /// Corner radius of the view
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }

    // MARK: - Variables
    /// Closure is called on click event of the button
    public var onClick = { () }

    private var gradientlayer = CAGradientLayer()

    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }

    // MARK: - UI Setup
    private func setupUI() {
        gradientlayer = CAGradientLayer()
        updateUI()
        layer.addSublayer(gradientlayer)
    }

    // MARK: - Update frame
    private func updateFrame() {
        gradientlayer.frame = bounds
    }

    // MARK: - Update UI
    private func updateUI() {
        addTarget(self, action: #selector(clickAction(button:)), for: UIControl.Event.touchUpInside)
        gradientlayer.colors = [startColor.cgColor, endColor.cgColor]
        if verticalGradient {
            gradientlayer.startPoint = CGPoint(x: 0, y: 0)
            gradientlayer.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientlayer.startPoint = CGPoint(x: 0, y: 0)
            gradientlayer.endPoint = CGPoint(x: 1, y: 0)
        }
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor ?? tintColor.cgColor
        if cornerRadius > 0 {
            layer.masksToBounds = true
        }
        updateFrame()
    }

    // MARK: - On Click
    @objc private func clickAction(button: UIButton) {
        onClick()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: CGFloat(-10), dy: CGFloat(-10)).contains(point)
      }
    
    
    
    private func makeRound() {
        if self.round {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
}
