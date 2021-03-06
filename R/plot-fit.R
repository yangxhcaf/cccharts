# Copyright 2016 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' Plot Trend Observed
#'
#' Plots trends with observed data.
#'
#' @inheritParams plot_estimates_pngs
#' @inheritParams plot_fit_pngs
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' plot_fit(cccharts::flow_station_timing, cccharts::flow_station_timing_observed,
#'   facet = "Station", nrow = 2)
plot_fit <- function(data, observed, facet = NULL, nrow = NULL, ylimits = NULL,
                     ybreaks = waiver(), xbreaks = waiver(), ylab = ylab_fit, free_y = FALSE) {
  check_flag(free_y)

  test_estimate_data(data)
  test_observed_data(observed)

  data %<>% complete_estimate_data()
  observed %<>% complete_observed_data()


  check_all_identical(data$Indicator)

  if (data$Units[1] %in% c("percent", "Percent")) {
    data %<>% rescale_data()
    data$Units <- observed$Units[1]
  }
  if (data$Units[1] != observed$Units[1])
    stop("inconsistent units", call. = FALSE)

  suppressMessages(observed %<>% dplyr::inner_join(data))
  suppressMessages(data %<>% dplyr::semi_join(observed))

  observed %<>% dplyr::filter_(~Year >= StartYear, ~Year <= EndYear)

  if (!is.null(facet)) {
    check_vector(facet, "", min_length = 1, max_length = 2)
    check_cols(data, facet)
  }

  data %<>% change_period(1L)

  data %<>% add_segment_xyend(observed)

  if (data$Units[1] %in% c("percent", "Percent")) {
    data %<>% dplyr::mutate_(y = ~y / 100,
                             yend = ~yend / 100)
    observed %<>% dplyr::mutate_(Value = ~Value/100)
    if (is.numeric(ybreaks))
      ybreaks %<>% magrittr::divide_by(100)
    if (is.numeric(ylimits))
      ylimits %<>% magrittr::divide_by(100)
  }

  data$Significant %<>% factor(levels = c("TRUE", "FALSE"))
  levels(data) <- c("Significant", "Insignificant")

  gp <- ggplot(observed, aes_string(x = "Year", y = "Value")) +
    geom_point(alpha = 1/3) +
    scale_y_continuous(ylab(data), labels = get_labels(observed),
                       limits = ylimits, breaks = ybreaks)

  if (is.vector(xbreaks))
    gp <- gp + scale_x_continuous(breaks = xbreaks)

    gp <- gp + geom_segment(data = data, aes_string(x = "x", xend = "xend", y = "y", yend = "yend", alpha = "Significant"), size = 1.5)
  gp <- gp + scale_alpha_manual(values = c(1,1/2), drop = FALSE, guide = FALSE)

  if (free_y) {
    scales = "free_y"
  } else {
    scales = "fixed"
  }
  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow, scales = scales)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]), scales = scales)
  }
  gp <- gp + theme_cccharts(facet = !is.null(facet), map = FALSE)
  gp
}

#' Fit PNGS
#'
#' @inheritParams plot_estimates_pngs
#' @param observed A data.frame of the observed data.
#' @param free_y A flag indicating whether the facet axis should have free_y scales.
#' @export
plot_fit_pngs <- function(
  data = cccharts::precipitation, observed, by = "Indicator", facet = NULL, nrow = NULL, width = 450L, height = 450L, ask = TRUE, dir = NULL, ylimits = NULL, ybreaks = waiver(), xbreaks = waiver(), ylab = ylab_fit,
  free_y = FALSE, prefix = "") {

  test_estimate_data(data)
  test_observed_data(observed)
  check_flag(ask)
  check_flag(free_y)
  check_vector(by, "", min_length = 1)
  if (!is.function(ylab)) stop("ylab must be a function", call. = FALSE)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  if (!abs_path(dir)) {
    dir <- file.path("cccharts", "fit", dir)
  }

  data %<>% complete_estimate_data()
  observed %<>% complete_observed_data()
  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (data$Units[1] %in% c("percent", "Percent")) {
    data %<>% rescale_data()
    data$Units <- observed$Units[1]
  }

  suppressMessages(data %<>% dplyr::semi_join(observed))
  suppressMessages(observed %<>% dplyr::semi_join(data))

  data %<>% plyr::dlply(by, fun_png, observed = observed, facet = facet, nrow = nrow, dir = dir,
              width = width, height = height, ylimits = ylimits,
              ybreaks = ybreaks, xbreaks = xbreaks,
              ylab = ylab, free_y = free_y,
              fun = plot_fit, prefix = prefix, by = by, suffix = "fit")

  invisible(data)
}
