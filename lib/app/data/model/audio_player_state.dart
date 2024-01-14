import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';

class AudioPlayerState {
  const AudioPlayerState({required this.audio, required this.playerState});
  final PlayerState playerState;
  final AudioModel audio;
}
