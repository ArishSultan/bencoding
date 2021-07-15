part of bencode;

class BCodec extends Codec<Object?, List<int>> {
  const BCodec();

  @override
  Converter<List<int>, Object?> get decoder => const BDecoder();

  @override
  Converter<Object?, List<int>> get encoder => const BEncoder();
}

const bcodec = BCodec();

List<int> bEncode(Object? input) => bcodec.encode(input);
Object? bDecode(List<int> input) => bcodec.decode(input);
