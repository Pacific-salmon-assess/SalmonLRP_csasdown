remotes::install_github("vlucet/rgovcan")
library(rgovcan)
library(here)
library(bcmaps)
library(ggplot2)
library(sf)
library(ggspatial)
library(purrr)
library(rgdal)
library(PNWColors)
#library(leaflet)

# where map data shapefiles are saved
# Note that the files are all stored in the english Case Study paper folder
path <- here("caseStudyWP", "data")

# Download Salmon Conservation Unit shapefiles
# id of the Conservation Unit spatial data on open.canada.ca
ids <- c( "f86c0867-d38d-4072-bd08-57cbbcbafa46", # chum
          "2f4bd945-f47e-47e3-9108-79f6ee39242c", # chinook
          "bfeb3ecd-b99a-4d1a-b8c1-87373f31f4bd") # coho
# function to download the shapefile data
dlf <- function(x, path) {
 govcan_dl_resources( govcan_get_record(record_id=x), included="shp", path=path)
}
# for checking if data is present
folders <- paste0(c("Chum", "Chinook", "Coho"), "_Salmon_CU_Boundary")
# download the shapefiles if at least one is not present
if(!all(folders %in%  list.files(here(path))))
  walk(ids, dlf, path=path)
# unzip .zip files
# get zip file locations
zips <- here(path,list.files(path, pattern="zip"))
# unzip
if(!all(folders %in%  list.files(here(path))))
  walk(zips, unzip, exdir=here(path))
# Read in species shapefiles
chum_cu <- st_read(here("caseStudyWP","data","Chum_Salmon_CU_Shape", "Chum_Salmon_CU_Boundary", "CM_CU_BOUNDARY_En.shp"))
#coho_cu <- st_read(here("caseStudyWP","data","Coho_Salmon_CU_Shape", "Coho_Salmon_CU_Boundary", "Coho_Salmon_CU_Boundary_En_edit.shp")) # includes manual edit removing area below Hell's Gate, done in QGIS
coho_cu <- st_read(here("caseStudyWP","data", "CO_CU_BOUNDARY_En_edit.shp")) # includes manual edit removing area below Hell's Gate, done in QGIS
chinook_cu <- st_read(here("caseStudyWP","data","Chinook_Salmon_CU_Shape", "Chinook_Salmon_CU_Boundary", "CK_CU_BOUNDARY_En.shp"))

# # Get just Nahatlatch for IFR Coho Fraser Canyon CU boundary- downloaded from https://maps.gov.bc.ca/ess/hm/imap4m/ 
# nahat <- st_read(here("caseStudyWP", "data", "FWA_NAMED_WATERSHEDS_POLY", "FWNMDWTRSH_polygon.shp"))

# Provincial and US Borders and Coastlines (not using rgovcan because they are more complicated file source urls)
download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/canvec/shp/Admin/canvec_1M_CA_Admin_shp.zip', destfile=here("caseStudyWP",'data/can_admin.zip'), mode="wb")
fs <- unzip(zipfile=here('caseStudyWP/data/can_admin.zip'), list=TRUE) # get all files
# just unzip region boundaries
unzip(zipfile=here("caseStudyWP",'data/can_admin.zip'),  files=fs$Name[grep("region", fs$Name)], exdir=here('CaseStudyWP/data'))
borders <- st_read(here("caseStudyWP",'data/canvec_1M_CA_Admin/geo_political_region_2.shp'))

# Rivers + lakes
# This one takes ~20 min to download, don't download if already present
options(timeout = max(5000, getOption("timeout")))
if(!file.exists(here("caseStudyWP",'data/canvec_50K_BC_Hydro/waterbody_2.shp')))
download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/canvec/shp/Hydro/canvec_50K_BC_Hydro_shp.zip', destfile=here('caseStudyWP/data/rivers_lakes.zip'), mode="wb")
fs1 <- unzip(zipfile=here('caseStudyWP/data/rivers_lakes.zip'), list=TRUE) # get all files
# Unzip (large file)
unzip(zipfile=here("caseStudyWP",'data/rivers_lakes.zip'), files=fs1$Name[grep("waterbody_2", fs1$Name)], exdir=here("caseStudyWP",'data'))
water <- st_read(here("caseStudyWP",'data/canvec_50K_BC_Hydro/waterbody_2.shp'))
water <- water[!water$definit_en == "Ocean", ] # remove ocean polygons
# get area of water objects
water$area_m2 <- as.numeric(st_area(water))
# remove small lakes, < 10,000 m2 area
water1 <- water[!(water$definit_en=="Lake" & water$area_m2 < 100000), ]

