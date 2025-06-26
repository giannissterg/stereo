import 'dart:math';
import 'dart:typed_data';

import 'package:stereo/stereo.dart';

// Custom Complex number class
class Complex {
  final double real;
  final double imag;

  Complex(this.real, this.imag);

  Complex operator +(Complex other) => Complex(real + other.real, imag + other.imag);
  Complex operator -(Complex other) => Complex(real - other.real, imag - other.imag);
  Complex operator *(Complex other) {
    return Complex(
      real * other.real - imag * other.imag,
      real * other.imag + imag * other.real,
    );
  }

  Complex scale(double scalar) => Complex(real * scalar, imag * scalar);
  Complex conjugate() => Complex(real, -imag);
  Complex divideScalar(double scalar) => Complex(real / scalar, imag / scalar);
  double get magnitude => sqrt(real * real + imag * imag);
  @override
  String toString() => '($real, $imag)';
}

// Generate square wave signal: approximated Fourier series
double Function(double time) generateSquareWave(double f0, int numHarmonics) {
  return (double t) {
    double sum = 0;
    for (int k = 1; k <= numHarmonics; k += 2) {
      sum += (1 / k) * sin(2 * pi * k * f0 * t);
    }
    return 4 / pi * sum;
  };
}

// Generate triangle wave signal: approximated Fourier series
double Function(double time) generateTriangleWave(double f0, int numHarmonics) {
  return (double t) {
    double sum = 0;
    for (int k = 1; k <= numHarmonics; k += 2) {
      sum += pow(-1, (k - 1) / 2) * (1 / (k * k)) * sin(2 * pi * k * f0 * t);
    }
    return 8 / (pi * pi) * sum;
  };
}

// Generate chirp signal
double Function(double time) generateChirp(double f0, double alpha) {
  return (double t) => sin(2 * pi * (f0 * t + 0.5 * alpha * t * t));
}

// Fourier transform for periodic signals (square, triangle)
Complex Function(double frequency) fourierTransformPeriodic(
  double f0,
  int numHarmonics,
  String type,
) {
  const double tolerance = 1e-6;
  return (double f) {
    for (int k = 1; k <= numHarmonics; k += 2) {
      double fk = k * f0;
      if ((f - fk).abs() < tolerance) {
        if (type == 'square') {
          return Complex(0, 2 / (pi * k));
        } else if (type == 'triangle') {
          return Complex(0, 4 * pow(-1, (k - 1) / 2) / (pi * pi * k * k));
        }
      } else if ((f + fk).abs() < tolerance) {
        if (type == 'square') {
          return Complex(0, -2 / (pi * k));
        } else if (type == 'triangle') {
          return Complex(0, -4 * pow(-1, (k - 1) / 2) / (pi * pi * k * k));
        }
      }
    }
    return Complex(0, 0);
  };
}

// Fourier transform for chirp (approximation)
Complex Function(double frequency) fourierTransformChirp(
  double f0,
  double alpha,
) {
  const double tolerance = 1e-6;
  return (double f) {
    if (f >= f0 && f <= f0 + alpha && (f - f0).abs() > tolerance) {
      return Complex(0, 0.5);
    } else if (f <= -f0 && f >= -(f0 + alpha) && (f + f0).abs() > tolerance) {
      return Complex(0, -0.5);
    }
    return Complex(0, 0);
  };
}

// Butterworth-like low-pass filter
Complex Function(double frequency) butterworthLowPassFilter(
  Complex Function(double frequency) spectrum,
  double cutoff,
  double n,
) {
  return (double f) {
    double gain = 1 / sqrt(1 + pow(f.abs() / cutoff, 2 * n));
    return spectrum(f).scale(gain);
  };
}

// Inverse Fourier transform for periodic signals
double Function(double time) inverseFourierTransformPeriodic(
  Complex Function(double frequency) spectrum,
  double f0,
  int numHarmonics,
) {
  const double tolerance = 1e-6;
  List<double> gains = [];
  for (int k = 1; k <= numHarmonics; k += 2) {
    double fk = k * f0;
    double gain = spectrum(fk).magnitude > tolerance ? spectrum(fk).scale(2).imag : 0;
    gains.add(gain);
  }
  return (double t) {
    double sum = 0;
    for (int i = 0; i < gains.length; i++) {
      int k = 2 * i + 1;
      sum += gains[i] * sin(2 * pi * k * f0 * t);
    }
    return sum;
  };
}

