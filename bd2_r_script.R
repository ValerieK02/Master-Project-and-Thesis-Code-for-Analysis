# THE FOLLOWING R SCRIPT IS A CODE FOR MAKING A SUMMARY TABLE BASED ON THE RAW BD2 OUTPUT

# 1. SETTINGS
# Folder containing the BatDetect2 CSV files
input_folder <- "/Users/valerie/batdetect2-main/manually_identified_bat_calls/Enil_with_Pnat_and_Ppyg_Important_Output"

# Where the finished summary table should be saved
output_file <- "/Users/valerie/batdetect2-main/manually_identified_bat_calls/Enil_with_Pnat_and_Ppyg_Important_Output_R_Script_Summary_Table/r_script_summary_table.csv"


# 2. FIND ALL CSV FILES

csv_files <- list.files(
  path = input_folder,
  pattern = "\\.csv$",
  full.names = TRUE
)

# 3. CREATE EMPTY LIST FOR RESULTS
summary_rows <- list()

# 4. PROCESS EACH RECORDING

for (csv_file in csv_files) {
  
  # Read the CSV file
  data <- read.csv(csv_file)
  
  # Get the recording/file name
  recording <- basename(csv_file)
  
  
  # Find all species detected in this recording
  species_list <- unique(data$class)
  
  
  # Process each species separately
  for (species in species_list) {
    
    # Keep only detections belonging to this species
    species_data <- data[data$class == species, ]
    
    
    # Create one summary row for this recording × species
    summary_row <- data.frame(
      
      recording = recording,
      species = species,
      
      # Number of detected calls
      number_of_calls = nrow(species_data),
      
      # Detection probability
      mean_det_prob = mean(species_data$det_prob, na.rm = TRUE),
      max_det_prob = max(species_data$det_prob, na.rm = TRUE),
      
      # Classification probability
      mean_class_prob = mean(species_data$class_prob, na.rm = TRUE),
      max_class_prob = max(species_data$class_prob, na.rm = TRUE),
      
      # Low frequency
      mean_low_freq = mean(species_data$low_freq, na.rm = TRUE),
      min_low_freq = min(species_data$low_freq, na.rm = TRUE),
      max_low_freq = max(species_data$low_freq, na.rm = TRUE),
      
      # High frequency
      mean_high_freq = mean(species_data$high_freq, na.rm = TRUE),
      min_high_freq = min(species_data$high_freq, na.rm = TRUE),
      max_high_freq = max(species_data$high_freq, na.rm = TRUE)
    )
    
    
    # Add this row to the results
    summary_rows[[length(summary_rows) + 1]] <- summary_row
  }
}

# 5. COMBINE ALL ROWS INTO ONE SUMMARY TABLE

summary <- do.call(rbind, summary_rows)

# 6. SAVE THE SUMMARY TABLE

write.csv(
  summary,
  output_file,
  row.names = FALSE
)

# 7. CONFIRM THAT IT WORKED

print("Summary created successfully.")

print(paste("Saved to:", output_file))

# Show the first few rows
head(summary)
