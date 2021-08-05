singles_011_results %>%
  mutate(target_year = round(measurement_error)) %>%
  group_by(1) %>%
  summarize(
    check = sum(accuracy_68)
  ) %>%
  head()

singles_011_results[,1]
