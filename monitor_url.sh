#!/bin/bash

URL=""
TEMP_FILE="temp.html"
EMAIL_SUBJECT="Cambio en la página web detectado"
RECIPIENT_EMAIL=""

while true; do
curl -s "$URL" > "$TEMP_FILE"

sleep 2

curl -s "$URL" > "$TEMP_FILE.2"


diff_output=$(diff "$TEMP_FILE" "$TEMP_FILE.2")

if [ -n "$diff_output" ]; then
  EMAIL_BODY="$(date)\n\n"

  if [ "$(md5sum "$TEMP_FILE" | cut -d' ' -f1)" != "$(md5sum "$TEMP_FILE.2" | cut -d' ' -f1)" ]; then
    EMAIL_BODY+="La URL ha cambiado.\n\n"
  fi

  EMAIL_BODY+="Diferencias encontradas:\n$diff_output"

  echo -e "$EMAIL_BODY" | mailx -s "$EMAIL_SUBJECT" "$RECIPIENT_EMAIL"
fi

rm "$TEMP_FILE" "$TEMP_FILE.2"
done

