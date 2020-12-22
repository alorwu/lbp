// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NotificationDao _notificationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notifications` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `notification_id` TEXT NOT NULL, `title` TEXT NOT NULL, `message` TEXT NOT NULL, `completed` INTEGER NOT NULL, `timestamp` TEXT NOT NULL)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_notifications_id_notification_id` ON `notifications` (`id`, `notification_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _notificationsInsertionAdapter = InsertionAdapter(
            database,
            'notifications',
            (Notifications item) => <String, dynamic>{
                  'id': item.id,
                  'notification_id': item.notificationId,
                  'title': item.title,
                  'message': item.description,
                  'completed': item.completed ? 1 : 0,
                  'timestamp': item.timestamp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Notifications> _notificationsInsertionAdapter;

  @override
  Future<List<Notifications>> findAllNotifications() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications ORDER BY id DESC',
        mapper: (Map<String, dynamic> row) => Notifications(
            row['id'] as int,
            row['notification_id'] as String,
            row['title'] as String,
            row['message'] as String,
            (row['completed'] as int) != 0,
            row['timestamp'] as String));
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM notifications WHERE id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<Notifications> findByNotificationId(String notificationId) async {
    return _queryAdapter.query(
        'SELECT * FROM notifications WHERE notification_id = ?',
        arguments: <dynamic>[notificationId],
        mapper: (Map<String, dynamic> row) => Notifications(
            row['id'] as int,
            row['notification_id'] as String,
            row['title'] as String,
            row['message'] as String,
            (row['completed'] as int) != 0,
            row['timestamp'] as String));
  }

  @override
  Future<void> insertNotification(Notifications notification) async {
    await _notificationsInsertionAdapter.insert(
        notification, OnConflictStrategy.abort);
  }
}
