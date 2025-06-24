import 'dart:typed_data';

class AudioMixer {
  static Float32List mix(List<Float32List> tracks, {double gain = 1.0}) {
    final maxLength = tracks.map((track) => track.length).reduce((a, b) => a > b ? a : b);
    final mixedSamples = Float32List(maxLength);

    for (var track in tracks) {
      for (var i = 0; i < track.length && i < mixedSamples.length; i++) {
        mixedSamples[i] += track[i] * gain;
      }
    }

    // Normalize to avoid clipping
    final maxAmplitude = mixedSamples.reduce((a, b) => a.abs() > b.abs() ? a : b);
    if (maxAmplitude > 1.0) {
      final scale = 1.0 / maxAmplitude;
      for (var i = 0; i < mixedSamples.length; i++) {
        mixedSamples[i] *= scale;
      }
    }

    return mixedSamples;
  }
}
