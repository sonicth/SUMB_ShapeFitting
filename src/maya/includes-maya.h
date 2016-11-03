/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting Maya plugin
 */
 
#pragma once

// standard
#include <iostream>
#include <sstream>

// boost
#include <boost/foreach.hpp>

// exported functions
#include "../shared/fit-poly.h"

#include "../shared/shared-logging.h"


////////////////////////////////////////////////////////////////
// maya-specific
////////////////////////////////////////////////////////////////
#include <maya/MString.h>
#include <maya/MArgList.h>
#include <maya/MFnPlugin.h>
#include <maya/MPxCommand.h>
#include <maya/MObject.h>
// command plugin
#include <maya/MPxCommand.h>
#include <maya/MArgList.h>
#include <maya/MItSelectionList.h>
// accessing mesh data
#include <maya/MFnMesh.h>
#include <maya/MPointArray.h>
#include <maya/MFnSet.h>
//Iterator Includes
#include <maya/MItMeshPolygon.h>
// writing to mesh/poly
#include <maya/MFloatPointArray.h>
#include <maya/MFnMeshData.h>
#include <maya/MDagModifier.h>
#include <maya/MFnTypedAttribute.h>

//debuug
#include <maya/MGlobal.h>
#include <maya/MSelectionList.h>
#include <maya/MDagPath.h>


