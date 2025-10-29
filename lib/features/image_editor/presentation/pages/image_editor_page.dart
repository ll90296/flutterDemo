import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class _SaveImageData {
  final Uint8List selectedImageBytes;
  final Uint8List? logoImageBytes;
  final double logoSize;
  final Alignment logoPosition;

  _SaveImageData({
    required this.selectedImageBytes,
    this.logoImageBytes,
    required this.logoSize,
    required this.logoPosition,
  });
}

class ImageEditorPage extends StatefulWidget {
  const ImageEditorPage({super.key});

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  File? _selectedImage;
  File? _logoImage;
  Uint8List? _selectedImageBytes;
  Uint8List? _logoImageBytes;
  double _logoOpacity = 0.5;
  double _logoSize = 0.2;
  Alignment _logoPosition = Alignment.bottomRight;
  Color _borderColor = Colors.white;
  double _borderWidth = 5.0;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, {bool isLogo = false}) async {
    try {
      print('开始选择图片，类型: ${isLogo ? 'Logo' : '主图片'}, 来源: $source');
      
      final XFile? image = await _picker.pickImage(source: source);
      
      if (image != null) {
        print('图片选择成功: ${image.name}, 路径: ${image.path}, 大小: ${await image.length()} bytes');
        
        // 读取图片字节数据（Web环境需要）
        final Uint8List imageBytes = await image.readAsBytes();
        print('图片字节数据读取成功，大小: ${imageBytes.length} bytes');
        
        setState(() {
          if (isLogo) {
            _logoImage = File(image.path);
            _logoImageBytes = imageBytes;
            print('Logo图片已设置');
          } else {
            _selectedImage = File(image.path);
            _selectedImageBytes = imageBytes;
            print('主图片已设置');
          }
        });
        
        print('图片设置完成，当前状态 - 主图片: ${_selectedImage != null}, Logo: ${_logoImage != null}');
      } else {
        print('用户取消了图片选择');
      }
    } catch (e, stackTrace) {
      print('图片选择发生错误: $e');
      print('错误堆栈: $stackTrace');
      
      // 显示错误信息给用户
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('图片选择失败: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildImagePreview() {
    print('构建图片预览，主图片: ${_selectedImage != null}, Logo: ${_logoImage != null}');
    
    if (_selectedImage == null) {
      print('没有选择主图片，显示占位符');
      return Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('请选择主图片', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    print('显示主图片预览，路径: ${_selectedImage!.path}');
    
    return Stack(
      children: [
        // 主图片
        _selectedImageBytes != null
            ? Image.memory(
                _selectedImageBytes!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('主图片加载错误: $error');
                  print('错误堆栈: $stackTrace');
                  return Container(
                    color: Colors.red[100],
                    child: const Center(
                      child: Text('图片加载失败', style: TextStyle(color: Colors.red)),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Text('图片数据未加载', style: TextStyle(color: Colors.grey)),
                ),
              ),
        
        // 边框
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _borderColor,
              width: _borderWidth,
            ),
          ),
        ),
        
        // Logo叠加
        if (_logoImageBytes != null)
          Positioned.fill(
            child: Align(
              alignment: _logoPosition,
              child: Opacity(
                opacity: _logoOpacity,
                child: Container(
                  width: 100 * _logoSize,
                  height: 100 * _logoSize,
                  child: Image.memory(
                    _logoImageBytes!, 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Logo图片加载错误: $error');
                      print('错误堆栈: $stackTrace');
                      return Container(
                        color: Colors.blue[100],
                        child: const Center(
                          child: Text('Logo加载失败', style: TextStyle(color: Colors.blue)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('图片选择', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('选择主图片'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery, isLogo: true),
                    icon: const Icon(Icons.branding_watermark),
                    label: const Text('选择Logo'),
                  ),
                ),
              ],
            ),
            
            if (_logoImage != null) ...[
              const SizedBox(height: 24),
              const Text('Logo设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // Logo透明度
              Row(
                children: [
                  const Text('透明度:'),
                  Expanded(
                    child: Slider(
                      value: _logoOpacity,
                      onChanged: (value) => setState(() => _logoOpacity = value),
                      min: 0.1,
                      max: 1.0,
                    ),
                  ),
                  Text('${(_logoOpacity * 100).round()}%'),
                ],
              ),
              
              // Logo大小
              Row(
                children: [
                  const Text('大小:'),
                  Expanded(
                    child: Slider(
                      value: _logoSize,
                      onChanged: (value) => setState(() => _logoSize = value),
                      min: 0.1,
                      max: 0.5,
                    ),
                  ),
                  Text('${(_logoSize * 100).round()}%'),
                ],
              ),
              
              // Logo位置
              const Text('位置:'),
              Wrap(
                spacing: 8,
                children: [
                  _buildPositionButton(Alignment.topLeft, Icons.arrow_upward),
                  _buildPositionButton(Alignment.topCenter, Icons.arrow_upward),
                  _buildPositionButton(Alignment.topRight, Icons.arrow_upward),
                  _buildPositionButton(Alignment.centerLeft, Icons.arrow_back),
                  _buildPositionButton(Alignment.center, Icons.center_focus_strong),
                  _buildPositionButton(Alignment.centerRight, Icons.arrow_forward),
                  _buildPositionButton(Alignment.bottomLeft, Icons.arrow_downward),
                  _buildPositionButton(Alignment.bottomCenter, Icons.arrow_downward),
                  _buildPositionButton(Alignment.bottomRight, Icons.arrow_downward),
                ],
              ),
            ],
            
            const SizedBox(height: 24),
            const Text('边框设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // 边框颜色
            Row(
              children: [
                const Text('边框颜色:'),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _borderColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<Color>(
                    value: _borderColor,
                    onChanged: (color) => setState(() => _borderColor = color!),
                    items: const [
                      DropdownMenuItem(value: Colors.white, child: Text('白色')),
                      DropdownMenuItem(value: Colors.black, child: Text('黑色')),
                      DropdownMenuItem(value: Colors.red, child: Text('红色')),
                      DropdownMenuItem(value: Colors.blue, child: Text('蓝色')),
                      DropdownMenuItem(value: Colors.green, child: Text('绿色')),
                    ],
                  ),
                ),
              ],
            ),
            
            // 边框宽度
            Row(
              children: [
                const Text('边框宽度:'),
                Expanded(
                  child: Slider(
                    value: _borderWidth,
                    onChanged: (value) => setState(() => _borderWidth = value),
                    min: 0,
                    max: 20,
                  ),
                ),
                Text('${_borderWidth.round()}px'),
              ],
            ),
            
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _selectedImage == null ? null : _saveImage,
              icon: const Icon(Icons.save),
              label: const Text('保存图片'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionButton(Alignment alignment, IconData icon) {
    return IconButton(
      onPressed: () => setState(() => _logoPosition = alignment),
      icon: Icon(icon, color: _logoPosition == alignment ? Colors.blue : Colors.grey),
      tooltip: alignment.toString(),
    );
  }

  Future<void> _saveImage() async {
    try {
      print('开始保存图片...');
      
      if (_selectedImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先选择主图片')),
        );
        return;
      }

      // 显示保存进度
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在处理图片，请稍候...')),
      );

      // 使用异步处理避免阻塞UI
      final Uint8List resultBytes = await _processImageAsync();
      
      // 在Web环境中保存图片
      _saveImageForWeb(resultBytes);
      
      print('图片保存成功！');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('图片保存成功！')),
      );
      
    } catch (e, stackTrace) {
      print('图片保存失败: $e');
      print('错误堆栈: $stackTrace');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('图片保存失败: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Uint8List> _processImageAsync() async {
    // 使用简单的异步处理，避免阻塞UI
    return await Future.microtask(() => _processImage(_SaveImageData(
      selectedImageBytes: _selectedImageBytes!,
      logoImageBytes: _logoImageBytes,
      logoSize: _logoSize,
      logoPosition: _logoPosition,
    )));
  }

  static Uint8List _processImage(_SaveImageData data) {
    // 优化：限制图片最大尺寸，避免处理过大图片
    const int maxImageSize = 2000; // 最大图片尺寸
    
    // 解码主图片
    final img.Image baseImage = img.decodeImage(data.selectedImageBytes)!;
    
    // 如果图片过大，先进行缩放
    img.Image processedImage = baseImage;
    if (baseImage.width > maxImageSize || baseImage.height > maxImageSize) {
      final double scale = maxImageSize / max(baseImage.width, baseImage.height);
      final int newWidth = (baseImage.width * scale).round();
      final int newHeight = (baseImage.height * scale).round();
      processedImage = img.copyResize(baseImage, width: newWidth, height: newHeight);
    }
    
    // 如果有Logo，合成Logo
    if (data.logoImageBytes != null) {
      final img.Image logoImage = img.decodeImage(data.logoImageBytes!)!;
      
      // 计算Logo大小（限制最大尺寸）
      final int logoWidth = min((logoImage.width * data.logoSize).round(), 500);
      final int logoHeight = min((logoImage.height * data.logoSize).round(), 500);
      
      // 调整Logo大小
      final img.Image resizedLogo = img.copyResize(logoImage, width: logoWidth, height: logoHeight);
      
      // 计算Logo位置
      final int x = _calculateLogoPositionX(processedImage.width, resizedLogo.width, data.logoPosition);
      final int y = _calculateLogoPositionY(processedImage.height, resizedLogo.height, data.logoPosition);
      
      // 合成图片
      img.compositeImage(processedImage, resizedLogo, 
        dstX: x, dstY: y, blend: img.BlendMode.alpha);
    }
    
    // 编码为PNG（优化压缩质量）
    return img.encodePng(processedImage, level: 6); // 使用中等压缩级别
  }

  static int _calculateLogoPositionX(int baseWidth, int logoWidth, Alignment position) {
    switch (position.toString()) {
      case 'Alignment.topLeft':
      case 'Alignment.centerLeft':
      case 'Alignment.bottomLeft':
        return 10; // 左边距
      case 'Alignment.topCenter':
      case 'Alignment.center':
      case 'Alignment.bottomCenter':
        return (baseWidth - logoWidth) ~/ 2; // 居中
      case 'Alignment.topRight':
      case 'Alignment.centerRight':
      case 'Alignment.bottomRight':
      default:
        return baseWidth - logoWidth - 10; // 右边距
    }
  }

  static int _calculateLogoPositionY(int baseHeight, int logoHeight, Alignment position) {
    switch (position.toString()) {
      case 'Alignment.topLeft':
      case 'Alignment.topCenter':
      case 'Alignment.topRight':
        return 10; // 上边距
      case 'Alignment.centerLeft':
      case 'Alignment.center':
      case 'Alignment.centerRight':
        return (baseHeight - logoHeight) ~/ 2; // 居中
      case 'Alignment.bottomLeft':
      case 'Alignment.bottomCenter':
      case 'Alignment.bottomRight':
      default:
        return baseHeight - logoHeight - 10; // 下边距
    }
  }

  int _calculateLogoX(int baseWidth, int logoWidth) {
    switch (_logoPosition.toString()) {
      case 'Alignment.topLeft':
      case 'Alignment.centerLeft':
      case 'Alignment.bottomLeft':
        return 10; // 左边距
      case 'Alignment.topCenter':
      case 'Alignment.center':
      case 'Alignment.bottomCenter':
        return (baseWidth - logoWidth) ~/ 2; // 居中
      case 'Alignment.topRight':
      case 'Alignment.centerRight':
      case 'Alignment.bottomRight':
      default:
        return baseWidth - logoWidth - 10; // 右边距
    }
  }

  int _calculateLogoY(int baseHeight, int logoHeight) {
    switch (_logoPosition.toString()) {
      case 'Alignment.topLeft':
      case 'Alignment.topCenter':
      case 'Alignment.topRight':
        return 10; // 上边距
      case 'Alignment.centerLeft':
      case 'Alignment.center':
      case 'Alignment.centerRight':
        return (baseHeight - logoHeight) ~/ 2; // 居中
      case 'Alignment.bottomLeft':
      case 'Alignment.bottomCenter':
      case 'Alignment.bottomRight':
      default:
        return baseHeight - logoHeight - 10; // 下边距
    }
  }

  void _saveImageForWeb(Uint8List imageBytes) {
    // 对于Web环境，使用html库进行下载
    if (kIsWeb) {
      // 创建Blob
      final blob = html.Blob([imageBytes], 'image/png');
      
      // 创建URL
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // 创建下载链接
      final anchor = html.AnchorElement(href: url);
      anchor.download = 'edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
      anchor.style.display = 'none';
      
      // 添加到页面并触发下载
      html.document.body!.append(anchor);
      anchor.click();
      
      // 清理
      Future.delayed(const Duration(seconds: 1), () {
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      });
    } else {
      // 对于非Web环境，使用文件保存
      // 这里可以添加原生平台的保存逻辑
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存功能仅支持Web环境')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图片编辑器'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 图片预览区域
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildImagePreview(),
            ),
            
            const SizedBox(height: 24),
            
            // 控制面板
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }
}