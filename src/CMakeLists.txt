cmake_minimum_required( VERSION 3.6 )

project( SketchupShapeFitting )


#add boost
set(Boost_USE_STATIC_LIBS		ON)
set(Boost_USE_STATIC_RUNTIME	ON)
set(BOOST_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../externals/builds-boost")
find_package( Boost 1.69 REQUIRED )

#add glm
set(glm_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../externals/builds-glm/lib/cmake/glm")
find_package(glm 0.9.7 REQUIRED)

#gte
set(GTE_INC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../externals/builds-gte/include")

#----------------globals----------------
include_directories(${Boost_INCLUDE_DIRS})

#----------------targets----------------
add_library(ImportExportLib STATIC
	io/import.cpp io/import.h
	io/export.cpp io/export.h
	"${CMAKE_CURRENT_SOURCE_DIR}/../ThirdParty/TinyObjLoader/tiny_obj_loader.h"
	"${CMAKE_CURRENT_SOURCE_DIR}/../ThirdParty/TinyObjLoader/tiny_obj_loader.cc"
	)
target_include_directories(ImportExportLib PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../ThirdParty/TinyObjLoader/")
target_link_libraries(ImportExportLib glm)

add_library(GteLib STATIC
	gte/gte-bbox.cpp gte/gte-bbox.h
	gte/includes-gte.h
	)
target_link_libraries(GteLib glm)
target_include_directories(GteLib PRIVATE ${GTE_INC_DIR})
