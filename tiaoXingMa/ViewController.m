//
//  ViewController.m
//  tiaoXingMa
//
//  Created by kuanter on 16/4/19.
//  Copyright © 2016年 kuanter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ddddd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
        //     1. 实例化二维码滤镜
        CIFilter*filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];//二维码
        
        //    CIFilter*filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];//条形码
        // 2. 恢复滤镜的默认属性
        [filter setDefaults];
        
        // 3. 将字符串转换成NSData
        NSData *data = [@"我是孙少伟，你是谁" dataUsingEncoding:NSUTF8StringEncoding];
        
        // 4. 通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKey:@"inputMessage"];
        
        [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
        // 5. 获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        
        // 6. 将CIImage转换成UIImage，并放大显示
//        UIImage*erWeiImage= [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    
         _ddddd.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
      }

//将生成的二维码变清析
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (IBAction)button:(id)sender {
    
    UIImage*myImage =_ddddd.image;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_孙d.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(myImage)writeToFile: filePath    atomically:YES];
    
    
//    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", conut_]];   // 保存文件的名称
//    
//    [info setObject:filePath forKey:@"img"];
//    [specialArr addObject:info];
    
    
//    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath2 = [[paths2 objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", (int)current]];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
