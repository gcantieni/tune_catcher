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
  String? _tuneName;
  String? _from;
  String? _key;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TuneNameAutoComplete(
            controller: _nameController,
            onTuneSelected: (tune) {
              setState(() {
                _nameController.text = tune.name.value;

                // Our parsing doesn't allow null values
                _keyController.text = tune.key.value!;

                _tuneType = tune.type.value;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "From whom/where?"),
            onSaved: (value) {
              if (value != null) _from = value;
            },
            validator: (String? value) => null,
          ),
          TextFormField(
            controller: _keyController,
            decoration: const InputDecoration(labelText: "Key"),
            onSaved: (value) {
              if (value != null) _key = value;
            },
            validator: (String? value) => null,
          ),
          DropdownButtonFormField(
            value: _tuneType, // Possibly set by the autocomplete feature
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
          DropdownButtonFormField(
            value: _status,
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
