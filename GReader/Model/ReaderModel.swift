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

// MARK: - Direction
enum Direction : CGFloat{
    case up = -1
    case down = 1
}

// MARK: - Step
enum Step : CGFloat {
    case small = 1
    case big   = 50
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

// MARK: - Outline
class OutlineNode {
    var pdfOutline: PDFOutline?
    var label: String = ""
    var isLeaf = true
    var numberOfChild = 0
    var children = [OutlineNode]()
    
    init(pdfOutline: PDFOutline) {
        self.pdfOutline = pdfOutline
        self.label = pdfOutline.label!
        self.numberOfChild = pdfOutline.numberOfChildren
    }
    
}

