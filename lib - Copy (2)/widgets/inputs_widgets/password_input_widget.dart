import 'package:flutter/material.dart';


import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class PasswordInputWidget extends StatefulWidget {
  final String hint;
  final int maxLines;
  final TextEditingController controller;

  const PasswordInputWidget({
    Key? key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<PasswordInputWidget> createState() => _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<PasswordInputWidget> {
  FocusNode? focusNode;
  bool obscureText = true;

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
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.heightSize * .3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Poppins', // Set the Poppins font family
              fontSize: Dimensions.defaultTextSize * 1.2,

            ),
          ),

          SizedBox(
            height: Dimensions.heightSize * 0.0,
          ),


          Container(
            padding: EdgeInsets.only(
              left: Dimensions.widthSize * 1.2,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: focusNode!.hasFocus
                      ? CustomColor.primaryColor.withOpacity(0.2)
                      : Theme.of(context).primaryColor,
                  width: 1
              ),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radius * 20),
            ),
            child: TextFormField(
              controller: widget.controller,
              style: CustomStyle.primaryTextStyle.copyWith(fontSize: Dimensions.defaultTextSize * 1.6),
              textAlign: TextAlign.left,
              maxLines: widget.maxLines,
              onTap: (){
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
              textInputAction: TextInputAction.next,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: focusNode!.hasFocus
                      ? CustomColor.primaryColor.withOpacity(0.2)
                      : Theme.of(context).primaryColor,
                  fontSize: Dimensions.defaultTextSize * 1.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: focusNode!.hasFocus
                        ? CustomColor.primaryColor
                        : Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
