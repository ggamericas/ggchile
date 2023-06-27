################# Compute panel function ###########

#' Title
#'
#' @param data
#' @param scales
#' @param county
#'
#' @return
#' @export
#'
#' @examples
#' library(dplyr)
#' #nc_flat |> rename(fips = FIPS) |> compute_county_nc() |> head()
#' #nc_flat |> rename(fips = FIPS) |> compute_county_nc(county = "Ashe")
compute_county_nc <- function(data, scales, county = NULL){

  reference_filtered <- reference_full
  #
  if(!is.null(county)){

    county %>% tolower() -> county

    reference_filtered %>%
      dplyr::filter(.data$county_name %>%
                      tolower() %in%
                      county) ->
      reference_filtered

  }

  # to prevent overjoining
  reference_filtered %>%
    dplyr::select("fips", "geometry", "xmin",
                  "xmax", "ymin", "ymax") ->
    reference_filtered


  data %>%
    dplyr::inner_join(reference_filtered) %>% # , by = join_by(fips)
    dplyr::mutate(group = -1) %>%
    dplyr::select(-fips) #%>%
    # sf::st_as_sf() %>%
    # sf::st_transform(crs = 5070)

}


###### Specify ggproto ###############

StatCountync <- ggplot2::ggproto(`_class` = "StatCountync",
                               `_inherit` = ggplot2::Stat,
                               compute_panel = compute_county_nc,
                               default_aes = ggplot2::aes(geometry =
                                                            ggplot2::after_stat(geometry)))



########### geom function, inherits from sf ##################

#' Title
#'
#' @param mapping
#' @param data
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' nc_flat %>%
#' ggplot() +
#' aes(fips = FIPS) +
#' geom_sf_countync()
geom_sf_countync <- function(
                                 mapping = NULL,
                                 data = NULL,
                                 position = "identity",
                                 na.rm = FALSE,
                                 show.legend = NA,
                                 inherit.aes = TRUE,
                                 crs = "NAD27", # "NAD27", 5070, "WGS84", "NAD83", 4326 , 3857
                                 ...
                                 ) {

                                 c(ggplot2::layer_sf(
                                   stat = StatCountync,  # proto object from step 2
                                   geom = ggplot2::GeomSf,  # inherit other behavior
                                   data = data,
                                   mapping = mapping,
                                   position = position,
                                   show.legend = show.legend,
                                   inherit.aes = inherit.aes,
                                   params = rlang::list2(na.rm = na.rm, ...)),
                                   coord_sf(crs = crs,
                                            default_crs = sf::st_crs(crs),
                                            datum = crs,
                                            default = TRUE)
                                 )

}



