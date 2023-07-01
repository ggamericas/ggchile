################# Compute panel function ###########

#' Title
#'
#' @param data
#' @param scales
#' @param keep_region
#'
#' @return
#' @export
#'
#' @examples
#' library(dplyr)
#' #chile_region_flat |> rename(fips = FIPS) |> compute_region_chile() |> head()
#' #chile_region_flat |> rename(fips = FIPS) |> compute_region_chile(keep_region = "Ashe")
compute_region_chile <- function(data, scales, keep_region = NULL){

  reference_filtered <- chile_region_reference
  #
  if(!is.null(keep_region)){

    keep_region %>% tolower() -> keep_region

    reference_filtered %>%
      dplyr::filter(.data$region_codigo %>%
                      tolower() %in%
                      keep_region) ->
      reference_filtered

  }

  # to prevent overjoining
  reference_filtered %>%
    dplyr::select("region_codigo", "geometry", "xmin",
                  "xmax", "ymin", "ymax") ->
    reference_filtered


  data %>%
    dplyr::inner_join(reference_filtered) %>% # , by = join_by(fips)
    dplyr::mutate(group = -1) %>%
    dplyr::select(-region_codigo) #%>%
    # sf::st_as_sf() %>%
    # sf::st_transform(crs = 5070)

}


###### Specify ggproto ###############

Statregionchile <- ggplot2::ggproto(`_class` = "Statregionchile",
                               `_inherit` = ggplot2::Stat,
                               compute_panel = compute_region_chile,
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
#' chile_region_flat %>%
#' ggplot() +
#' aes(region_codigo = region_codigo) +
#' geom_sf_regionchile()
geom_sf_regionchile <- function(
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
                                   stat = Statregionchile,  # proto object from step 2
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



