// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

part of firebase_database;

enum _EventType {
  childAdded,
  childRemoved,
  childChanged,
  childMoved,
  value,
}

/// `Event` encapsulates a DataSnapshot and possibly also the key of its
/// previous sibling, which can be used to order the snapshots.
class Event {
  Event._(Map<Object, Object> _data)
      : previousSiblingKey = _data['previousSiblingKey'],
        snapshot = DataSnapshot._(_data['snapshot'], _data['childKeys']);

  final DataSnapshot snapshot;

  final String previousSiblingKey;
}

/// A DataSnapshot contains data from a Firebase Database location.
/// Any time you read Firebase data, you receive the data as a DataSnapshot.
class DataSnapshot {
  DataSnapshot._(Map<Object, Object> _data, List<Object> childKeys)
      : key = _data['key'],
        value = {
          for (final key in childKeys) key: (_data['value'] as Map)[key]
        };

  /// The key of the location that generated this DataSnapshot.
  final String key;

  /// Returns the contents of this data snapshot as native types.
  final dynamic value;
}

class MutableData {
  @visibleForTesting
  MutableData.private(this._data);

  final Map<dynamic, dynamic> _data;

  /// The key of the location that generated this MutableData.
  String get key => _data['key'];

  /// Returns the mutable contents of this MutableData as native types.
  dynamic get value => _data['value'];
  set value(dynamic newValue) => _data['value'] = newValue;
}

/// A DatabaseError contains code, message and details of a Firebase Database
/// Error that results from a transaction operation at a Firebase Database
/// location.
class DatabaseError {
  DatabaseError._(this._data);

  Map<dynamic, dynamic> _data;

  /// One of the defined status codes, depending on the error.
  int get code => _data['code'];

  /// A human-readable description of the error.
  String get message => _data['message'];

  /// Human-readable details on the error and additional information.
  String get details => _data['details'];

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType($code, $message, $details)';
}
