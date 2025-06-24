class MetadataChunk {
  final String artist;
  final String title;
  final String album;

  MetadataChunk({required this.artist, required this.title, required this.album});

  List<int> generate() {
    final bytes = <int>[];
    bytes.addAll('INFO'.codeUnits);
    bytes.addAll(_intToBytes(artist.length + title.length + album.length, 4));  // Data size
    bytes.addAll(artist.codeUnits);
    bytes.addAll(title.codeUnits);
    bytes.addAll(album.codeUnits);
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
