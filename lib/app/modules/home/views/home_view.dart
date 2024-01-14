import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:musicplayer/app/modules/home/views/music_list_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return DefaultTabController(
          length: controller.audioData.value.keys.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Musics'),
              centerTitle: true,
              bottom: TabBar(
                isScrollable: true,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                tabs: controller.audioData.value.keys
                    .map((e) => Tab(text: e))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: controller.audioData.value.keys
                  .map((e) => MusicListView(
                      audios: controller.audioData.value[e] ?? []))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
