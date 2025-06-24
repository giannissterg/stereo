import 'dart:math' as math;
import 'dart:typed_data';

import 'package:stereo/src/signal_compiler/adsr_envelope_compiler.dart';
import 'package:stereo/src/signal_compiler/composite_signal_compiler.dart';
import 'package:stereo/src/signal_compiler/linear_decay_envelope_compiler.dart';
import 'package:stereo/src/signal_compiler/pair_signal_compiler.dart';
import 'package:stereo/src/signal_compiler/sine_signal_compiler.dart';
import 'package:stereo/src/signal_compiler/triangle_signal_compiler.dart';
import 'package:stereo/src/signals/adsr_signal.dart';
import 'package:stereo/src/signals/composite_signal.dart';
import 'package:stereo/src/signals/pair_signal.dart';
import 'package:stereo/src/signals/sine_signal.dart';
import 'package:stereo/src/signals/triangle_signal.dart';
import 'package:stereo/src/wav/wav_file_writer.dart';

void main() {
  final tr = TriangleSignalCompiler();
  final sineSignalCompiler = SineSignalCompiler();
  final adsrEnvelopeCompiler = AdsrEnvelopeCompiler(sineSignalCompiler);
  final sineSignal = SineSignal(frequency: 440 * 1.5, amplitude: 0.2);
  final sineSignal2 = SineSignal(frequency: 440, amplitude: 0.1);
  final trSignal = TriangleSignal(440 * 1.5, 0.2);
  final ldEnvelopeCompiler = LinearDecayEnvelopeCompiler(sineSignalCompiler);

  final sumSignalCompiler = PairSignalCompiler(ldEnvelopeCompiler, adsrEnvelopeCompiler);
  var adsrEnvelope = AdsrEnvelope(
    attackTime: 0.5,
    decayTime: 0.9,
    sustainLevel: 0.1,
    releaseTime: 0.1,
    noteDuration: 1.7,
    signal: sineSignal,
  );
  final finalSignal = adsrEnvelopeCompiler.compile(adsrEnvelope);
  final fSignal = sumSignalCompiler.compile(
    PairSignal(LinearDecayEnvelope(sineSignal2, 0.6), adsrEnvelope),
  );

  final compo = CompositeSignal(
    List.generate(12, (n) {
      final harmonic = n + 1;
      final freq = 440.0 * harmonic;
      final amp = 1 / math.pow(harmonic, 1.1);

      return AdsrEnvelope(
        attackTime: 0.005,
        decayTime: 0.05,
        sustainLevel: 0.6,
        releaseTime: 1.5,
        noteDuration: 0.4,
        signal: SineSignal(frequency: freq, amplitude: amp),
      );
    }),
  );

  final compoCompiler = CompositeSignalCompiler(adsrEnvelopeCompiler);
  final compS = compoCompiler.compile(compo);

  final sampleRate = 44100;
  final samples = List.generate(2 * sampleRate, (i) => compS(i / sampleRate));

  WavFileWriter(
    path: 'my_path.wav',
    sampleRate: sampleRate,
  ).writeWavFile(Float32List.fromList(samples));
}
