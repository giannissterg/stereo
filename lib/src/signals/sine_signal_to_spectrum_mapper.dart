import 'package:stereo/src/complex/complex.dart';
import 'package:stereo/src/mappers/mapper.dart';
import 'package:stereo/src/signals/sine_signal.dart';
import 'package:stereo/src/spectrums/delta_spectrum.dart';
import 'package:stereo/src/spectrums/sum_spectrum.dart';

class SineSignalToSpectrumMapper
    implements Mapper<SineSignal, SumSpectrum<DeltaSpectrum, DeltaSpectrum>> {
  @override
  SumSpectrum<DeltaSpectrum, DeltaSpectrum> map(SineSignal input) {
    return SumSpectrum(
      DeltaSpectrum(input.frequency, Complex(input.amplitude, 0)),
      DeltaSpectrum(input.frequency, Complex(-input.amplitude, 0)),
    );
  }
}
