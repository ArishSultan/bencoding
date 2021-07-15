part of bencode;

/// A [BCodec] encodes Dart objects to bytes i.e. [List<int>] and decodes bytes
/// to Dart objects.
///
/// Supported Dart objects are [int], [String], [Map], [List]
///
/// Examples:
/// ```dart
/// var encoded = bcodec.encode([1, 2, { "a": null }]);
/// var decoded = bcodec.decode('li1ei2ed1:aee'.codeUnits);
/// ```
class BCodec extends Codec<Object?, List<int>> {
  /// Creates a [BCodec] instance.
  const BCodec();

  @override
  Converter<List<int>, Object?> get decoder => const BDecoder();

  @override
  Converter<Object?, List<int>> get encoder => const BEncoder();
}

/// An instance of the default implementation of the [BCodec].
///
/// This instance provides a convenient access to the most common bencoding
/// use cases.
///
/// Examples:
/// ```dart
/// var encoded = bcodec.encode([1, 2, { "a": null }]);
/// var decoded = bcodec.decode('li1ei2ed1:aee'.codeUnits);
/// ```
/// The top-level [bEncoder] and [bDecode] functions may be used instead if a
/// local variable shadows the [bcodec] constant.
const bcodec = BCodec();

/// Converts [Object?] to a byte array.
///
/// Shorthand for `bcodec.encode`. Useful if a local variable shadows the global
/// [bcodec] constant.
List<int> bEncode(Object? input) => bcodec.encode(input);

/// Parses the byte array and returns the resulting [Object].
///
/// Shorthand for `bcodec.decode`. Useful if a local variable shadows the global
/// [bcodec] constant.
Object? bDecode(List<int> input) => bcodec.decode(input);
