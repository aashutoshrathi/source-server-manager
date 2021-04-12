import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/server.dart';
import 'package:turrant/themes/styling.dart';

import 'add_server.dart';
import 'home_appbar_actions.dart';
import 'home_drawer_list.dart';
import 'servers_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Server> servers = <Server>[];

  @override
  void initState() {
    super.initState();
    _getServers();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = AppLocalizations.of(context)
        .getTranslatedValue('app_bar_title');

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          HomeAppbarActions(),
        ],
      ),
      drawer: HomeDrawerList(),
      body: SingleChildScrollView(child: ServersList(servers, _removeServer)),
      floatingActionButton: addSvFab(context),
    );
  }

  Widget addSvFab(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<Widget>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) => Container(
              color: AppStyles.charcoalGrey,
              child: AddServerForm(refreshServers: _getServers,),
            ));
        // Navigator.pushNamed(context, addServerRoute);
      },
    );
  }

  Future<void> _getServers() {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final List<String> currentAddedServers = prefs
          .getStringList('addedServers') ?? <String>[];

      final List<Server> currentServers = currentAddedServers.map((String server) => Server
          .fromJson(jsonDecode(server) as Map<String, dynamic>)
      ).toList();

      setState(() {
        servers = currentServers;
      });
    });
  }

  Future<void> _removeServer(Server serverToRemove) {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final List<String> currentAddedServers = prefs
          .getStringList('addedServers') ?? <String>[];

      final List<String> filteredSv = <String>[];
      final List<Server> filteredServerObjects = <Server>[];

      currentAddedServers.forEach((String svString) {
        final Server svObject = Server
            .fromJson(jsonDecode(svString) as Map<String, dynamic>);

        if (serverToRemove.serverIp != svObject.serverIp
            || serverToRemove.serverRcon != svObject.serverRcon) {
          filteredSv.add(svString);
          filteredServerObjects.add(svObject);
        }
      });

      setState(() {
        servers = filteredServerObjects;
      });

      prefs.setStringList('addedServers', filteredSv);
    });
  }
}
