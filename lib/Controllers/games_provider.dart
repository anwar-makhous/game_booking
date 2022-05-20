import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:game_booking/Models/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamesProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Game> _gamesList = [];

  List<Game> get gamesList => _gamesList;

  bool isSortedByTitle = true;

  void sortBy(String sortingType) {
    if (sortingType == "Title") {
      isSortedByTitle = true;
    } else {
      isSortedByTitle = false;
    }
    _sortBySelected();
  }

  void _sortBySelected() {
    if (isSortedByTitle) {
      _sortByTitle();
    } else {
      _sortByDate();
    }
    notifyListeners();
  }

  void _sortByTitle() {
    _gamesList
        .sort((a, b) => a.title.toUpperCase().compareTo(b.title.toUpperCase()));
    isSortedByTitle = true;
    notifyListeners();
  }

  void _sortByDate() {
    _gamesList.sort((a, b) => a.date.compareTo(b.date));
    isSortedByTitle = false;
    notifyListeners();
  }

  void addNewGame(
    String title,
    String description,
    String location,
    int maxPlayersNo,
    DateTime date,
    String imgURL,
  ) async {
    int newId = 1;
    if (_gamesList.isNotEmpty) {
      int maxId = findMaxId();
      newId = maxId + 1;
    }
    Game game = Game(
      id: newId,
      title: title,
      description: description,
      location: location,
      maxPlayersNo: maxPlayersNo,
      date: date,
      imgURL: imgURL,
    );
    _gamesList.add(game);
    _sortBySelected();
    await saveList();
    notifyListeners();
  }

  void updateGame(
    int id,
    String title,
    String description,
    String location,
    int maxPlayersNo,
    DateTime date,
    String imgURL,
  ) async {
    int index = _gamesList.indexWhere((element) => element.id == id);
    Game game = Game(
      id: _gamesList[index].id,
      title: title,
      description: description,
      location: location,
      maxPlayersNo: maxPlayersNo,
      date: date,
      imgURL: imgURL,
    );
    _gamesList[index] = game;
    _sortBySelected();
    await saveList();
    notifyListeners();
  }

  void deleteGame(int id) async {
    int index = _gamesList.indexWhere((element) => element.id == id);
    if (_gamesList[index].imgURL! != "") {
      await File(_gamesList[index].imgURL!).delete();
    }
    _gamesList.removeAt(index);
    _sortBySelected();
    await saveList();
    notifyListeners();
  }

  int findMaxId() {
    int max = 0;
    for (var element in _gamesList) {
      if (element.id > max) {
        max = element.id;
      }
    }
    return max;
  }

  saveList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = _gamesList.map((e) => json.encode(e.toJson())).toList();
    prefs.setStringList('Games', temp);
  }

  restoreList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList("Games") ?? List.empty();
    if (temp.isNotEmpty) {
      _gamesList = temp.map((e) => Game.fromJson(json.decode(e))).toList();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }
}
