import 'package:flutter/material.dart';

import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class SendInputField extends StatefulWidget {
  final TextEditingController controller;  // Controller for text input.
  final String hintText;  // Hint text displayed in the input field.
  final VoidCallback? onTap, voiceTab;  // Callbacks for onTap and voiceTab actions.
  final Widget icon;  // Icon widget displayed as a suffix icon.

  // Constructor to initialize the widget with required properties.
  const SendInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.onTap,
    this.voiceTab,
  }) : super(key: key);

  @override
  State<SendInputField> createState() => _SendInputFieldState();
}

class _SendInputFieldState extends State<SendInputField> with TickerProviderStateMixin {
  FocusNode? focusNode;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; // Define _scaleAnimation here

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.1,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    focusNode!.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.widthSize * 1.2,
        vertical: Dimensions.heightSize * 1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.widthSize * 1.2,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                    color: focusNode!.hasFocus
                        ? CustomColor.primaryColor
                        : Theme.of(context).primaryColor,
                    width: 1
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.radius * 50),
              ),
              child: TextFormField(
                controller: widget.controller,  // Connect the text input controller.
                style: CustomStyle.primaryTextStyle.copyWith(
                  fontSize: Dimensions.defaultTextSize * 1.6,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.left,

                onTap: () {
                  setState(() {
                    focusNode!.requestFocus();  // Request focus when the input field is tapped.
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    focusNode!.unfocus();  // Unfocus the input field when submitted.
                  });
                },
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: widget.hintText,  // Display the provided hint text.
                  hintStyle: TextStyle(
                    color: focusNode!.hasFocus
                        ? CustomColor.primaryColor.withOpacity(0.9)
                        : Theme.of(context).primaryColor,
                    fontSize: Dimensions.defaultTextSize * 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,

                  suffixIcon: IconButton(
                    onPressed: widget.voiceTab,  // Execute the voiceTab callback on icon press.
                    icon: widget.icon,  // Display the provided icon as a suffix.
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 0,
            child: CircleAvatar(
              backgroundColor: CustomColor.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // Log the click event to the console.
                    print('Icon tapped');
                    widget.onTap?.call();
                  },
                  child: ScaleTransition(
                    scale: _scaleAnimation, // Use the scale animation here.
                    child: const Icon(
                      Icons.send,
                      color: CustomColor.whiteColor,
                    ),
                  ),
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
