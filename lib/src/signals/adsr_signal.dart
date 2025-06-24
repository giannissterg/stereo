class AdsrEnvelope<T> {
  AdsrEnvelope({
    required this.attackTime,
    required this.decayTime,
    required this.sustainLevel,
    required this.releaseTime,
    required this.noteDuration,
    required this.signal,
  });

  final double attackTime;
  final double decayTime;
  final double sustainLevel;
  final double releaseTime;
  final double noteDuration;
  final T signal;
}
