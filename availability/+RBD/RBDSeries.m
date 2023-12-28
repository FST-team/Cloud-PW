function result = RBDSeries(avail)
    arguments (Repeating)
        avail
    end
    result = prod(cell2mat(avail));
end

