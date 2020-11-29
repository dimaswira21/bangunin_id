import 'package:bangunin_id/models/project_details_model.dart';
import 'package:bangunin_id/services/auth.dart';
import 'package:bangunin_id/services/database.dart';
import 'package:bangunin_id/shared/UI_components/custom_button.dart';
import 'package:bangunin_id/shared/UI_components/popup_dialog.dart';
import 'package:bangunin_id/shared/page_templates/sliver_page.dart';
import 'package:flutter/material.dart';

class NewProjectMaterials extends StatefulWidget {
  @override
  _NewProjectMaterialsState createState() => _NewProjectMaterialsState();
}

class _NewProjectMaterialsState extends State<NewProjectMaterials> {
  final _formKey = GlobalKey<FormState>();
  final userID = AuthService().getCurrentUID();

  TextEditingController _dateController = TextEditingController();
  ProjectDetailsModel _projectDetails = ProjectDetailsModel();

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  //========================= main function =========================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Form(
        key: _formKey,
        child: SliverPage(
          // backgroundImage: Image.asset(
          //   'assets/img/UI/new_project_bg.jpg',
          //   fit: BoxFit.cover,
          // ),
          title:
              Text('Material Proyek ${_projectDetails.projectName ?? 'Baru'}'),
          children: [
            SliverList(
              delegate: SliverChildListDelegate([
                //widget-widget lain dipasang di sini
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: customButton('Simpan', _uploadData)),
              ]),
            ), //sliver-sliver lain ditulis di sini
          ],
        ),
      ),
    );
  }

  //========================= main function =========================

  Future<bool> _onBackPressed() async {
    bool tappedYes = false;
    final action = await PopUpDialog.yesNoDialog(context, 'Kembali?',
        'Apakah anda yakin ingin kembali? Semua pengaturan pada halaman ini tidak akan tersimpan.');
    if (action == DialogAction.yes) {
      tappedYes = true;
    }
    return tappedYes;
  }

  void _uploadData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _projectDetails.dateCreated = DateTime.now();
        _projectDetails.isCompleted = false;
      });
      await DatabaseService(uid: AuthService().getCurrentUID())
          .createDataOnSubcollection('accounts', 'projects', {
        'projectName': _projectDetails.projectName,
        'address': _projectDetails.address,
        'addressGMap': _projectDetails.addressGMap,
        'clientName': _projectDetails.clientName,
        'clientEmail': _projectDetails.clientEmail,
        'clientPhone': _projectDetails.clientPhone,
        'dateCreated': _projectDetails.dateCreated,
        'dateDeadline': _projectDetails.dateDeadline,
        'isCompleted': _projectDetails.isCompleted,
      });
      //TODO: upload materials information
      // await DatabaseService(uid: AuthService().getCurrentUID()).updateData(
      //     'accounts', attribute, data ?? snapshot.data.data()[attribute]);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
}
