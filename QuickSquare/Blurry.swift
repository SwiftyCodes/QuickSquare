import UIKit
import CoreImage
import CoreGraphics

/// Options for how a blur should be rendered. A few helper multi-options are available, such as 'pro'.
public struct BlurryOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let unspecified = BlurryOptions(rawValue: 0)
    public static let dithered    = BlurryOptions(rawValue: 1 << 0)
    public static let hardEdged   = BlurryOptions(rawValue: 1 << 1)
    public static let saturated   = BlurryOptions(rawValue: 1 << 2)
    public static let brightened  = BlurryOptions(rawValue: 1 << 3)
    
    public static let none: BlurryOptions = (rawValue: unspecified) as! BlurryOptions
    public static let pro: BlurryOptions = [.hardEdged, .saturated]
    public static let all: BlurryOptions = [.dithered, .hardEdged, .saturated, .brightened]
}

/// 🌫 Blurry, image blurring in Swift
public final class Blurry {
    
    /// Creates a blurred UIImage.
    ///
    /// - Parameters:
    ///   - image: Input image to blur.
    ///   - size: Desired resulting size.
    ///   - blurRadius: A scalar value that specifies the distance from the center of an blur.
    /// - Returns: Resulting blurred image.
    public class func blurryImage(forImage image: UIImage, size: CGSize, blurRadius: CGFloat) -> UIImage? {
        return self.blurryImage(withOptions: .none, overlayColor: nil, forImage: image, size: size, blurRadius: blurRadius)
    }
    
    /// Creates a blurred UIImage with some additional options.
    ///
    /// - Parameters:
    ///   - options: Bit mask type representing the blurring operations to perform on the input.
    ///   - image: Input image to blur.
    ///   - size: Desired resulting size.
    ///   - blurRadius: A scalar value that specifies the distance from the center of an blur.
    /// - Returns: Resulting blurred image.
    public class func blurryImage(withOptions options: BlurryOptions, forImage image: UIImage, size: CGSize, blurRadius: CGFloat) -> UIImage? {
        return self.blurryImage(withOptions: options, overlayColor: nil, forImage: image, size: size, blurRadius: blurRadius)
    }
    
    /// Creates a blurred UIImage with some additional options and overlay color.
    ///
    /// - Parameters:
    ///   - options: Bit mask type representing the blurring operations to perform on the input.
    ///   - overlayColor: Color composited over the image.
    ///   - image: Input image to blur.
    ///   - size: Desired resulting size.
    ///   - blurRadius: A scalar value that specifies the distance from the center of an blur.
    /// - Returns: Resulting blurred image.
    public class func blurryImage(withOptions options: BlurryOptions, overlayColor: UIColor?, forImage image: UIImage, size: CGSize, blurRadius: CGFloat) -> UIImage? {
        var outputImage: UIImage? = nil
        
        let imageOutset = options.contains(BlurryOptions.hardEdged) ? 0.0 : (blurRadius * 2.0)
        
        var bitsPerComponent: size_t = 8
        if let cgimage = image.cgImage {
            bitsPerComponent = cgimage.bitsPerComponent
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        if let bitmapContext = CGContext(data: nil, width: Int(size.width + (imageOutset * 2.0)), height: Int(size.height + (imageOutset * 2.0)), bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
            
            if let cgimage = image.cgImage {
                bitmapContext.draw(cgimage, in: CGRect(x: imageOutset, y: imageOutset, width: size.width, height: size.height))
            }
            
            if let blurryCGImage = bitmapContext.makeImage() {
                struct Static {
                    // Note:
                    // To request that Core Image perform no color management, specify the NSNull object as the value for this key.
                    // https://developer.apple.com/reference/coreimage/kcicontextworkingcolorspace
                    static var cicontext: CIContext? = CIContext(options: [kCIContextWorkingColorSpace:NSNull()])
                }
                let imageRect = bitmapContext.boundingBoxOfClipPath
                var ciimage = CIImage(cgImage: blurryCGImage)
                
                // apply saturation
                if options.contains(.saturated) {
                    ciimage.applyingFilter("CIColorControls", withInputParameters: [kCIInputSaturationKey:2.0])
                }
                
                // apply brightness
                if options.contains(.brightened) {
                    ciimage.applyingFilter("CIColorControls", withInputParameters: [kCIInputBrightnessKey:6.0])
                }
                
                // apply blur through to edge
                if options.contains(.hardEdged) {
                    ciimage = ciimage.clampingToExtent()
                }
                
                ciimage = ciimage.applyingFilter("CIGaussianBlur", withInputParameters: [kCIInputRadiusKey:blurRadius])
                
                // apply overlay color
                if let color = overlayColor {
                    let constantColorImage = CIImage(color: CIColor(cgColor: color.cgColor))
                    ciimage = constantColorImage.compositingOverImage(ciimage)
                }
                
                // apply dither
                if options.contains(.dithered) {
                    if let randomFilter = CIFilter(name: "CIRandomGenerator"), let randomImage = randomFilter.outputImage {
                        let monochromeVec = CIVector(x: 1, y: 0, z: 0, w: 0)
                        let inputParams = ["inputRVector": monochromeVec,
                                           "inputGVector": monochromeVec,
                                           "inputBVector": monochromeVec,
                                           "inputAVector": CIVector(x: 0, y: 0, z: 0, w: 0.04)]
                        let noiseImage = randomImage.applyingFilter("CIColorMatrix", withInputParameters: inputParams)
                        ciimage = noiseImage.compositingOverImage(ciimage)
                    }
                }
                
                // create output image
                if let context = Static.cicontext, let blurryCGImage = context.createCGImage(ciimage, from: imageRect) {
                    outputImage = UIImage(cgImage: blurryCGImage)
                }
            }
            
        }
        return outputImage
    }
}

// MARK: - UIImage extension
extension UIImage {
    
    /// An extension on UIImage that blurs the UIImage.
    ///
    /// - Parameter blurRadius: A scalar value that specifies the distance from the center of an blur.
    /// - Returns: Resulting blurred image.
    public func blurryImage(blurRadius: CGFloat) -> UIImage? {
        return Blurry.blurryImage(withOptions: .none, overlayColor: nil, forImage: self, size: self.size, blurRadius: blurRadius)
    }
    
    /// An extension on UIImage that blurs the UIImage with some additional options.
    ///
    /// - Parameters:
    ///   - options: Bit mask type representing the blurring operations to perform on the input.
    ///   - blurRadius: A scalar value that specifies the distance from the center of an blur.
    /// - Returns: Resulting blurred image.
    public func blurryImage(withOptions options: BlurryOptions, blurRadius: CGFloat) -> UIImage? {
        return Blurry.blurryImage(withOptions: options, overlayColor: nil, forImage: self, size: self.size, blurRadius: blurRadius)
    }
    
    /// An extension on UIIMage that blurs the UIImage with some additional options and overlay color.
    ///
    /// - Parameters:
    ///   - options: Bit mask type representing the blurring operations to perform on the input.
    ///   - overlayColor: Color composited over the image.
    ///   - blurRadius: A scalar value that specifies the distance from the center of an blur.
    /// - Returns: Resulting blurred image.
    public func blurryImage(withOptions options: BlurryOptions, overlayColor: UIColor?, blurRadius: CGFloat) -> UIImage? {
        return Blurry.blurryImage(withOptions: options, overlayColor: overlayColor, forImage: self, size: self.size, blurRadius: blurRadius)
    }
    
  }


// For Dynamic UIImanagement Purpose

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

