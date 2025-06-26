/// Represents an inverse Fourier transform operation that converts a frequency domain
/// spectrum back to its time domain signal representation.
class InverseFourierTransform<T> {
  const InverseFourierTransform(this.spectrum);

  final T spectrum;
} 