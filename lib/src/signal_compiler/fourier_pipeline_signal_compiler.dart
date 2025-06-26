import 'dart:math' as math;

import '../mappers/fourier_transform_mapper.dart';
import '../mappers/inverse_fourier_transform_mapper.dart';
import '../mappers/spectrum_filter_mapper.dart';
import '../signals/pair_signal.dart';
import '../signals/sine_signal.dart';
import '../spectrums/rect_spectrum.dart';
import '../transforms/fourier_transform.dart';
import '../transforms/inverse_fourier_transform.dart';
import 'signal_compiler.dart';

/// A signal model that represents a complete Fourier transform pipeline.
class FourierPipelineSignal {
  const FourierPipelineSignal({
    required this.inputSignal,
    required this.filter,
  });

  final PairSignal<SineSignal, SineSignal> inputSignal;
  final RectSpectrum filter;
}

/// A signal compiler that can compile a complete Fourier transform pipeline.
/// 
/// This compiler takes a FourierPipelineSignal, applies Fourier transform,
/// filters with a RectSpectrum, applies inverse Fourier transform, and returns
/// a continuous time function representing the final single SineSignal.
class FourierPipelineSignalCompiler implements SignalCompiler<FourierPipelineSignal> {
  const FourierPipelineSignalCompiler({
    required this.fourierMapper,
    required this.filterMapper,
    required this.inverseFourierMapper,
  });

  final PairSineSignalToSpectrumMapper fourierMapper;
  final SpectrumFilterMapper filterMapper;
  final DeltaSpectrumToSineSignalMapper inverseFourierMapper;

  @override
  ContinuousSignal compile(FourierPipelineSignal signal) {
    final fourierTransform = FourierTransform(signal.inputSignal);
    final frequencySpectrum = fourierMapper.map(fourierTransform);
    final filteredSpectrum = filterMapper.map((spectrum: frequencySpectrum, filter: signal.filter));
    
    // Apply inverse Fourier transform to get the final sine signal
    final inverseFourierTransform = InverseFourierTransform(filteredSpectrum);
    final finalSignal = inverseFourierMapper.map(inverseFourierTransform);
    
    // Return continuous time function
    return (double time) {
      return finalSignal.amplitude * math.sin(2 * math.pi * finalSignal.frequency * time);
    };
  }
} 