import 'package:stereo/stereo.dart';


/// Maps a PairSignal of two SineSignals to their frequency domain representation
/// by composing with the single SineSignalToSpectrumMapper.
class PairSineSignalToSpectrumMapper 
    implements Mapper<FourierTransform<PairSignal<SineSignal, SineSignal>>, SumSpectrum<SineSpectrum, SineSpectrum>> {
  
  const PairSineSignalToSpectrumMapper({required this.sineMapper});
  
  final SineSignalToSpectrumMapper sineMapper;
  
  @override
  SumSpectrum<SineSpectrum, SineSpectrum> map(FourierTransform<PairSignal<SineSignal, SineSignal>> input) {
    final signal1 = input.signal.signal1;
    final signal2 = input.signal.signal2;
    
    // Use the existing mapper for each sine signal
    final sine1Spectrum = sineMapper.map(signal1);
    final sine2Spectrum = sineMapper.map(signal2);
    
    return SumSpectrum(sine1Spectrum, sine2Spectrum);
  }
} 