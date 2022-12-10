#!/bin/bash

set -eux -o pipefail

call_opensky_api() {
  curl -X GET https://opensky-network.org/api/states/all | jq -c '.states[] | { "icao24": .[0], "callsign": .[1], "origin_country": .[2], "time_position": .[3], "last_contact": .[4], "longitude": .[5], "latitude": .[6]}' | sponge opensky.jsonl
}

#while true
#do
  call_opensky_api
  #sleep 600
#done

