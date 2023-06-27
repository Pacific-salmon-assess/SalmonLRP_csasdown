ABSTRACT
CanVec is a digital cartographical reference product produced by Natural Resources Canada. It originates from the best available data sources covering Canadian territory, 
offers quality topographical information in vector format and complies with international geomatics standards. CanVec is a multi-source product coming mainly from the National 
Topographic Data Base (NTDB), the Mapping the North process conducted by the Canada Center for Mapping and Earth Observation (CCMEO), the Atlas of Canada data, the GeoBase initiative 
and the data update using satellite imagery coverage (e.g. Landsat 7, Spot, Radarsat, etc). CanVec contains more than 60 topographical features organized into 8 themes: Transport Features, 
Administrative Features, Hydro Features, Land Features, Man-Made Features, Elevation Features, Resource Management Features and Toponymic Features. 

CANVEC PRODUCT DOCUMENTATION:
1-Feature Catalogue
2-Info.html
3-Product Specifications
4-Product Distribution Formats
5-Shapefile attribute names
6-Transition Guide between former and new codification
7-Feature List
8-Mapping Symbols for the FGDB format
9-Release Note

1- FEATURE CATALOGUE
A catalogue contains the entity names, definitions, codes, geometries, and attributes. Each theme has its own Feature Catalogue.
2- INFO.HTML
The info.html file eases the navigation through the Catalogues, Product Specifications, and Product Distribution Formats.
3-PRODUCT SPECIFICATIONS
Document describing the product and its characteristics :  access to the data, reference system, data quality and maintenance.
4- PRODUCT DISTRIBUTION FORMATS
Document describing the distribution formats (GML, Shapefile and FGDB).
5- SHAPEFILE ATTRIBUTE NAMES
Document containing the lookup table linking  the attribute names in the catalogue and the attribute names in the Shapefile format.
6- TRANSITION GUIDE BETWEEN THE FORMER AND NEW CANVEC CODING
The CanVec_en_Transition document ensures the correlation between former and new CanVec coding. 
7- FEATURE LIST
The document CanVec_Code contains the list of entities and the scales at which they are available.
8- MAPPING SYMBOLS FOR THE FGDB FORMAT
The CanVec_en_symbol file contains all map symbols but can only be used with FDGB file format.
9- RELEASE NOTE
The Release note document lists all updates, improvements, and corrections in the data since the last publication.

FTP FOLDER STRUCTURE:
1st level is the format: shp (Shapefile) or FDGB
2nd level is the theme: 
	Transport (Transport Features), Admin (Administrative Features), Hydro (Hydro Features), Land (Land Features), ManMade (Man-Made Features), 
	Elevation (Elevation Features), Res_MGT (Resource Management Features), and Toponymy (Toponymic Features)

3rd level contains the compressed files. The file naming, includes:
	Scale Code:
		50k – best source of data
		250k – NTDB source at the scale of 1:250 000 (generalization for NRN and NRWN)
		1M –Atlas of Canada source at the scale of 1:1 000 000
		5M– Atlas of Canada source at the scale of 1:5 000 000
		15M– Atlas of Canada source at the scale of 1:15 000 000
	Province, territory or Canada code:
		PE, NL, NS, NB, QC, ON, MB, SK, AB, BC, NU, NT, YK, and CA.

ARCHIVES:
Access to the CanVec former version published on May 15, 2013: canvec_archive_20130515 
http://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/canvec/archive/canvec_archive_20130515/
Access to the CanVec+ former version published on October 29, 2015: canvec+_archive_20151029 
http://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/canvec/archive/canvec+_archive_20151029/
