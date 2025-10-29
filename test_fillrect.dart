import 'package:image/image.dart' as img;

void main() {
  // 创建一个测试图片
  final img.Image image = img.Image(width: 100, height: 100);
  
  // 测试fillRect方法
  final img.Color color = img.ColorInt8.rgba(255, 0, 0, 255);
  
  // 查看fillRect方法的签名
  print('Testing fillRect method...');
  
  // 尝试不同的调用方式
  try {
    img.fillRect(image, 0, 0, 10, 10, color: color);
    print('fillRect with named parameter works');
  } catch (e) {
    print('fillRect with named parameter failed: $e');
  }
  
  try {
    img.fillRect(image, x: 0, y: 0, width: 10, height: 10, color: color);
    print('fillRect with all named parameters works');
  } catch (e) {
    print('fillRect with all named parameters failed: $e');
  }
  
  try {
    img.fillRect(image, 0, 0, 10, 10);
    print('fillRect without color works');
  } catch (e) {
    print('fillRect without color failed: $e');
  }
}