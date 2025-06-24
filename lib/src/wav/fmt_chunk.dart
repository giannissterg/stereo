class FmtChunk  {
  final int sampleRate;
  final bool stereo;
  final int bitDepth;

  FmtChunk({required this.sampleRate, this.stereo = false, this.bitDepth = 16});

  List<int> generate() {
    final bytes = <int>[];
    bytes.addAll('fmt '.codeUnits);
    bytes.addAll(_intToBytes(16, 4));  // SubChunk1Size
    bytes.addAll(_intToBytes(1, 2));   // AudioFormat (PCM)
    bytes.addAll(_intToBytes(stereo ? 2 : 1, 2));   // NumChannels
    bytes.addAll(_intToBytes(sampleRate, 4));  // SampleRate
    bytes.addAll(_intToBytes(sampleRate * (bitDepth / 8).toInt() * (stereo ? 2 : 1), 4));  // ByteRate
    bytes.addAll(_intToBytes(2 * (bitDepth / 8).toInt() * (stereo ? 2 : 1), 2));   // BlockAlign
    bytes.addAll(_intToBytes(bitDepth, 2));  // BitsPerSample
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
