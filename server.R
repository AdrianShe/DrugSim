library(shiny)
library(rcdk)
library(pbapply)
library(data.table)

source("chemicalTransUtils.R") ## Functions to translate between chemical identifers
load("drug_dat_with_fps.RData") ## database with drug curation & corresponding ids/fingerprints
load("chembls.RData") ## Load chembl Ids

## Use tanimoto algorithm to return a data.frame of similar drugs against all drugs in DB
## smiles: a smiles id 
findSimilarDrugs <- function(smiles) {
  
  ## Get fingerprint for drug and compare it amongst all drugs in search space
  query.fp <- get.fingerprint(smiles, type="extended")
  
  sims <- unlist(lapply(drugs$fps, distance, fp2 = query.fp, method = "tanimoto"))
  
  ## Get unique entries from frame and order
  frame <- data.frame("drug_id" = drugs$drug_id, "smiles" = drugs$smiles, 
                      "inchikey"= drugs$inchikey, "study_name" = drugs$study_name, 
                      "similarity_score" = sims)
  frame <- frame[order(frame$similarity_score, decreasing = TRUE), ]
  
  return(frame)
}

## Create hyperlink to chembl record around chemical name, if a chembl record exists
## name: a chemical name
createCHEMBLPage <- function(name) {
    if (is.null(name)) {
      "No ChEMBL ID Found" 
    }
    else { ## Create link for each unique chembl ID
      paste0(
      lapply(name, function (x) sprintf('<a href="https://www.ebi.ac.uk/chembl/compound/inspect/%s">%s</a>', x, x)),
      collapse = ","
    )
    }
}

## Create hyperlinks based on all names
## name: vector of chemical name
createCHEMBLPages <- function(drugs) {
  links <- sapply(chembls[as.character(drugs)], createCHEMBLPage) ## Get ChEMBL IDs from chembl list then create pages
  return(links)
}

shinyServer(function(input, output) {
  
  createOutputText <- eventReactive(input$change, {
    if (length(input$string) == 0) {
      ""
    }
    
    else {
      paste("You searched for all drugs matching", input$string, ".")
  }})
  
  output$params <- renderText({
    createOutputText()
  })
  
  processProcessDat <- function(vals) {
    ## cutoff the similarity
    vals <- vals[vals$similarity_score > (input$cutoff / 100), ]
    
    if (length(input$studies) != 0) {
      vals <- vals[which(vals$study_name %in% input$studies), ] ## Cutoff according to studies
    }
    
    if (input$row) {
      ## Return one row for drug (i.e. remove duplicates)
      vals$studies <- sapply(vals$drug_id, 
                             function (name) paste0(t(vals[which(vals$drug_id == name), "study_name"]), collapse = ","))
      vals <- vals[!duplicated(vals$drug_id), -which(names(vals) %in% "study_name")]
    }
    
    ## Download table here since only has similarity scores and studies
    output$downloadResults <- downloadHandler(
      filename = function() {
        paste0(input$string, "_", "similarity.csv")
      },
      content = function(file) {
        write.csv(vals[,c("drug_id", "similarity_score")], file) 
      })
    
    if(!input$inchikey) {
      vals <- vals[, -which(names(vals) %in% c("inchikey"))]
    }
    
    if (!input$smiles) {
      vals <- vals[, -which(names(vals) %in% c("smiles"))]
    }
    
    if (input$chembl) {
      vals$chembls <- createCHEMBLPages(vals$drug_id)
    }
    
    return(vals)
    
  }

  
  createDrugTable <- eventReactive(input$change, {
    
    withProgress(message = "Search in progress...", {
    
    toConvert <- switch(input$optn, "SMILES String" = input$string, "Chemical Name" = getSMILESfromName(input$string))
    
    validate(
      need(length(toConvert) != 0, "Chemical name not found. Please check the spelling or enter its SMILES string directly.")
    )
    
    query.mol <- parse.smiles(toConvert)[[1]]
    findSimilarDrugs(query.mol)
    
    })
  })

  output$similarDrugs <- renderDataTable({
  
  validate(need(input$string != "", message = FALSE))
  vals <- createDrugTable()
  vals <- processProcessDat(vals)
  return(vals)
  }, escape = FALSE, options = list(searching = FALSE)) 
  
  drugSimMatrix <- eventReactive(input$compute, {
    lista_drugs <- unlist(strsplit(input$ListA, "\n"))
    if (input$self) {
      listb_drugs <- lista_drugs
    }
    else {
      listb_drugs <-  unlist(strsplit(input$ListB, "\n"))
    }
    return(matrix(0, nrow = length(lista_drugs), ncol = length(listb_drugs), dimnames=list(lista_drugs, listb_drugs)))
  })
  
  output$Results <- renderTable({
    drugSimMatrix()
  })
})

