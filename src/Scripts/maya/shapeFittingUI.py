# Copyright 2015 Autodesk, Inc. All rights reserved.
# 
# Use of this software is subject to the terms of the Autodesk
# license agreement provided at the time of installation or download,
# or which otherwise accompanies this software in either electronic
# or hard copy form.

from maya import cmds
from maya import mel
from maya import OpenMayaUI as omui 

try:
  from PySide2.QtCore import * 
  from PySide2.QtGui import * 
  from PySide2.QtWidgets import *
  from PySide2.QtUiTools import *
  from shiboken2 import wrapInstance 
except ImportError:
  from PySide.QtCore import * 
  from PySide.QtGui import * 
  from PySide.QtUiTools import *
  from shiboken import wrapInstance 

import os.path
import maya.cmds as mc
import maya.mel as mel

mayaMainWindowPtr = omui.MQtUtil.mainWindow() 
mayaMainWindow = wrapInstance(long(mayaMainWindowPtr), QWidget) 

class ShapeFittingUI(QWidget):
	def __init__(self, *args, **kwargs):
		super(ShapeFittingUI,self).__init__(*args, **kwargs)
		self.setParent(mayaMainWindow)
		self.setWindowFlags( Qt.Window )

		# load module
		self.fit_plugin_path = "K:/external/SUMB_ShapeFitting/build/products/ShapeFittingCmd.mll"
		mc.loadPlugin(self.fit_plugin_path)

		# load UI
		self.initUI()

	def closeEvent(self, fish):
		mc.unloadPlugin("ShapeFittingCmd.mll")

	def initUI(self):
		loader = QUiLoader()
		currentDir = os.path.dirname(__file__)
		file = QFile(currentDir+"/shapeFittingWindow.ui")
		file.open(QFile.ReadOnly)
		self.ui = loader.load(file, parentWidget=self)
		file.close()

		# dropdown entries
		method_names = ["Box", "Axes Corners", "Adaptive", "First Four" ]
		box_type_names = [ "Axis Aligned", "Oriented" ]
		
		# populate dropdown lists
		for name in method_names:
			self.ui.dropMethod.addItem( name )
		for name in box_type_names:
			self.ui.dropBoxType.addItem( name )
		
		# create dictionaries for *name -> id* lookup
		self.method_hash = {}
		i = 0
		for name in method_names:
			self.method_hash[name] = i
			i += 1
		self.box_type_hash = {}
		i = 0
		for name in box_type_names:
			self.box_type_hash[name] = i
			i += 1

		self.ui.buttonFit.clicked.connect( self.doFit )


	def doFit(self):
		method_id = self.method_hash[self.ui.dropMethod.currentText()]
		box_type_id = self.box_type_hash[self.ui.dropBoxType.currentText()]
		eval_str = "fitShape {0} {1}".format(method_id, box_type_id)
		mel.eval(eval_str)


	def doCancel(self):
		self.close()


def main():
	ui = ShapeFittingUI()
	ui.show()
	return ui


if __name__ == '__main__':
	main()
