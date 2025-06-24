import 'dart:io';
import 'dart:typed_data';

import 'data_chunk.dart';
import 'fmt_chunk.dart';
import 'sample_converter.dart';
import 'wav_header.dart';

class WavFileWriter {
  final String path;
  final int sampleRate;

  WavFileWriter({required this.path, required this.sampleRate});

  String? writeWavFile(Float32List samples, {bool stereo = false, int bitDepth = 16}) {
    final sampleConverter = SampleConverter();
    final samplesAsInts = sampleConverter.convertSamples(samples, bitDepth);

    final dataSize = samplesAsInts.length * 2;
    final wavHeader = WavHeader(sampleRate: sampleRate, dataSize: dataSize);
    final fmtChunk = FmtChunk(sampleRate: sampleRate, stereo: stereo, bitDepth: bitDepth);
    final dataChunk = DataChunk(samples: samplesAsInts);

    final bytes = BytesBuilder();
    bytes.add(wavHeader.generateHeader());
    bytes.add(fmtChunk.generate());
    bytes.add(dataChunk.generateDataChunk());

    try {
      final file = File(path);
      file.writeAsBytesSync(bytes.takeBytes());
      return null;
    } catch (e) {
      return 'Error writing WAV file: $e';
    }
  }
}
