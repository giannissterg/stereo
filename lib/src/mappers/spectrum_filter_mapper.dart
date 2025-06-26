import '../core/complex/complex.dart';
import '../core/mappers/mapper.dart';
import '../spectrums/rect_spectrum.dart';
import '../spectrums/sine_spectrum.dart';
import '../spectrums/sum_spectrum.dart';
import '../spectrum_compiler/spectrum_compiler.dart';

/// Maps a composition of SumSpectrum and RectSpectrum to a filtered spectrum.
/// Uses spectrum compilers to evaluate the spectra and apply filtering.
class SpectrumFilterMapper 
    implements Mapper<({SumSpectrum<SineSpectrum, SineSpectrum> spectrum, RectSpectrum filter}), SineSpectrum> {
  
  const SpectrumFilterMapper({
    required this.sumSpectrumCompiler,
    required this.rectSpectrumCompiler,
  });
  
  final SpectrumCompiler<SumSpectrum<SineSpectrum, SineSpectrum>> sumSpectrumCompiler;
  final SpectrumCompiler<RectSpectrum> rectSpectrumCompiler;
  
  @override
  SineSpectrum map(({SumSpectrum<SineSpectrum, SineSpectrum> spectrum, RectSpectrum filter}) input) {
    final spectrum = input.spectrum;
    final filter = input.filter;
    
    // Compile both spectra to functions
    final spectrumFunction = sumSpectrumCompiler.compile(spectrum);
    final filterFunction = rectSpectrumCompiler.compile(filter);
    
    // Find the frequency with maximum amplitude in the spectrum
    double maxFrequency = 0;
    Complex maxAmplitude = Complex.zero();
    
    // Check all possible frequencies from the sine spectrums
    final frequencies = [
      spectrum.spectrum1.frequency,
      spectrum.spectrum2.frequency,
    ];
    
    print('Filtering frequencies: $frequencies');
    print('Filter range: ${filter.lowCutoff} - ${filter.highCutoff} Hz');
    
    for (final frequency in frequencies) {
      final spectrumValue = spectrumFunction(frequency);
      final filterValue = filterFunction(frequency);
      final filteredValue = spectrumValue * filterValue;
      
      print('  Frequency $frequency Hz:');
      print('    Spectrum value: ${spectrumValue.re} + ${spectrumValue.im}i');
      print('    Filter value: ${filterValue.re} + ${filterValue.im}i');
      print('    Filtered value: ${filteredValue.re} + ${filteredValue.im}i');
      
      // Only consider frequencies that pass the filter (filterValue != 0)
      if (filterValue.re != 0 && filteredValue.re.abs() > maxAmplitude.re.abs()) {
        maxFrequency = frequency;
        maxAmplitude = filteredValue;
      }
    }
    
    print('Selected frequency: $maxFrequency Hz, amplitude: ${maxAmplitude.re} + ${maxAmplitude.im}i');
    
    // Convert the filtered result back to a SineSpectrum
    // The amplitude should be doubled since we're reconstructing the full sine signal
    final amplitude = maxAmplitude.re.abs() * 2;
    
    return SineSpectrum(frequency: maxFrequency, amplitude: amplitude);
  }
} 