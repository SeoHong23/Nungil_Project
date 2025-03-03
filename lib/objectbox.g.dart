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

import 'models/detail/DeletedItem.dart';
import 'models/detail/VideoReaction.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 3739474223868304647),
      name: 'VideoReaction',
      lastPropertyId: const obx_int.IdUid(12, 3380423253305838325),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8734899035898293281),
            name: 'objectId',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3120971365932344357),
            name: 'mongoId',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 4962719489880639364),
            name: 'videoId',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7614352333826094254),
            name: 'title',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 9093533046324336408),
            name: 'posterUrl',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 4366328154794827948),
            name: 'isLiked',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 6761506248849380447),
            name: 'isDisliked',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 5298704032809115418),
            name: 'isWatching',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 7770965617476064908),
            name: 'isWatched',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 2161187560337658973),
            name: 'isBookmarked',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 4837415536539722834),
            name: 'isIgnored',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 3380423253305838325),
            name: 'isModified',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 3131336590472639130),
      name: 'DeletedItem',
      lastPropertyId: const obx_int.IdUid(2, 5062440662736837607),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 9085922871712819336),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5062440662736837607),
            name: 'itemId',
            type: 9,
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
      lastEntityId: const obx_int.IdUid(3, 3131336590472639130),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [2581933279753088637],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        1966263670889069915,
        6987552514450779871,
        6423756207060662407,
        6799811005735605070,
        8526056136326485837,
        8952205669879977292,
        4756327460227734154,
        8855204925951776721,
        1175661293551751892,
        5375974280956006017
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    VideoReaction: obx_int.EntityDefinition<VideoReaction>(
        model: _entities[0],
        toOneRelations: (VideoReaction object) => [],
        toManyRelations: (VideoReaction object) => {},
        getId: (VideoReaction object) => object.objectId,
        setId: (VideoReaction object, int id) {
          object.objectId = id;
        },
        objectToFB: (VideoReaction object, fb.Builder fbb) {
          final mongoIdOffset = fbb.writeString(object.mongoId);
          final videoIdOffset = fbb.writeString(object.videoId);
          final titleOffset = fbb.writeString(object.title);
          final posterUrlOffset = fbb.writeString(object.posterUrl);
          fbb.startTable(13);
          fbb.addInt64(0, object.objectId);
          fbb.addOffset(1, mongoIdOffset);
          fbb.addOffset(2, videoIdOffset);
          fbb.addOffset(3, titleOffset);
          fbb.addOffset(4, posterUrlOffset);
          fbb.addBool(5, object.isLiked);
          fbb.addBool(6, object.isDisliked);
          fbb.addBool(7, object.isWatching);
          fbb.addBool(8, object.isWatched);
          fbb.addBool(9, object.isBookmarked);
          fbb.addBool(10, object.isIgnored);
          fbb.addBool(11, object.isModified);
          fbb.finish(fbb.endTable());
          return object.objectId;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final objectIdParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final mongoIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final videoIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final titleParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final posterUrlParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final isLikedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false);
          final isDislikedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 16, false);
          final isWatchingParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 18, false);
          final isWatchedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 20, false);
          final isBookmarkedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 22, false);
          final isIgnoredParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 24, false);
          final isModifiedParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 26, false);
          final object = VideoReaction(
              objectId: objectIdParam,
              mongoId: mongoIdParam,
              videoId: videoIdParam,
              title: titleParam,
              posterUrl: posterUrlParam,
              isLiked: isLikedParam,
              isDisliked: isDislikedParam,
              isWatching: isWatchingParam,
              isWatched: isWatchedParam,
              isBookmarked: isBookmarkedParam,
              isIgnored: isIgnoredParam,
              isModified: isModifiedParam);

          return object;
        }),
    DeletedItem: obx_int.EntityDefinition<DeletedItem>(
        model: _entities[1],
        toOneRelations: (DeletedItem object) => [],
        toManyRelations: (DeletedItem object) => {},
        getId: (DeletedItem object) => object.id,
        setId: (DeletedItem object, int id) {
          object.id = id;
        },
        objectToFB: (DeletedItem object, fb.Builder fbb) {
          final itemIdOffset = fbb.writeString(object.itemId);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, itemIdOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final itemIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final object = DeletedItem(itemId: itemIdParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [VideoReaction] entity fields to define ObjectBox queries.
class VideoReaction_ {
  /// see [VideoReaction.objectId]
  static final objectId =
      obx.QueryIntegerProperty<VideoReaction>(_entities[0].properties[0]);

  /// see [VideoReaction.mongoId]
  static final mongoId =
      obx.QueryStringProperty<VideoReaction>(_entities[0].properties[1]);

  /// see [VideoReaction.videoId]
  static final videoId =
      obx.QueryStringProperty<VideoReaction>(_entities[0].properties[2]);

  /// see [VideoReaction.title]
  static final title =
      obx.QueryStringProperty<VideoReaction>(_entities[0].properties[3]);

  /// see [VideoReaction.posterUrl]
  static final posterUrl =
      obx.QueryStringProperty<VideoReaction>(_entities[0].properties[4]);

  /// see [VideoReaction.isLiked]
  static final isLiked =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[5]);

  /// see [VideoReaction.isDisliked]
  static final isDisliked =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[6]);

  /// see [VideoReaction.isWatching]
  static final isWatching =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[7]);

  /// see [VideoReaction.isWatched]
  static final isWatched =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[8]);

  /// see [VideoReaction.isBookmarked]
  static final isBookmarked =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[9]);

  /// see [VideoReaction.isIgnored]
  static final isIgnored =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[10]);

  /// see [VideoReaction.isModified]
  static final isModified =
      obx.QueryBooleanProperty<VideoReaction>(_entities[0].properties[11]);
}

/// [DeletedItem] entity fields to define ObjectBox queries.
class DeletedItem_ {
  /// see [DeletedItem.id]
  static final id =
      obx.QueryIntegerProperty<DeletedItem>(_entities[1].properties[0]);

  /// see [DeletedItem.itemId]
  static final itemId =
      obx.QueryStringProperty<DeletedItem>(_entities[1].properties[1]);
}
