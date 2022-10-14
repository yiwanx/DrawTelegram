//
//  EditorViewController.swift
//  DrawTelegram
//
//  Created by Ivan Petukhov on 11/10/2022.
//

import Foundation

import UIKit
import PencilKit

class EditorViewController: UIViewController {

    var model = EditorModel()

    var canvasView: PKCanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        canvasView = PKCanvasView(frame: view.bounds)
        view.addSubview(canvasView)
        view.backgroundColor = .white
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        }
//        canvas.delegate = self
        setTool(EditorModel.defaultTool)
    }

    func setTool(_ tool: PKTool) {
        canvasView.tool = tool
    }
//
//
//    func saveDrawing(_ sender : UIButton) {
//        var drawing = canvasView.drawing.image(from: canvasView.bounds, scale: 0)
//        if let markedupImage = saveImage(drawing: drawing) {
//
//        }
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func saveImage(drawing : UIImage) -> UIImage? {
////        let bottomImage = self.imgForMarkup!
//        let newImage = autoreleasepool { () -> UIImage in
//            UIGraphicsBeginImageContextWithOptions(self.canvasView!.frame.size, false, 0.0)
////            bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: self.canvasView!.frame.size))
//            drawing.draw(in: CGRect(origin: CGPoint.zero, size: self.canvasView!.frame.size))
//            let createdImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return createdImage
//        }
//        return newImage
//    }

}
