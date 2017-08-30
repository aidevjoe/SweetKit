import UIKit
import CoreGraphics
import CoreImage
import Accelerate

public extension UIImage {
    
    public func roundWithCornerRadius(_ cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    /// 缩放
//    public func resize(_ size: CGSize) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        draw(in: CGRect(origin: CGPoint.zero, size: size))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
    
    /// Resizes the image by a given rate for a given interpolation quality.
    ///
    /// - Parameters:
    ///   - rate: The resize rate. Positive to enlarge, negative to shrink. Defaults to medium.
    ///   - quality: The interpolation quality.
    /// - Returns: The resized image.
    public func resized(by rate: CGFloat, quality: CGInterpolationQuality = .medium) -> UIImage {
        let width = self.size.width * rate
        let height = self.size.height * rate
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = quality
        self.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resized
    }
    
    // More information here: http://nshipster.com/image-resizing/
    public func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// 切图
    public func crop(_ rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 根据颜色生成一张图片
    public static func withColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 获取指定View图片
    public class func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx?.addEllipse(in: rect)
        ctx?.clip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// Creates a QR code from a string.
    /// Resizing rate defaults to 15.0 here because the CIFilter result is 31x31 pixels in size.
    ///
    /// - Parameter string: Text to be the QR Code content
    /// - Parameter resizeRate: The resizing rate. Positive for enlarging and negative for shrinking. Defaults to 15.0.
    /// - Returns: image QR Code image
    public static func imageQRCode(for string: String, resizeRate: CGFloat = 15.0) -> UIImage {
        let data = string.data(using: .isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        let cImage = filter.outputImage!
        
        let qrCode = UIImage(ciImage: cImage)
        let qrCodeResized = qrCode.resized(by: resizeRate, quality: .none)
        
        return qrCodeResized
    }
    
    /// 图片高宽比
    public var aspectRatio: CGFloat {
        return size.width / size.height
    }
    
    public var base64: String {
        return UIImageJPEGRepresentation(self, 1.0)!.base64EncodedString()
    }
    
    
    /// 从base64字符串创建一个图像。
    public convenience init?(base64: String) {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        self.init(data: data)
    }
    
    /**
     Fix the image's orientation
     
     https://github.com/cosnovae/fixUIImageOrientation/blob/master/fixImageOrientation.swift
     
     - parameter src: the source image
     
     - returns: new image
     */
    public func fixImageOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch self.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: self.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: self.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch self.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            break
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            break
        }
        
        let cgimage:CGImage = ctx.makeImage()!
        let image:UIImage = UIImage(cgImage: cgimage)
        
        return image
    }
    
    //https://github.com/melvitax/AFImageHelper/blob/master/AFImageHelper%2FAFImageExtension.swift
    public enum UIImageContentMode {
        case scaleToFill, scaleAspectFit, scaleAspectFill
    }
    
    /**
     Creates a resized copy of an image.
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     - Parameter quality:     The image quality
     
     - Returns A new image
     */
    public func resize(_ size:CGSize, contentMode: UIImageContentMode = .scaleToFill, quality: CGInterpolationQuality = .medium) -> UIImage? {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let transform = CGAffineTransform.identity
        
        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality = quality
        
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    public func j_crop(_ bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!, scale: 0.0, orientation: self.imageOrientation)
    }
    
    public func cropToSquare() -> UIImage? {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        let left: CGFloat = size.width > shortest ? (size.width-shortest)/2 : 0
        let top: CGFloat = size.height > shortest ? (size.height-shortest)/2 : 0
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)
        return crop(insetRect)
    }

    /// 将模糊效果应用于图像
    ///
    /// - Parameters:
    ///   - blurRadius: Blur radius.
    ///   - saturation: Saturation delta factor, leave it default (1.8) if you don't what is.
    ///   - tintColor: Blur tint color, default is nil.
    ///   - maskImage: Apply a mask image, leave it default (nil) if you don't want to mask.
    /// - Returns: Return the transformed image.
    public func blur(radius blurRadius: CGFloat, saturation: CGFloat = 1.8, tintColor: UIColor? = nil, maskImage: UIImage? = nil) -> UIImage {
        guard size.width > 1 && size.height > 1, let selfCGImage = cgImage else {
            return self
        }
        
        let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        var effectImage = self
        
        let hasBlur = Float(blurRadius) > Float.ulpOfOne
        let hasSaturationChange = Float(abs(saturation - 1)) > Float.ulpOfOne
        
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            effectInContext.scaleBy(x: 1, y: -1)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(selfCGImage, in: imageRect)
            var effectInBuffer = vImage_Buffer(data: effectInContext.data, height: UInt(effectInContext.height), width: UInt(effectInContext.width), rowBytes: effectInContext.bytesPerRow)
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            guard let effectOutContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            var effectOutBuffer = vImage_Buffer(data: effectOutContext.data, height: UInt(effectOutContext.height), width: UInt(effectOutContext.width), rowBytes: effectOutContext.bytesPerRow)
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.main.scale
                var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * Double.pi)) / 4 + 0.5))
                if radius % 2 != 1 {
                    radius += 1
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            if hasSaturationChange {
                let s = saturation
                let floatingPointSaturationMatrix = [
                    0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
                    0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
                    0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
                    0, 0, 0, 1
                ]
                
                let divisor: CGFloat = 256
                let saturationMatrix = floatingPointSaturationMatrix.map {
                    return Int16(round($0 * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let outputContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        outputContext.scaleBy(x: 1, y: -1)
        outputContext.translateBy(x: 0, y: -size.height)
        
        outputContext.draw(selfCGImage, in: imageRect)
        
        if hasBlur {
            outputContext.saveGState()
            if let maskImage = maskImage {
                outputContext.clip(to: imageRect, mask: maskImage.cgImage!)
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        
        if let tintColor = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(tintColor.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        UIGraphicsEndImageContext()
        
        return outputImage
    }

}

