import 'package:atomic_notes/database/note.dart';
import 'package:flutter/foundation.dart';

/// What the notes state needs from the place notes are kept.
///
/// [NotesRepository] is the real one (Hive on the device, the Server in the cloud). The state
/// layer only sees this interface, so it can be tested with a small fake and no storage.
/// It tells listeners when anything changed, including changes that do not touch a note
/// (a sync starting or ending), so a listener must compare before it rebuilds anything.
abstract interface class NotesSource implements Listenable {
  /// Live notes (deleted ones excluded), pinned first, ordered and cut by [filter].
  List<Note> visible({NoteFilter filter = NoteFilter.newest});

  /// One note by id, deleted or not; null when the device has no such note.
  Note? byId(String id);

  /// How many live notes there are.
  int get count;

  /// The most live notes the account may hold.
  int get limit;

  /// How many notes wait to be sent to the cloud.
  int get pendingCount;

  /// The reason the last sync failed, in words for the user.
  String? get lastError;

  Future<void> save(Note note);

  /// Moves the notes to the Recycle Bin (soft delete).
  Future<void> deleteNotes(Iterable<String> ids);

  /// Pushes waiting changes, then pulls. True when the sync finished cleanly.
  Future<bool> syncNow({bool instant = false});
}
