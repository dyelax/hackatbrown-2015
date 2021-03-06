import os.path
from flask import Flask
import sqlite3 as sql
import re
import json
import cgi
import requests
from operator import itemgetter

DB = "mixr.db"

app = Flask(__name__)
app.config.from_object("config")

LatLongRE = re.compile(r"d+\.d+")

def parseLatLong(s):
	f1, f2 = s.split(',')
	try:
		return (float(f1), float(f2))
	except ValueError:
		return (None, None)

def setup():
	CRS = conn.cursor()
	CRS.execute("""CREATE TABLE EVENTS (ID INTEGER PRIMARY KEY, LAT REAL,
					 LONG REAL, CREATOR INTEGER, CONTRIBUTORS TEXT,
					 CLASSIFIERS TEXT, SONGS TEXT, PLAYLIST TEXT,
					 EXCLUDED TEXT, PRIVATE INTEGER, NOW_PLAYING INTEGER)""")
	CRS.execute("""CREATE TABLE SONGS (ID TEXT PRIMARY KEY, GENRES TEXT,
					 EVENTS TEXT)""")
	conn.commit()

@app.route('/new/<int:clientId>/<latLong>', methods=['GET'])
def new(clientId, latLong):
	# Parse latitude, longitude, create new event id, insert into events.
	CRS = conn.cursor()
	CRS.execute("SELECT count(*) FROM EVENTS")
	count = int(CRS.fetchone()[0])
	lat, long = parseLatLong(latLong)

	if lat and long:

		CRS.execute("""INSERT INTO EVENTS (ID, LAT, LONG, CREATOR, CONTRIBUTORS,
				   CLASSIFIERS, SONGS, PLAYLIST, EXCLUDED, PRIVATE, NOW_PLAYING)
				   VALUES (?, ?, ?, ?, ?, "", "", "", "", 0, 0)""", (count,
				   lat, long, clientId, str(clientId)+","))

		conn.commit()

		result = {'success': True, 'eventId':count}

		return json.dumps(result), 201

	else:
		result = {'success': False, 'reason':'invalid_latlong'}
		return json.dumps(result), 403

@app.route('/join/<int:eventId>/<int:clientId>', methods=['PUT'])
def join(eventId, clientId):
	# Update events, add clientId to contributors.
	CRS = conn.cursor()
	CRS.execute("SELECT CONTRIBUTORS FROM EVENTS WHERE ID=?", (eventId,))
	s = CRS.fetchone()[0]

	if not re.match(str(clientId), s):
		s += str(clientId)
		if s[-1] != ',':
			s += ','

		CRS.execute("UPDATE EVENTS SET CONTRIBUTORS=? WHERE ID=?", (s, eventId))
		conn.commit()
		return json.dumps({'success': True}), 200
	else:
		conn.commit()
		return json.dumps({'success': False, 'reason': 'exists'}), 403

@app.route('/delete/<int:eventId>/<int:clientId>', methods=['DELETE'])
def delete(eventId, clientId):
	# Delete from events if clientId = creator.
	CRS = conn.cursor()
	CRS.execute("SELECT CREATOR FROM EVENTS WHERE ID=?", (eventId,))
	if CRS.fetchone()[0] == clientId:
		CRS.execute("DELETE FROM EVENTS WHERE ID=?", (eventId,))
		conn.commit()
		return json.dumps({'success': True}), 200
	else:
		return json.dumps({'success': False, 'reason': 'not_creator'}), 403

@app.route('/find/<latLong>', methods=['GET'])
def find(latLong):
	# Select * from events, then sort for distance.
	pass

@app.route('/get/<int:eventId>/<int:clientId>', methods=['GET'])
def get(eventId, clientId):
	# Select * from events where eventId is okay.
	CRS = conn.cursor()
	CRS.execute("SELECT CONTRIBUTORS, PLAYLIST, NOW_PLAYING FROM EVENTS WHERE ID=?", (eventId,))
	contributors, playlist, playing = CRS.fetchone()

	if re.search(str(clientId), contributors):
		# Deal with playlist.
		songIds = [int(s) for s in playlist.strip(',').split(',')]

		result = {'success': True, 'songs':songIds, 'now_playing':playing}

		return json.dumps(result), 200
	else:
		return json.dumps({'success': False, 'reason': 'not_contributor'}), 403

@app.route('/addthemes/<int:eventId>/<int:clientId>/<themes>', methods=['PUT'])
def addthemes(eventId, clientId, themes):
	# Select event, check to see if client is a contributor, update themes.
	CRS = conn.cursor()
	CRS.execute("SELECT CREATOR, CLASSIFIERS FROM EVENTS WHERE ID=?", (eventId,))
	creator, classifiers = CRS.fetchone()

	if creator == clientId:
		classifiers += themes
		if classifiers[-1] != ',':
			classifiers += ','

		CRS.execute("UPDATE EVENTS SET CLASSIFIERS=? WHERE ID=?", (classifiers, eventId))
		conn.commit()

		refresh(eventId)

		return json.dumps({'success': True}), 200
	else:
		return json.dumps({'success': False, 'reason': 'not_creator'}), 403

