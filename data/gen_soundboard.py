#!/usr/bin/python

import sys
import os
import csv
import subprocess
import json

if len(sys.argv) < 4:
    print("Args: <csv path> <audio dir> <output dir> (--wav)")
    sys.exit(0)

if not os.path.isfile(sys.argv[1]):
    print("First arg should be a CSV file")
    sys.exit(0)

if not os.path.isdir(sys.argv[2]):
    print("Second arg should be the directory with the audio files")
    sys.exit(0)

if not os.path.exists(sys.argv[3]):
    os.makedirs(sys.argv[3])

wav_output = "--wav" in sys.argv

with open(sys.argv[1], newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    #columns: 0: filename, 1: en name, 2: jp name, 3: en category, 4: jp category, 5: include or not
    categories = dict()
    next(reader)
    for row in reader:
        if not row[5].strip(): continue
        if not row[1].strip(): continue
        if not row[2].strip(): continue
        
        # TODO: temporary until we have proper categories
        row[3] = "Voices (work in progress)"
        row[4] = "音声（開発中）"
        
        if not row[3] in categories:
            categories[row[3]] = dict()
        if not "sounds" in categories[row[3]]: categories[row[3]]["sounds"] = []
        if "title" in categories[row[3]]:
            if categories[row[3]]["title"] != {"en":row[3], "jp":row[4]}:
                print("Inconsistent en/jp category titles:")
                print(categories[row[3]]["title"])
                print({"en":row[3], "jp":row[4]})
        categories[row[3]]["title"] = {"en":row[3], "jp":row[4]}
        fpath = sys.argv[2]+"/"+row[0]
        fname_without_ext = os.path.splitext(os.path.basename(fpath))[0]
        if not os.path.isfile(fpath):
            print(f"Missing file: {fpath}")
            sys.exit(0)
        print("Encoding file:"+fpath)
        subprocess.run(["ffmpeg", "-y", "-f", "s16le", "-ar", "44100", "-ac", "2", "-i", fpath, "-metadata", "artist=\"角巻わため\"", sys.argv[3]+"/"+fname_without_ext+".wav"])
        if not os.path.isfile(sys.argv[3]+"/"+fname_without_ext+".wav"):
            print("Something went wrong during wav encoding")
            sys.exit(0)
        subprocess.run(["ffmpeg", "-y", "-i", fpath, "-codec:a", "libmp3lame", "-qscale:a", "1", "-metadata", "artist=\"角巻わため\"", sys.argv[3]+"/"+fname_without_ext+".mp3"])
        if not os.path.isfile(sys.argv[3]+"/"+fname_without_ext+".mp3"):
            print("Something went wrong during mp3 encoding")
            sys.exit(0)
        categories[row[3]]["sounds"].append({"file":fname_without_ext+(".wav" if wav_output else ".mp3"), "en":row[1],"jp":row[2]})
results = []
for cat in categories:
    results.append(categories[cat])
with open(sys.argv[3]+('/sounds_wav.json' if wav_output else '/sounds.json'), 'w') as sounds:
    json.dump(results, sounds, indent=4, ensure_ascii=False)
print("Done!")
