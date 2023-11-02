import 'package:flutter/material.dart';

class RequiredCustomTextField extends StatelessWidget {
  final String label;
  final String hintText;

  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  const RequiredCustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            children: const [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 30),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          controller: controller,
          maxLength: 15,
          decoration: InputDecoration(
            counterStyle: const TextStyle(color: Colors.white54),
            labelText: hintText,
            labelStyle: const TextStyle(color: Colors.white54),
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final int maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.maxLength = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: labelText,
            style: const TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          controller: controller,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterStyle: const TextStyle(color: Colors.white54),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white54),
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.white,
            ),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

class NoteCustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const NoteCustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: "活動内容など",
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextRich extends StatelessWidget {
  final String mainText;
  final String optionalText;

  const CustomTextRich({
    super.key,
    required this.mainText,
    required this.optionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: mainText,
        style: const TextStyle(fontSize: 20.0, color: Colors.white),
        children: [
          TextSpan(
            text: optionalText,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontSize: 30),
          ),
        ],
      ),
    );
  }
}
