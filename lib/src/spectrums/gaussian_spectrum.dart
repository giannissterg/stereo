// Smooth frequency domain model (e.g. Gaussian)
import 'package:stereo/src/complex/complex.dart';

class GaussianSpectrum {
  const GaussianSpectrum(this.frequency, this.bandwidth, this.peakMagnitude);

  final double frequency;
  final double bandwidth;
  final Complex peakMagnitude;
}