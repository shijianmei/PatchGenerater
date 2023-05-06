//
//  ViewController.swift
//  PatchGenerater
//
//  Created by jianmei on 2023/3/4.
//

import Cocoa

class ViewController: NSViewController, NSUserNotificationCenterDelegate, NSTextViewDelegate, NSTextFieldDelegate {

    //源代码
    @IBOutlet var sourceCodeTF: NSTextView!
    @IBOutlet weak var sourceCodeScroll: NSScrollView!
    
    @IBOutlet weak var patchCodeScroll: NSScrollView!
    //patchCode
    @IBOutlet var patchCodeTF: NSTextView!
    
    //生成patch按钮
    @IBOutlet weak var generateBtn: NSButton!
    // 导出Patch包按钮
    @IBOutlet weak var saveBtn: NSButton!
    
    @IBOutlet weak var patchNameTF: NSTextField!
    // 状态栏
    @IBOutlet weak var statusLab: NSTextField!
    
    var patchCodeTFText: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        generateBtn.isEnabled = false
        saveBtn.isEnabled = false
        sourceCodeTF.delegate = self
        patchNameTF.delegate = self
        statusLab.stringValue = ""
        
        setupNumberedTextView(scrollView: sourceCodeScroll, textView: sourceCodeTF)
        setupNumberedTextView(scrollView: patchCodeScroll, textView: patchCodeTF)
               
        self.patchCodeTFText = observe(\.patchCodeTF.string, options: [.new, .old], changeHandler: { _, change in
            self.saveBtn.isEnabled = !self.patchCodeTF.string.isEmpty && !self.patchNameTF.stringValue.isEmpty;
        })
        
    }
    
    @IBAction func generateAction(_ sender: Any) {
        patchCodeTF.string = ""
        let ocCode = self .insertDefaultCodeIfNeed(ocCode: self.sourceCodeTF.attributedString())
        self.sourceCodeTF.textStorage?.setAttributedString(ocCode)
        
        let ast = Parser.shared().parseSource(ocCode.string)
        var output:String!
        if Parser.shared().isSuccess() {
            let convert = Convert()
            for (_, value) in ast.classCache {
                output = convert.convert(value)
            }
        }
        
        if Parser.shared().errorAttributedString != nil {
            patchCodeTF.textStorage?.setAttributedString(Parser.shared().errorAttributedString!)
            showErrorStatus("Generated Failed")
            patchCodeTF.textColor = NSColor.red
        } else {
            let str = !output.isEmpty ? output : "出错了"
            patchCodeTF.string = str ?? ""
            showSuccessStatus("Generated Successed")
            patchCodeTF.textColor = NSColor.white
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if (patchCodeTF.string.isEmpty) {
            self.patchCodeTF.string = "请输入内容";
            return;
        }
        if patchNameTF.stringValue.isEmpty {
            return;
        }
        let patchFileName = self.patchNameTF.stringValue + ".mg";
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.allowsOtherFileTypes = true
        savePanel.nameFieldStringValue = patchFileName;
        savePanel.beginSheetModal(for: self.view.window!) { button in
            if button.rawValue == NSApplication.ModalResponse.OK.rawValue {
                self.saveToPath(savePanel.url!.absoluteString)
                self.showDoneSuccessfully()
            }
        }
    }
    
    // MARK: - Private Fun
    func insertDefaultCodeIfNeed(ocCode:NSAttributedString) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(attributedString: ocCode)

        if !ocCode.string.contains("@implementation"){
            let classBeginCodeAttributedString = NSMutableAttributedString(string: "@implementation RepalceMe \n\n")
            addDefaultAttributeFor(attributedString: classBeginCodeAttributedString)
            result.insert(classBeginCodeAttributedString, at: 0)
        }
        
        let trimCode = ocCode.string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if !trimCode.contains("@end") {
            let classEndCodeAttributedString = NSMutableAttributedString(string: "\n\n@end")
            addDefaultAttributeFor(attributedString: classEndCodeAttributedString)
            result.append(classEndCodeAttributedString)
        }
        
        return result
    }

    func addDefaultAttributeFor(attributedString: NSMutableAttributedString) {
        attributedString.addAttribute(NSAttributedString.Key.font, value: NSFont(name: "PingFang SC", size: 16)!, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.red, range: NSMakeRange(0, attributedString.length))
    }
    
    /**
     Saves all the generated files in the specified path
     - parameter path: in which to save the files
     */
    func saveToPath(_ url : String)
    {
        let patchCode = self.patchCodeTF.string
        
        let encryptContent = MBPatchAES.aes128CBC_PKCS5Padding_EncryptStrig(patchCode)
        if encryptContent.isEmpty {
            print("加密失败")
            return
        }
        
        let patchData = patchCode.data(using:String.Encoding.utf8)
        let aesData = CategoryBridge.aes128ParmEncrypt(withKey: aes128Key, iv: aes128Iv, data: patchData!)
        
        let saveFileUrl = CategoryBridge.strFilePath(url)
        
        let createFile = FileManager.default.createFile(atPath: saveFileUrl!, contents: aesData)
        if createFile {
            print("文件创建成功")
            showSuccessStatus("文件创建成功")
        } else {
            print("文件创建失败")
            showErrorStatus("文件导出失败")
        }
    }
       
    func setupNumberedTextView(scrollView: NSScrollView, textView: NSTextView)
    {
        let lineNumberView = NoodleLineNumberView(scrollView: scrollView)
        scrollView.hasHorizontalRuler = false
        scrollView.hasVerticalRuler = true
        scrollView.verticalRulerView = lineNumberView
        scrollView.rulersVisible = true
        textView.font = NSFont.userFixedPitchFont(ofSize: NSFont.smallSystemFontSize)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func showDoneSuccessfully()
    {
        let notification = NSUserNotification()
        notification.title = "Success!"
        notification.informativeText = "导出成功"
        notification.deliveryDate = Date()
        
        let center = NSUserNotificationCenter.default
        center.delegate = self
        center.deliver(notification)
    }
    
    func showSuccessStatus(_ message: String)
    {
        statusLab.textColor = NSColor.green
        statusLab.stringValue = message
    }
    
    func showErrorStatus(_ errorMessage: String)
    {
        statusLab.textColor = NSColor.red
        statusLab.stringValue = errorMessage
    }
    
//MARK: - NSTextViewDelegate
    func textDidChange(_ notification: Notification) {
        let tempTextView = notification.object as! NSTextView
        if tempTextView == sourceCodeTF {
            generateBtn.isEnabled = !tempTextView.string.isEmpty
        }
        
    }
    
}


