## code to prepare `DATASET` dataset goes here


###### 0. Read in shape file data  #####

library(sf)
nc <- st_read(system.file("shape/nc.shp", package="sf"))

### save as is if desired #####
usethis::use_data(nc, overwrite = TRUE)


#### 1, create polygon reference dataframe w xmin, ymin, xmax and ymax and save
reference_full <- nc |>
  ggnc::create_geometries_reference(
                            id_cols = c(NAME, FIPS)) |>
  dplyr::rename(county_name = NAME,
         fips = FIPS)

usethis::use_data(reference_full, overwrite = TRUE)


####### 2. create and save flat file for examples, if desired ####

nc %>%
  sf::st_drop_geometry() ->
nc_flat

usethis::use_data(nc_flat, overwrite = TRUE)

############### 3. create polygon centers and labels reference data frame

# county centers for labeling polygons

nc_county_centers <- nc |>
  dplyr::rename(county_name = NAME,
                fips = FIPS) |>
  ggnc::prepare_polygon_labeling_data(id_cols = c(county_name, fips))


usethis::use_data(nc_county_centers, overwrite = TRUE)
