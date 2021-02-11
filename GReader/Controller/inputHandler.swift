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
        
        //        switch currentMode {
        //        case .commandMode:
        //            self.inputBuffer = "COMMAND MODE"
        //        default:
        //            self.inputBuffer = "NORMAL MODE"
        //        }
        self.inputTextLabel.stringValue = self.inputBuffer
        Swift.print(event.characters!)
        // Display everything !
        //        if self.inputBuffer.count <= 20 {
        //            self.inputBuffer.append(event.characters!)
        //        } else {
        //            self.inputBuffer = ""
        //        }
        //        self.inputTextLabel.stringValue = self.inputBuffer
        
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
        if event.characters == ":" {
            inputBuffer.append(":")
            currentMode = .commandMode
            return
        } else if event.characters == "p" {
            Swift.print(pdfView.currentDestination as Any)
        } else if event.characters == "o" {
            Swift.print(pdfView.currentPage?.bounds(for: PDFDisplayBox.artBox) as Any)
        } else if event.characters == "a" {
            Swift.print(pdfDocument?.documentAttributes as Any)
        } else {
            scrollPDFView(command: event.characters!)
        }
        
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
        }
    }
    
    private func loadOutline() {
        // TODO
    }
    
}

// MARK: - Normal Mode Functions
extension ViewController {
    private func scrollPDFView(command: String) {
        var direction = 0
        var step      = 0
        
        switch command {
        case "j":
            direction = 1
            step      = 1
        case "k":
            direction = -1
            step      = 1
        case "d":
            direction = 1
            step      = 50
        case "u":
            direction = -1
            step      = 50
        default: break
        }
        
        var point = pdfView.currentDestination?.point
        
        
        point?.y -= CGFloat(direction*step)
        
        
        let destination = PDFDestination(page: pdfView.currentPage!, at: point!)
        pdfView.go(to: destination)
        
        // TODO: Bug when scrolling too much times.
        // TODO: Make scrolling more fluently by
        //
        // for i in 0 ... Step {
        //     XXXXX
        //     pdfView.go()
        //     refreshView()
        // }
    }
}
