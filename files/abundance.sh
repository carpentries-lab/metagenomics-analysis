
File=$(basename $1 .kraken)
Outdir="results"
mkdir results
# sort abundance (third column)
echo "Sorting abundance "
cut -f3 ${File}.kraken  |sort -n |uniq -c > ${Outdir}/${File}_tmp.ranked
cat ${Outdir}/${File}_tmp.ranked |while read a b; do echo $b$'\t'$a; done > ${Outdir}/${File}.ranked
rm ${Outdir}/${File}_tmp.ranked

echo " Producing taxonomy error file"
cut -f1 ${Outdir}/${File}.ranked |taxonkit lineage  >${Outdir}/${File}.table 2>${Outdir}/${File}.error


# Finding error in taxa
grep deleted ${Outdir}/${File}.error| cut -d' ' -f4,8 > ${Outdir}/${File}.deleted
grep merged ${Outdir}/${File}.error | cut -d' ' -f4,8 > ${Outdir}/${File}.merged

# echo "cut -f3 ${File}> ${File}-wc"
 cut -f3 ${File}.kraken> ${Outdir}/${File}-wc

cat  ${Outdir}/${File}.merged  | while read line
do
 #   echo line $line 	
    original=$(echo $line|cut -d' ' -f1)
    new=$( echo $line|cut -d' '  -f2)
    echo "Replacing $original by $new taxa"
#    perl -p -i -e "s/^$original\n/$new\n/" ${Outdir}/${File}-wc
    sed -i "s/\<$original\>/$new/" ${Outdir}/${File}-wc 
done  

cat ${Outdir}/${File}.deleted |while read line
do
	echo "Removing $line taxa"
	grep -v -w $line ${Outdir}/${File}-wc >${Outdir}/${File}-tmp
	mv ${Outdir}/${File}-tmp ${Outdir}/${File}-wc
done

cat ${Outdir}/${File}-wc |sort -n |uniq -c > ${Outdir}/${File}_tmp.ranked  
cat ${Outdir}/${File}_tmp.ranked |while read a b; do echo $b$'\t'$a; done > ${Outdir}/${File}.ranked
rm ${Outdir}/${File}_tmp.ranked 

cut -f1 ${Outdir}/${File}.ranked |taxonkit lineage  >${Outdir}/${File}.table 2>${Outdir}/${File}.error

echo "Creating lineage table"
cat ${Outdir}/${File}.table | taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" | cut  -f1,3 >${Outdir}/${File}.lineage_table



echo -e "OTU\tsuperkingdom\tphylum\tclass\torder\tfamily\tgenus\tspecies\tsubspecies\tsubspecies_2" > ${Outdir}/${File}.lineage_table-wc               
cat ${Outdir}/${File}.lineage_table >> ${Outdir}/${File}.lineage_table-wc

#echo "OTU$'\t'superkingdom$'\t'phylum$'\t'class        order$'\t'family$'\t'genus$'\t'species$'\t'subspecies$'\t'subspecies_2" |cat ${Outdir}/${File}.lineage_table > ${Outdir}/${File}.lineage_table-wc

#perl -p -i -e 's/;/\t/g' ${Outdir}/${File}.lineage_table-wc
sed -i "s/;/\t/g" ${Outdir}/${File}.lineage_table-wc

echo -e "OTU\t${File}" >  ${Outdir}/${File}.ranked-wc
cat ${Outdir}/${File}.ranked >> ${Outdir}/${File}.ranked-wc



#rm ${File}.table
