library(webchem)

## Convert chemical name into a SMILES string based on record in ChEMBL database
## string: a chemical name
getSMILESfromName <- function(string) {
  pubchem <- cts_convert(string, 'Chemical Name', 'PubChem CID', first = TRUE)[1]
  smiles <- cid_compinfo(pubchem)$CanonicalSmiles
  if (length(smiles) == 0) {
    return(NULL)
  }
  return(smiles)
}

## Convert chemical name into a ChEMBL identifier based on CTS
## string: a chemical name
getChEMBLfromName <- function(string) {
  tryCatch(cts_convert(string, 'Chemical Name', 'CHEMBL', first = TRUE), error = function (e) return(NA))
}



