import '../core/mappers/mapper.dart';
import '../signals/sine_signal.dart';
import '../spectrums/sine_spectrum.dart';
import '../transforms/inverse_fourier_transform.dart';

/// Maps a DeltaSpectrum back to a SineSignal using inverse Fourier transform.
///
/// Note: A single DeltaSpectrum represents only half of a sine signal.
/// The full sine signal A*sin(2π*f*t) requires both δ(f) and δ(-f) components.
/// This mapper reconstructs the sine signal from the positive or negative frequency component.
class DeltaSpectrumToSineSignalMapper
    implements Mapper<InverseFourierTransform<SineSpectrum>, SineSignal> {
  @override
  SineSignal map(InverseFourierTransform<SineSpectrum> input) {
    final spectrum = input.spectrum;

    // Use SineSpectrum to reconstruct the sine signal from the delta spectrums
    return SineSignal(
      frequency: spectrum.frequency,
      amplitude: spectrum.amplitude,
    );
  }
}
