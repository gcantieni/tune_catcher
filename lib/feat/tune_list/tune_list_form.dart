import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

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
  TuneStatus? _status;
  String? _tuneName;
  String? _from;
  String? _key;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: "Tune name?"),
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
          TextFormField(
            decoration: const InputDecoration(hintText: "From whom/where?"),
            onSaved: (newValue) {
              if (newValue != null) _from = newValue;
            },
            validator: (String? value) => null,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Key"),
            onSaved: (newValue) {
              if (newValue != null) _key = newValue;
            },
            validator: (String? value) => null,
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
          DropdownButtonFormField(
            items: [
              for (final TuneStatus v in TuneStatus.values)
                DropdownMenuItem<TuneStatus>(value: v, child: Text(v.name)),
            ],
            onChanged: (changedTuneType) {
              _status = changedTuneType;
            },
            onSaved: (newValue) {
              if (_status != null) {
                _status = newValue;
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
                        createdAt: DateTime.now(),
                        status: drift.Value(_status),
                        key: _key == null
                            ? const drift.Value.absent()
                            : drift.Value(_key),
                        type: drift.Value(_tuneType),
                        from: drift.Value(_from),
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
