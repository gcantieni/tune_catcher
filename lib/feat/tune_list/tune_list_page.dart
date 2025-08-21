import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/providers/tunes_provider.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

class TuneListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter tune name')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const TuneFormWidget(),
            const SizedBox(height: 10),
            TuneListWidget(),
          ],
        ),
      ),
    );
  }
}

class TuneFormWidget extends ConsumerStatefulWidget {
  const TuneFormWidget({super.key});

  @override
  _TuneFormState createState() {
    return _TuneFormState();
  }
}

class _TuneFormState extends ConsumerState<TuneFormWidget> {
  final _formKey = GlobalKey<FormState>();
  TuneType? _tuneType;
  TuneStatus? _tuneStatus;
  String? _tuneName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              // icon: Icon(Icons.abc), // TODO: is there a good icon for 'name'?
              hintText: "Tune name?",
            ),
            onSaved: (newValue) {
              if (newValue != null) _tuneName = newValue;
            },
            validator: (String? value) {
              if (value == null || value == "") {
                return 'Please provide a tune name';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            items: [
              for (final TuneType v in TuneType.values)
                DropdownMenuItem<TuneType>(value: v, child: Text(v.name)),
            ],
            onChanged: (changedTuneType) {
              _tuneType = changedTuneType;
            },
            onSaved: (newValue) {
              if (_tuneType != null) {
                _tuneType = newValue;
              }
            },
            validator: (value) => null,
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                ref
                    .read(databaseProvider)
                    .tuneDao
                    .insertTune(
                      TunesCompanion.insert(
                        name: _tuneName!,
                        status: drift.Value(_tuneStatus),
                        type: drift.Value(_tuneType),
                        createdAt: DateTime.now(),
                      ),
                    );

                _formKey.currentState!.reset();

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('"$_tuneName" saved!')));
              }
            },
            child: const Text('Submit tune'),
          ),
        ],
      ),
    );
  }
}

class TuneWidget extends StatelessWidget {
  const TuneWidget({required this.tune});

  final Tune tune;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min, // TODO: make cards smaller
        children: [
          ListTile(
            title: Text(tune.name),
            subtitle: Text(tune.type?.name ?? ''),
          ),
        ],
      ),
    );
  }
}

class TuneListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fontSize = 19.0;
    final AsyncValue<List<Tune>> allTunesAsync = ref.watch(allTunesProvider);

    return allTunesAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (allTunes) => Column(
        mainAxisSize: MainAxisSize.min,
        children: allTunes.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No tunes saved',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ),
              ]
            : [for (final Tune t in allTunes) TuneWidget(tune: t)],
      ),
    );
  }
}
