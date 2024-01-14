import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';
import 'package:musicplayer/app/modules/music_list/controllers/music_list_controller.dart';
import 'package:musicplayer/app/routes/app_pages.dart';

class MusicTabListview extends StatelessWidget {
  MusicTabListview({
    super.key,
    required this.audios,
  });
  final List<AudioModel> audios;
  final MusicListController controller = Get.find<MusicListController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioPlayerState>(
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
                  arguments: {'audios': audios, 'index': index},
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
                        audios[index].name ?? "aud",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              (AudioProvider.instance.currentAudioPlaying?.id ==
                                      audios[index].id)
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
          itemCount: audios.length,
        );
      },
    );
  }
}
