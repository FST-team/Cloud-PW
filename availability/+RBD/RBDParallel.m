function result = RBDParallel(avail)
    arguments (Repeating)
        avail
    end
    result = 1 - prod(cellfun(@(cell)1-avail, avail));
end