// Inverse Fourier transform for chirp (approximation)
double Function(double time) inverseFourierTransformChirp(
  Complex Function(double frequency) spectrum,
  double f0,
  double alpha,
) {
  const double tolerance = 1e-6;
  double fStart = f0;
  double fEnd = f0 + alpha;
  int numSteps = 10;
  double df = (fEnd - fStart) / numSteps;
  List<double> frequencies = [];
  List<double> gains = [];
  for (int i = 0; i <= numSteps; i++) {
    double f = fStart + i * df;
    if (spectrum(f).magnitude > tolerance) {
      frequencies.add(f);
      gains.add(spectrum(f).scale(2).imag);
    }
  }
  return (double t) {
    double sum = 0;
    for (int i = 0; i < frequencies.length; i++) {
      sum += gains[i] * sin(2 * pi * frequencies[i] * t);
    }
    return sum;
  };
}

void main() {
  // Signal parameters
  double f0 = 220.0; // Hz for periodic signals
  int numHarmonics = 30;
  double chirpF0 = 200.0; // Hz
  double chirpAlpha = 12000.0; // Hz/s

  // Filter parameters
  double lowPassCutoff = 500.0; // Hz
  List<double> butterworthOrders = [1.0, 2.0, 3.0]; // Slow, medium, fast

  // Sampling parameters for output
  double tStart = 0.0;
  double tEnd = 0.05;
  double dt = 0.0001;
  int numSamples = 44100;

  // Generate signals
  var signals = {
    'Square': generateSquareWave(f0, numHarmonics),
    'Triangle': generateTriangleWave(f0, numHarmonics),
    'Chirp': generateChirp(chirpF0, chirpAlpha),
  };

  // Compute Fourier transforms
  var spectra = {
    'Square': fourierTransformPeriodic(f0, numHarmonics, 'square'),
    'Triangle': fourierTransformPeriodic(f0, numHarmonics, 'triangle'),
    'Chirp': fourierTransformChirp(chirpF0, chirpAlpha),
  };

  // Apply filters (only Butterworth low-pass for simplicity)
  var filteredSpectra = {
    'Square': <String, Map<double, Complex Function(double frequency)>>{},
    'Triangle': <String, Map<double, Complex Function(double frequency)>>{},
    'Chirp': <String, Map<double, Complex Function(double frequency)>>{},
  };

  for (String signal in filteredSpectra.keys) {
    filteredSpectra[signal]!['Butterworth-LP'] = {};
    for (double n in butterworthOrders) {
      filteredSpectra[signal]!['Butterworth-LP']![n] = butterworthLowPassFilter(
        spectra[signal]!,
        lowPassCutoff,
        n,
      );
    }
  }

  // Compute output signals
  var outputSignals = {
    'Square': <String, Map<double, double Function(double time)>>{},
    'Triangle': <String, Map<double, double Function(double time)>>{},
    'Chirp': <String, Map<double, double Function(double time)>>{},
  };

  for (String signal in filteredSpectra.keys) {
    outputSignals[signal]!['Butterworth-LP'] = {};
    for (double n in butterworthOrders) {
      if (signal == 'Chirp') {
        outputSignals[signal]!['Butterworth-LP']![n] = inverseFourierTransformChirp(
          filteredSpectra[signal]!['Butterworth-LP']![n]!,
          chirpF0,
          chirpAlpha,
        );
      } else {
        outputSignals[signal]!['Butterworth-LP']![n] = inverseFourierTransformPeriodic(
          filteredSpectra[signal]!['Butterworth-LP']![n]!,
          f0,
          numHarmonics,
        );
      }
    }
  }

  // // Print CSV-like output for each signal
  // for (String signal in signals.keys) {
  //   print('\nSignal: $signal');
  //   // Print header
  //   String header = 'time,Input';
  //   for (double n in butterworthOrders) {
  //     header += ',Butterworth-LP-n=$n';
  //   }
  //   print(header);

  //   // Print data
  //   for (int i = 0; i < numSamples; i++) {
  //     double t = tStart + i * dt;
  //     List<String> row = [
  //       t.toStringAsFixed(6),
  //       signals[signal]!(t),
  //     ];
  //     for (double n in butterworthOrders) {
  //       row.add(
  //         outputSignals[signal]!['Butterworth-LP']![n]!(t),
  //       );
  //     }
  //     print(row.join(','));
  //   }
  // }

  for (String signal in signals.keys) {
    final samples = List.generate(2 * numSamples, (i) => signals[signal]!(i / numSamples));
    final outputSamples =
        List.generate(2 * numSamples, (i) => outputSignals[signal]!['Butterworth-LP']![1]!(i / numSamples));

    WavFileWriter(
      path: '${signal.toLowerCase()}.wav',
      sampleRate: numSamples,
    ).writeWavFile(Float32List.fromList(samples));

    WavFileWriter(
      path: '${signal.toLowerCase()}_filtered.wav',
      sampleRate: numSamples,
    ).writeWavFile(Float32List.fromList(outputSamples));
  }
}
