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
            break
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
        
        // Move to the new destination
        // Previous codes
//        var point = pdfView.currentDestination?.point
        let directionValue = direction.rawValue
        let stepValue      = step.rawValue
        
//        point?.y -= directionValue*stepValue
//
//        let destination = PDFDestination(page: pdfView.currentPage!, at: point!)
//        pdfView.go(to: destination)
        
        
        // New codes
        if direction == .down {
            if currentUpperRightCoord!.y >= stepValue - 5 { // Normal case. -5 due to the grey space
                currentUpperRightCoord!.y -= stepValue*directionValue
                let destination = PDFDestination(page: currentPage!, at: currentUpperRightCoord!)
                pdfView.go(to: destination)
            } else { // Need to turn page
                currentPage = pdfView.currentPage
                let totalValue = pageFrame!.height - stepValue + currentUpperRightCoord!.y + 5 // +5 due to the grey space
                currentUpperRightCoord?.y = totalValue
                let destination = PDFDestination(page: currentPage!, at: currentUpperRightCoord!)
                pdfView.go(to: destination)
            }
        } else { // up
            if (pageFrame!.height - currentUpperRightCoord!.y) >= stepValue { // Normal case

            } else { // Need to turn page

            }
        }
        
        // TODO: Bug when scrolling too much times.
        // TODO: Make scrolling more fluently by
        //
        // for i in 0 ... Step {
        //     XXXXX
        //     pdfView.go()
        //     refreshView()
        // }     ↓
        // pdfView.needsDisplay = true
    }
}
