import 'package:flutter/material.dart';
import 'package:delivery/widgets/app_spaces.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({Key? key}) : super(key: key);

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MapView(),
          ChangeOrderStatusButton(),
          ClientCommentContainer(),
          AppSizeBox(height: AppSpaces.sm),
          TripDetailsContainer()
        ],
      ),
    );
  }
}
