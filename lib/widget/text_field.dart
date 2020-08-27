import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';


class TextFieldWidget extends StatefulWidget{
  final String placeholder;
  final bool obscureText;
  final bool autovalidate;
  final Function(String) validator;
  final String Function(String) onSaved;
  final TextInputType keyboardType;
  final Widget suffixItem;
  final Function onTap;
  final Function onValueChanged;
  final TextEditingController controller;

  TextFieldWidget({
    Key key, 
    this.placeholder,
    this.obscureText = false, 
    this.autovalidate = false, 
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixItem,
    this.onTap,
    this.onValueChanged,
    this.controller,
    this.onSaved,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget>{
  
  bool _contentVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // readOnly: true, //temporary
      obscureText: widget.obscureText ? _contentVisible : false,
      style: NunitoStyle.body2,
      validator: widget.validator,
      autovalidate: widget.autovalidate,
      keyboardType: widget.keyboardType,
      cursorColor: ThemeColor.primary,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        // filled: true, //temporary
        // fillColor: Colors.grey[200], //temporary
        contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
        hintText: '${widget.placeholder}',
        suffixIcon: Visibility(
          visible: widget.obscureText || widget.suffixItem != null,
          child: widget.obscureText ? IconButton(
            icon: Icon(
              !_contentVisible ? Icons.visibility : Icons.visibility_off,
              color: ThemeColor.primary,
            ),
            onPressed: () { 
              setState(() {
                _contentVisible = !_contentVisible;
              });
            },
          ) : 
          (widget.suffixItem != null ? widget.suffixItem : Text('')),
        ),
        // focusColor: Colors.transparent, //temporary
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          // borderSide: BorderSide(color: Colors.transparent, width: 1.0), //temporary
          borderSide: BorderSide(color: ThemeColor.black[24], width: 1.0), //temporary
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: ThemeColor.black[24], width: 1.0) //temporary
          // borderSide: BorderSide(color: Colors.transparent, width: 1.0) //temporary
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onTap: () => widget.onTap != null ? widget.onTap() : {},
      controller: widget.controller,
      onChanged: (val) => widget.onValueChanged(val),
    );
  }
}