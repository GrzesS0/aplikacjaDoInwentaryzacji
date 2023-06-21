import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String? title;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.onChanged,
    this.title,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextField();
}

class _CustomTextField extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (value) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      maxLines: 1,
      obscureText: _obscureText,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelText: widget.title,
        labelStyle: const TextStyle(
          color: Colors.lightGreenAccent,
          fontSize: 15,
        ),
        suffixIcon: widget.obscureText == false
            ? null
            : IconButton(
                icon: Icon(_obscureText == true
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
      ),
      keyboardType: widget.keyboardType,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
    );
  }
}