@app.route('/addsongs/<int:eventId>/<int:clientId>/<songs>', methods=['PUT'])
def addsongs(eventId, clientId, songs):
	# Select event, check to see if client is a contributor, update themes.
	CRS = conn.cursor()
	CRS.execute("SELECT CONTRIBUTORS, SONGS FROM EVENTS WHERE ID=?", (eventId,))
	contributors, existing_songs = CRS.fetchone()

	if re.search(str(clientId), contributors):
		existing_songs += songs

		for song in songs.strip(",").split(","):
			pullSong(song)

		if songs[-1] != ',':
			songs += ','

		CRS.execute("UPDATE EVENTS SET SONGS=? WHERE ID=?", (songs, eventId,))
		conn.commit()

		refresh(eventId)

		return json.dumps({'success': True}), 200
	else:
		return json.dumps({'success': False, 'reason': 'not_contributor'}), 403


@app.route('/next/<int:eventId>/<int:clientId>', methods=['PUT'])
def next(eventId, clientId):
	# Select event, check to see if client is creator, update if so.
	CRS = conn.cursor()
	CRS.execute("SELECT CONTRIBUTORS, PLAYLIST, NOW_PLAYING FROM EVENTS WHERE ID=?", (eventId,))
	contributors, playlist, now_playing = CRS.fetchone()

	if not re.match(str(clientId), contributors):

		length = len(playlist.strip(',').split(','))

		if length == 0:
			return json.dumps({'success': True, 'reason': 'no_songs'}), 403

		new_song = (now_playing+1)%length

		CRS.execute("UPDATE EVENTS SET NOW_PLAYING=? WHERE ID=?", (new_song, eventId))
		conn.commit()

		return json.dumps({'success': True, 'now_playing': new_song}), 200
	else:
		return json.dumps({'success': False, 'now_playing': now_playing, 'reason': 'not_contributor'}), 403

@app.route('/remove/<int:eventId>/<int:clientId>/<songId>', methods=['PUT'])
def remove(eventId, clientId, songId):
	# Select event, remove song from playlist, add to excluded.
	pass

@app.route('/close/<password>', methods=['POST'])
def close(password):
	if password == "123":
		stop()

@app.route('/refresh/<int:eventId>', methods=['PUT'])
def refresh(eventId):
	# Recalculate and refresh data. Incredibly computation heavy.
	try:
		CRS = conn.cursor()
		CRS.execute("SELECT CLASSIFIERS, SONGS, EXCLUDED FROM EVENTS WHERE ID=?", (eventId,))

		classifiers, songs, excluded = CRS.fetchone()

		target_genres = classifiers.strip(",").split(",")

		priorities = []

		for songId in songs.strip(",").split(","):
			priority = 0
			CRS.execute("SELECT GENRES FROM SONGS WHERE ID=?", (songId,))
			genres = CRS.fetchone()

			for genre in target_genres:
				r = re.search(genre, genres)
				if r:
					priority += 10

			if re.search(excluded, songId):
				priority = 0

			priorities.append([songId, priority])

		priorities = sorted(priorities, key=itemgetter(1))
		if len(priorities) > 10:
			priorities = priorities[-10:]

		playlist = ""
		for song in priorities:
			playlist += song[0]
			playlist += ","

		CRS.execute("UPDATE EVENTS SET PLAYLIST=? WHERE ID=?", (playlist, eventId))
		CRS.commit()

		return json.dumps({'success':True}), 200
	except:
		return json.dumps({'success':False}), 403

def pullSong(songId):
	CRS = conn.cursor()

	CRS.execute("SELECT count(*) FROM SONGS WHERE ID=?", (songId,))

	if CRS.fetchone()[0] == 0:

		spotify = requests.get("https://api.spotify.com/v1/tracks/{0}".format(songId))

		if spotify.status_code == 200:
			spotify_data = spotify.json()

			print(spotify_data)
			artist = spotify_data['artists'][0]['name']
			name = spotify_data['name']
			artist_href = spotify_data['artists'][0]['href']

			spotify_artist = requests.get(artist_href)

			if spotify_artist.status_code == 200:
				spotify_artist_data = spotify_artist.json()
				genres = spotify_artist_data['genres']

				string = "";
				for genre in genres:
					string += genre
					string += ","

				CRS.execute("""INSERT INTO SONGS (ID, GENRES, EVENTS) VALUES
							   (?, ?, "")""", (songId, string))

				conn.commit()

#			echonest = request.get("""http://developer.echonest.com/api/v4/song/search?
#							api_key=YOLC108TJAVYOB4TR&format=json&results=1&
#							artist={0}&title={1}""".format(cgi.escape(artist), cgi.escape(name)))
#
#			if echonest.status_code = 200:
#				echonest_data = echonest.json()
#
#				artist_id = echonest_data["songs"]["artist_id"]
#
#				moods = request.get("""http://developer.echonest.com/api/v4/artist/search?
#				api_key=YOLC108TJAVYOB4TR&format=json&results=1&)
	else:
		print "Spotify API didn't work."
		return

needsSetup = False;
if not os.path.isfile(DB):
	needsSetup = True;
conn = sql.connect(DB, check_same_thread=False)
if needsSetup:
	print("Setting up...")
	setup()
app.run()
conn.close()
