import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Sort { createdAsc, createdDesc }

String sortName(Sort sort) {
  switch (sort) {
    case Sort.createdAsc:
      return 'Created Ascending';
    case Sort.createdDesc:
      return 'Created Descending';
  }
}

final sortProvider = StateProvider<Sort>((ref) {
  return Sort.createdAsc;
});
