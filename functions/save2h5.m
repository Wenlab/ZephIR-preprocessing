function save2h5(filename,stacks,tform_parameters)
    if ~exist(filename,"file")
        [T,C,Z,Y,X] = size(stacks);
        h5create(filename,'/data',[X Y Z C T],'DataType','uint8','ChunkSize',[X Y Z C 1],'Deflate',5);
        h5write(filename, '/data', permute(stacks,[5 4 3 2 1]));
        h5create(filename,'/tform_parameters',[T 3],'DataType','single');
        h5write(filename, '/tform_parameters', single(tform_parameters));
    else
        h5write(filename, '/data', permute(stacks,[5 4 3 2 1]));
        h5write(filename, '/tform_parameters', single(tform_parameters));
    end
    
end

