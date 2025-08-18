import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TuneListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Tune')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [const TuneFormWidget(), TuneListWidget()]),
      ),
    );
  }
}

enum TuneStatus { todo, canPlay, canStart, inSet, mastered }

enum TuneType { noType, reel, jig, polka, slide }

class Tune {
  Tune({required this.name, this.status, this.type});

  final String name;
  final TuneStatus? status;
  final TuneType? type;
}

class TuneFormState {
  final String name;
  final TuneType? type;

  TuneFormState({this.name = '', this.type});

  TuneFormState copyWith({String? name, TuneType? type}) {
    return TuneFormState(name: name ?? this.name, type: type ?? this.type);
  }
}

class TuneFormNotifier extends StateNotifier<TuneFormState> {
  TuneFormNotifier() : super(TuneFormState());

  void setTitle(String title) {
    state = state.copyWith(name: title);
  }

  void setType(TuneType? type) {
    state = state.copyWith(type: type);
  }

  Tune toTune() {
    return Tune(name: state.name, type: state.type);
  }

  bool isValid() {
    return state.name.isNotEmpty;
  }
}

final tuneFormProvider = StateNotifierProvider<TuneFormNotifier, TuneFormState>(
  (ref) => TuneFormNotifier(),
);

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

  @override
  Widget build(BuildContext context) {
    final tuneFormNotifier = ref.read(tuneFormProvider.notifier);
    final tuneListNotifier = ref.read(tuneListProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              // icon: Icon(Icons.abc), // TODO: is there a good icon for 'name'?
              hintText: "What's the name of this tune?",
            ),
            onSaved: (newValue) {
              if (newValue != null) tuneFormNotifier.setTitle(newValue);
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
                tuneFormNotifier.setType(_tuneType);
              }
            },
            validator: (value) => null,
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final Tune tuneToSave = tuneFormNotifier.toTune();
                tuneListNotifier.append(tuneToSave);

                _formKey.currentState!.reset();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${tuneToSave.name}" saved!')),
                );
              }
            },
            child: const Text('Submit tune'),
          ),
        ],
      ),
    );
  }
}

class TuneListNotifier extends StateNotifier<List<Tune>> {
  TuneListNotifier() : super([]);

  void add(Tune tune) {
    state = [...state, tune];
  }

  void append(Tune tune) {
    state = [...state, tune];
  }
}

final tuneListProvider = StateNotifierProvider<TuneListNotifier, List<Tune>>(
  (ref) => TuneListNotifier(),
);

class TuneWidget extends StatelessWidget {
  const TuneWidget({required this.tune});

  final Tune tune;

  @override
  Widget build(BuildContext context) {
    return Text('$tune');
  }
}

class TuneListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fontSize = 19.0;
    final List<Tune> myList = ref.watch(tuneListProvider);

    return Column(
      children: myList.isNotEmpty
          ? [
              for (final Tune myTune in myList)
                ListTile(
                  title: Text(
                    myTune.name,
                    style: const TextStyle(fontSize: fontSize),
                  ),
                ),
            ]
          : [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No tunes saved',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
            ],
    );
  }
}
