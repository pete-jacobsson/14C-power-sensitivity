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
