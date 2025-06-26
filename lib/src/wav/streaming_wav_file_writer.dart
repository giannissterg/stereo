import 'dart:io' show IOSink;
import 'dart:typed_data';

import 'data_chunk.dart';
import 'fmt_chunk.dart';
import 'wav_header.dart';
import 'sample_converter.dart';

class StreamWavFileWriter {
  final IOSink sink;
  final int sampleRate;
  final int bitDepth;

  StreamWavFileWriter({required this.sink, required this.sampleRate, required this.bitDepth});

  String? writeWavFile(Float32List samples) {
    final sampleConverter = SampleConverter();
    final samplesAsInts = sampleConverter.convertSamples(samples, bitDepth);

    final dataSize = samplesAsInts.length * 2;
    final wavHeader = WavHeader(sampleRate: sampleRate, dataSize: dataSize);
    final fmtChunk = FmtChunk(sampleRate: sampleRate, bitDepth: bitDepth);
    final dataChunk = DataChunk(samples: samplesAsInts);

    final bytes = BytesBuilder();
    bytes.add(wavHeader.generateHeader());
    bytes.add(fmtChunk.generate());
    bytes.add(dataChunk.generateDataChunk());

    try {
      sink.add(bytes.takeBytes()); // Write to stream
      sink.close();
      return null;
    } catch (e) {
      return 'Error writing WAV file to stream: $e';
    }
  }
}
