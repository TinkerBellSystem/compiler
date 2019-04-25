# Author: Xueyuan Han <hanx@g.harvard.edu>
#
# Copyright (C) 2015-2019 University of Cambridge, Harvard University, University of Bristol
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2, as
# published by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.

import sqlite3
import os, sys
import argparse
import logging
import re
from collections import deque


def getCallee(cursor, caller, callmap):
	'''
	This function gets all the functions called by the caller, and record the level of the functions
	'''
	cursor.execute('SELECT c.Caller, c.Callee, f.File FROM functions AS f INNER JOIN calls AS c ON f.Id = c.Caller WHERE Caller = ?', (caller,))
	calleelist = []
	for callee in cursor.fetchall():	# all the functions called by the caller
		calleelist.append(callee[1])	# callee[1] is the function ID of the callee function
	if caller not in callmap:
		callmap[caller] = calleelist
	return calleelist


def getName(fid, cursor):
	'''
	This function gets the function name and the location of the give function `id` @fid in system call database.
	It returns None or the Name and file location (as a one-element list) of the system call in the database
	'''
	cursor.execute('SELECT f.Name, f.File FROM functions AS f WHERE Id = ?', (fid,))
	ret = list()
	for (name, filename) in cursor.fetchall():
		ret.append((name, filename))
	
	if len(ret) != 1:
		print "Error in function ID: " + fid
		return None
	else:
		return ret[0]


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Create a list of functions (recursively) called by the top-level/root system call.')
	parser.add_argument('-v', '--verbose', action='store_true', help='increase console verbosity')
	parser.add_argument('-db', '--database', help='input SQLite3 database file', required=True)
	parser.add_argument('-r', '--root', help='entry point syscall caller ID', required=True)
	parser.add_argument('-o', '--output', help='output file path', required=True)
	args = parser.parse_args()

	logging.basicConfig(filename='error.log',level=logging.DEBUG)

	# connect to the database and get a cursor.
	conn = sqlite3.connect(args.database)
	c = conn.cursor()

	# open the output file to write output
	output = open(args.output, "w+")

	syscallID = args.root
	# map a caller function (ID) to its callee functions (IDs).
	caller2callee = dict()
	# start from the root caller
	queue = deque([syscallID])
	while len(queue) > 0:
		caller = queue.popleft()
		callees = getCallee(c, caller, caller2callee)
		for callee in callees:
			# we have not checked this function as a caller yet nor will we check later
			if callee not in caller2callee and callee not in queue:
				queue.append(callee)

	# get all the callee IDs
	calleeIDs = list()
	for caller, callees in caller2callee.iteritems():
		calleeIDs.extend(callees)
	# only get unique callee IDs
	calleeIDs = set(calleeIDs)

	# maps file name to all the callee functions defined in that file
	file2functions = dict()
	for calleeID in calleeIDs:
		name, filename = getName(calleeID, c)
		if filename not in file2functions:
			file2functions[filename] = [name]
		else:
			file2functions[filename].append(name)

	output.write(repr(getName(syscallID, c)))
	output.write("\n============================================================================\n")
	for filename, callees in file2functions.iteritems():
		output.write(repr(filename) + ":\n")
		output.write(repr(callees))
		output.write("\n\n")

	output.close()
	conn.close()
