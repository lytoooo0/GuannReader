//
//  ReaderModel.swift
//  GReader
//
//  Created by Li Yuetong on 2/8/21.
//

import Foundation
import PDFKit

// MARK: - Mode
enum Mode {
    case commandMode, normalMode
}

// MARK: - Frame of a PDF page
struct PageFrame {
    var width:  CGFloat
    var height: CGFloat
    init(of: PDFView) {
        let bounds = of.currentPage?.bounds(for: PDFDisplayBox.artBox)
        width  = bounds!.width
        height = bounds!.height
        
        Swift.print("Width:  \(width)\nHeight: \(height)")
        
    }
}
