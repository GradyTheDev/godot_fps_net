class_name GFN_Sync_Tools
extends RefCounted

static func serialize_uint24(value: int):
	# Ensure the value is within the uint24 range
	value = clamp(value, 0, 16777215)

	# Extract individual bytes
	var byte1: int = (value & 0xFF0000) >> 16
	var byte2: int = (value & 0x00FF00) >> 8
	var byte3: int = value & 0x0000FF

	# Return the three bytes
	return PackedByteArray([byte1, byte2, byte3])

static func deserialize_uint24(data: PackedByteArray):
	# Ensure the data contains at least three bytes
	if data.size() < 3:
		return 0

	# Extract individual bytes and combine them into a uint24_t value
	return (data[0] << 16) | (data[1] << 8) | data[2]

static func sprint(a: Array):
	var s := ""
	for x in a:
		s += ' ' + str(x)
	print(s)