// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockDetailsHash() => r'1d3f1c239d9c0f754d78fb7d0b4ff51f417f6f80';

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
  late final String symbol;

  FutureOr<StockModel> build(
    String symbol,
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
    String symbol,
  ) {
    return StockDetailsProvider(
      symbol,
    );
  }

  @override
  StockDetailsProvider getProviderOverride(
    covariant StockDetailsProvider provider,
  ) {
    return call(
      provider.symbol,
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
    String symbol,
  ) : this._internal(
          () => StockDetails()..symbol = symbol,
          from: stockDetailsProvider,
          name: r'stockDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockDetailsHash,
          dependencies: StockDetailsFamily._dependencies,
          allTransitiveDependencies:
              StockDetailsFamily._allTransitiveDependencies,
          symbol: symbol,
        );

  StockDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  FutureOr<StockModel> runNotifierBuild(
    covariant StockDetails notifier,
  ) {
    return notifier.build(
      symbol,
    );
  }

  @override
  Override overrideWith(StockDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: StockDetailsProvider._internal(
        () => create()..symbol = symbol,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
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
    return other is StockDetailsProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StockDetailsRef on AutoDisposeAsyncNotifierProviderRef<StockModel> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _StockDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StockDetails, StockModel>
    with StockDetailsRef {
  _StockDetailsProviderElement(super.provider);

  @override
  String get symbol => (origin as StockDetailsProvider).symbol;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
