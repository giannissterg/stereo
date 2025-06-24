class WavHeader {
  final int fileSize;
  final int sampleRate;
  final int dataSize;

  WavHeader({
    required this.sampleRate,
    required this.dataSize,
  }) : fileSize = 36 + dataSize;

  List<int> generateHeader() {
    final bytes = <int>[];
    bytes.addAll('RIFF'.codeUnits);
    bytes.addAll(_intToBytes(fileSize, 4));
    bytes.addAll('WAVE'.codeUnits);
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
