import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';
import 'package:musicplayer/app/modules/music_list/views/playing_nov_bar.dart';
import 'package:musicplayer/app/routes/app_pages.dart';

import '../controllers/directory_list_controller.dart';

class DirectoryListView extends GetView<DirectoryListController> {
  const DirectoryListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Obx(
          () => GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.85),
            itemBuilder: (context, index) {
              String key = controller.audioData.value.keys.toList()[index];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      Routes.MUSIC_LIST,
                      arguments: controller.audioData.value[key],
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.folder,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          key,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: controller.audioData.value.keys.length,
          ),
        ),
      ),
      bottomNavigationBar: StreamBuilder<AudioPlayerState>(
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
    );
  }
}
