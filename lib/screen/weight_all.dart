import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/screen/weight_update.dart';

class WeightAllPage extends StatelessWidget {
  static const routeName = '/weight-all';

  final List<WeightHistory> items = [
    WeightHistory("Nov 27, 2019", '40.5kg'),
    WeightHistory("Nov 29, 2019", '41.5kg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _topBar(context),
              Expanded(
                child: _content()
              )
            ]
          )
        )
      )
    );
  }

  Widget _topBar(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(
          'Weight History',
          style: NunitoStyle.h4.copyWith(color: Colors.black),
        ),
        Text(
          '         ', //wtf
          style: NunitoStyle.h4.copyWith(color: ThemeColor.black[56]),
        ),
      ],
    );
  }

  Widget _content() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          subtitle: Text(item.day),
          title: Text(item.weight),
          trailing: Icon(Icons.more_vert),
          onTap: () { 
            _settingModalBottomSheet(context);
          },
        );
      }
    );
  }

}

class WeightHistory {
  final String day;
  final String weight;

  WeightHistory(this.day, this.weight);
}


void _settingModalBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                title: Center(
                  child: new Text('Edit weight'),
                ),
                onTap: () => Nav.navigateTo(WeightUpdatePage.routeName)         
              ),
              new ListTile(
                title: Center(
                  child: new Text(
                    'Delete weight', 
                    style: TextStyle(color: Colors.red)
                  ),
                ),
                onTap: () => {},          
              ),
            ],
          ),
        );
      }
    );
}