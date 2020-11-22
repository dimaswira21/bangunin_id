import 'package:bangunin_id/shared/UI_templates.dart'; // sumber AppColors()
import 'package:bangunin_id/shared/slide_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:bangunin_id/services/database.dart';
import 'package:bangunin_id/services/auth.dart';

class HomeTab extends StatefulWidget {
  //Home({Key key}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final userID = _auth.getCurrentUID();

    return SlideUpPanel(
      tabTitle: 'Beranda',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: projectInProgress()),
            Expanded(child: projectDone()),
          ],
        ),
        projectList(context),
        projectList(context),
        projectList(context),
        // widget-widget lain dimasukkan di sini
      ],
      floatingButton: createProjectButton(userID),
    );
  }
}

ListTile projectInProgress() {
  return ListTile(
    title:
        Center(child: Text('3', style: TextStyle(fontWeight: FontWeight.bold))),
    subtitle: Center(child: Text('Sedang berjalan')),
  );
}

ListTile projectDone() {
  return ListTile(
    title:
        Center(child: Text('2', style: TextStyle(fontWeight: FontWeight.bold))),
    subtitle: Center(child: Text('Selesai')),
  );
}

Padding projectList(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors().accent3,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ListTile(
        dense: true,
        title: Text("Proyek A"),
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
}

StreamBuilder createProjectButton(String userID) {
  return StreamBuilder(
    stream: DatabaseService(uid: userID).entitySnapshot('accounts'),
    builder: (context, snapshot) {
      if (snapshot.hasData &&
          ((snapshot.data.data()['role'] == 'Administrator') ||
              (snapshot.data.data()['role'] == 'Mandor'))) {
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
