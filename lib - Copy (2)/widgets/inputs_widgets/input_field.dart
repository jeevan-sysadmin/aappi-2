import 'package:flutter/material.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLines;
  final VoidCallback? onTap;


  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onTap
  }) : super(key: key);

  @override
  State<InputField> createState() => _PrimaryInputFieldState();
}

class _PrimaryInputFieldState extends State<InputField> {

  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.heightSize * 0.4
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.widthSize * 1.2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: focusNode!.hasFocus
                ? CustomColor.primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.4),
            width: 1
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: widget.readOnly,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(1),
                fontSize: Dimensions.defaultTextSize * 2,
                fontWeight: FontWeight.w500,
              ),
              onTap: widget.readOnly ? widget.onTap: (){
                setState(() {
                  focusNode!.requestFocus();
                });
              },
              onFieldSubmitted: (value){
                setState(() {
                  focusNode!.unfocus();
                });
              },
              focusNode: focusNode,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: focusNode!.hasFocus
                        ? CustomColor.primaryColor.withOpacity(0.2)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    fontSize: Dimensions.defaultTextSize * 2,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,

                // contentPadding: EdgeInsets.zero
              ),

            ),
          ),
          Visibility(
            visible: widget.readOnly,
            child: Icon(
              widget.onTap == null ? Icons.check_circle_outline : Icons.calendar_month_outlined,
              color: widget.onTap == null ? Colors.green : Theme.of(context).primaryColor.withOpacity(1),
            ),
          )
        ],
      ),
    );
  }
}
