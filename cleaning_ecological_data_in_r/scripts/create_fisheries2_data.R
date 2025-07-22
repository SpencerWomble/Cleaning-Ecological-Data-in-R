library(dplyr)
library(lubridate)
# Set seed for reproducibility
set.seed(456)
# Create base vectors with exactly 50 rows each
n_rows <- 50
# Site IDs - 5 sites with 10 observations each
site_id <- rep(c("Lake_Hartwell_A", "Lake_Hartwell_B", "Clarks_Hill_A", 
                 "West_Point_A", "Sinclair_A"), each = 10)
# Create sampling dates with irregular frequency patterns
sampling_date <- as.Date(character(0))
# Each site gets exactly 10 dates
for(i in 1:5) {
  if(i %in% c(1, 3)) {
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
  "Micropterus salmoides", "Lepomis macrochirus", "Pomoxis nigromaculatus",
  # Misspelled
  "Micropterus salmoides", "Lepomis macrochirus",
  # Genus only
  "Micropterus salmoides", "Lepomis macrochirus",
  # Uncapitalized
  "Micropterus salmoides", "Lepomis macrochirus",
  # More variety
  "Ictalurus punctatus", "Ictalurus punctatus", "Ictalurus punctatus"
)
species <- rep(species_pool, length.out = n_rows)
# Gear types
gear_type <- sample(c("Gillnet_2inch", "Gillnet_3inch", "Gillnet_4inch", 
                      "Electrofishing"), n_rows, replace = TRUE)
# Count column with missing value issues
count_values <- c(
  sample(0:25, 25, replace = TRUE),  # Regular counts
  rep(NA, 5),                       # NA values
  rep("", 4),                       # Empty strings
  rep("none", 6),                   # Text "none"
  rep("nothing caught", 5),         # Text "nothing caught"
  rep("0", 5)                       # Character zeros
)
count <- sample(count_values, n_rows, replace = TRUE)
# Weight column with typo issues
weight_values <- c(
  round(runif(41, 0.5, 8.5), 2),    # Normal fish weights (0.5-8.5 kg)
  rep("no weight recorded", 3),      # Text entries
  c(1250, 3400, 8920)               # Extremely high values (likely typos - should be 1.25, 3.4, 8.92)
)
weight <- sample(weight_values, n_rows, replace = TRUE)
# Coordinates - all in decimal degrees
lat_decimal <- c(34.3969, 34.3887, 33.6598, 32.8796, 33.1234)
longitude_decimal <- c(-82.9375, -82.9298, -82.1971, -85.1174, -84.1234)
# Create coordinate vectors (each site gets same coordinates repeated 10 times)
latitude <- rep(lat_decimal, each = 10)
longitude <- rep(longitude_decimal, each = 10)
# Create the main dataset
fisheries2 <- data.frame(
  site_id = site_id,
  sampling_date = sampling_date,
  species = species,
  gear_type = gear_type,
  count = count,
  weight = weight,
  latitude = latitude,
  longitude = longitude,
  stringsAsFactors = FALSE
)
# Add some duplicate rows (exact duplicates)
duplicate_rows <- fisheries2[c(8, 15, 25, 35), ]
fisheries2 <- rbind(fisheries2, duplicate_rows)
# Shuffle the dataset to make duplicates less obvious
fisheries2 <- fisheries2[sample(nrow(fisheries2)), ]
fisheries2 <- fisheries2 %>%
  mutate(count = ifelse(row_number() == 21, 155, count))
# Reset row names
rownames(fisheries2) <- NULL
# save as a csv
write.csv(fisheries2, "data/fisheries2.csv")
