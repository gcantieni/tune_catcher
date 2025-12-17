import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/tune_list/tune_list_autocomplete.dart';
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
  String? _from;
  String? _name;

  final TextEditingController _keyController = TextEditingController();

  final _autoCompleteKey = GlobalKey<TuneNameAutoCompleteState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TuneNameAutoComplete(
            key: _autoCompleteKey,
            onTuneSelected: (tune) {
              setState(() {
                _name = tune.name.value;
                _keyController.text = tune.key.value!;
                _tuneType = tune.type.value;
                _status = TuneStatus.todo;
              });
            },
          ),
          Wrap(
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: _keyController,
                  decoration: const InputDecoration(labelText: "Key"),
                  validator: (String? value) => null,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 120,
                child: DropdownButtonFormField(
                  initialValue: _tuneType, // Possibly set by the autocomplete feature
                  decoration: const InputDecoration(labelText: "Type"),
                  items: [
                    for (final TuneType v in TuneType.values)
                      DropdownMenuItem<TuneType>(value: v, child: Text(v.name)),
                  ],
                  onChanged: (value) {
                    _tuneType = value;
                  },
                  onSaved: (value) {
                    if (_tuneType != null) {
                      _tuneType = value;
                    }
                  },
                  validator: (value) => null,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 110,
                child: DropdownButtonFormField(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: "Status"),
                  items: [
                    for (final TuneStatus v in TuneStatus.values)
                      DropdownMenuItem<TuneStatus>(
                        value: v,
                        child: Text(v.name),
                      ),
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
              ),

              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "From whom/where?",
                  ),
                  onSaved: (value) {
                    if (value != null) _from = value;
                  },
                  validator: (String? value) => null,
                ),
              ),
            ],
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
                        name: _name!,
                        createdAt: DateTime.now(),
                        status: drift.Value(_status),
                        key: drift.Value(_keyController.text),
                        type: drift.Value(_tuneType),
                        from: drift.Value(_from),
                      ),
                    );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('"$_name saved!')));

                setState(() {
                  _formKey.currentState!.reset();
                  _autoCompleteKey.currentState?.clearName();
                  _keyController.clear();
                  _tuneType = null;
                  _status = null;
                  _name = null;
                });
              }
            },
            child: const Text('Submit tune'),
          ),
        ],
      ),
    );
  }
}
