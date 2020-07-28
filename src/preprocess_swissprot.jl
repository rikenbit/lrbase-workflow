open("data/uniprotkb/swissprot_" * ARGS[1] * ".csv", "w") do fp
    open("data/uniprotkb/uniprot_sprot.dat", "r") do fp2
        # 空の配列を用意 : [Accession, TaxID, Sub.Loc.]の順
        eachentry = ["","","",""]
        eachcc = []
        eachpmid = []
        # フラグ
        isac = false
        istax = false
        isloc = false
        isncbi = false
        hit = false
        # 毎行パース
        for line in eachline(fp2)
            # AC   Q6GZX4;
            # みたいな行を切り出す
            # !!!1行に複数書かれていることが多い!!!
            if occursin(r"^AC   ", line)
                eachentry[1] = replace(replace(replace(line, r"^AC   " => ""), r";$" => ""), "," => " ")
                isac = true
            end

            # OX   NCBI_TaxID=9606;
            # みたいな行を切り出す
            # !!!1つだけ!!!
            if occursin(r"^OX   NCBI_TaxID=", line)
                tmp = match(r"^OX   NCBI_TaxID=(\d*).*;", line)
                if tmp.captures[1] == ARGS[1]
                    istax = true
                end
            end

            # RX   PubMed=15165820;
            # みたいな行を切り出す
            # !!!複数行にまたがっている!!!
            if occursin(r"^RX   PubMed=", line)
                tmp = match(r"^RX   PubMed=(\d*);", line)
                push!(eachpmid, replace(tmp.captures[1], "," => " "))
            end

            # 先頭が"CC"
            if occursin(r"^CC   ", line)
                # 先頭が"CC" かつ "CC   -!- SUBCELLULAR LOCATION:"
                if occursin(r"^CC   -!- SUBCELLULAR LOCATION:", line)
                    push!(eachcc, replace(replace(line, r"^CC   -!- SUBCELLULAR LOCATION: " => ""), "," => " "))
                    hit = true

                # 先頭が"CC" かつ "CC   -!- SUBCELLULAR LOCATION:"ではない
                else
                    # 先頭が"CC" かつ "CC   -!- SUBCELLULAR LOCATION:"ではなく かつ CC   みたいなやつ
                    if occursin(r"^CC   -!-", line) && hit
                        push!(eachcc, replace(replace(line, r"^CC   " => ""), "," => " "))
                    end
                end
            end

            # CCから出てからtmpを格納して、islocを作動
            if !occursin(r"^CC   -!-", line) && hit
                # 次のCCの情報になったタイミングで保存
                tmp = ""
                for i in 1:length(eachcc)
                    tmp = tmp * eachcc[i]
                end
                eachentry[2] = replace(replace(tmp, r",$" => ""), "," => " ")
                eachcc = []
                isloc = true
                hit = false
            end

            # DR   GeneID;
            # みたいな形を取り出す
            if occursin(r"^DR   GeneID;", line)
                ncbi = replace(line, r"^DR   GeneID; " => "")
                ncbi = replace(ncbi, r"; -." => "")
                ncbi = replace(ncbi, r";" => "")
                eachentry[3] = replace(ncbi, "," => " ")
                isncbi = true
            end

            # もし該当する生物種だったら保存
            if isac && istax && isloc && isncbi
                # PMIDをまとめ
                if length(eachpmid) != 0
                    tmp = ""
                    for i in 1:length(eachpmid)
                        tmp = tmp * eachpmid[i] * ";"
                    end
                    eachentry[4] = replace(replace(tmp, r";$" => ""), "," => " ")
                else
                    eachentry[4] = "-"
                end

                write(fp, eachentry[1] * "," * eachentry[2] * "," * eachentry[3] * "," * eachentry[4] * "\n")
                eachentry = ["","","",""]
                eachpmid = []
                isac = false
                istax = false
                isloc = false
                isncbi = false
            end

            # 1エントリー終わったら一度リセット
            if occursin(r"^//", line)
                eachentry = ["","","",""]
                eachpmid = []
                isac = false
                istax = false
                isloc = false
                isncbi = false
            end
        end
    end
end
