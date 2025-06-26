/// Represents a Fourier transform operation that converts a time domain signal
/// to its frequency domain representation.
class FourierTransform<T> {
  const FourierTransform(this.signal);

  final T signal;
} 