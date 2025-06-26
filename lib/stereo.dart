/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/core/complex/complex.dart';
export 'src/core/mappers/mapper.dart';
export 'src/core/time/fold_time_extension.dart';

export 'src/signals/adsr_signal.dart'; 
export 'src/signals/composite_signal.dart'; 
export 'src/signals/pair_signal.dart'; 
export 'src/signals/sine_signal.dart'; 
export 'src/signals/sine_signal_to_spectrum_mapper.dart'; 
export 'src/signals/triangle_signal.dart'; 

export 'src/signal_compiler/adsr_envelope_compiler.dart';
export 'src/signal_compiler/composite_signal_compiler.dart';
export 'src/signal_compiler/linear_decay_envelope_compiler.dart';
export 'src/signal_compiler/pair_signal_compiler.dart';
export 'src/signal_compiler/sine_signal_compiler.dart';
export 'src/signal_compiler/triangle_signal_compiler.dart';
export 'src/signal_compiler/fourier_pipeline_signal_compiler.dart';

export 'src/spectrums/delta_spectrum.dart';
export 'src/spectrums/gaussian_spectrum.dart';
export 'src/spectrums/rect_spectrum.dart';
export 'src/spectrums/sine_spectrum.dart';
export 'src/spectrums/sum_spectrum.dart';

export 'src/spectrum_compiler/spectrum_compiler.dart';
export 'src/spectrum_compiler/delta_spectrum_compiler.dart';
export 'src/spectrum_compiler/sine_spectrum_compiler.dart';
export 'src/spectrum_compiler/sum_spectrum_compiler.dart';
export 'src/spectrum_compiler/rect_spectrum_compiler.dart';

export 'src/transforms/fourier_transform.dart';
export 'src/transforms/inverse_fourier_transform.dart';

export 'src/mappers/fourier_transform_mapper.dart';
export 'src/mappers/spectrum_filter_mapper.dart';
export 'src/mappers/inverse_fourier_transform_mapper.dart';

export 'src/wav/data_chunk.dart';
export 'src/wav/fmt_chunk.dart';
export 'src/wav/sample_converter.dart';
export 'src/wav/wav_header.dart';
export 'src/wav/wav_file_writer.dart';