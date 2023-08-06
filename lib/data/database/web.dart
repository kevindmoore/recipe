import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlite3/wasm.dart';
import 'package:drift/web/worker.dart';

const _useWorker = true;

DatabaseConnection connect({bool isInWebWorker = false}) {
  // if (_useWorker && !isInWebWorker) {
  //   return DatabaseConnection.delayed(connectToDriftWorker(
  //       'drift_worker.dart.js',
  //       mode: DriftWorkerMode.shared));
  // } else {
    return DatabaseConnection.delayed(
      Future.sync(() async {
        final db = await WasmDatabase.open(
          databaseName: 'recipes',
          sqlite3Uri: Uri.parse('/sqlite3.wasm'),
          // driftWorkerUri: Uri.parse('/shared_worker.dart.js'),
          driftWorkerUri: Uri.parse('/drift_worker.js'),
        );

        if (db.missingFeatures.isNotEmpty) {
          debugPrint('Using ${db.chosenImplementation} due to unsupported '
              'browser features: ${db.missingFeatures}');
        }

        return db.resolvedExecutor;
      }),
    );
  // }
}
/*
DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      final result = await WasmDatabase.open(
        databaseName: 'recipes.db', // prefer to only use valid identifiers here
        sqlite3Uri: Uri.parse('/sqlite3.wasm'),
        driftWorkerUri: Uri.parse('/drift_worker.dart.js'),
      );
      // final sqlite3 = await WasmSqlite3.loadFromUrl(
      //   Uri.parse('sqlite3.wasm'),
      // );

      // final databaseImpl = WasmDatabase(sqlite3: sqlite3, path: 'recipes.db'
      // );
      // return DatabaseConnection(databaseImpl);
      return DatabaseConnection(result.resolvedExecutor);
    }),
  );
}
*/