# DrugSim
Drug Similarity Shiny App for DRUGNET

Large pharmacological datasets such as the Cancer Cell Line Encyclopedia (CCLE), the Cancer Genomics Project,
the Connectivity Map, and the NCI60 screen a variety of compounds and test their response on cancer cell lines.
These high-throughput screens assess response variables such as viability of cell lines or changes in 
cell line gene expression to a given compound, which can eludicate information about the properties
of a drug when treated on a certain disease. Quantative Structure-Activity Relationship (QSAR) modelling aims to predict 
these response variables using the chemical properties of these compounds. Examining the structure of these 
chemical compounds is then the first step in doing this type of modelling. If there is a new therapeutic being
examined on cancer cell lines, the therapeutic should have a similar effect as previously examined
therapeutics with a similar structure on known targets, under the hypothesis that similar drugs will have similar 
properties. This application then allows the user to find drugs tested in large pharmacogenomic
datasets which are similar to a given drug, with this aim of facilitating QSAR modelling, which may aid in drug
repurposing, and elucidating families of similar drugs.

Since similarity is often an arbitrary metric, the metric we have chosen to use is as follows:

Given drugs A and B for which a SMILES string representation exists for both drugs, the similarity between them is the Tanimoto similarity of 
their 1024-bit extended valence fingerprints (as computed using the R Chemistry Development Kit). 

Work is ongoing to facilitate use of different similarity metrics in the application and to support additional methods of looking
at the similiarity of drugs other than the similarity in their structures.

The application is available at //Insert web link here//.

References:

1. The Signature Molecular Descriptor. 1. Using Extended Valence Sequences in QSAR and QSPR Studies
Jean-Loup Faulon*, Donald P. Visco, Jr. and, and Ramdas S. Pophale
Journal of Chemical Information and Computer Sciences 2003 43 (3), 707-720 

2.Garnett,M.J. et al. Systematic identification of Genomic Markers of Drug Sensitivity in cancer cells.
Nature 483, 570–575 (2012).

3. Barretina, J. et al. The Cancer Cell Line Encyclopedia enables predictive modelling
of anticancer drug sensitivity. Nature 483, 603–607 (2012)

4. Lamb,J. et al. The Connectivity Map: using gene-expression signatures to connect small molecules, genes,
and disease. Science, 313(5795):1929-1935, September 2006.

5. NCI DTP: https://dtp.nci.nih.gov/ 

6. R Chemical Development Kit: https://cran.r-project.org/web/packages/rcdk/index.html
