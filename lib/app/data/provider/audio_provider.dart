import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';

class AudioProvider {
  static final AudioProvider _audioProvider = AudioProvider._internal();
  static AudioProvider get instance => _audioProvider;
  AudioProvider._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioModel> _musicPlayList = [];
  int _autoPlayingIndex = -1;
  bool _handleAutoPlay = false;
  bool _isProcessiong = false;
  final StreamController<AudioPlayerState> _playerStateController =
      StreamController.broadcast();
  AudioModel? _currentAudio;

  void init() {
    addListener();
  }

  Future<Duration?> setFilePath(AudioModel audio) async {
    _currentAudio = audio;
    _playerStateController.sink.add(
      AudioPlayerState(
        audio: _currentAudio!,
        playerState: _audioPlayer.playerState,
      ),
    );
    int index = _musicPlayList.indexWhere((element) => element.id == audio.id);
    if (index != -1 && index != _autoPlayingIndex) {
      _autoPlayingIndex = index;
    }
    return await _audioPlayer.setFilePath(_currentAudio!.path!);
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future seek(Duration duration) async {
    await _audioPlayer.seek(duration);
  }

  void clear() {
    _musicPlayList.clear();
  }

  void addListener() {
    _audioPlayer.playerStateStream.listen((event) async {
      if (_currentAudio != null) {
        _playerStateController.sink.add(
          AudioPlayerState(
            audio: _currentAudio!,
            playerState: event,
          ),
        );
      }
      if (event.processingState == ProcessingState.completed &&
          _handleAutoPlay) {
        if (!_isProcessiong) {
          _isProcessiong = true;
          try {
            if (_musicPlayList.isNotEmpty &&
                _autoPlayingIndex != -1 &&
                _musicPlayList.length > _autoPlayingIndex) {
              int index = 0;
              if (_musicPlayList.length - 1 > _autoPlayingIndex) {
                _autoPlayingIndex += 1;
                index = _autoPlayingIndex;
              }
              _currentAudio = _musicPlayList[index];
              _audioPlayer.setFilePath(_currentAudio!.path!);
              _isProcessiong = false;
            }
          } catch (e) {
            _isProcessiong = false;
            print("Exception: ${e.toString()}");
          }
        }
      }
    });
  }

  set setMusicPlayList(List<AudioModel> audios) => _musicPlayList = audios;

  set setHandleAutoPlay(bool val) => _handleAutoPlay = val;

  set setPlayingIndex(int val) => _autoPlayingIndex = val;

  Stream<AudioPlayerState> get playerStateStream =>
      _playerStateController.stream;

  bool get playing => _audioPlayer.playing;

  AudioModel? get currentAudioPlaying => _currentAudio;

  Duration? get playingDuration => _audioPlayer.duration;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  Stream<Duration> get bufferedPositionStream =>
      _audioPlayer.bufferedPositionStream;
}
