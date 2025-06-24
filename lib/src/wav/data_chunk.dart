class DataChunk {
  final List<int> samples;

  DataChunk({required this.samples});

  List<int> generateDataChunk() {
    final bytes = <int>[];
    bytes.addAll('data'.codeUnits);
    bytes.addAll(_intToBytes(samples.length * 2, 4));  // Data size

    for (final sample in samples) {
      bytes.addAll(_intToBytes(sample, 2));  // Write each sample as 2 bytes
    }

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
