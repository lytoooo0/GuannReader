//
//  inputHandler.swift
//  GReader
//
//  Created by Li Yuetong on 2/8/21.
//

import Foundation
import Cocoa
import Carbon.HIToolbox
import PDFKit

extension ViewController {
    
    // MARK: - Keyboard Listener
    func myKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
              NSApplication.shared.keyWindow === locWindow else { return false }
        
        switch currentMode {
        case .commandMode:
            handleCommandModeInput(event: event)
        default:
            handleNormalModeInput(event: event)
        }
        
        self.inputTextLabel.stringValue = self.inputBuffer
        Swift.print(event.characters!)
        
        return true
    }
}

// MARK: - Handle Input

extension ViewController {
    
    func handleCommandModeInput(event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_Escape:
            inputBuffer = ""
            currentMode = .normalMode
        case kVK_Return:
            handleCommands(command: inputBuffer)
            inputBuffer = ":"
        case kVK_Delete:
            inputBuffer.remove(at: inputBuffer.index(before: inputBuffer.endIndex))
        default:
            inputBuffer.append(event.characters!)
        }
    }
    
    func handleNormalModeInput(event: NSEvent) {
        switch event.characters {
        case ":":
            inputBuffer.append(":")
            currentMode = .commandMode
        case "j":
            scrollPDFView(direction: .down, step: .small)
        case "k":
            scrollPDFView(direction: .up, step: .small)
        case "d":
            scrollPDFView(direction: .down, step: .big)
        case "u":
            scrollPDFView(direction: .up, step: .big)
        default:
            Swift.print(pdfView.currentDestination as Any)
        }
        
//        if event.characters == ":" {
//            inputBuffer.append(":")
//            currentMode = .commandMode
//            return
//        } else if event.characters == "p" {
//            Swift.print(pdfView.currentDestination as Any)
//        } else if event.characters == "o" {
//            Swift.print(pdfView.currentPage?.bounds(for: PDFDisplayBox.artBox) as Any)
//        } else if event.characters == "a" {
//            Swift.print(pdfDocument?.documentAttributes as Any)
//        }
//
    }
    
    func handleCommands(command: String) {
        if command == ":open" {
            openFile()
        } else if command == ":q" {
            exit(-1)
        }
        
    }
    
}

// MARK: - Command Mode Functions
extension ViewController {
    
    private func openFile() {
        // Create the penal
        let panel = NSOpenPanel()
        
        // Get the url of the file
        if panel.runModal() == .OK {
            url = panel.url
        }
        
        if ((url?.isFileURL) != nil) {
            // Initialize PdfDocument
            pdfDocument = PDFDocument(url: url!)
            
            // pass PDFDocument to PDFView
            pdfView.document = pdfDocument
            
            pageFrame = PageFrame(of: pdfView)
            currentUpperRightCoord = CGPoint()
            currentUpperRightCoord?.x = pageFrame!.width
            currentUpperRightCoord?.y = pageFrame!.height
            currentPage = pdfView.currentPage
        }
    }
    
    private func loadOutline() {
        // TODO
    }
    
}

// MARK: - Normal Mode Functions
extension ViewController {
    
    private func scrollPDFView(direction: Direction, step: Step) {
        
        let stepValue      = step.rawValue

        for _ in 1...Int(stepValue) {
            scrollOneUnit(direction: direction)
        }

        // TODO: Buggy when is at the last page and press 'j' or 'd'. Because the currentUpperRightCoord.y continue decreasing but the view is already at the bottom. When press 'k' or 'u', the view will not scrolling until cURC.y reach some value. Have no idea how to detect the value.
        // TODO: Make scrolling more fluently by
        //
        // for i in 0 ... Step {
        //     XXXXX
        //     pdfView.go()
        //     refreshView()
        // }     
    }
    
    func scrollOneUnit(direction: Direction) {
        if direction == .down {
            if currentUpperRightCoord!.y >= 0{ // Normal Case
                currentUpperRightCoord!.y -= direction.rawValue
                let destination = PDFDestination(page: currentPage!, at: currentUpperRightCoord!)
                pdfView.go(to: destination)
            } else if currentPageIndex < pdfDocument!.pageCount{ // Need to Turn page
                // TODO: Consider the Last page
                currentPageIndex += 1
                currentPage = pdfView.currentPage
                currentUpperRightCoord?.y = pageFrame!.height
                let destination = PDFDestination(page: currentPage!, at: currentUpperRightCoord!)
                pdfView.go(to: destination)
            }
        } else { // up
            if currentUpperRightCoord!.y <= pageFrame!.height{ // Normal Case
                currentUpperRightCoord!.y -= direction.rawValue
                let destination = PDFDestination(page: currentPage!, at: currentUpperRightCoord!)
                pdfView.go(to: destination)
            } else if currentPageIndex != 0{
                // TODO: Consider the First page
                currentPageIndex -= 1
                currentPage = pdfDocument?.page(at: currentPageIndex)
                currentUpperRightCoord?.y = 0
                let destination = PDFDestination(page: currentPage!, at: currentUpperRightCoord!)
                pdfView.go(to: destination)
            }
        }
    }
}
