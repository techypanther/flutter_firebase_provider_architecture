import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';

// import '../../common/config.dart' as config;
// import '../../common/tools.dart';

class TypingStream extends StatefulWidget {
  final bool isAdminLoggedIn;
  final String userEmail;
  final String chatId;

  TypingStream({this.isAdminLoggedIn, this.userEmail, this.chatId});

  @override
  _TypingStreamState createState() => _TypingStreamState();
}

class _TypingStreamState extends State<TypingStream>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
    // print(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    String avatarUserUrl =
        'https://api.adorable.io/avatars/5/${widget.userEmail}.png';

    return StreamBuilder(
      stream: fireStore.collection('chat').document(widget.chatId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && (snapshot.data == null)) {
          fireStore.collection('chat').document(widget.chatId).setData(
              {'userTyping': false, 'adminTyping': false},
              merge: true);
          return Container();
        }
        var document = snapshot.data;

        if (document == null ||
            document['userTyping'] == null ||
            document['adminTyping'] == null) {
          return Container();
        }

        if (!widget.isAdminLoggedIn && document["userTyping"] ||
            widget.isAdminLoggedIn && document["adminTyping"]) {
          controller.forward();
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
            child: Container(
              padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Utils.getCachedAvatar(avatarUserUrl),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'is typing...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        controller.reset();

        return Container();
      },
    );
  }
}
