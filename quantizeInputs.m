function q = quantizeInputs(k_bit, w)
   % Import the Python library
quantizers = py.importlib.import_module('larq.quantizers');
q = quantizers.DoReFa(k_bit, 'activations').call(py.numpy.array(w));
q=double(q);
q=q';

end