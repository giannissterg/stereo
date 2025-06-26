import 'package:stereo/src/spectrums/sine_spectrum.dart';

import '../core/mappers/mapper.dart';
import 'sine_signal.dart';

class SineSignalToSpectrumMapper implements Mapper<SineSignal, SineSpectrum> {
  @override
  SineSpectrum map(SineSignal input) {
    // Sine signal: A*sin(2π*f*t) -> A/2 * (δ(f) - δ(-f))
    return SineSpectrum(
      frequency: input.frequency,
      amplitude: input.amplitude,
    );
  }
}
