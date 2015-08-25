library(RMySQL)
library(rcdk)
source("chemicalTransUtils.R")

## Script to initialize application objects by
## getting drug curation, drug fingerprints, and
## chembl ids

## Remove na values for smiles to get fingerprints
## Create CSV with SELECT DRUG_STRUCTURE_METADATA.drug_id, smiles, inchikey, cid, study_name FROM DRUG_CURATION INNER JOIN
## DRUG_STRUCTURE_METADATA ON DRUG_CURATION.drug_id = DRUG_STRUCTURE_METADATA.drug_id
## INNER JOIN STUDIES ON STUDIES.study_id = DRUG_CURATION.drug_study_id;
drugs <- read.csv("drug_sim_app_obj.csv", na.strings = c("NA", "list()", "NULL"))
drugs <- drugs[!is.na(drugs$drug_id),]
drugs <- drugs[!is.na(drugs$smiles) & !is.null(drugs$smiles), ]
target.mols <- parse.smiles(as.character(drugs[,"smiles"]))
target.fps <- pbapply::pblapply(target.mols, get.fingerprint, type="extended")
drugs$fps <- target.fps
save(drugs, file = "drug_dat_with_fps.RData")

## Get CHEMBL IDS
#chembls <- lapply(unique(drugs$drug_id), getChEMBLfromName)
#names(chembls) <- unique(drugs$drug_id)
#chembls <- Filter(function (x) (length(x) > 0 && !is.na(x)), chembls) ## Filter ChEMBL ids which were not found
#save(chembls, file = "chembls.RData")

