import 'package:flutter/material.dart';
import 'package:monity/helper/interfaces.dart';

class ListProvider<T extends Category> extends ChangeNotifier {
  List<T> _list = [];
  final Future<List<T>> Function() fetchFunction;
  final Future<T> Function(T) createFunction;
  final Future<int> Function(int) deleteFunction;
  final Future<int> Function(T) updateFunction;

  List<T> get list => _list;
  int get length => _list.length;

  ListProvider({
    required this.fetchFunction,
    required this.createFunction,
    required this.deleteFunction,
    required this.updateFunction,
  }) {
    fetchList();
  }

  Future fetchList() async {
    _list = await fetchFunction();
    notifyListeners();
  }

  Future<int> update(int id, T newValue) async {
    _list.removeWhere((element) => element.id == id);
    insert(newValue, writeToDatabase: false, shouldNotify: false);
    notifyListeners();
    return await updateFunction(newValue);
  }

  Future<T> insert(T value, {bool writeToDatabase = true, bool shouldNotify = true}) async {
    T newValue = value;
    if (writeToDatabase) {
      newValue = await createFunction(value);
    }
    // Insert the category and keep the list sorted.
    int index = _list.lastIndexWhere((v) => v.name.compareTo(value.name) < 0);
    _list.insert(index + 1 < 0 ? 0 : index + 1, newValue);
    if (shouldNotify) {
      notifyListeners();
    }
    return newValue;
  }

  Future<int> delete(T value) async {
    _list.remove(value);
    notifyListeners();
    if (value.id != null) {
      return await deleteFunction(value.id!);
    }
    return -1;
  }

  void reset() {
    _list = [];
    notifyListeners();
  }
}
