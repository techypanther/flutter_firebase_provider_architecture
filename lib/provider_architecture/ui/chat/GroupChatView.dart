import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/chat/GroupChatViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/chat/chat_typing.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';
import 'package:intl/intl.dart';

class GroupChatView extends StatefulWidget {
  // Chat chat;
  // User user;
  // GroupChatView({this.user, this.chat});

  @override
  State<StatefulWidget> createState() => GroupChatViewState();
}

class GroupChatViewState extends State<GroupChatView> {
  ScrollController _scrollController;
  bool isAtTopOfChatList = true;
  String lastestMessage = '';
  String messagesText = '';

  TextEditingController messageTextController = new TextEditingController();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset !=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isAtTopOfChatList = false;
      });
    } else {
      setState(() {
        isAtTopOfChatList = true;
      });
    }
  }

  void showMessage(GroupChatViewModel model) {
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
    return BaseView<GroupChatViewModel>(
      builder: (context, model, child) {
        model.init();
        showMessage(model);
        return Scaffold(
          backgroundColor: AppTheme.surfaceWhite,
          appBar: AppBar(
            leading: Container(),
            title: Text('${model.chat.title}'),
          ),
          body: SafeArea(
            child: Scrollbar(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: model.reference != null
                              ? FirestoreAnimatedList(
                                  controller: _scrollController,
                                  reverse: true,
                                  query: model.reference,
                                  itemBuilder:
                                      (context, snapshot, animation, index) {
                                    return FadeTransition(
                                      opacity: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeIn),
                                      child: MessageBubble(
                                        index: index,
                                        document: snapshot,
                                        isMe: model.loggedInUser.email ==
                                            snapshot.data()['sender'],
                                        // user: widget.user,
                                      ),
                                    );
                                  })
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  TypingStream(
                    isAdminLoggedIn: false,
                    userEmail: model.loggedInUser != null
                        ? model.loggedInUser.email
                        : '',
                    chatId: model.chat.id,
                  ),
                  _buildBottomBar(context, model),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       top:
                  //           BorderSide(color: AppTheme.accentColor, width: 2.0),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       IconButton(
                  //         icon: Icon(
                  //           Icons.image,
                  //           color: AppTheme.accentColor,
                  //         ),
                  //         onPressed: () {
                  //           model.getImage();
                  //         },
                  //       ),
                  //       Expanded(
                  //         child: TextField(
                  //           controller: messageTextController,
                  //           onChanged: (value) {
                  //             messagesText = value;
                  //             model.updateTyping(true);
                  //           },
                  //           onEditingComplete: () {
                  //             model.updateTyping(false);
                  //           },
                  //           decoration: InputDecoration(
                  //             contentPadding: EdgeInsets.symmetric(
                  //                 vertical: 10.0, horizontal: 20.0),
                  //             hintText: 'Type your message here...',
                  //             border: InputBorder.none,
                  //           ),
                  //         ),
                  //       ),
                  //       FlatButton(
                  //         onPressed: () {
                  //           messageTextController.clear();
                  //           if (messagesText.isNotEmpty) {
                  //             model.sendMessage(messagesText);
                  //           }
                  //           messagesText = '';
                  //         },
                  //         child: Icon(
                  //           Icons.send,
                  //           color: AppTheme.accentColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container _buildBottomBar(BuildContext context, GroupChatViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.image,
              color: AppTheme.accentColor,
            ),
            onPressed: () {
              model.getImage();
            },
          ),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: messageTextController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: AppTheme.accentColor),
              ),
              onChanged: (value) {
                messagesText = value;
                model.updateTyping(true);
              },
              onEditingComplete: () {
                model.updateTyping(false);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: AppTheme.accentColor,
            onPressed: () {
              messageTextController.clear();
              if (messagesText.isNotEmpty) {
                model.sendMessage(messagesText);
              }
              messagesText = '';
            },
          )
        ],
      ),
    );
  }
}

