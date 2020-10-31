import 'package:bangunin_id/shared/decorations.dart'; // sumber AppColors()
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: transparentAppbarAndNavbar()
          .copyWith(statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: AppColors().accent1,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: screenHeight / 4,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Pengaturan'),
              ),
            ),
            //Sliver-sliver lain ditulis di sini
          ],
        ),
      ),
    );
  }
}
