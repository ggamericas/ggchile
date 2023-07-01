## code to prepare `DATASET` dataset goes here


###### 0. Read in shape file data  #####

library(sf)
chile_region_sf <- chilemapas::generar_regiones() |>
  dplyr::rename(region_codigo = codigo_region)

### save as is if desired #####
usethis::use_data(chile_region_sf, overwrite = TRUE)


#### 1, create polygon reference dataframe w xmin, ymin, xmax and ymax and save
chile_region_reference <- chile_region_sf |>
  ggnc::create_geometries_reference(
                            id_cols = c(region_codigo))

usethis::use_data(chile_region_reference, overwrite = TRUE)


####### 2. create and save flat file for examples, if desired ####

chile_region_reference %>%
  sf::st_drop_geometry() ->
chile_region_flat

usethis::use_data(chile_region_flat, overwrite = TRUE)

############### 3. create polygon centers and labels reference data frame

# region centers for labeling polygons

chile_region_centers <- chile_region_sf |>
  ggnc::prepare_polygon_labeling_data(id_cols = c(region_codigo))


usethis::use_data(chile_region_centers, overwrite = TRUE)
