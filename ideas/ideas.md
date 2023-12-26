# Design
godot FPS Net (GFN)

***THIS IS VERY WORK IN PROGRESS***

This library is designed for cooperative  
PVE FPS games lasting 5 to 30 minutes, supporting up  
to 8 players. It is optimized for small maps and a 
limited number of entities.


# Overview
Model: Server-Authoritative (can be changed)

- Compression
- Partial synchronization
	- Delta synchronization
	- Accumulator synchronization
	- Interest Management synchronization
		- Dynamic Entity Subscription


