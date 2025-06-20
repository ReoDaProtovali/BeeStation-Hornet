/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded, as set in _maps/_basemap.dm. SSmapping is
responsible for loading every non-hardcoded z-level.

As of 2018-02-04, the typical z-levels for a single-level station are:
1: CentCom
2: Station
3-4: Randomized space
5: Mining
6: City of Cogs
7-11: Randomized space
12: Empty space
13: Transit space

Multi-Z stations are supported and multi-Z mining and away missions would
require only minor tweaks.
*/

#define SPACERUIN_MAP_EDGE_PAD 15

/// Distance from edge to move to another z-level
#define TRANSITIONEDGE 7

// Maploader bounds indices
/// The maploader index for the maps minimum x
#define MAP_MINX 1
/// The maploader index for the maps minimum y
#define MAP_MINY 2
/// The maploader index for the maps minimum z
#define MAP_MINZ 3
/// The maploader index for the maps maximum x
#define MAP_MAXX 4
/// The maploader index for the maps maximum y
#define MAP_MAXY 5
/// The maploader index for the maps maximum z
#define MAP_MAXZ 6

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_REEBE "Reebe"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
#define ZTRAIT_DYNAMIC_LEVEL "Dynamic Level"
#define ZTRAIT_LAVA_RUINS "Lava Ruins"
#define ZTRAIT_POCKETDIM "Pocket Dimension"
#define ZTRAIT_ISOLATED_RUINS "Isolated Ruins" //Placing ruins on z levels with this trait will use turf reservation instead of usual placement.
#define ZTRAIT_DEBUG "Debug Level"

// boolean - weather types that occur on the level
#define ZTRAIT_ASHSTORM "Weather_Ashstorm"
#define ZTRAIT_ACIDRAIN "Weather_Acidrain"
#define ZTRAIT_VOIDSTORM "Weather_Voidstorm"
/// number - bombcap is multiplied by this before being applied to bombs
#define ZTRAIT_BOMBCAP_MULTIPLIER "Bombcap Multiplier"

/// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

// Whether this z level is linked up/down. Bool.
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

/// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
	/// UNAFFECTED if absent - no space transitions
	#define UNAFFECTED null
	/// SELFLOOPING - space transitions always self-loop
	#define SELFLOOPING "Self"
	/// CROSSLINKED - mixed in with the cross-linked space pool
	#define CROSSLINKED "Cross"

/// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

/// default trait definitions, used by SSmapping
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE)
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = SELFLOOPING, ZTRAIT_STATION = TRUE)
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = SELFLOOPING, ZTRAIT_DYNAMIC_LEVEL = TRUE)
#define ZTRAITS_LAVALAND list(\
	ZTRAIT_MINING = TRUE, \
	ZTRAIT_LAVA_RUINS = TRUE, \
	ZTRAIT_BOMBCAP_MULTIPLIER = 2, \
	ZTRAIT_ASHSTORM = TRUE, \
	ZTRAIT_BASETURF = /turf/open/lava/smooth/lava_land_surface)
#define ZTRAITS_REEBE list(ZTRAIT_REEBE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 0.5)
#define ZTRAITS_DEBUG list(ZTRAIT_DEBUG = TRUE)
#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

/// boolean - does this z prevent phasing
#define ZTRAIT_NOPHASE "No Phase"


/// must correspond to _basemap.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list(\
	DECLARE_LEVEL("CentCom", ZTRAITS_CENTCOM),\
)

// Camera lock flags
#define CAMERA_LOCK_STATION 1
#define CAMERA_LOCK_MINING 2
#define CAMERA_LOCK_CENTCOM 4
#define CAMERA_LOCK_REEBE 8

/// Reserved/Transit turf type
#define RESERVED_TURF_TYPE /turf/open/space/basic			//What the turf is when not being used

//Ruin Generation

#define PLACEMENT_TRIES 100 //! How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)

#define PLACE_DEFAULT "random"
#define PLACE_SAME_Z "same" //On same z level as original ruin
#define PLACE_SPACE_RUIN "space" //On space ruin z level(s)
#define PLACE_LAVA_RUIN "lavaland" //On lavaland ruin z levels(s)
#define PLACE_BELOW "below" //On z levl below - centered on same tile
#define PLACE_ISOLATED "isolated" //On isolated ruin z level

///Map generation defines
#define PERLIN_LAYER_HEIGHT "perlin_height"
#define PERLIN_LAYER_HUMIDITY "perlin_humidity"
#define PERLIN_LAYER_HEAT "perlin_heat"

#define BIOME_LOW_HEAT "low_heat"
#define BIOME_LOWMEDIUM_HEAT "lowmedium_heat"
#define BIOME_HIGHMEDIUM_HEAT "highmedium_heat"
#define BIOME_HIGH_HEAT "high_heat"

#define BIOME_LOW_HUMIDITY "low_humidity"
#define BIOME_LOWMEDIUM_HUMIDITY "lowmedium_humidity"
#define BIOME_HIGHMEDIUM_HUMIDITY "highmedium_humidity"
#define BIOME_HIGH_HUMIDITY "high_humidity"

//Echo surface pathing define
#define ECHO_TEMPLATE_PATH(path) ispath(path, /datum/map_template/random_room/echo)

///Hint for whether a genturf should generate as a closed or open turf. null for default.
#define GENTURF_HINT_OPEN "open"
#define GENTURF_HINT_CLOSED "closed"

#define SPACE_KEY "space"


// Bluespace shelter deploy checks
/// Shelter spot is allowed
#define SHELTER_DEPLOY_ALLOWED "allowed"
/// Shelter spot has turfs that restrict deployment
#define SHELTER_DEPLOY_BAD_TURFS "bad turfs"
/// Shelter spot has areas that restrict deployment
#define SHELTER_DEPLOY_BAD_AREA "bad area"
/// Shelter spot has anchored objects that restrict deployment
#define SHELTER_DEPLOY_ANCHORED_OBJECTS "anchored objects"

#define STARLIGHT_MODE_STARLIGHT "starlight"
#define STARLIGHT_MODE_CYCLE "cycle"

//Individual defines
#define CLUSTER_CHECK_NONE				0  			//No checks are done, cluster as much as possible
#define CLUSTER_CHECK_DIFFERENT_TURFS	(1<<1)  //Don't let turfs of DIFFERENT types cluster
#define CLUSTER_CHECK_DIFFERENT_ATOMS	(1<<2)  //Don't let atoms of DIFFERENT types cluster
#define CLUSTER_CHECK_SAME_TURFS		(1<<3)  //Don't let turfs of the SAME type cluster
#define CLUSTER_CHECK_SAME_ATOMS		(1<<4) 	//Don't let atoms of the SAME type cluster

//Combined defines
#define CLUSTER_CHECK_SAMES				24 //Don't let any of the same type cluster
#define CLUSTER_CHECK_DIFFERENTS		6  //Don't let any of different types cluster
#define CLUSTER_CHECK_ALL_TURFS			10 //Don't let ANY turfs cluster same and different types
#define CLUSTER_CHECK_ALL_ATOMS			20 //Don't let ANY atoms cluster same and different types

//All
#define CLUSTER_CHECK_ALL				30 //Don't let anything cluster, like, at all

// Ruin generation
#define OPEN_CONNECTION 1
#define ROOM_CONNECTION 16
