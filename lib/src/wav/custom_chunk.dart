class CustomChunk {
  final String chunkId;
  final List<int> data;

  CustomChunk({required this.chunkId, required this.data});

  List<int> generate() {
    final bytes = <int>[];
    bytes.addAll(chunkId.codeUnits);
    bytes.addAll(_intToBytes(data.length, 4)); // SubChunkSize
    bytes.addAll(data);
    return bytes;
  }

  List<int> _intToBytes(int value, int numBytes) {
    final bytes = <int>[];
    for (var i = 0; i < numBytes; i++) {
      bytes.add((value >> (i * 8)) & 0xFF);
    }
    return bytes;
  }
}
