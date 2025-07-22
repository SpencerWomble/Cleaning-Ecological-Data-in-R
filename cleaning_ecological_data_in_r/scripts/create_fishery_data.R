# Georgia Reservoir Fish Survey Dataset for QA/QC Workshop
# This dataset contains intentional data quality issues for teaching purposes

library(dplyr)
library(lubridate)

# Set seed for reproducibility
set.seed(123)

# Create base vectors with exactly 100 rows each
n_rows <- 100

# Site IDs - 10 sites with 10 observations each
site_id <- rep(c("Lake_Lanier_A", "Lake_Lanier_B", "Clarks_Hill_A", "Clarks_Hill_B",
                 "West_Point_A", "West_Point_B", "Hartwell_A", "Hartwell_B", 
                 "Sinclair_A", "Sinclair_B"), each = 10)

# Create sampling dates with irregular frequency patterns
sampling_date <- as.Date(character(0))

# Each site gets exactly 10 dates
for(i in 1:10) {
  if(i %in% c(1, 3, 5)) {
    # Sites with irregular sampling - create exactly 10 dates
    dates <- c(seq(as.Date("2023-01-15"), by="month", length.out=6),
               seq(as.Date("2023-07-08"), by="week", length.out=4))
  } else {
    # Regular monthly sampling - exactly 10 dates
    dates <- seq(as.Date("2023-01-15"), by="month", length.out=10)
  }
  sampling_date <- c(sampling_date, dates)
}

# Species names with QA/QC issues (cycling through problematic entries)
species_pool <- c(
  # Correct names
  "Micropterus salmoides", "Lepomis macrochirus", "Pomoxis nigromaculatus",
  "Cyprinus carpio", "Morone saxatilis",
  # Common names
  "Largemouth bass", "Bluegill", "Black crappie", 
  # Misspelled
  "Micropterus salmonides", "Lepomis machrochirus",
  # Genus only
  "Micropterus", "Lepomis", "Pomoxis",
  # Uncapitalized
  "micropterus salmoides", "lepomis macrochirus",
  # More variety
  "Ictalurus punctatus", "Channel catfish", "ictalurus punctatus",
  "Dorosoma cepedianum", "Gizzard shad"
)

species <- rep(species_pool, length.out = n_rows)

# Gear types
gear_type <- sample(c("Gillnet_2inch", "Gillnet_3inch", "Gillnet_4inch", 
                      "Electrofishing"), n_rows, replace = TRUE)

# Count column with missing value issues
count_values <- c(
  sample(0:25, 50, replace = TRUE),  # Regular counts
  rep(NA, 10),                      # NA values
  rep("", 8),                       # Empty strings
  rep("none", 12),                  # Text "none"
  rep("nothing caught", 10),        # Text "nothing caught"
  rep("0", 10)                      # Character zeros
)

count <- sample(count_values, n_rows, replace = TRUE)

# Coordinates - all in decimal degrees (need exactly 10 values for 10 sites)
lat_decimal <- c(
  34.2104, 34.2089, 33.6598, 33.6712, 32.8796, 
  32.8801, 34.3969, 34.3887, 33.1234, 34.5678
)

longitude_decimal <- c(
  -83.8768, -83.8756, -82.1971, -82.2045, -85.1174,
  -85.1189, -82.9375, -82.9298, -84.1234, -83.5678
)

# Create coordinate vectors (each site gets same coordinates repeated 10 times)
latitude <- rep(lat_decimal, each = 10)
longitude <- rep(longitude_decimal, each = 10)

# Create the main dataset
fishery_data <- data.frame(
  site_id = site_id,
  sampling_date = sampling_date,
  species = species,
  gear_type = gear_type,
  count = count,
  latitude = latitude,
  longitude = longitude,
  stringsAsFactors = FALSE
)

# Add some duplicate rows (exact duplicates)
duplicate_rows <- fishery_data[c(15, 23, 45, 67, 89), ]
fishery_data <- rbind(fishery_data, duplicate_rows)

# Shuffle the dataset to make duplicates less obvious
fishery_data <- fishery_data[sample(nrow(fishery_data)), ]

# Reset row names
rownames(fishery_data) <- NULL

# Display the first 20 rows
print("Georgia Reservoir Fish Survey Dataset (First 20 rows)")
head(fishery_data, 20)

# Print summary information
cat("\nDataset Summary:\n")
cat("Total rows:", nrow(fishery_data), "\n")
cat("Total columns:", ncol(fishery_data), "\n")
cat("Date range:", min(fishery_data$sampling_date), "to", max(fishery_data$sampling_date), "\n")

# Show QA/QC issues present
cat("\nQA/QC Issues Present:\n")
cat("- Unique species entries:", length(unique(fishery_data$species)), "\n")
cat("- Count column data types:", paste(unique(class(fishery_data$count)), collapse=", "), "\n")
cat("- Coordinate formats: Mixed decimal degrees and DMS\n")
cat("- Duplicate rows: 5 exact duplicates present\n")
cat("- Sampling frequency: Irregular at some sites\n")


# add a typo to the count to make an outlier
fishery_data <- fishery_data %>%
  mutate(count = ifelse(row_number() == 9, 199, count))

# Export to CSV for use in workshop
write.csv(fishery_data, "data/georgia_reservoir_fish_survey.csv", row.names = FALSE)

saveRDS(fishery_data, "data/georgia_reservoir_fish_survey.RDS")


cat("\nDataset saved as 'georgia_reservoir_fish_survey.csv'\n")
