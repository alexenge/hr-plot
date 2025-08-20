# remotes::install_github("grimbough/FITfileR")

library("dplyr")
library("FITfileR")
library("jpeg")
library("ggplot2")
library("ggpubr")
library("here")

fit_file_alex <- here("data", "15409799043_ACTIVITY.fit")
fit_alex <- readFitFile(fit_file_alex)

bg_file <- here("data", "loessnig.jpg")
bg_img <- readJPEG(bg_file)

df_alex <- fit_alex %>%
  records() %>%
  bind_rows() %>%
  arrange(timestamp) %>%
  filter(between(heart_rate, 80, 200))

output_file <- here("output", "hr_plot.png")

p <- df_alex %>%
  ggplot(aes(x = distance, y = heart_rate)) +
  background_image(bg_img) +
  geom_point(color = "#BB2649", shape = 16, size = 3.0, alpha = 0.8) +
  annotate(
    "rect",
    xmin = 0.0,
    xmax = max(df_alex$distance),
    ymin = 194,
    ymax = 215,
    fill = "#000000",
    alpha = 0.25
  ) +
  annotate(
    "text",
    x = c(165, 1460, 2650),
    y = 205,
    label = c(
      "15.05.2024",
      "51°18'02.202\", 012°24'24.597\"\n27°C, 50% rF, 14 km/h NNW",
      "SPORTPLATZ LÖẞNIG"
    ),
    color = "#BBAAAA",
    size = c(16.0, 5.3, 16.0),
    family = "Fira Sans",
    hjust = 0.0,
    alpha = 0.7
  ) +
  annotate(
    "text",
    x = c(430, 1470, 2580, 3750, 4850),
    y = 107,
    label = c(
      "600 m\n1'56\"",
      "1000 m\n3'14\"",
      "600 m\n1'58\"",
      "1000 m\n3'19\"",
      "600 m\n1'54\""
    ),
    color = "#887777",
    size = 5.4,
    family = "Fira Sans",
    hjust = 0.5,
  ) +
  coord_cartesian(ylim = c(75, 215), expand = FALSE) +
  theme_void() +
  theme(aspect.ratio = 13 / 18)

ggsave(output_file, width = 13, height = 18, dpi = 300)
