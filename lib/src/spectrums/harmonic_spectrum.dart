class HarmonicSpectrum {
  const HarmonicSpectrum({
    required this.fundamentalFrequency,
    required this.harmonicsCount,
    required this.harmonicDecay,
    required this.amplitude,
  });

  final double fundamentalFrequency;
  final int harmonicsCount;
  final double harmonicDecay;
  final double amplitude;
}
