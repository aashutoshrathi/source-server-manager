import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/ui/pages/home/server_item.dart';

class ServersList extends StatelessWidget {
  const ServersList(this.servers, this._removeServer);

  final List<Server> servers;
  final Function _removeServer;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: servers.length,
            itemBuilder: (BuildContext context, int index) {
              return ServerItem(servers[index], _removeServer);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
        ),
      ],
    );
  }
}
