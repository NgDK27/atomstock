// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockDetailsHash() => r'890eccb65468f9be66f8a73f083d4fe9f681a6c5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$StockDetails
    extends BuildlessAutoDisposeAsyncNotifier<StockModel> {
  late final String identifier;
  late final StockItemType type;
  late final StockPriceDateFilter timeRange;

  FutureOr<StockModel> build(
    String identifier,
    StockItemType type,
    StockPriceDateFilter timeRange,
  );
}

/// See also [StockDetails].
@ProviderFor(StockDetails)
const stockDetailsProvider = StockDetailsFamily();

/// See also [StockDetails].
class StockDetailsFamily extends Family<AsyncValue<StockModel>> {
  /// See also [StockDetails].
  const StockDetailsFamily();

  /// See also [StockDetails].
  StockDetailsProvider call(
    String identifier,
    StockItemType type,
    StockPriceDateFilter timeRange,
  ) {
    return StockDetailsProvider(
      identifier,
      type,
      timeRange,
    );
  }

  @override
  StockDetailsProvider getProviderOverride(
    covariant StockDetailsProvider provider,
  ) {
    return call(
      provider.identifier,
      provider.type,
      provider.timeRange,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stockDetailsProvider';
}

/// See also [StockDetails].
class StockDetailsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<StockDetails, StockModel> {
  /// See also [StockDetails].
  StockDetailsProvider(
    String identifier,
    StockItemType type,
    StockPriceDateFilter timeRange,
  ) : this._internal(
          () => StockDetails()
            ..identifier = identifier
            ..type = type
            ..timeRange = timeRange,
          from: stockDetailsProvider,
          name: r'stockDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockDetailsHash,
          dependencies: StockDetailsFamily._dependencies,
          allTransitiveDependencies:
              StockDetailsFamily._allTransitiveDependencies,
          identifier: identifier,
          type: type,
          timeRange: timeRange,
        );

  StockDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.identifier,
    required this.type,
    required this.timeRange,
  }) : super.internal();

  final String identifier;
  final StockItemType type;
  final StockPriceDateFilter timeRange;

  @override
  FutureOr<StockModel> runNotifierBuild(
    covariant StockDetails notifier,
  ) {
    return notifier.build(
      identifier,
      type,
      timeRange,
    );
  }

  @override
  Override overrideWith(StockDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: StockDetailsProvider._internal(
        () => create()
          ..identifier = identifier
          ..type = type
          ..timeRange = timeRange,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        identifier: identifier,
        type: type,
        timeRange: timeRange,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<StockDetails, StockModel>
      createElement() {
    return _StockDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockDetailsProvider &&
        other.identifier == identifier &&
        other.type == type &&
        other.timeRange == timeRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, identifier.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, timeRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StockDetailsRef on AutoDisposeAsyncNotifierProviderRef<StockModel> {
  /// The parameter `identifier` of this provider.
  String get identifier;

  /// The parameter `type` of this provider.
  StockItemType get type;

  /// The parameter `timeRange` of this provider.
  StockPriceDateFilter get timeRange;
}

class _StockDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StockDetails, StockModel>
    with StockDetailsRef {
  _StockDetailsProviderElement(super.provider);

  @override
  String get identifier => (origin as StockDetailsProvider).identifier;
  @override
  StockItemType get type => (origin as StockDetailsProvider).type;
  @override
  StockPriceDateFilter get timeRange =>
      (origin as StockDetailsProvider).timeRange;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
