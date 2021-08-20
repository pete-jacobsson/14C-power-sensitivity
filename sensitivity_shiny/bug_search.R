singles_011_results %>%
  mutate(target_year = round(measurement_error)) %>%
  group_by(1) %>%
  summarize(
    check = sum(accuracy_68)
  ) %>%
  head()

singles_011_results$V1

test <- "potato"

case_when(
  test == "target_year" ~ "Target Year",
  test == "potato" ~ "Potatofish"
)



plyr::round_any(1331, 110)

singles_011_results %>%
  mutate(
    target_year  = plyr::round_any(target_year, 400),
    measurement_error = plyr::round_any(measurement_error, 2),
    offset_magnitude  = plyr::round_any(offset_magnitude, 4)
  ) %>%
  group_by(target_year, offset_magnitude) %>%
  summarize(
    ratio_68 = mean(accuracy_68),
    ratio_95 = mean(accuracy_95)
  ) %>%
  ggplot(aes(target_year, offset_magnitude, fill = ratio_68)) +
  geom_raster(interpolate = TRUE) +
  theme_minimal()
