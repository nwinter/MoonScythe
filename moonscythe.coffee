###

MoonScythe 0.0.1
A CoffeeScript-based Lua parser/interpreter
Author: Ray Perry

Notes: This project is still undergoing heavy development. I would NOT suggest using it just yet.
Dependancies: This project currently requires Esprima.

###

# Test expression for Lua
currentMoon = 'function () function () function add() return num1+num2 end end end'
# Chew up the input to be iterated over
moonRocks = currentMoon.split ' '

###

(IN PROGRESS) Lua parser mode

###

# Load Esprima
esprima = require 'esprima'

stills =
	isAnonymous: "/^\(/",	# I don't think that is necessary in this implementation.
	namesAndParams: "/[a-z]*\((.*)\)/"

moonShine = ''

for clause in moonRocks
	# replace and append the exceptions
	switch clause
		when clause == 'end' then
			moonShine += '} '
		when clause.match(stills.namesAndParams) then
			moonShine += clause.match(stills.namesAndParams)
			moonShine += '{ '
	moonShine += clause + ' '

console.log moonShine
console.log esprima.parse(moonShine)





###

(IN PROGRESS) Lua interpreter mode



# Set globals for the Lua parser
globals = 
	regFunctions: {},
	variables: {}

# Define the registered function class which has a constructor for its name
# and an exec() function which contains the actual function contents
class RegisteredFunction
	constructor: (name) ->
		@name = name
		@params = 'Successful function creation.'

	exec: ->
		return @params
		return this	

class NestedFunction
	constructor: (name, parent) ->
		@name = name
		parent[name] = this
		@params = 'Successful function creation.'

	
	exec: ->
		return @params
		return this	


# Set diving flags
inFunction = false
# If looking for a function name flag (resets if it finds a nested function)
lookForName = false
# Nest level counter
nestedLevelCount = 0
nestedLevelNames = []
anonFunctionCount = 1

# diving loop
for clause in moonRocks
	console.log clause
	inFunction = if nestedLevel > 1 then true else false
	# If the current clause is a 'function'
	if clause == 'function'
		# Set the diving flags
		lookForName = true
		nestedLevel++
		continue
	# If we're looking for a name (will fix to accomodate nested functions soon)
	if lookForName and clause.indexOf '(',0 > -1
		# Reset this flag
		lookForName = false
		# Get the position of the parameter field
		subStringIndex = clause.indexOf '(',0
		if subStringIndex == 0
			newFuncName = 'anonFunction' + anonFunctionCount.toString()
			anonFunctionCount++
		else
			# Create a new function name from the substring
			newFuncName = clause.substring(0,subStringIndex)
		# Create a placeholder function with that name and register it with the registered functions array
		if inFunction
			new NestedFunction newFuncName 
		else
			globals.regFunctions[newFuncName] = new RegisteredFunction newFuncName

	# If we see an 'end', step up one level
	if clause == 'end'
		inFunction = false
		nestedLevel--
		continue

console.log globals.regFunctions

###