# Point shapefile of place names for labels
if(!file.exists(here("caseStudyWP",'data/canvec_50K_BC_Toponymy/bdg_named_feature_0.shp')))
download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/canvec/shp/Toponymy/canvec_50K_BC_Toponymy_shp.zip', destfile=here("caseStudyWP",'data/place_names.zip'), mode="wb")
fs2 <- unzip(zipfile=here("caseStudyWP",'data/place_names.zip'), list=TRUE)
unzip(zipfile=here("caseStudyWP",'data/place_names.zip'), files=fs2$Name[grep("bdg_named_feature_0", fs2$Name)], exdir=here('caseStudyWP/data'))
pnames <- st_read(here("caseStudyWP",'data/canvec_50K_BC_Toponymy/bdg_named_feature_0.shp'))

# Dowdload DFO Fishery Management areas shapefile from:
# https://catalogue.data.gov.bc.ca/dataset/dfo-statistical-areas-boundaries#edc-pow
fma <- st_read(here("caseStudyWP","data/DFO_PFMA_STAT_AREA_BDRY_SP/DFO_STAT_A_polygon.shp"))

areas <- c(12:19,28,29) # make vector of areas used in chum analysis
fma <- fma[!fma$MNGMNTR==0, ] # remove small areas (?)
fma <- fma[fma$MNGMNTR %in% areas, ] # keep only areas used in chum analysis



# get bc_maps layers
# bc <- bc_bound_hres()
# av<- available_layers()

# Define global colours
water_col <- "deepskyblue"
land_col <- "antiquewhite"

# Chum map -------------

# get south coast chum CUs
sc_cus <- c("Southern Coastal Streams", "Northeast Vancouver Island", "Upper Knight", "Loughborough", "Bute Inlet", "Georgia Strait", "Howe Sound-Burrard Inlet")
# Get just the 5 CUs without CU-level infilling
sc_cus_no_CU_infilled <- c("Southern Coastal Streams", "Northeast Vancouver Island", "Loughborough","Georgia Strait", "Howe Sound-Burrard Inlet")
#scc <- chum_cu[chum_cu$CU_name %in% sc_cus_no_CU_infilled, ] # get sf object of just south coast chum CUs
scc <- chum_cu[chum_cu$CU_NAME %in% sc_cus, ] # get sf object of just south coast chum CUs
scc$CU_NAME <- sub("Upper Knight", "Inlet Knight supérieur", scc$CU_NAME) # change names to french
scc$CU_NAME <- sub("Bute Inlet", "Inlet Bute", scc$CU_NAME) # change names to french
scc$CU_NAME <- sub("Southern Coastal Streams", "Cours d’eau de la côte sud", scc$CU_NAME) # change names to french
scc$CU_NAME <- sub("Northeast Vancouver Island", "Nord-est de l’île de Vancouver", scc$CU_NAME) # change names to french
scc$CU_NAME <- sub("Georgia Strait", "Détroit de Géorgie", scc$CU_NAME) # change names to french
scc$CU_NAME <- sub("Howe Sound-Burrard Inlet", "Baie Howe et inlet Burrard", scc$CU_NAME) # change names to french



# get bounds
bounds <- as.numeric(st_bbox(scc))

# Get palette
pal <- pnw_palette("Cascades", length(scc$CU_NAME), type="continuous")

# function to remove extra polygons from fishery management areas with multiple polygons
# for labelling (otherwise, makes duplicate labels)
drop_multi_poly  <- function(y) {
  a <- as.data.frame(y[ y$MNGMNTR %in% names(which(table(y$MNGMNTR) >1)), ]) # get multi-polygon area rows
  small_areas <- aggregate(formula = AREA_SQM ~ MNGMNTR, data=a, FUN="min") # get smallest polygons in sets
  y[!y$AREA_SQM %in% small_areas$AREA_SQM, ] # select not small polygons
}

