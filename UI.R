library(shiny)

shinyUI(
  navbarPage("Drug Similarity Search",
             tabPanel("DRUGNET Similarity Search",
                      fluidPage(
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("optn", label = "Search by:", choice = c("Chemical Name", "SMILES String")),
                            textInput("string", label = h4("Input a Chemical Identifer")),
                            checkboxGroupInput("studies", label = h4("Studies"), list("CCLE", "CGP", "GRAY", "GNE", "GSK", "CTRP", "NCI60")),
                            sliderInput("cutoff", label = h4("Cutoff in %"), min = 0, max = 100, value = 50),
                            checkboxInput("row", label = "Display one row per drug", value = FALSE),
                            checkboxInput("smiles", label = "Display SMILES", value = FALSE),
                            checkboxInput("inchikey", label = "Display InChIKey", value = FALSE),
                            checkboxInput("chembl", label = "Display links to ChEMBL", value = FALSE),
                            actionButton("change", "Submit!")
                          ),
                          mainPanel(
                            p("Search for similar drugs in large pharmacogenomic studies given an input drug name or SMILES id."),
                            p("Current studies include CCLE, CGP, GRAY, GNE, GSK, CTRP, and NCI60."),
                            p("Similarity of two drugs is defined by the Tanimoto similarity of their extended fingerprints, as computed using rcdk package."),
                            p("Enter a query drug and press submit to complete a search. By default, an input drug will be searched against drugs in all studies."),
                            textOutput("params"),
                            h3("Results"),
                            dataTableOutput("similarDrugs"),
                            downloadLink('downloadResults', 'Export results to CSV')
                          )
                        )
                      )),
             tabPanel("Custom Similarity Search",
                      fluidPage(
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("optn", label = "Search by:", choice = c("Chemical Name", "SMILES String")),
                            uiOutput("prompt"),
                            p("Enter a list of chemical identifers, each of the same kind and on a new line."),
                            h3("List A"),
                            tags$textarea(id="ListA", cols=40, rows=3),
                            h3("List B"),
                            tags$textarea(id="ListB", cols=40, rows=3),
                            checkboxInput("self", label = "Compare all drugs in List A against themselves", value = FALSE),
                            selectInput("choice", label = h3("Fingerprint"), choice = list("Extended", "Standard" , "Graph" , "PubChem"), selected = "Extended"),
                            actionButton("compute", "Submit!")
                            ),
                          mainPanel(
                            p("Returns the drug similarity matrix of all drugs identified in list A against all drugs identified in list B."),
                            p("Similarity of drugs is the Tanimoto similarity of their fingerprints, according to the users' choice."),
                            h3("Results"),
                            tableOutput("Results")
                            )
                          )
                        ))
             ))

