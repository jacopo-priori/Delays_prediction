#  Library we will use
suppressWarnings (library (dplyr, quietly=TRUE))

#  Read the airport codes as character instead of factor as we will be manipulating them.
dfAirports <- read.csv("C:/Users/megar/OneDrive/Documenten/Business Analytics Management/Exchange/Course/Predictive Analytics/Group assignment/DBA3803/Data/airports.csv", stringsAsFactors=FALSE)
colClasses <- c ('integer', 'integer', 'integer', 'integer', 'factor', 
                 'integer', 'factor', 'character', 'character', 
                 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 
                 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL')
dfFlights <- read.csv ("C:/Users/megar/OneDrive/Documenten/Business Analytics Management/Exchange/Course/Predictive Analytics/Group assignment/DBA3803/Data/flights_old.csv")





origin_airports <- unique (dfFlights$ORIGIN_AIRPORT)
destination_airports <- unique (dfFlights$DESTINATION_AIRPORT)
airport_lookup <- unique (dfAirports$IATA_CODE)

cat ("UNMATCHED ORIGIN AIRPORTS: ", length (setdiff (origin_airports, airport_lookup)))
  
cat ("UNMATCHED DESTINATION AIRPORTS: ", length (setdiff (destination_airports, airport_lookup)))


setwd("C:/Users/megar/OneDrive/Documenten/Business Analytics Management/Exchange/Course/Predictive Analytics/Group assignment/DBA3803D/Data")

# find working directory
getwd()
#' Convert Department of Transportation 5 digit Airport ID values into 
#' their corresponding 3 character IATA values.
#'
#' Any 3 character IATA values in the vector will pass through unmodified.
#'
#' @param x Vector. The input can be either numeric or character.
#' @return A character vector the same length as `x` with 5 digit Airport ID values 
#'   replaced by their 3 character IATA values.
#' @seealso
#' @export
#' @examples
#' # The function will accept integers
#' x <- c(10135L, 10136L, 10140L)
#' Airport_ID_to_IATA (x)
#'
#' # The function can also work with character values, with IATA codes mixed in.
#' x <- c("10135", "DSM", "10136", "MSP", "10140")
#' Airport_ID_to_IATA (x)
#'
Airport_ID_to_IATA <- function (x) {

  #  Step 0: Initial setup 
  #  Load the incoming vector into a data frame, so we can use dplyr functions to join things up.
  df <- data.frame (ID = as.character (x), stringsAsFactors = FALSE)
  #  Store the number of records - used to make sure joins do not introduce duplicates
  num_records = nrow (df)


  #  Step 1: Add the Description to the base data.
  dfAirportID <- read.csv ("Data/L_AIRPORT_ID.csv",
                           colClasses=c("character", "character"), col.names=c("AirportID", "Description"))
  df <- dplyr::left_join (df, dfAirportID, by=c("ID" = "AirportID"))


  #  Step 2: Use Description to add the IATA_CODE to the base data.
  dfAirport <- read.csv ("Data/L_AIRPORT.csv",
                         colClasses=c("character", "character"), col.names=c("IATA_CODE", "Description"))
  #
  #  There are duplicated airports. To solve this problem, clear out codes discontinued before 2015.
  #  BSM was discontinued in 1999.
  #  The IATA does not use NYL for Yuma, it uses YUM. So remove NYL.
  dfAirport <- dfAirport [! (dfAirport$IATA_CODE %in% c('BSM', 'NYL')),]
  
  df <- dplyr::left_join (df, dfAirport, by="Description")


  #  Step 3: Make sure we have the same number of rows that we started with
  #          If this error is triggered, steps will need to be made to eliminate 
  #          duplicate key values.
  if (num_records != nrow (df)) {
    stop ("Due to duplicates in the data, the number of records has changed.")
  }


  #  Step 4: In cases where we didn't get a matching IATA_CODE, copy over the original value
  df$ID <- dplyr::coalesce (df$IATA_CODE, df$ID)

  
  #  Step 5: We are all done. Return the results. 
  return (df$ID)
}


dfFlights$ORIGIN_AIRPORT <- Airport_ID_to_IATA (dfFlights$ORIGIN_AIRPORT)
dfFlights$DESTINATION_AIRPORT <- Airport_ID_to_IATA (dfFlights$DESTINATION_AIRPORT)

origin_airports <- unique (dfFlights$ORIGIN_AIRPORT)
destination_airports <- unique (dfFlights$DESTINATION_AIRPORT)
airport_lookup <- unique (dfAirports$IATA_CODE)

"UNMATCHED ORIGIN AIRPORTS: "
print (setdiff (origin_airports, airport_lookup))

"UNMATCHED DESTINATION AIRPORTS: "
print (setdiff (destination_airports, airport_lookup))

# lets look at the how Origin airport are distributed in a graph
dfFlights %>%
  group_by (ORIGIN_AIRPORT) %>%
  summarize (count=n()) %>%
  arrange (desc (count)) %>%
  print(n=628)


# save the csv file with the updated airport codes
write.csv (dfFlights, "Data/flights_withcode.csv", row.names=FALSE)
