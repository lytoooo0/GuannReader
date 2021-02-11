//
//  ViewController.swift
//  GReader
//
//  Created by Li Yuetong on 2/7/21.
//

import Cocoa
import PDFKit

class ViewController: NSViewController {
    
// MARK: - Outlets
    @IBOutlet weak var inputTextLabel: NSTextField!
    @IBOutlet weak var pdfView: PDFView!
    
// MARK: - Properties
    var inputBuffer = ""
    
    // Current Properties
    // Mode is for global control
    var currentMode: Mode = .normalMode
    
    // Pgae is mainly for scrolling
    var currentPage : PDFPage? // Meed to record this. See https://developer.apple.com/documentation/pdfkit/pdfview/1504963-currentpage
    var currentPageIndex: Int  = 0
    var currentUpperRightCoord: CGPoint? // Page space is a 72 dpi coordinate system with the origin at the lower-left corner of the current page.
    
    // PDF Document
    var pdfDocument: PDFDocument?
    var url: URL?
    var pageFrame: PageFrame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

