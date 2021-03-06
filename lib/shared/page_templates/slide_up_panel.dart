import 'package:bangunin_id/shared/UI_components/app_colors.dart';
import 'package:bangunin_id/shared/UI_components/slide_up_marker.dart';
import 'package:flutter/material.dart';

class SlideUpPanel extends StatefulWidget {
  final List<Widget> children;
  final Widget floatingButton;

  SlideUpPanel({Key key, List<Widget> children, this.floatingButton})
      : this.children = children ?? [];

  @override
  _SlideUpPanelState createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize:
          (MediaQuery.of(context).orientation == Orientation.portrait)
              ? 0.65
              : 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              padding: const EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: AppColors().accent1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.grey[700], blurRadius: 5.0)
                ],
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    SlideUpMarker(),
                    for (var element in widget.children) element,
                  ],
                ),
              ),
            ),
            floatingActionButton: widget.floatingButton,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }
}
