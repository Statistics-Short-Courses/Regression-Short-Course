library(tidyverse)

n_part <- 5
n_obs <- 10
mu_00 <- 100
mu_01 <- 5 #between-person effect
mu_10 <- -2 #withinperson effect

nonindependence_df <- tibble(
  participant = c("Anne", "John", "Laura", "Mary", "Steve"),
  intake_mean = seq(from = 1, to = 10, by = 2),
  u0 = rnorm(n_part, 0, 2)
) |>
  mutate(
    IQ_baseline = mu_00 + mu_01 * intake_mean + u0,
    β_within = mu_10
  ) |>
  mutate(obs = list(1:n_obs)) |>
  unnest(obs) |>
  mutate(
    intake = intake_mean + rnorm(n_obs, 0, 2),
    dev_intake = intake - intake_mean,
    IQ = IQ_baseline + β_within * dev_intake + rnorm(n(), 0, 3)
  )

nonindependence_df |>
  ggplot() +
  aes(x = IQ, y = intake, colour = factor(participant)) +
  geom_point()
