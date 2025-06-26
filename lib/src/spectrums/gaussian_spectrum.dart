import '../core/complex/complex.dart';

class GaussianSpectrum {
  const GaussianSpectrum(this.frequency, this.bandwidth, this.peakMagnitude);

  final double frequency;
  final double bandwidth;
  final Complex peakMagnitude;
}