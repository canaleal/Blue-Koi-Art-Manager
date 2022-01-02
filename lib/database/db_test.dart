import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test_bed/domain/unimage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'unImage_database.db'),
    // When the database is first created, create a table to store unImages.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE unImages(id INTEGER PRIMARY KEY, username TEXT, url TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts unImages into the database
  Future<void> insertUnImage(UnImage unImage) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the UnImage into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same unImage is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'unImages',
      unImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the unImages from the unImages table.
  Future<List<UnImage>> unImages() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The UnImages.
    final List<Map<String, dynamic>> maps = await db.query('unImages');

    // Convert the List<Map<String, dynamic> into a List<UnImage>.
    return List.generate(maps.length, (i) {
      return UnImage(
        id: maps[i]['id'],
        username: maps[i]['username'],
        url: maps[i]['url'],
      );
    });
  }

  Future<void> updateUnImage(UnImage unImage) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given UnImage.
    await db.update(
      'unImages',
      unImage.toMap(),
      // Ensure that the UnImage has a matching id.
      where: 'id = ?',
      // Pass the UnImage's id as a whereArg to prevent SQL injection.
      whereArgs: [unImage.id],
    );
  }

  Future<void> deleteUnImage(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the UnImage from the database.
    await db.delete(
      'unImages',
      // Use a `where` clause to delete a specific unImage.
      where: 'id = ?',
      // Pass the UnImage's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Create a UnImage and add it to the unImages table
  var fido = UnImage(
    id: 0,
    username: 'Fido',
    url: 'http://ddd.com',
  );

  await insertUnImage(fido);

  // Now, use the method above to retrieve all the unImages.
  print(await unImages()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = UnImage(
    id: fido.id,
    username: fido.username,
    url: fido.url,
  );
  await updateUnImage(fido);

  // Print the updated results.
  print(await unImages()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteUnImage(fido.id);

  // Print the list of unImages (empty).
  print(await unImages());
}
