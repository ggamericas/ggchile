# step 00 reference data
# chile_region_centers <- data.frame(     x   =  -81.49496,   y = 36.42112,  region_name = "Ashe",   fips = "37009")


# step 1
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
#' #chile_region_flat |>
#' #  dplyr::rename(fips = FIPS) |>
#' #  dplyr::rename(label = NAME) |>
#' #  compute_panel_region_centers()
compute_panel_region_centers <- function(data,
                                         scales,
                                         keep_region = NULL){

  chile_region_centers_filtered <- chile_region_centers

  if(!is.null(keep_region)){
    keep_region %>% tolower() -> keep_region

    chile_region_centers_filtered %>%
      dplyr::filter(.data$region_name %>%
                      tolower() %in%
                      keep_region) ->
      chile_region_centers_filtered}

  data %>%
    dplyr::inner_join(chile_region_centers_filtered) %>%
    dplyr::select(x, y, label)

}




# step 2 proto
Statregioncenters <- ggplot2::ggproto(
  `_class` = "StatRownumber",
  `_inherit` = ggplot2::Stat,
  # required_aes = c("label"), # for some reason this breaks things... why?
  compute_panel = compute_panel_region_centers
)

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
#'  ggplot() +
#'  aes(region_codigo = region_codigo, label = region_codigo) +
#'  geom_label_chile_region()
#'
#' chile_region_flat %>%
#'  ggplot() +
#'  aes(region_codigo = region_codigo, label = region_codigo) +
#'  geom_sf_regionchile() +
#'  geom_label_chile_region()
#'
#'  chile_region_flat %>%
#'  ggplot() +
#'  aes(region_codigo = region_codigo, label = region_codigo) +
#'  geom_sf_regionchile(fill = "navyblue") +
#'  geom_label_chile_region(color = "oldlace")
#'

geom_label_chile_region <- function(
  mapping = NULL,
  data = NULL,
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = Statregioncenters,  # proto object from Step 2
    geom = ggplot2::GeomText,  # inherit other behavior
    data = data,
    mapping = mapping,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

