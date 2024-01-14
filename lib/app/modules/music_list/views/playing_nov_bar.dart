import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';

class PlayingNavBar extends StatelessWidget {
  const PlayingNavBar({super.key, required this.audioPlayerState});
  final AudioPlayerState audioPlayerState;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      clipBehavior: Clip.hardEdge,
      color: Colors.black45,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 5,
          top: 5,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.music_note_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: MarqueeText(
                text: TextSpan(
                  text: audioPlayerState.audio.name ?? "",
                ),
                speed: 15,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (AudioProvider.instance.playing) {
                  AudioProvider.instance.pause();
                } else {
                  AudioProvider.instance.play();
                }
              },
              icon: Padding(
                padding: const EdgeInsets.all(5),
                child: audioPlayerState.playerState.playing
                    ? Icon(
                        Icons.pause,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
