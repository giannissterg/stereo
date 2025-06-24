import 'dart:typed_data';

class SampleConverter {
  List<int> convertSamples(Float32List samples, int bitDepth) {
    return samples.map((sample) {
      final intSample = (sample * (2 << bitDepth)).clamp(-2 << bitDepth, 2 << bitDepth).toInt();
      return intSample;
    }).toList();
  }
}
