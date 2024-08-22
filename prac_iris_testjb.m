function prac_iris_testjb(prevLayerNeurons, Vpi, time_period, data_bit, bit_res, inputFilePath, layerNumber, neuronNumber, flag, data_size, weightLUT, xLUT)
    
    % basic setup(demo run)
    % prevLayerNeurons=4;
    % Vpi=3.6;
    % time_period=100e-12;
    % bit_res=8;
    % flag=0;
    % inputFilePath = 'F:\Documents\IITP\4th Year\BTP\Matlab\testing_data.txt';
    % data_matrix = readmatrix(inputFilePath);

    num_repetitions=2^bit_res;
    
    data_matrix = readmatrix(inputFilePath);

    if flag==1
        data_matrix=data_matrix';
        [vUpper, vLow]=weight_calculation_try(data_matrix, weightLUT);
        % data_matrix
        % prevLayerNeurons
        % weightLUT
    end


    if flag==0
        Voltage_layer1=zeros(data_size,prevLayerNeurons);
        for u=1:data_size
            [xi_achieve,Voltage_xi]=find_xi(data_matrix(u,:), xLUT);
            Voltage_layer1(u,:)=Voltage_xi;
        end
    end
        
    %use this if you want to access aparticular number of lines
    % data_size=3;
    
    total_duration = prevLayerNeurons*time_period;
    separation_value=0;


    for r=1:2*data_size
        if mod(r, 2)==1
            if flag==1
                %Generating weights waveform
                kVlow=vLow(neuronNumber, :)';
                kVupper=vUpper(neuronNumber, :)';
                Waveform1(kVlow, time_period, num_repetitions, r, total_duration*((r-1)), 2, flag, layerNumber, neuronNumber);
                Waveform1(kVupper, time_period, num_repetitions, r, total_duration*((r-1)), 3, flag, layerNumber, neuronNumber);
            else
                %Generating voltage waveform
                k=Voltage_layer1((r+1)/2,:)';
                Waveform1(k, time_period, num_repetitions, r, total_duration*((r-1)), 1, flag, layerNumber, neuronNumber);
            end
        end
    
        gap_matrix=separation_value*ones(1, prevLayerNeurons)';
        if mod(r, 2)==0
            Waveform1(gap_matrix, time_period, num_repetitions,r, total_duration*(r-1), 0, flag, layerNumber, neuronNumber);
        end
    end
end




