//
//  DialogTextView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

open class DialogTextView: UITextView {
    // MARK: - Private Properties

    private var placeholderAttributes: [NSAttributedString.Key: Any] {
        var placeholderAttributes = typingAttributes

        if placeholderAttributes[.font] == nil {
            placeholderAttributes[.font] = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
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

    // MARK: - Open Properties

    @NSCopying open var attributedPlaceholder: NSAttributedString? {
        didSet {
            guard self.attributedPlaceholder != oldValue else { return }

            if let attributedPlaceholder = self.attributedPlaceholder {
                let attributes = attributedPlaceholder.attributes(at: 0, effectiveRange: nil)
                if let font = attributes[.font] as? UIFont, self.font != font {
                    self.font = font
                    self.typingAttributes[.font] = font
                }
                if let foregroundColor = attributes[.foregroundColor] as? UIColor, self.placeholderColor != foregroundColor {
                    self.placeholderColor = foregroundColor
                }
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle, self.textAlignment != paragraphStyle.alignment {
                    let mutableParagraphStyle = NSMutableParagraphStyle()
                    mutableParagraphStyle.setParagraphStyle(paragraphStyle)

                    self.textAlignment = paragraphStyle.alignment
                    self.typingAttributes[.paragraphStyle] = mutableParagraphStyle
                }
            }
            guard self.isEmpty == true else { return }
            self.setNeedsDisplay()
        }
    }

    open var isEmpty: Bool { return self.text.isEmpty }

    open var placeholder: NSString? {
        get {
            return self.attributedPlaceholder?.string as NSString?
        }

        set {
            if let newValue = newValue as String? {
                self.attributedPlaceholder = NSAttributedString(string: newValue, attributes: self.placeholderAttributes)
            } else {
                self.attributedPlaceholder = nil
            }
        }
    }

    open var placeholderColor: UIColor = .darkGray {
        didSet {
            if let placeholder = self.placeholder as String? {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }

    // MARK: - Superclass Properties

    override open var attributedText: NSAttributedString! { didSet { self.setNeedsDisplay() } }

    override open var bounds: CGRect { didSet { self.setNeedsDisplay() } }

    override open var contentInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }

    override open var font: UIFont? {
        didSet {
            if let placeholder = self.placeholder as String? {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }

    override open var textAlignment: NSTextAlignment {
        didSet {
            if let placeholder = self.placeholder as String? {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }

    override open var textContainerInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }

    override open var typingAttributes: [NSAttributedString.Key: Any] {
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

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitializer()
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInitializer()
    }

    // MARK: - Superclass API

    override open func caretRect(for position: UITextPosition) -> CGRect {
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

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        guard isEmpty == true else { return }

        guard let attributedPlaceholder = attributedPlaceholder else { return }

        var inset = placeholderInsets
        inset.left += textContainer.lineFragmentPadding
        inset.right += textContainer.lineFragmentPadding

        let placeholderRect = rect.inset(by: inset)

        attributedPlaceholder.draw(in: placeholderRect)
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
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

    override open func sizeToFit() {
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

        NotificationCenter.default.addObserver(self, selector: #selector(DialogTextView.handleTextViewTextDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: self)
    }

    @objc internal func handleTextViewTextDidChangeNotification(_ notification: Notification) {
        guard let object = notification.object as? DialogTextView, object === self else {
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
