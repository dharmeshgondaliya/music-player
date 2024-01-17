import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';
import 'package:musicplayer/app/utils/common.dart';
import 'package:wave_blob/wave_blob.dart';

import '../controllers/player_screen_controller.dart';

class PlayerScreenView extends GetView<PlayerScreenController> {
  const PlayerScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.toggleFafvourite();
            },
            icon: Obx(
              () => controller.isFavourite.value
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border_outlined),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: controller.pageController,
        itemCount: controller.audios.length,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (value) {
          controller.changeMusic(value);
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              const Spacer(),
              SizedBox(
                width: Get.width * 0.7,
                height: Get.width * 0.7,
                child: const WaveBlob(
                  centerCircle: false,
                  overCircle: false,
                  speed: 6,
                  child: Icon(
                    Icons.music_note_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MarqueeText(
                  text: TextSpan(
                    text: controller.audios[index].name ?? "",
                  ),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                  speed: 15,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2.5,
                        overlayShape: SliderComponentShape.noOverlay,
                        trackShape: const RectangularSliderTrackShape(),
                      ),
                      child: StreamBuilder<Duration>(
                          stream: AudioProvider.instance.positionStream,
                          builder: (context, snapshot) {
                            double? max = 0;
                            double val = 0;
                            if (snapshot.data != null &&
                                AudioProvider.instance.playingDuration !=
                                    null) {
                              max = (AudioProvider.instance.playingDuration
                                          ?.inSeconds ??
                                      0)
                                  .toDouble();
                              val = (snapshot.data?.inSeconds ?? 0).toDouble();
                            }
                            return Slider(
                              value: val,
                              min: 0,
                              max: max,
                              onChanged: (value) {
                                controller.seekAudio(value);
                              },
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<Duration>(
                            stream: AudioProvider.instance.positionStream,
                            builder: (context, snapshot) {
                              return Text(
                                formatDuration(
                                  snapshot.data ?? Duration.zero,
                                ),
                              );
                            },
                          ),
                          StreamBuilder<Duration?>(
                            stream: AudioProvider.instance.durationStream,
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return const Text("00:00");
                              }
                              return Text(formatDuration(snapshot.data!));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (index != 0) {
                        controller.changeNextPrevious(index - 1);
                      }
                    },
                    iconSize: 40,
                    color: Colors.white,
                    icon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.skip_previous_outlined),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      controller.togglePlaying();
                    },
                    iconSize: 45,
                    icon: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: StreamBuilder<AudioPlayerState>(
                        stream: AudioProvider.instance.playerStateStream,
                        builder: (context, snapshot) {
                          bool isPlaying = false;
                          PlayerState? state = snapshot.data?.playerState;
                          isPlaying = state?.playing ?? false;
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.easeInOut,
                            child: isPlaying
                                ? const Icon(
                                    Icons.pause,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      if (controller.audios.length - 1 != index) {
                        controller.changeNextPrevious(index + 1);
                      }
                    },
                    iconSize: 40,
                    color: Colors.white,
                    icon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.skip_next_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
