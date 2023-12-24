function binned_stacks = binning2by2(stacks)

    T = length(stacks);
    binned_stacks = cell(T,1);

    blockSize = [2, 2]; % Define the block size for binning

    % Function to apply to each block
    fun = @(block_struct) mean(block_struct.data, [1 2]);

    Z = size(stacks{1},3);
    Y = size(stacks{1},1);
    X = size(stacks{1},2);

    binned_stack = zeros(Y/2,X/2,Z,"uint16");

    for t = 1:T
        for z = 1:Z
            % Apply 2x2 binning
            binned_stack(:,:,z)= blockproc(stacks{t}(:,:,z),blockSize,fun);
        end
        binned_stacks{t} = binned_stack;
        fprintf('t = %d stack has been binned!\n', t);

    end

end

