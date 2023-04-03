import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InlineImageTextWidget extends StatefulWidget {
  final List<dynamic> content;
  final Function(int, String) onTextChanged;
  final Function(int, File) onImageAdded;

  InlineImageTextWidget({
    required this.content,
    required this.onTextChanged,
    required this.onImageAdded,
  });

  @override
  _InlineImageTextWidgetState createState() => _InlineImageTextWidgetState();
}

class _InlineImageTextWidgetState extends State<InlineImageTextWidget> {
  late List<TextEditingController?> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _createControllers(widget.content);
  }

  List<TextEditingController?> _createControllers(List<dynamic> content) {
    return content.map((item) {
      if (item is String) {
        return TextEditingController(text: item);
      } else {
        return null;
      }
    }).toList();
  }

  void _onTextChanged(int index, String text) {
    widget.onTextChanged(index, text);
  }

  void _onImageAdded(int index, File image) {
    widget.onImageAdded(index, image);
    setState(() {
      _controllers.insert(index + 1, TextEditingController());
      _controllers.insert(index + 2, TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.content.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.content[index];
        if (item is String) {
          final controller =
              _controllers[index] ?? TextEditingController(text: '');
          _controllers[index] = controller;
          return TextField(
            controller: controller,
            onChanged: (text) => _onTextChanged(index, text),
            decoration: InputDecoration(
              hintText: 'Type something...',
              border: InputBorder.none,
            ),
          );
        } else if (item is File) {
          return Image.file(item);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
