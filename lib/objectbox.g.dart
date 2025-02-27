// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/detail/Movie.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 2581933279753088637),
      name: 'Movie',
      lastPropertyId: const obx_int.IdUid(11, 9070030530466674174),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1966263670889069915),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6987552514450779871),
            name: 'videoId',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 6423756207060662407),
            name: 'title',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 6799811005735605070),
            name: 'posterUrl',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 8526056136326485837),
            name: 'isLiked',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 8952205669879977292),
            name: 'isDisliked',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 4756327460227734154),
            name: 'isWatching',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 8855204925951776721),
            name: 'isWatched',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 1175661293551751892),
            name: 'isBookmarked',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 5375974280956006017),
            name: 'isIgnored',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(1, 2581933279753088637),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [9070030530466674174],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Movie: obx_int.EntityDefinition<Movie>(
        model: _entities[0],
        toOneRelations: (Movie object) => [],
        toManyRelations: (Movie object) => {},
        getId: (Movie object) => object.id,
        setId: (Movie object, int id) {
          object.id = id;
        },
        objectToFB: (Movie object, fb.Builder fbb) {
          final videoIdOffset = fbb.writeString(object.videoId);
          final titleOffset = fbb.writeString(object.title);
          final posterUrlOffset = fbb.writeString(object.posterUrl);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, videoIdOffset);
          fbb.addOffset(2, titleOffset);
          fbb.addOffset(3, posterUrlOffset);
          fbb.addBool(4, object.isLiked);
          fbb.addBool(5, object.isDisliked);
          fbb.addBool(6, object.isWatching);
          fbb.addBool(7, object.isWatched);
          fbb.addBool(8, object.isBookmarked);
          fbb.addBool(9, object.isIgnored);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final videoIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final titleParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final posterUrlParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final isLikedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 12, false);
          final isDislikedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false);
          final isWatchingParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 16, false);
          final isWatchedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 18, false);
          final isBookmarkedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 20, false);
          final isIgnoredParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 22, false);
          final object = Movie(
              id: idParam,
              videoId: videoIdParam,
              title: titleParam,
              posterUrl: posterUrlParam,
              isLiked: isLikedParam,
              isDisliked: isDislikedParam,
              isWatching: isWatchingParam,
              isWatched: isWatchedParam,
              isBookmarked: isBookmarkedParam,
              isIgnored: isIgnoredParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Movie] entity fields to define ObjectBox queries.
class Movie_ {
  /// see [Movie.id]
  static final id = obx.QueryIntegerProperty<Movie>(_entities[0].properties[0]);

  /// see [Movie.videoId]
  static final videoId =
      obx.QueryStringProperty<Movie>(_entities[0].properties[1]);

  /// see [Movie.title]
  static final title =
      obx.QueryStringProperty<Movie>(_entities[0].properties[2]);

  /// see [Movie.posterUrl]
  static final posterUrl =
      obx.QueryStringProperty<Movie>(_entities[0].properties[3]);

  /// see [Movie.isLiked]
  static final isLiked =
      obx.QueryBooleanProperty<Movie>(_entities[0].properties[4]);

  /// see [Movie.isDisliked]
  static final isDisliked =
      obx.QueryBooleanProperty<Movie>(_entities[0].properties[5]);

  /// see [Movie.isWatching]
  static final isWatching =
      obx.QueryBooleanProperty<Movie>(_entities[0].properties[6]);

  /// see [Movie.isWatched]
  static final isWatched =
      obx.QueryBooleanProperty<Movie>(_entities[0].properties[7]);

  /// see [Movie.isBookmarked]
  static final isBookmarked =
      obx.QueryBooleanProperty<Movie>(_entities[0].properties[8]);

  /// see [Movie.isIgnored]
  static final isIgnored =
      obx.QueryBooleanProperty<Movie>(_entities[0].properties[9]);
}
