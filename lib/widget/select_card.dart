import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';


class SelectCardWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget content;
  final bool selected;
  final double marginBottom;
  final bool suffixCheckbox;
  final bool leftAlign;
  final Function(bool val) onCheckboxChanged;
  final bool checkboxSelected;

  SelectCardWidget({
    Key key, 
    this.onTap, 
    this.content, 
    this.selected = false,
    this.marginBottom = 0.0,
    this.suffixCheckbox = false,
    this.leftAlign = false,
    this.onCheckboxChanged,
    this.checkboxSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _size = MediaQuery.of(context).size.width;

    return InkResponse(
      onTap: () => onTap(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 80.0 + marginBottom,
          minWidth: _size
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.0,27.0,16.0,27.0),
          margin: EdgeInsets.only(bottom: marginBottom),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: selected ? Border.all(color: ThemeColor.primaryDark, width: 2.0) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 10.0,
                spreadRadius: 0,
                offset: Offset(5.0,6.0)
              )
            ]
          ),
          child: !leftAlign ? Center(
            child: content,
          ) : (suffixCheckbox ? Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(
                flex: 8,
                child: content
              ),
              Flexible(
                child: Checkbox(
                  activeColor: ThemeColor.primary,
                  value: checkboxSelected, 
                  onChanged: (val) => onCheckboxChanged(val)
                ),
              )
            ],
          ) : content),
        ),
      ),
    );
  }
}
