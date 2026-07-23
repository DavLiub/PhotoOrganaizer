// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PhotoIndexEntriesTable extends PhotoIndexEntries
    with TableInfo<$PhotoIndexEntriesTable, PhotoIndexRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoIndexEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identityKeyMeta = const VerificationMeta(
    'identityKey',
  );
  @override
  late final GeneratedColumn<String> identityKey = GeneratedColumn<String>(
    'identity_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta(
    'sourceUri',
  );
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceProviderMeta = const VerificationMeta(
    'sourceProvider',
  );
  @override
  late final GeneratedColumn<String> sourceProvider = GeneratedColumn<String>(
    'source_provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumIdMeta = const VerificationMeta(
    'albumId',
  );
  @override
  late final GeneratedColumn<String> albumId = GeneratedColumn<String>(
    'album_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discoveredAtMeta = const VerificationMeta(
    'discoveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> discoveredAt = GeneratedColumn<DateTime>(
    'discovered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availabilityStatusMeta =
      const VerificationMeta('availabilityStatus');
  @override
  late final GeneratedColumn<String> availabilityStatus =
      GeneratedColumn<String>(
        'availability_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indexedAtMeta = const VerificationMeta(
    'indexedAt',
  );
  @override
  late final GeneratedColumn<DateTime> indexedAt = GeneratedColumn<DateTime>(
    'indexed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetId,
    identityKey,
    sourceUri,
    sourceProvider,
    sourceName,
    albumId,
    filename,
    mimeType,
    fileSize,
    createdAt,
    modifiedAt,
    discoveredAt,
    lastSeenAt,
    availabilityStatus,
    width,
    height,
    status,
    indexedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_index_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhotoIndexRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('identity_key')) {
      context.handle(
        _identityKeyMeta,
        identityKey.isAcceptableOrUnknown(
          data['identity_key']!,
          _identityKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityKeyMeta);
    }
    if (data.containsKey('source_uri')) {
      context.handle(
        _sourceUriMeta,
        sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUriMeta);
    }
    if (data.containsKey('source_provider')) {
      context.handle(
        _sourceProviderMeta,
        sourceProvider.isAcceptableOrUnknown(
          data['source_provider']!,
          _sourceProviderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceProviderMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    }
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('discovered_at')) {
      context.handle(
        _discoveredAtMeta,
        discoveredAt.isAcceptableOrUnknown(
          data['discovered_at']!,
          _discoveredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discoveredAtMeta);
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenAtMeta);
    }
    if (data.containsKey('availability_status')) {
      context.handle(
        _availabilityStatusMeta,
        availabilityStatus.isAcceptableOrUnknown(
          data['availability_status']!,
          _availabilityStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availabilityStatusMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('indexed_at')) {
      context.handle(
        _indexedAtMeta,
        indexedAt.isAcceptableOrUnknown(data['indexed_at']!, _indexedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_indexedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoIndexRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoIndexRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      identityKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_key'],
      )!,
      sourceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_uri'],
      )!,
      sourceProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_provider'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      ),
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_id'],
      ),
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      discoveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}discovered_at'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
      availabilityStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability_status'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      indexedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}indexed_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PhotoIndexEntriesTable createAlias(String alias) {
    return $PhotoIndexEntriesTable(attachedDatabase, alias);
  }
}

class PhotoIndexRow extends DataClass implements Insertable<PhotoIndexRow> {
  final String id;
  final String assetId;
  final String identityKey;
  final String sourceUri;
  final String sourceProvider;
  final String? sourceName;
  final String? albumId;
  final String filename;
  final String mimeType;
  final int fileSize;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime discoveredAt;
  final DateTime lastSeenAt;
  final String availabilityStatus;
  final int? width;
  final int? height;
  final String status;
  final DateTime indexedAt;
  final DateTime updatedAt;
  const PhotoIndexRow({
    required this.id,
    required this.assetId,
    required this.identityKey,
    required this.sourceUri,
    required this.sourceProvider,
    this.sourceName,
    this.albumId,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
    required this.modifiedAt,
    required this.discoveredAt,
    required this.lastSeenAt,
    required this.availabilityStatus,
    this.width,
    this.height,
    required this.status,
    required this.indexedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['identity_key'] = Variable<String>(identityKey);
    map['source_uri'] = Variable<String>(sourceUri);
    map['source_provider'] = Variable<String>(sourceProvider);
    if (!nullToAbsent || sourceName != null) {
      map['source_name'] = Variable<String>(sourceName);
    }
    if (!nullToAbsent || albumId != null) {
      map['album_id'] = Variable<String>(albumId);
    }
    map['filename'] = Variable<String>(filename);
    map['mime_type'] = Variable<String>(mimeType);
    map['file_size'] = Variable<int>(fileSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    map['discovered_at'] = Variable<DateTime>(discoveredAt);
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    map['availability_status'] = Variable<String>(availabilityStatus);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['status'] = Variable<String>(status);
    map['indexed_at'] = Variable<DateTime>(indexedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PhotoIndexEntriesCompanion toCompanion(bool nullToAbsent) {
    return PhotoIndexEntriesCompanion(
      id: Value(id),
      assetId: Value(assetId),
      identityKey: Value(identityKey),
      sourceUri: Value(sourceUri),
      sourceProvider: Value(sourceProvider),
      sourceName: sourceName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceName),
      albumId: albumId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumId),
      filename: Value(filename),
      mimeType: Value(mimeType),
      fileSize: Value(fileSize),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      discoveredAt: Value(discoveredAt),
      lastSeenAt: Value(lastSeenAt),
      availabilityStatus: Value(availabilityStatus),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      status: Value(status),
      indexedAt: Value(indexedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PhotoIndexRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoIndexRow(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      identityKey: serializer.fromJson<String>(json['identityKey']),
      sourceUri: serializer.fromJson<String>(json['sourceUri']),
      sourceProvider: serializer.fromJson<String>(json['sourceProvider']),
      sourceName: serializer.fromJson<String?>(json['sourceName']),
      albumId: serializer.fromJson<String?>(json['albumId']),
      filename: serializer.fromJson<String>(json['filename']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      discoveredAt: serializer.fromJson<DateTime>(json['discoveredAt']),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
      availabilityStatus: serializer.fromJson<String>(
        json['availabilityStatus'],
      ),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      status: serializer.fromJson<String>(json['status']),
      indexedAt: serializer.fromJson<DateTime>(json['indexedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'identityKey': serializer.toJson<String>(identityKey),
      'sourceUri': serializer.toJson<String>(sourceUri),
      'sourceProvider': serializer.toJson<String>(sourceProvider),
      'sourceName': serializer.toJson<String?>(sourceName),
      'albumId': serializer.toJson<String?>(albumId),
      'filename': serializer.toJson<String>(filename),
      'mimeType': serializer.toJson<String>(mimeType),
      'fileSize': serializer.toJson<int>(fileSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'discoveredAt': serializer.toJson<DateTime>(discoveredAt),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
      'availabilityStatus': serializer.toJson<String>(availabilityStatus),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'status': serializer.toJson<String>(status),
      'indexedAt': serializer.toJson<DateTime>(indexedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PhotoIndexRow copyWith({
    String? id,
    String? assetId,
    String? identityKey,
    String? sourceUri,
    String? sourceProvider,
    Value<String?> sourceName = const Value.absent(),
    Value<String?> albumId = const Value.absent(),
    String? filename,
    String? mimeType,
    int? fileSize,
    DateTime? createdAt,
    DateTime? modifiedAt,
    DateTime? discoveredAt,
    DateTime? lastSeenAt,
    String? availabilityStatus,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    String? status,
    DateTime? indexedAt,
    DateTime? updatedAt,
  }) => PhotoIndexRow(
    id: id ?? this.id,
    assetId: assetId ?? this.assetId,
    identityKey: identityKey ?? this.identityKey,
    sourceUri: sourceUri ?? this.sourceUri,
    sourceProvider: sourceProvider ?? this.sourceProvider,
    sourceName: sourceName.present ? sourceName.value : this.sourceName,
    albumId: albumId.present ? albumId.value : this.albumId,
    filename: filename ?? this.filename,
    mimeType: mimeType ?? this.mimeType,
    fileSize: fileSize ?? this.fileSize,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    discoveredAt: discoveredAt ?? this.discoveredAt,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    availabilityStatus: availabilityStatus ?? this.availabilityStatus,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    status: status ?? this.status,
    indexedAt: indexedAt ?? this.indexedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PhotoIndexRow copyWithCompanion(PhotoIndexEntriesCompanion data) {
    return PhotoIndexRow(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      identityKey: data.identityKey.present
          ? data.identityKey.value
          : this.identityKey,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      sourceProvider: data.sourceProvider.present
          ? data.sourceProvider.value
          : this.sourceProvider,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      filename: data.filename.present ? data.filename.value : this.filename,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      discoveredAt: data.discoveredAt.present
          ? data.discoveredAt.value
          : this.discoveredAt,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      availabilityStatus: data.availabilityStatus.present
          ? data.availabilityStatus.value
          : this.availabilityStatus,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      status: data.status.present ? data.status.value : this.status,
      indexedAt: data.indexedAt.present ? data.indexedAt.value : this.indexedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoIndexRow(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('identityKey: $identityKey, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('sourceProvider: $sourceProvider, ')
          ..write('sourceName: $sourceName, ')
          ..write('albumId: $albumId, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('availabilityStatus: $availabilityStatus, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('status: $status, ')
          ..write('indexedAt: $indexedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    assetId,
    identityKey,
    sourceUri,
    sourceProvider,
    sourceName,
    albumId,
    filename,
    mimeType,
    fileSize,
    createdAt,
    modifiedAt,
    discoveredAt,
    lastSeenAt,
    availabilityStatus,
    width,
    height,
    status,
    indexedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoIndexRow &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.identityKey == this.identityKey &&
          other.sourceUri == this.sourceUri &&
          other.sourceProvider == this.sourceProvider &&
          other.sourceName == this.sourceName &&
          other.albumId == this.albumId &&
          other.filename == this.filename &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.discoveredAt == this.discoveredAt &&
          other.lastSeenAt == this.lastSeenAt &&
          other.availabilityStatus == this.availabilityStatus &&
          other.width == this.width &&
          other.height == this.height &&
          other.status == this.status &&
          other.indexedAt == this.indexedAt &&
          other.updatedAt == this.updatedAt);
}

class PhotoIndexEntriesCompanion extends UpdateCompanion<PhotoIndexRow> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<String> identityKey;
  final Value<String> sourceUri;
  final Value<String> sourceProvider;
  final Value<String?> sourceName;
  final Value<String?> albumId;
  final Value<String> filename;
  final Value<String> mimeType;
  final Value<int> fileSize;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime> discoveredAt;
  final Value<DateTime> lastSeenAt;
  final Value<String> availabilityStatus;
  final Value<int?> width;
  final Value<int?> height;
  final Value<String> status;
  final Value<DateTime> indexedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PhotoIndexEntriesCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.identityKey = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.sourceProvider = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.albumId = const Value.absent(),
    this.filename = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.discoveredAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.availabilityStatus = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.status = const Value.absent(),
    this.indexedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoIndexEntriesCompanion.insert({
    required String id,
    required String assetId,
    required String identityKey,
    required String sourceUri,
    required String sourceProvider,
    this.sourceName = const Value.absent(),
    this.albumId = const Value.absent(),
    required String filename,
    required String mimeType,
    required int fileSize,
    required DateTime createdAt,
    required DateTime modifiedAt,
    required DateTime discoveredAt,
    required DateTime lastSeenAt,
    required String availabilityStatus,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    required String status,
    required DateTime indexedAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetId = Value(assetId),
       identityKey = Value(identityKey),
       sourceUri = Value(sourceUri),
       sourceProvider = Value(sourceProvider),
       filename = Value(filename),
       mimeType = Value(mimeType),
       fileSize = Value(fileSize),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt),
       discoveredAt = Value(discoveredAt),
       lastSeenAt = Value(lastSeenAt),
       availabilityStatus = Value(availabilityStatus),
       status = Value(status),
       indexedAt = Value(indexedAt),
       updatedAt = Value(updatedAt);
  static Insertable<PhotoIndexRow> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<String>? identityKey,
    Expression<String>? sourceUri,
    Expression<String>? sourceProvider,
    Expression<String>? sourceName,
    Expression<String>? albumId,
    Expression<String>? filename,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? discoveredAt,
    Expression<DateTime>? lastSeenAt,
    Expression<String>? availabilityStatus,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? status,
    Expression<DateTime>? indexedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (identityKey != null) 'identity_key': identityKey,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (sourceProvider != null) 'source_provider': sourceProvider,
      if (sourceName != null) 'source_name': sourceName,
      if (albumId != null) 'album_id': albumId,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (discoveredAt != null) 'discovered_at': discoveredAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (availabilityStatus != null) 'availability_status': availabilityStatus,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (status != null) 'status': status,
      if (indexedAt != null) 'indexed_at': indexedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoIndexEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? assetId,
    Value<String>? identityKey,
    Value<String>? sourceUri,
    Value<String>? sourceProvider,
    Value<String?>? sourceName,
    Value<String?>? albumId,
    Value<String>? filename,
    Value<String>? mimeType,
    Value<int>? fileSize,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime>? discoveredAt,
    Value<DateTime>? lastSeenAt,
    Value<String>? availabilityStatus,
    Value<int?>? width,
    Value<int?>? height,
    Value<String>? status,
    Value<DateTime>? indexedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PhotoIndexEntriesCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      identityKey: identityKey ?? this.identityKey,
      sourceUri: sourceUri ?? this.sourceUri,
      sourceProvider: sourceProvider ?? this.sourceProvider,
      sourceName: sourceName ?? this.sourceName,
      albumId: albumId ?? this.albumId,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      width: width ?? this.width,
      height: height ?? this.height,
      status: status ?? this.status,
      indexedAt: indexedAt ?? this.indexedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (identityKey.present) {
      map['identity_key'] = Variable<String>(identityKey.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (sourceProvider.present) {
      map['source_provider'] = Variable<String>(sourceProvider.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<String>(albumId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (discoveredAt.present) {
      map['discovered_at'] = Variable<DateTime>(discoveredAt.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (availabilityStatus.present) {
      map['availability_status'] = Variable<String>(availabilityStatus.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (indexedAt.present) {
      map['indexed_at'] = Variable<DateTime>(indexedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoIndexEntriesCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('identityKey: $identityKey, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('sourceProvider: $sourceProvider, ')
          ..write('sourceName: $sourceName, ')
          ..write('albumId: $albumId, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('availabilityStatus: $availabilityStatus, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('status: $status, ')
          ..write('indexedAt: $indexedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PhotoIndexEntriesTable photoIndexEntries =
      $PhotoIndexEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [photoIndexEntries];
}

typedef $$PhotoIndexEntriesTableCreateCompanionBuilder =
    PhotoIndexEntriesCompanion Function({
      required String id,
      required String assetId,
      required String identityKey,
      required String sourceUri,
      required String sourceProvider,
      Value<String?> sourceName,
      Value<String?> albumId,
      required String filename,
      required String mimeType,
      required int fileSize,
      required DateTime createdAt,
      required DateTime modifiedAt,
      required DateTime discoveredAt,
      required DateTime lastSeenAt,
      required String availabilityStatus,
      Value<int?> width,
      Value<int?> height,
      required String status,
      required DateTime indexedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PhotoIndexEntriesTableUpdateCompanionBuilder =
    PhotoIndexEntriesCompanion Function({
      Value<String> id,
      Value<String> assetId,
      Value<String> identityKey,
      Value<String> sourceUri,
      Value<String> sourceProvider,
      Value<String?> sourceName,
      Value<String?> albumId,
      Value<String> filename,
      Value<String> mimeType,
      Value<int> fileSize,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime> discoveredAt,
      Value<DateTime> lastSeenAt,
      Value<String> availabilityStatus,
      Value<int?> width,
      Value<int?> height,
      Value<String> status,
      Value<DateTime> indexedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PhotoIndexEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PhotoIndexEntriesTable> {
  $$PhotoIndexEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityKey => $composableBuilder(
    column: $table.identityKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceProvider => $composableBuilder(
    column: $table.sourceProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumId => $composableBuilder(
    column: $table.albumId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availabilityStatus => $composableBuilder(
    column: $table.availabilityStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get indexedAt => $composableBuilder(
    column: $table.indexedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PhotoIndexEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotoIndexEntriesTable> {
  $$PhotoIndexEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityKey => $composableBuilder(
    column: $table.identityKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceProvider => $composableBuilder(
    column: $table.sourceProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumId => $composableBuilder(
    column: $table.albumId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availabilityStatus => $composableBuilder(
    column: $table.availabilityStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get indexedAt => $composableBuilder(
    column: $table.indexedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PhotoIndexEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotoIndexEntriesTable> {
  $$PhotoIndexEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get identityKey => $composableBuilder(
    column: $table.identityKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumn<String> get sourceProvider => $composableBuilder(
    column: $table.sourceProvider,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumId =>
      $composableBuilder(column: $table.albumId, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availabilityStatus => $composableBuilder(
    column: $table.availabilityStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get indexedAt =>
      $composableBuilder(column: $table.indexedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PhotoIndexEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotoIndexEntriesTable,
          PhotoIndexRow,
          $$PhotoIndexEntriesTableFilterComposer,
          $$PhotoIndexEntriesTableOrderingComposer,
          $$PhotoIndexEntriesTableAnnotationComposer,
          $$PhotoIndexEntriesTableCreateCompanionBuilder,
          $$PhotoIndexEntriesTableUpdateCompanionBuilder,
          (
            PhotoIndexRow,
            BaseReferences<
              _$AppDatabase,
              $PhotoIndexEntriesTable,
              PhotoIndexRow
            >,
          ),
          PhotoIndexRow,
          PrefetchHooks Function()
        > {
  $$PhotoIndexEntriesTableTableManager(
    _$AppDatabase db,
    $PhotoIndexEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoIndexEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoIndexEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoIndexEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<String> identityKey = const Value.absent(),
                Value<String> sourceUri = const Value.absent(),
                Value<String> sourceProvider = const Value.absent(),
                Value<String?> sourceName = const Value.absent(),
                Value<String?> albumId = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime> discoveredAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<String> availabilityStatus = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> indexedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotoIndexEntriesCompanion(
                id: id,
                assetId: assetId,
                identityKey: identityKey,
                sourceUri: sourceUri,
                sourceProvider: sourceProvider,
                sourceName: sourceName,
                albumId: albumId,
                filename: filename,
                mimeType: mimeType,
                fileSize: fileSize,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                discoveredAt: discoveredAt,
                lastSeenAt: lastSeenAt,
                availabilityStatus: availabilityStatus,
                width: width,
                height: height,
                status: status,
                indexedAt: indexedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetId,
                required String identityKey,
                required String sourceUri,
                required String sourceProvider,
                Value<String?> sourceName = const Value.absent(),
                Value<String?> albumId = const Value.absent(),
                required String filename,
                required String mimeType,
                required int fileSize,
                required DateTime createdAt,
                required DateTime modifiedAt,
                required DateTime discoveredAt,
                required DateTime lastSeenAt,
                required String availabilityStatus,
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                required String status,
                required DateTime indexedAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PhotoIndexEntriesCompanion.insert(
                id: id,
                assetId: assetId,
                identityKey: identityKey,
                sourceUri: sourceUri,
                sourceProvider: sourceProvider,
                sourceName: sourceName,
                albumId: albumId,
                filename: filename,
                mimeType: mimeType,
                fileSize: fileSize,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                discoveredAt: discoveredAt,
                lastSeenAt: lastSeenAt,
                availabilityStatus: availabilityStatus,
                width: width,
                height: height,
                status: status,
                indexedAt: indexedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PhotoIndexEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotoIndexEntriesTable,
      PhotoIndexRow,
      $$PhotoIndexEntriesTableFilterComposer,
      $$PhotoIndexEntriesTableOrderingComposer,
      $$PhotoIndexEntriesTableAnnotationComposer,
      $$PhotoIndexEntriesTableCreateCompanionBuilder,
      $$PhotoIndexEntriesTableUpdateCompanionBuilder,
      (
        PhotoIndexRow,
        BaseReferences<_$AppDatabase, $PhotoIndexEntriesTable, PhotoIndexRow>,
      ),
      PhotoIndexRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PhotoIndexEntriesTableTableManager get photoIndexEntries =>
      $$PhotoIndexEntriesTableTableManager(_db, _db.photoIndexEntries);
}
