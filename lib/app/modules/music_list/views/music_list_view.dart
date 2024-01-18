import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';
import 'package:musicplayer/app/modules/music_list/views/playing_nov_bar.dart';
import 'package:musicplayer/app/routes/app_pages.dart';

import '../controllers/music_list_controller.dart';

class MusicListView extends GetView<MusicListController> {
  const MusicListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musics'),
        centerTitle: true,
      ),
      body: StreamBuilder<AudioPlayerState>(
        stream: AudioProvider.instance.playerStateStream,
        builder: (context, snapshot) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed(
                    Routes.PLAYER_SCREEN,
                    arguments: {
                      'audios': controller.audioFiles,
                      'index': index
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.music_note_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          controller.audioFiles[index].name ?? "aud",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: (AudioProvider
                                        .instance.currentAudioPlaying?.id ==
                                    controller.audioFiles[index].id)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: controller.audioFiles.length,
          );
        },
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
