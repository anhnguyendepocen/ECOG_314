### make files for Lecture 6
makeSurveyData <- function(n = 1) {
  idVector <- as.vector("ab1234")
  sampleID <- ""
  
  for(j in 1:n) {
      sampleID <- paste(c(sample(LETTERS, 2),
                          sample(seq(0:9), 4, replace = T)),
                          collapse = "", sep = "")
     
    
  
     surveyData <- data.frame(date = seq(as.Date("2015-01-02"), by = "week", length = 52),
                             id = sampleID,
                             deposits = c(floor(runif(1, 20000, 100000)), rep(0, 51)),
                             loans = c(floor(runif(1, 20000, 100000)), rep(0, 51))
                             )
     
    
    idVector <- c(idVector, sampleID)
    
    for(i in 2:52) { 
      surveyData$deposits[i] <- floor(surveyData$deposits[i - 1] * runif(1, .99, 1.01))
      surveyData$loans[i] <- floor(surveyData$loans[i - 1] * runif(1, 0.99, 1.01))
    }
    
    write.csv(surveyData, paste0("bankSurveys/survey_", sprintf("%03d", j, 0), ".csv"), 
              row.names = F)
  }
}