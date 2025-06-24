// import 'package:stereo/src/signal_compiler/signal_compiler.dart';

// class PluckedStringSignal {
//   final double frequency;
//   final double duration;
//   final double decay;

//   PluckedStringSignal({required this.frequency, this.duration = 1.0, this.decay = 0.995});
// }

// class PluckedStringCompiler implements SignalCompiler<PluckedStringSignal> {
//   @override
//   ContinuousSignal compile(PluckedStringSignal signal) {
//     final bufferSize = (context.sampleRate.hertz / signal.frequency).floor();
//     final buffer = List<double>.generate(bufferSize, (_) => context.rand.nextDouble() * 2 - 1);

//     return (double t) {
//       final n = (t * context.sampleRate.hertz).floor();
//       final index = n % bufferSize;
//       if (n >= buffer.length) {
//         final next = 0.5 * (buffer[(index - 1 + bufferSize) % bufferSize] + buffer[index]);
//         buffer[index] = next * signal.decay;
//       }
//       return buffer[index];
//     };
//   }
// }