# plot with ggplot
png(here("caseStudyWP_FN","figure/chum-map.png"), width=8, height=7, units="in", res=600)
ggplot(scc) +
  #geom_sf(data=fma,colour="coral", size=1, fill=NA) +
  geom_sf(data=borders[!borders$ctry_en == "Ocean",], fill=land_col, size=0.1, colour="black") +
  geom_sf(data=scc, aes(fill=CU_NAME), size=0) +
  geom_sf(data=water1, fill=water_col, colour=water_col, size=0.1) +
  geom_sf_label(data=scc, aes(label = CU_NAME, colour=CU_NAME),  size=4.5, fontface="bold") +
  #geom_sf_label(data=drop_multi_poly(fma), aes(label = MNGMNTR), size=3,label.size=0.1, colour="coral",alpha=0.7, fontface="bold") +
  annotate( geom="text", label = "Colombie-Britannique", x = -121.8, y = 49.5, color = "grey22", size = 4) +
  annotate( geom="text", label = "WASHINGTON", x = -121.8, y = 48.5, color = "grey22", size = 4) +
  annotate( geom="text", label = "Océan Pacifique", x = -127.7, y = 49.3, fontface = "italic", color = "darkblue", size = 4) +
  annotate( geom="text", label = "Mer des Salish", x = -123.8, y = 49.3, fontface = "italic", color = "darkblue", size = 3, angle=327) +
  scale_fill_manual( values=pal, guide=NULL) +
  scale_colour_manual( values=pal, guide=NULL) +
  coord_sf(xlim = bounds[c(1,3)] + c(0,1) , ylim = bounds[c(2,4)]) +
  scale_x_continuous(breaks=seq(-128,-122,1)) +
  xlab(NULL) +
  ylab(NULL) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering, width=unit(0.3, "in")) +
  theme_classic() +
  theme(panel.background = element_rect(fill="aliceblue") )
dev.off()

# plot with ggplot with fisheries management areas
# png("Figures/chum_map_fishing_areas.png", width=8, height=7, units="in", res=300)
# ggplot(scc) +
#   geom_sf(data=fma,colour="coral", size=1, fill=NA) +
#   geom_sf(data=borders[!borders$ctry_en == "Ocean",], fill="antiquewhite", size=0) +
#   geom_sf(data=scc, aes(fill=CU_name), size=0) +
#   geom_sf(data=lakes, fill="cornflowerblue", colour="cornflowerblue", size=0.001) +
#   geom_sf(data=riv, fill="cornflowerblue", colour="cornflowerblue", size=0.001) +
#   geom_sf_label(data=scc, aes(label = CU_name, colour=CU_name),  size=4.5, fontface="bold") +
#   geom_sf_label(data=drop_multi_poly(fma), aes(label = MNGMNTR), size=3,label.size=0.1, colour="coral",alpha=0.7, fontface="bold") +
#   annotate( geom="text", label = "BRITISH COLUMBIA", x = -121.8, y = 49.5, color = "grey22", size = 4) +
#   annotate( geom="text", label = "WASHINGTON", x = -121.8, y = 48.5, color = "grey22", size = 4) +
#   annotate( geom="text", label = "Pacific Ocean", x = -127.7, y = 49.3, fontface = "italic", color = "darkblue", size = 4) +
#   annotate( geom="text", label = "Salish Sea", x = -123.8, y = 49.3, fontface = "italic", color = "darkblue", size = 3, angle=327) +
#   scale_fill_manual( values=pal, guide=NULL) +
#   scale_colour_manual( values=pal, guide=NULL) +
#   coord_sf(xlim = bounds[c(1,3)] + c(0,1) , ylim = bounds[c(2,4)]) +
#   scale_x_continuous(breaks=seq(-128,-122,1)) +
#   xlab(NULL) +
#   ylab(NULL) +
#   annotation_scale(location = "bl", width_hint = 0.5) +
#   annotation_north_arrow(location = "bl", which_north = "true",
#                          pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
#                          style = north_arrow_fancy_orienteering, width=unit(0.3, "in")) +
#   theme_classic() +
#   theme(panel.background = element_rect(fill="aliceblue") )
# dev.off()

