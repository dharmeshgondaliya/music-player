import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';
import 'package:musicplayer/app/modules/music_list/views/music_tab_listview.dart';
import 'package:musicplayer/app/modules/music_list/views/playing_nov_bar.dart';

import '../controllers/music_list_controller.dart';

class MusicListView extends GetView<MusicListController> {
  const MusicListView({Key? key}) : super(key: key);
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
                  .map(
                    (e) => MusicTabListview(
                      audios: controller.audioData.value[e] ?? [],
                    ),
                  )
                  .toList(),
            ),
            bottomNavigationBar: StreamBuilder(
              stream: AudioProvider.instance.playerStateStream,
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: snapshot.data?.audio == null
                      ? const SizedBox()
                      : PlayingNavBar(
                          audioPlayerState: snapshot.data!,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
