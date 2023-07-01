#' Title
#'
#' @param data
#' @param scales
#' @param region
#'
#' @return
#' @export
#'
#' @examples
#' library(dplyr)
#' #chile_region_flat |> rename(fips = FIPS) |> compute_region_chile() |> head() |> str()
#' #chile_region_flat |> rename(fips = FIPS) |> compute_region_chile(keep_region = "Ashe")
compute_region_chile_stamp <- function(data, scales, keep_region = NULL){

  reference_filtered <- chile_region_reference
  #
  if(!is.null(keep_region)){

    keep_region %>% tolower() -> keep_region

    reference_filtered %>%
      dplyr::filter(.data$region_name %>%
                      tolower() %in%
                      keep_region) ->
      reference_filtered

  }

  reference_filtered %>%
    dplyr::select("region_codigo", "geometry", "xmin",
                  "xmax", "ymin", "ymax") ->
    reference_filtered


  reference_filtered %>%
    dplyr::mutate(group = -1)

}


Statregionchilestamp <- ggplot2::ggproto(`_class` = "Statregionchilestamp",
                               `_inherit` = ggplot2::Stat,
                               compute_panel = compute_region_chile_stamp,
                               default_aes = ggplot2::aes(geometry =
                                                            ggplot2::after_stat(geometry)))



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
#' ggplot() +
#' stamp_sf_regionchile()
stamp_sf_regionchile <- function(
                                 mapping = NULL,
                                 data = reference_full,
                                 position = "identity",
                                 na.rm = FALSE,
                                 show.legend = NA,
                                 inherit.aes = TRUE,
                                 crs = "NAD27", #WGS84, NAD83
                                 ...
                                 ) {

                                 c(ggplot2::layer_sf(
                                   stat = Statregionchilestamp,  # proto object from step 2
                                   geom = ggplot2::GeomSf,  # inherit other behavior
                                   data = data,
                                   mapping = mapping,
                                   position = position,
                                   show.legend = show.legend,
                                   inherit.aes = inherit.aes,
                                   params = rlang::list2(na.rm = na.rm, ...)),
                                   coord_sf(crs = crs,
                                            # default_crs = sf::st_crs(crs),
                                            # datum = sf::st_crs(crs),
                                            default = TRUE)
                                 )

}






