class Complex {
  final double re;
  final double im;

  const Complex(this.re, this.im);

  factory Complex.zero() => Complex(0, 0);
  
  Complex operator +(Complex other) =>
      Complex(re + other.re, im + other.im);

  Complex operator *(Complex other) =>
      Complex(re * other.re - im * other.im, re * other.im + im * other.re);
}
