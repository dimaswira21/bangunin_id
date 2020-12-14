import 'package:bangunin_id/models/project_details_model.dart';
import 'package:bangunin_id/services/auth.dart';
import 'package:bangunin_id/shared/UI_components/custom_button.dart';
import 'package:bangunin_id/shared/UI_components/custom_text_form.dart';
import 'package:bangunin_id/shared/UI_components/project_details_card.dart';
import 'package:bangunin_id/shared/page_templates/sliver_page.dart';
import 'package:flutter/material.dart';
import 'package:bangunin_id/shared/UI_components/custom_heading.dart';

class ProjectBoQ extends StatefulWidget {
  @override
  _ProjectBoQState createState() => _ProjectBoQState();
}

class _ProjectBoQState extends State<ProjectBoQ> {
  final _formKey = GlobalKey<FormState>();
  final userID = AuthService().getCurrentUID();

  //========================= main function =========================
  @override
  Widget build(BuildContext context) {
    ProjectDetailsModel input = ModalRoute.of(context).settings.arguments;

    return Form(
      key: _formKey,
      child: SliverPage(
        // backgroundImage: Image.asset(
        //   'assets/img/UI/new_project_bg.jpg',
        //   fit: BoxFit.cover,
        // ),
        title: Text('BoQ ${input.projectName ?? 'Baru'}'),
        children: [
          SliverList(
            delegate: SliverChildListDelegate([
              //widget-widget lain dipasang di sini
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                //child: ProjectDetailsCard(child: input),
                child: CustomHeading(
                  title: 'Rincian Anggaran Biaya \nPekerjaan Pembangunan Rumah',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                //child: ProjectDetailsCard(child: input),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _tabledetail(),
                    Divider(
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              _judul('01.1 Pekerjaan Persiapan'),
              _formFill('A. Koordinasi Keamanan', 'ls'),
              _formFill('B. Pembersihan Lokasi', 'm2'),
              _formFill('C. Uragan Tanah', 'm3'),
              _formFill('D. Mobilisasi dan demobilisasi', 'ls'),
              _formFill('E. Bedeng Tukang', 'ls'),
              _judul('01.2 Pekerjaan Struktur'),
              _formFill('A. Galian Tanah pondasi', 'm3'),
              _formFill('B. Galian Tanah Sloof', 'm3'),
              _formFill('C. Pasir urug bawah fondasi\n t = 5 cm', 'm3'),
              _formFill('D. Pasir urug bawah sloof\n t = 5 cm', 'm3'),
              _formFill('E. Kolom beton Bertulang K1', 'm3'),
              _nextButton(input),
            ]),
          ), //sliver-sliver lain ditulis di sini
        ],
      ),
    );
  }

  //========================= main function =========================

  Padding _judul(String judul) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          judul,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Padding _nextButton(ProjectDetailsModel input) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: CustomButton(
          prompt: 'Selanjutnya',
          onPressed: () {
            _moveToNewProjectMaterials(input);
          },
        ));
  }

  Padding _formFill(String detail, String unit) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                detail,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: CustomTextForm(
                label: null, mustBeFilled: false, onChanged: (val) {}),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                unit,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _tabledetail() {
    return Container(
      color: Colors.orangeAccent,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'NO  Detail Pekerjaan',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            'Volume',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            'Unit',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  _moveToNewProjectMaterials(ProjectDetailsModel input) {
    if (_formKey.currentState.validate()) {
      setState(() {
        input.dateCreated = DateTime.now();
        input.isCompleted = false;
      });
      Navigator.of(context).pushNamed(
        '/projectmaterials',
        arguments: [input],
      );
    }
  }
}
