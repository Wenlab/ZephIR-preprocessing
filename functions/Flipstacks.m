function stacks = Flipstacks(stacks)

    T = length(stacks);
    
    for t = 1:T
        stack = stacks{t};
        stacks{t} = fliplr(stack);
    end

end

