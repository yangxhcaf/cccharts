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

#' Theme
#'
#' ggplot2 theme for cccharts plots
#'
#' @param facet A flag indicating whether to use the theme for facetted graphs.
#' @param map A flag indicating whether to use the theme for maps.
#' @param base_family Base font family for plotting
#' @seealso \code{\link[envreportutils]{theme_soe}} and
#'  \code{\link[envreportutils]{theme_soe_facet}}
#' @export
theme_cccharts <- function(facet = FALSE, map = FALSE, base_family = "") {
  if (facet) {
    theme <- envreportutils::theme_soe_facet(base_family = base_family)
  } else
    theme <- envreportutils::theme_soe(base_family = base_family)

  theme <- theme + theme(
    plot.title = element_text(size = rel(1.2)),
    axis.title.y = element_text(size = 14),
    axis.title.x = element_blank(),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    axis.line = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.border = element_rect(colour = "grey50", fill = NA),
    panel.background = element_rect(colour = "grey50", fill = NA),
    legend.position = ("bottom"),
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 11),
    legend.direction = ("horizontal"),
    legend.key = element_rect(color = "white", fill = NA),
    strip.text.x = element_text(size = 12)
    )

  if (map) {
    theme <- theme + theme(
      panel.grid = element_blank(),
      panel.border = element_blank(),
      panel.background = element_rect(color = "white", fill = NA),
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank()
    )
  }
  theme
}
