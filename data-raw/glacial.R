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

source("data-raw/header.R")

## Load CSV data file from BC Data Catalogue. Data licensed under the Open Data License-BC
## See metadata record in BC Data Catalogue for details on the data set.
glacial <- read_csv("https://catalogue.data.gov.bc.ca/dataset/89ff86d7-2d04-4c96-b945-ba56688906eb/resource/bf6ba520-dcfd-4a6b-a822-963b77ff7848/download/glacierchange1985-2005.csv")

glacial$StartYear <- 1985L
glacial$EndYear <- 2005L

glacial$Indicator <- "Glacial Area"

glacial$Units <- "percent"
glacial$Period <- 10L

glacial %<>% mutate(Estimate = Percentage_Area_Change / (EndYear - StartYear + 1) * Period)

glacial$Ecoprovince %<>% tolower() %>% tools::toTitleCase()
glacial$Ecoprovince %<>%  factor(levels = ecoprovince)

glacial %<>% select(
  Indicator, Units, Period, StartYear, EndYear, Ecoprovince,
  Estimate = Percentage_Area_Change)

glacial %<>% filter(!is.na(Estimate))

glacial %<>% arrange(Indicator, Ecoprovince, StartYear, EndYear)

use_data(glacial, overwrite = TRUE)
