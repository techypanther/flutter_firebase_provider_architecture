import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/model/chat.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/chat/GroupChatView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/home/HomeViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/widgets/animation/enter_exit.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/widgets/chat/grouplistcard.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  void initState() {
    screen = 2;
    super.initState();
  }

  @override
  void dispose() {
    screen = 1;
    super.dispose();
  }

  void showMessage(HomeViewModel model) {
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
    return BaseView<HomeViewModel>(
      onModelReady: (model) => HomeViewModel().init(),
      builder: (context, model, child) {
        showMessage(model);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.accentColor,
                size: 22,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text('Chat'),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: setBody(model),
          ),
        );
      },
    );
  }

  Widget setBody(HomeViewModel model) {
    return model.chatList.length <= 0
        ? Utils.noDataMessage('No chat groups found')
        : Container(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: AppTheme.accentColor,
              ),
              itemBuilder: (context, index) {
                Chat chat = model.chatList[index];
                print(chat.title);
                return GestureDetector(
                  child: GroupListCard(chat: chat),
                  onTap: () {
                    Navigator.of(context).push(
                      EnterExitRoute(
                        enterPage: GroupChatView(),
                        exitPage: HomeView(),
                      ),
                    );
                  },
                );
              },
              itemCount: model.chatList.length,
            ),
          );
  }
}
