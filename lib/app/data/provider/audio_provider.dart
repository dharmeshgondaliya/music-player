import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';

class AudioProvider extends BaseAudioHandler with SeekHandler {
  static final AudioProvider _audioProvider = AudioProvider._internal();
  static AudioProvider get instance => _audioProvider;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioModel> _musicPlayList = [];
  int _autoPlayingIndex = -1;
  bool _handleAutoPlay = false;
  bool _isProcessiong = false;
  final StreamController<AudioPlayerState> _playerStateController =
      StreamController.broadcast();
  AudioModel? _currentAudio;

  AudioProvider._internal() {
    AudioService.init(
      builder: () => this,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.musicplayer',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }

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

  Future<void> playAudio() async {
    await _audioPlayer.play();
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future seekAudio(Duration duration) async {
    await _audioPlayer.seek(duration);
  }

  @override
  Future<void> play() {
    return _audioPlayer.play();
  }

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) {
    return _audioPlayer.seek(position);
  }

  @override
  Future<void> stop() {
    return _audioPlayer.stop();
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
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
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

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