# Coho
ifc_cus <- c("Fraser Canyon", "Interior Fraser", "Lower Thompson", "South Thompson", "North Thompson")
head(coho_cu)
unique(coho_cu$CU_NAME)
ifc <- coho_cu[coho_cu$CU_NAME %in% ifc_cus, ] # get sf object of just interior fraser coho CUs
ifc$CU_NAME <- sub("Interior Fraser", "Moyen Fraser", ifc$CU_NAME) # 
ifc$CU_NAME <- sub("North Thompson", "Thompson Nord", ifc$CU_NAME) # 
ifc$CU_NAME <- sub("South Thompson", "Thompson Sud", ifc$CU_NAME) # 
ifc$CU_NAME <- sub("Lower Thompson", "Thompson inférieure", ifc$CU_NAME) # 
ifc$CU_NAME <- sub("Fraser Canyon", "Canyon du Fraser", ifc$CU_NAME) # 


# get bounds
bounds <- as.numeric(st_bbox(ifc))

# Get palette
pal <- pnw_palette("Starfish", length(ifc$CU_NAME), type="continuous")

png(here("caseStudyWP_FN","figure/coho-map.png"), width=8, height=7, units="in", res=600)
ggplot(ifc) +
  #geom_sf(data=fma,colour="coral", size=1, fill=NA) +
  geom_sf(data=borders[!borders$ctry_en == "Ocean",], fill=land_col, size=0.1, colour="black") +
  geom_sf(data=ifc, aes(fill=CU_NAME), size=0) +
  geom_sf(data=water1, fill=water_col, colour=water_col, size=0.1) +
  geom_sf(data=borders[borders$juri_en == "Alberta",], fill=land_col, size=0) +
  geom_sf_label(data=ifc, aes(label = CU_NAME, colour=CU_NAME),  size=4.5, fontface="bold") +
  #geom_sf_label(data=drop_multi_poly(fma), aes(label = MNGMNTR), size=3,label.size=0.1, colour="coral",alpha=0.7, fontface="bold") +
  annotate( geom="text", label = "Colombie-Britannique", x = -119, y = 49.3, color = "grey22", size = 4) +
  annotate( geom="text", label = "WASHINGTON", x = -121.8, y = 48.5, color = "grey22", size = 4) +
  #annotate( geom="text", label = "Pacific Ocean", x = -127.7, y = 49.3, fontface = "italic", color = "darkblue", size = 4) +
  #annotate( geom="text", label = "Salish Sea", x = -123.8, y = 49.3, fontface = "italic", color = "darkblue", size = 3, angle=327) +
  scale_fill_manual( values=pal, guide=NULL) +
  scale_colour_manual( values=pal, guide=NULL) +
  coord_sf(xlim = bounds[c(1,3)] + c(0,1) , ylim = bounds[c(2,4)]) +
  #scale_x_continuous(breaks=seq(-128,-122,1)) +
  xlab(NULL) +
  ylab(NULL) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering, width=unit(0.3, "in")) +
  theme_classic() +
  theme(panel.background = element_rect(fill="aliceblue") )
dev.off()

# Chinook
unique(chinook_cu$CU_NAME)
wvc <- chinook_cu[grep("West Vancouver Island", chinook_cu$CU_NAME), ]
wvc$CU_NAME <- sub("_.*", "", wvc$CU_NAME)
wvc$CU_NAME <- sub("West Vancouver Island-North", "Ouest de l’île de Vancouver – nord", wvc$CU_NAME) 
wvc$CU_NAME <- sub("West Vancouver Island-Nootka & Kyuquot", "Ouest de l’île de Vancoucer – Nootka et Kyuquot", wvc$CU_NAME) 
wvc$CU_NAME <- sub("West Vancouver Island-South", "Ouest de l’île de Vancouver – sud", wvc$CU_NAME)

