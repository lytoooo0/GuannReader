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
    
    var currentMode: Mode = .normalMode
    var currentPage: Int?
    var pageFrame: PageFrame?
    var url: URL?
    
    var pdfDocument: PDFDocument?
    
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

