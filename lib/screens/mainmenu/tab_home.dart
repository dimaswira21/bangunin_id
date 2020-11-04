import 'package:bangunin_id/models/user.dart';
import 'package:bangunin_id/shared/decorations.dart'; // sumber AppColors()
import 'package:bangunin_id/shared/scrollmenu.dart';
import 'package:flutter/material.dart';
import 'package:bangunin_id/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  //Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<User>(context).uid;

    return ScrollMenu(
      children: [
        SliverToBoxAdapter(
          child: pullDownMarker(),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              Expanded(child: projectInProgress()),
              Expanded(child: projectDone()),
            ],
          ),
        ),
        SliverList(
          delegate: infiniteList(context),
        )
      ],
      floatingButton: createProjectButton(userID),
    );
  }
}

Padding projectInProgress() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: ListTile(
      title: Text('in-progress'),
      subtitle: Text('3'),
    ),
  );
}

Padding projectDone() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: ListTile(
      title: Text('Selesai'),
      subtitle: Text('2'),
    ),
  );
}

SliverChildBuilderDelegate infiniteList(BuildContext context) {
  return SliverChildBuilderDelegate(
    (BuildContext context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors().accent3,
            borderRadius: BorderRadius.circular(100),
          ),
          child: ListTile(
            title: Text("Proyek $index"),
            subtitle: Text("Deadline: -"),
            trailing: Text(
              "In - progress",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.of(context).pushNamed('/projectdetails');
            },
          ),
        ),
      );
    },
  );
}

StreamBuilder createProjectButton(String userID) {
  return StreamBuilder(
    stream: DatabaseService(uid: userID).entitySnapshot('accounts'),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data.data['isSupervisor']) {
        return FloatingActionButton.extended(
          onPressed: () async {
            Navigator.of(context).pushNamed('/newproject');
          },
          label: Text(
            'Buat Proyek Baru',
            style: TextStyle(color: AppColors().accent1),
          ),
          backgroundColor: AppColors().primary,
        );
      } else {
        return Container();
      }
    },
  );
}
