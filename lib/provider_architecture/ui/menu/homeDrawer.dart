import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/model/user.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class HomeDrawer extends StatefulWidget {
  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;
  final User user;
  final Function logout;

  HomeDrawer({
    Key key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex,
    this.user,
    this.logout,
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;

  @override
  void initState() {
    setdDrawerListArray();
    super.initState();
  }

  void setdDrawerListArray() {
    drawerList = [
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: new Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Chat,
        labelName: 'Chat',
        icon: new Icon(Icons.chat),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: new Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: AppTheme.primaryColor,
            width: double.infinity,
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return new ScaleTransition(
                        scale: new AlwaysStoppedAnimation(
                            1.0 - (widget.iconAnimationController.value) * 0.3),
                        child: RotationTransition(
                          turns: new AlwaysStoppedAnimation(Tween(
                                      begin: 0.0, end: 80.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppTheme.backgroundWhite,
                            backgroundImage: widget.user.avatar != null
                                ? NetworkImage(widget.user.avatar)
                                : null,
                            child: widget.user.avatar != null
                                ? null
                                : Text(
                                    widget.user.firstName != null
                                        ? '${widget.user.firstName.substring(0, 1).toUpperCase()}'
                                        : '${widget.user.email.substring(0, 1).toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        color: AppTheme.accentColor),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  widget.user.firstName != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            widget.user.firstName != null
                                ? '${widget.user.firstName}'
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentColor,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      widget.user.email != null ? '${widget.user.email}' : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentColor,
                        fontSize: widget.user.firstName != null ? 14 : 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (context, index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.accentColor,
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: new Text(
                  "Logout",
                  style: new TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.accentColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: new Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  widget.logout(context);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? AppTheme.accentColor
                                  : AppTheme.accentColor),
                        )
                      : new Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppTheme.accentColor
                              : AppTheme.accentColor),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  new Text(
                    listData.labelName,
                    style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? AppTheme.accentColor
                          : AppTheme.accentColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppTheme.pink400.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  Chat,
  About,
}

class DrawerList {
  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;

  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });
}
