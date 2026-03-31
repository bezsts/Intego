# Data visualization

```r
library(tidyverse)
library(palmerpenguins)
library(ggthemes)
```

## Intro

With ggplot2, you begin a plot with the function **ggplot()**.

The **mapping** argument defines how variables in your dataset are
mapped to visual properties (**aesthetics**) of your plot.

We need to define a **geom**: the geometrical object that a plot uses to
represent data. These geometric objects are available with functions
that start with **geom\_**

We can improve the labels of our plot using the **labs()**.

To facet your plot by a single variable, use **facet_wrap()**.

```r
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g) 
) + 
  geom_point(mapping = aes(colour = species, shape = species)) + 
  geom_smooth(method = "lm") + 
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind() +
  facet_wrap(~island)
```

![](Data-visualization_files/figure-commonmark/unnamed-chunk-2-1.png)