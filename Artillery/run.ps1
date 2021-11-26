# -o produces report in json
docker run --rm -it -v %cd%:/script artilleryio/artillery:latest run -o /script/custom_16_56_utc.json /script/test.yaml

# generate html
docker run --rm -it -v %cd%:/script artilleryio/artillery:latest report -o /script/report.html /script/custom_16_56_utc.json