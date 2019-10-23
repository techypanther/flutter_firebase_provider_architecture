import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/model/user.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/about/AboutUsViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class AboutUsView extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsView> {
  @override
  void initState() {
    screen = 3;
    super.initState();
  }

  @override
  void dispose() {
    screen = 1;
    super.dispose();
  }

  void showMessage(AboutUsViewModel model) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (model.shouldShowMessage) {
          model.messageIsShown();
          Utils.showMessage(model.message);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AboutUsViewModel>(
      onModelReady: (model) => AboutUsViewModel(),
      builder: (context, model, child) {
        showMessage(model);
        return Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: Text('About Us'),
          ),
          body: Container(
            child: setBody(model),
          ),
        );
      },
    );
  }

  Widget setBody(AboutUsViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            // child: Image(image: AssetImage('assets/tp.png')),
            child: Image(image: AssetImage('assets/tp.jpg')),
          ),
          SizedBox(height: 5),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            separatorBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Divider(
                  color: AppTheme.accentColor,
                  height: 0.2,
                ),
              );
            },
            shrinkWrap: true,
            itemCount: model.userList.length,
            itemBuilder: (context, index) {
              User user = model.userList[index];
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(user.avatar),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${user.firstName + ' ' + user.lastName}',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontFamily: 'Oswald',
                        ),
                      ),
                      Text(
                        '${user.token}',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
