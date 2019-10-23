import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/model/chat.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class GroupListCard extends StatelessWidget {
  final Chat chat;

  GroupListCard({@required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: chat.groupPic,
            height: 100,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: (context, string) {
              return Utils.loadingView();
            },
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: Row(
              children: <Widget>[
                Text(
                  '${chat.title}',
                  style: TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
