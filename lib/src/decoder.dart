part of bencode;

const _end = 101;
const _num_start = 105;
const _list_start = 108;
const _dict_start = 100;

const _str_len_end = 58;
const _int_negative = 45;
const _int_positive = 43;
const _double_period = 46;

class BDecoder extends Converter<List<int>, Object?> {
  const BDecoder();

  @override
  Object? convert(List<int> input) => _parseValue(input, _Indexer());
}

class _Indexer {
  var val = 0;
}

Object? _parseValue(List<int> input, _Indexer index) {
  switch (input[index.val]) {
    case _num_start:
      return _parseNum(input, index..val += 1);
    case _list_start:
      return _parseList(input, index..val += 1);
    case _dict_start:
      return _parseDict(input, index..val += 1);
    default:
      return _parseString(input, index);
  }
}

Object? _parseNum(List<int> input, _Indexer index, [int end = _end]) {
  var number = 0;
  var digit = input[index.val];

  var isNegative = false;
  if (digit == _int_negative) {
    isNegative = true;
    ++index.val;
  } else if (digit == _int_positive) {
    ++index.val;
  }

  while ((digit = input[index.val]) != end) {
    if (digit >= 48 && digit <= 57) {
      number = 10 * number + digit - 48;

      ++index.val;
    } else if (digit == _double_period) {
      throw 'Only integers are supported not doubles or floats';
    } else {
      throw 'Invalid character in number';
    }
  }

  ++index.val;
  return isNegative ? -number : number;
}

Object? _parseList(List<int> input, _Indexer index) {
  final list = [];
  while (input[index.val] != _end) {
    list.add(_parseValue(input, index));
  }

  ++index.val;
  return list;
}

Object? _parseDict(List<int> input, _Indexer index) {
  final dict = {};

  while (input[index.val] != _end) {
    dict[_parseValue(input, index)] = _parseValue(input, index);
  }

  ++index.val;
  return dict;
}

Object? _parseString(List<int> input, _Indexer index) {
  final length =
      (_parseNum(input, index, _str_len_end) as int? ?? 0) + index.val;

  final buffer = StringBuffer();
  for (; index.val < length; ++index.val) {
    buffer.write(String.fromCharCode(input[index.val]));
  }

  return buffer.toString();
}
