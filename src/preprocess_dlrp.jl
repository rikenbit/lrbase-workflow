open("data/dlrp/pre_dlrp.csv", "w") do fp
    open("data/dlrp/dlrp.txt", "r") do fp2
        ligand = true
        pairs = ["",""]
        for line in readlines(fp2)
            col = split(chomp(line), "\t")
            if length(col) != 1
                if ligand == true
                    pairs[1] = col[2]
                    ligand = false
                else
                    pairs[2] = col[2]
                    write(fp, pairs[1] * "," * pairs[2] * ",-," * "DLRP")
                    write(fp, "\n")
                end
            else
                ligand = true
            end
        end
    end
end