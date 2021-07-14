part of bencode;

class BEncoder extends Converter<Object?, List<int>> {
  const BEncoder();

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
