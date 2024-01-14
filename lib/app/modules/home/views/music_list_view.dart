import 'package:flutter/material.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';

class MusicListView extends StatelessWidget {
  const MusicListView({super.key, required this.audios});
  final List<AudioModel> audios;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => InkWell(
        onTap: () {},
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
                ),
              ),
            ],
          ),
        ),
      ),
      itemCount: audios.length,
    );
  }
}