class ScrollToTopBubble extends StatelessWidget {
  final DocumentSnapshot document;

  ScrollToTopBubble({this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          )),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Text(
          "opps",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final int index;
  final DocumentSnapshot document;
  final bool isMe;

  // final FirebaseUser user;

  MessageBubble({
    this.index,
    this.document,
    this.isMe,
    /*  this.user */
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(document.data()['createdAt']);
    bool isRecent = DateTime.now().difference(date).inHours < 24;
    var dateFormat = isRecent
        ? DateFormat('h:mm a').format(date)
        : DateFormat('h:mm a - d/M').format(date);

    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: Row(
        children: isMe
            ? displayMyMessage(context, dateFormat)
            : displaySenderMessage(context, dateFormat),
      ),
    );
  }

  List<Widget> displaySenderMessage(context, dateFormat) {
    var theme = Theme.of(context);
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Utils.getCachedAvatar(
            'https://api.adorable.io/avatars/60/${document.data()['sender']}.png'),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                dateFormat.toString(),
                style: theme.textTheme.headline.copyWith(
                    fontSize: 10, color: theme.accentColor.withOpacity(0.5)),
              ),
              SizedBox(
                height: 5.0,
              ),
              document.data()['image'] != null &&
                      document.data()['image'].toString().isNotEmpty
                  ? GestureDetector(
                      child: Hero(
                        tag: document.data()['image'],
                        child: Image(
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            document.data()['image'],
                          ),
                        ),
                      ),
                      onTap: () {
                        // TODO set hero animation here
                        Navigator.push(
                          context,
                          // EnterExitRoute(
                          //   enterPage: DetailedImage(
                          //     imageUrl: document.data()['image'],
                          //   ),
                          //   exitPage: GroupChatView(),
                          // ),
                          MaterialPageRoute(builder: (_) {
                            return DetailedImage(
                              imageUrl: document.data()['image'],
                            );
                          }),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Text(
                          "${document.data()['text']}",
                          style: TextStyle(
                            color: AppTheme.textWhite,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Container(
          width: 0,
          height: 0,
        ),
      )
    ];
  }

  List<Widget> displayMyMessage(context, dateFormat) {
    var theme = Theme.of(context);

    return <Widget>[
      Expanded(
        flex: 3,
        child: Container(
          width: 0,
          height: 0,
        ),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              //in user chat screen, do not display user email, only display admin email
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  dateFormat.toString(),
                  style: theme.textTheme.headline.copyWith(
                      fontSize: 10, color: theme.accentColor.withOpacity(0.5)),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              document.data()['image'] != null &&
                      document.data()['image'].toString().isNotEmpty
                  ? GestureDetector(
                      child: Hero(
                        tag: document.data()['image'],
                        child: Image(
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            document.data()['image'],
                          ),
                        ),
                      ),
                      onTap: () {
                        // TODO set hero animation here
                        Navigator.push(
                          context,
                          // EnterExitRoute(
                          //   enterPage: DetailedImage(
                          //     imageUrl: document.data()['image'],
                          //   ),
                          //   exitPage: GroupChatView(),
                          // ),
                          MaterialPageRoute(builder: (_) {
                            return DetailedImage(
                              imageUrl: document.data()['image'],
                            );
                          }),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(3.0),
                          )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Text(
                          "${document.data()['text']}",
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    )
//                  : Tools.image(
//                      url: document.data()['image'],
//                      width: 200,
//                      height: 200,
//                      fit: BoxFit.cover)
            ],
          ),
        ),
      ),
    ];
  }
}

class DetailedImage extends StatelessWidget {
  final String imageUrl;

  DetailedImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.accentColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: AppTheme.accentColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.backgroundWhite,
            size: 22,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Hero(
        tag: imageUrl,
        child: Image(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fitWidth,
          image: NetworkImage(
            imageUrl,
          ),
        ),
      ),
    );
  }
}
