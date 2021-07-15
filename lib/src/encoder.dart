part of bencode;

/// This class converts Dart objects to bytes.
class BEncoder extends Converter<Object?, List<int>> {
  /// Creates a [BCodec] instance.
  const BEncoder();

  /// Converts [Object?] to a JSON [List<int>].
  ///
  /// Directly serializable values are [int], [String]. [List], and [Map] can
  /// also be serialized. For [List], the elements must all be serializable.
  /// For [Map], the keys must be [String] and the values must be serializable.
  ///
  /// Example:
  /// ```dart
  /// final encoder = BEncoder();
  /// final result = encoder.encode(["foo", {"bar": 499}])
  ///
  /// /// To Visualize generated output.e
  /// print(String.fromCharCodes(result)); /// will yiled `l3:food3:bari499eee`
  /// ```
  @override
  List<int> convert(Object? input) {
    final result = <int>[];

    if (input != null) {
      if (input is int) {
        result.add(_num_start);
        result.addAll(input.toString().codeUnits);
        result.add(_end);
      } else if (input is String) {
        result.addAll(input.length.toString().codeUnits);
        result.add(_str_len_end);
        result.addAll(input.codeUnits);
      } else if (input is List) {
        result.add(_list_start);
        for (final item in input) {
          result.addAll(convert(item));
        }
        result.add(_end);
      } else if (input is Map) {
        result.add(_dict_start);
        for (final item in input.entries) {
          result.addAll(convert(item.key));
          result.addAll(convert(item.value));
        }
        result.add(_end);
      }
    }

    return result;
  }
}
