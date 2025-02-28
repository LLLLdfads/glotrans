import 'package:flutter/material.dart';

Widget buildInputField(
    {required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
    required BuildContext context}) {
  return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.blue, // 只对包裹在这个 Theme 内的 TextField 生效
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        cursorColor: Colors.blue,
        cursorHeight: 10,
        cursorWidth: 1.5,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1.3,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(fontSize: 13, color: Colors.white),
      ));
}

Widget buildCheckbox(
    {required bool value, required Function(bool?) onChanged}) {
  return Checkbox(
    value: value,
    activeColor: Colors.blue,
    checkColor: Colors.white,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    // 移除悬停效果
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onChanged: onChanged,
  );
}
