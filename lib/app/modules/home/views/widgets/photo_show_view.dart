import 'package:cloudreve/app/api/file_item.dart';
import 'package:cloudreve/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoShowView extends StatelessWidget {
  final HomeController controller = Get.find();
  final FileData file;
  PhotoShowView(this.file);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.getImage(file),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return Container(child: snapshot.data!,alignment: Alignment.center,);
          } else {
            return Container(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 44.0,
                width: 44.0,
              ),
              alignment: Alignment.center,
            );
          }
        },
      ),
    );
  }
}
