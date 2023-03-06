//
//  BubbleTextView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class BubbleTextView: UITextView {
    private var placeholderAttributes: [NSAttributedString.Key: Any] {
        var placeholderAttributes = typingAttributes

        if placeholderAttributes[.font] == nil {
            placeholderAttributes[.font] = font ?? BubbleConfig.normalFont(ofSize: 14.0)
        }

        if placeholderAttributes[.paragraphStyle] == nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            paragraphStyle.lineBreakMode = textContainer.lineBreakMode
            placeholderAttributes[.paragraphStyle] = paragraphStyle
        }
        placeholderAttributes[.foregroundColor] = placeholderColor

        return placeholderAttributes
    }

    private var placeholderInsets: UIEdgeInsets {
        let placeholderTop = contentInset.top + textContainerInset.top
        let placeholderLeft = contentInset.left + textContainerInset.left
        let placeholderBottom = contentInset.bottom + textContainerInset.bottom
        let placeholderRight = contentInset.right + textContainerInset.right
        let placeholderInsets = UIEdgeInsets(top: placeholderTop, left: placeholderLeft, bottom: placeholderBottom, right: placeholderRight)
        return placeholderInsets
    }

    private lazy var placeholderLayoutManager: NSLayoutManager = .init()

    private lazy var placeholderTextContainer: NSTextContainer = .init()

    // MARK: - Properties

    override var attributedPlaceholder: NSAttributedString? {
        didSet {
            guard attributedPlaceholder != oldValue else { return }

            if let attributedPlaceholder = attributedPlaceholder {
                let attributes = attributedPlaceholder.attributes(at: 0, effectiveRange: nil)
                if let font = attributes[.font] as? UIFont, self.font != font {
                    self.font = font
                    typingAttributes[.font] = font
                }
                if let foregroundColor = attributes[.foregroundColor] as? UIColor, placeholderColor != foregroundColor {
                    placeholderColor = foregroundColor
                }
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle, textAlignment != paragraphStyle.alignment {
                    let mutableParagraphStyle = NSMutableParagraphStyle()
                    mutableParagraphStyle.setParagraphStyle(paragraphStyle)

                    textAlignment = paragraphStyle.alignment
                    typingAttributes[.paragraphStyle] = mutableParagraphStyle
                }
            }
            guard isEmpty == true else { return }
            setNeedsDisplay()
        }
    }

    var isEmpty: Bool { return text.isEmpty }

    override var placeholder: String? {
        get {
            return attributedPlaceholder?.string
        }

        set {
            if let newValue = newValue as String? {
                attributedPlaceholder = NSAttributedString(string: newValue, attributes: placeholderAttributes)
            } else {
                attributedPlaceholder = nil
            }
        }
    }

    override var placeholderColor: UIColor! {
        didSet {
            if let placeholder = self.placeholder as String? {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }

    // MARK: - Superclass Properties

    override var attributedText: NSAttributedString! { didSet { self.setNeedsDisplay() } }

    override var bounds: CGRect { didSet { self.setNeedsDisplay() } }

    override var contentInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }

    override var font: UIFont? {
        didSet {
            if let placeholder = self.placeholder as String? {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            if let placeholder = self.placeholder as String? {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }

    override var textContainerInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }

    override var typingAttributes: [NSAttributedString.Key: Any] {
        didSet {
            if let placeholder = placeholder as String? {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
            }
        }
    }

    // MARK: - Object Lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitializer()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInitializer()
    }

    // MARK: - Superclass API

    override func caretRect(for position: UITextPosition) -> CGRect {
        guard text.isEmpty == true,
              let attributedPlaceholder = attributedPlaceholder,
              attributedPlaceholder.length > 0 else {
            return super.caretRect(for: position)
        }

        var caretRect = super.caretRect(for: position)

        let placeholderLineFragmentUsedRect = placeholderLineFragmentUsedRectForGlyphAt0GlyphIndex(attributedPlaceholder: attributedPlaceholder)

        let userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection
        if #available(iOS 10.0, *) {
            userInterfaceLayoutDirection = self.effectiveUserInterfaceLayoutDirection
        } else {
            userInterfaceLayoutDirection = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        }

        let placeholderInsets = placeholderInsets
        switch userInterfaceLayoutDirection {
        case .rightToLeft:
            caretRect.origin.x = placeholderInsets.left + placeholderLineFragmentUsedRect.maxX - textContainer.lineFragmentPadding
        case .leftToRight:
            fallthrough
        @unknown default:
            caretRect.origin.x = placeholderInsets.left + placeholderLineFragmentUsedRect.minX + textContainer.lineFragmentPadding
        }

        return caretRect
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard isEmpty == true else { return }

        guard let attributedPlaceholder = attributedPlaceholder else { return }

        var inset = placeholderInsets
        inset.left += textContainer.lineFragmentPadding
        inset.right += textContainer.lineFragmentPadding

        let placeholderRect = rect.inset(by: inset)

        attributedPlaceholder.draw(in: placeholderRect)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if isEmpty == true, let attributedPlaceholder = attributedPlaceholder, attributedPlaceholder.length > 0 {
            let placeholderInsets = placeholderInsets
            var textContainerSize = size
            textContainerSize.width -= placeholderInsets.left + placeholderInsets.right
            textContainerSize.height -= placeholderInsets.top + placeholderInsets.bottom

            let placeholderUsedRect = placeholderUsedRect(attributedPlaceholder: attributedPlaceholder, textContainerSize: textContainerSize)

            let width = ceil(placeholderInsets.left + placeholderUsedRect.maxX + placeholderInsets.right)
            let height = ceil(placeholderInsets.top + placeholderUsedRect.maxY + placeholderInsets.bottom)
            let size = CGSize(width: width, height: height)
            return size
        } else {
            return super.sizeThatFits(size)
        }
    }

    override func sizeToFit() {
        if isEmpty == true, let attributedPlaceholder = attributedPlaceholder, attributedPlaceholder.length > 0 {
            let placeholderUsedRect = placeholderUsedRect(attributedPlaceholder: attributedPlaceholder, textContainerSize: .zero)

            let placeholderInsets = placeholderInsets
            let width = ceil(placeholderInsets.left + placeholderUsedRect.maxX + placeholderInsets.right)
            let height = ceil(placeholderInsets.top + placeholderUsedRect.maxY + placeholderInsets.bottom)
            bounds.size = CGSize(width: width, height: height)
        } else {
            return super.sizeToFit()
        }
    }

    // MARK: - Private API

    private func commonInitializer() {
        contentMode = .topLeft

        NotificationCenter.default.addObserver(self, selector: #selector(BubbleTextView.handleTextViewTextDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: self)
    }

    @objc internal func handleTextViewTextDidChangeNotification(_ notification: Notification) {
        guard let object = notification.object as? BubbleTextView, object === self else {
            return
        }
        setNeedsDisplay()
    }

    private func placeholderLineFragmentUsedRectForGlyphAt0GlyphIndex(attributedPlaceholder: NSAttributedString) -> CGRect {
        if placeholderTextContainer.layoutManager == nil {
            placeholderLayoutManager.addTextContainer(placeholderTextContainer)
        }

        let placeholderTextStorage = NSTextStorage(attributedString: attributedPlaceholder)
        placeholderTextStorage.addLayoutManager(placeholderLayoutManager)

        placeholderTextContainer.lineFragmentPadding = textContainer.lineFragmentPadding
        placeholderTextContainer.size = textContainer.size

        placeholderLayoutManager.ensureLayout(for: placeholderTextContainer)

        return placeholderLayoutManager.lineFragmentUsedRect(forGlyphAt: 0, effectiveRange: nil, withoutAdditionalLayout: true)
    }

    private func placeholderUsedRect(attributedPlaceholder: NSAttributedString, textContainerSize: CGSize) -> CGRect {
        if placeholderTextContainer.layoutManager == nil {
            placeholderLayoutManager.addTextContainer(placeholderTextContainer)
        }

        let placeholderTextStorage = NSTextStorage(attributedString: attributedPlaceholder)
        placeholderTextStorage.addLayoutManager(placeholderLayoutManager)

        placeholderTextContainer.lineFragmentPadding = textContainer.lineFragmentPadding
        placeholderTextContainer.size = textContainerSize

        placeholderLayoutManager.ensureLayout(for: placeholderTextContainer)

        return placeholderLayoutManager.usedRect(for: placeholderTextContainer)
    }
}
