## code to prepare `DATASET` dataset goes here


###### 0. Read in shape file data  #####

library(sf)
northcarolina_sf <- st_read(system.file("shape/nc.shp", package="sf"))

### save as is if desired #####
usethis::use_data(northcarolina_sf, overwrite = TRUE)


#### 1, create polygon reference dataframe w xmin, ymin, xmax and ymax and save
northcarolina_county_reference <- northcarolina_sf |>
  ggnc::create_geometries_reference(
                            id_cols = c(NAME, FIPS)) |>
  dplyr::rename(county_name = NAME,
         fips = FIPS)

usethis::use_data(northcarolina_county_reference, overwrite = TRUE)


####### 2. create and save flat file for examples, if desired ####

northcarolina %>%
  sf::st_drop_geometry() ->
northcarolina_flat

usethis::use_data(northcarolina_flat, overwrite = TRUE)

############### 3. create polygon centers and labels reference data frame

# county centers for labeling polygons

northcarolina_county_centers <- northcarolina_sf |>
  dplyr::rename(county_name = NAME,
                fips = FIPS) |>
  ggnc::prepare_polygon_labeling_data(id_cols = c(county_name, fips))


usethis::use_data(northcarolina_county_centers, overwrite = TRUE)