# get bounds 
ck_bounds <- as.numeric(st_bbox(wvc))
# Get palette
pal <- pnw_palette("Sunset", length(wvc$CU_NAME), type="continuous")
# get labels for inlets
#inlets <- c("Quatsino", "Kyuquot", "Nootka / Esperenza", " ", "Clayoquot", "Barkley Sound", "Nitinat ", "San Juan")
inlets <- c("Quatsino", "Kyuquot", "Nootka Sound", "Esperanza Inlet", "Clayoquot", "Barkley Sound", "Nitinat Lake", "San Juan Point")
inlets1 <- paste0("^", inlets, "$")
keep <- grep(paste(inlets1, collapse="|"), pnames$name_en)
chk_lab <- pnames[keep, ]
chk_lab <- chk_lab[!duplicated(chk_lab$name_en), ] # remove duplicated labels
chk_lab$name_en[grep("Nitinat Lake", chk_lab$name_en)]  <- "Nitinat"
chk_lab$name_en[grep("San Juan Point", chk_lab$name_en)] <- "San Juan"


# French
chk_lab$name_en <- sub("Esperanza Inlet", "Inlet Esperanza", chk_lab$name_en)
chk_lab$name_en <- sub("Barkley Sound", "Baie Barkley", chk_lab$name_en)



png(here("caseStudyWP_FN","figure/chinook-map.png"), width=8, height=7, units="in", res=600)
ggplot(wvc) +
  #geom_sf(data=fma,colour="coral", size=1, fill=NA) +
  geom_sf(data=borders[!borders$ctry_en == "Ocean",], fill=land_col, size=0.1, colour="black") +
  geom_sf(data=wvc, aes(fill=CU_NAME), size=0) +
  geom_sf(data=water1, fill=water_col, colour=water_col, size=0.1) +
  geom_sf_label(data=wvc, aes(label = CU_NAME, colour=CU_NAME), 
                nudge_y = c(0.3,0.25,0.5), nudge_x = c(1.5,1.5,1), size=4.5, fontface="bold") +
  #geom_sf_label(data=drop_multi_poly(fma), aes(label = MNGMNTR), size=3,label.size=0.1, colour="coral",alpha=0.7, fontface="bold") +
  #annotate( geom="text", label = "BRITISH COLUMBIA", x = -119, y = 49.3, color = "grey22", size = 4) +
  #annotate( geom="text", label = "WASHINGTON", x = -121.8, y = 48.5, color = "grey22", size = 4) +
  geom_sf_text(data=chk_lab, aes(label=name_en))+
  #annotate( geom="text", label = "Pacific Ocean", x = -127.7, y = 49.3, fontface = "italic", color = "darkblue", size = 4) +
  #annotate( geom="text", label = "Salish Sea", x = -123.8, y = 49.3, fontface = "italic", color = "darkblue", size = 3, angle=327) +
  scale_fill_manual( values=pal, guide=NULL) +
  scale_colour_manual( values=pal, guide=NULL) +
  coord_sf(xlim = ck_bounds[c(1,3)] + c(0,1) , ylim = ck_bounds[c(2,4)]) +
  #scale_x_continuous(breaks=seq(-128,-122,1)) +
  xlab(NULL) +
  ylab(NULL) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering, width=unit(0.3, "in")) +
  theme_classic() +
  theme(panel.background = element_rect(fill="aliceblue") )
dev.off()


# plot with leaflet - nice basemap but harder to do label
# cent <- as.data.frame(st_coordinates(st_centroid(scc)))
# cent$X[1] <- -122 # adjust Howe Sound Burrard Inlet label position
# m <-   leaflet(scc) %>%
#   #addTiles() %>%
#   addWMSTiles(baseUrl = "https://services.arcgisonline.com/arcgis/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}.png",
#               layers = "1", options = WMSTileOptions(format = "image/png", transparent = TRUE)) %>%
#   addPolygons(color= pal, fillColor=pal) %>%
#   addPolygons(color="black", fillColor=NULL) %>%
#   addLabelOnlyMarkers(lat=cent$Y, lng=cent$X, label=scc$CU_name,
#                       labelOptions = labelOptions(textOnly = TRUE, permanent=TRUE, direction="centre" ,
#                                                    style= list(
#                                                      "color" = pal[1:7],
#                                                   #   "font-family" = "serif",
#                                                      "font-style" = "bold",
#                                                   #   "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
#                                                      "font-size" = "14px"
#                                                   #   "border-color" = "rgba(0,0,0,0.5)"
#                                                   ) ))
# m
# mapview::mapshot(m, file="Figures/fig_chum_CU_map.png")
#




