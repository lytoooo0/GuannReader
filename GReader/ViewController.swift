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
    @IBOutlet weak var outlineView: NSOutlineView!
    
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

extension ViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let item = item as? PDFOutline {
            return item.numberOfChildren
        } else if pdfDocument != nil {
            return (pdfDocument?.outlineRoot?.numberOfChildren)!
        } else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? PDFOutline {
            return item.child(at: index) as Any
        } else if pdfDocument != nil {
            return pdfDocument?.outlineRoot?.child(at: index) as Any
        }
        return pdfDocument?.outlineRoot as Any
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? PDFOutline {
            if item.numberOfChildren > 0 {
                return true
            }
        }
        return false
    }
}

extension ViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
        
        if let item = item as? PDFOutline {
            cell?.textField?.stringValue = item.label!
            
        }
        return cell
    }
    
//    func outlineViewSelectionDidChange(_ notification: Notification) {
//        guard let outlineView = notification.object as? NSOutlineView else {
//            return
//        }
//        
//        let selectedIndex = outlineView.selectedRow
//        let item = outlineView.item(atRow: selectedIndex) as! PDFOutline
//        Swift.print(item.index)
//    }
}
