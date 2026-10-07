# THE FOLLOWING R SCRIPT CREATES A SUMMARY TABLE FROM THE BSG-BATS OUTPUT

# 1. SETTINGS

# BSG-BATS input file
input_file <- "/Users/valerie/bsgbat/manually_identified_bat_calls/Enil_with_Pnat_and_Ppyg_Important_Output/bsgbats_results.txt"

# Where the finished summary table should be saved
output_file <- "/Users/valerie/bsgbat/manually_identified_bat_calls/Enil_with_Pnat_and_Ppyg_Important_Output_Summary/summary_table.csv"


# 2. READ THE BSG-BATS OUTPUT

lines <- readLines(input_file)


# 3. CREATE EMPTY LIST FOR RESULTS

summary_rows <- list()


# 4. PROCESS EACH RECORDING

for (line in lines) {
  
  # Separate recording path from BSG-BATS predictions
  parts <- strsplit(line, "\t", fixed = TRUE)[[1]]
  
  # Get only the recording filename, not the full path
  recording <- basename(parts[1])
  
  # Skip recordings with no species prediction
  if (length(parts) < 2 || parts[2] == "") {
    next
  }
  
  # Separate species names and their associated values
  predictions <- strsplit(parts[2], ",", fixed = TRUE)[[1]]
  
  
  # Process each species/value pair
  for (i in seq(1, length(predictions), by = 2)) {
    
    species <- predictions[i]
    bsgbats_value <- as.numeric(predictions[i + 1])
    
    # Create one row for this recording × species
    summary_rows[[length(summary_rows) + 1]] <- data.frame(
      recording = recording,
      species = species,
      bsgbats_value = bsgbats_value
    )
  }
}


# 5. CREATE FINAL SUMMARY TABLE

summary <- do.call(rbind, summary_rows)


# 6. SAVE SUMMARY

write.csv(
  summary,
  output_file,
  row.names = FALSE
)


# 7. FINISHED

print("BSG-BATS summary created successfully.")

print(paste(
  "Number of species rows:",
  nrow(summary)
))

print(paste(
  "Saved to:",
  output_file
))