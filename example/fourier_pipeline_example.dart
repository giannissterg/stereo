import 'dart:typed_data';

import 'package:stereo/src/spectrum_compiler/sine_spectrum_compiler.dart';
import 'package:stereo/stereo.dart';

void main() {
  // Create the mappers for the pipeline
  final fourierMapper = PairSineSignalToSpectrumMapper(sineMapper: SineSignalToSpectrumMapper());
  final sineSpectrumCompiler = SineSpectrumCompiler();
  final rectSpectrumCompiler = RectSpectrumCompiler();
  final filterMapper = SpectrumFilterMapper(
    sumSpectrumCompiler: SumSpectrumCompiler(
      compiler1: sineSpectrumCompiler,
      compiler2: sineSpectrumCompiler,
    ),
    rectSpectrumCompiler: rectSpectrumCompiler,
  );
  final inverseFourierMapper = DeltaSpectrumToSineSignalMapper();

  // Create the signal compiler
  final pipelineCompiler = FourierPipelineSignalCompiler(
    fourierMapper: fourierMapper,
    filterMapper: filterMapper,
    inverseFourierMapper: inverseFourierMapper,
  );

  // Create input: PairSignal of two SineSignals
  final sine1 = SineSignal(frequency: 440, amplitude: 0.5); // A4 note
  final sine2 = SineSignal(frequency: 880, amplitude: 0.2); // A5 note
  final pairSignal = PairSignal(sine1, sine2);

  // Create filter: RectSpectrum to cutoff one of the sines
  // This will pass frequencies between 400-500 Hz, keeping only the 440 Hz sine
  final rectFilter = RectSpectrum(400, 500);

  // Compile the entire pipeline
  final continuousSignal = pipelineCompiler.compile(
    FourierPipelineSignal(inputSignal: pairSignal, filter: rectFilter),
  );

  // Generate samples
  final sampleRate = 44100;
  final duration = 2.0; // 2 seconds
  final samples = <double>[];
  for (int i = 0; i < (sampleRate * duration).round(); i++) {
    samples.add(continuousSignal(i / sampleRate));
  }

  // Write to WAV file
  WavFileWriter(
    path: 'fourier_pipeline_result.wav',
    sampleRate: sampleRate,
  ).writeWavFile(Float32List.fromList(samples));

  print('Generated WAV file with filtered sine signal (440 Hz only)');
}
