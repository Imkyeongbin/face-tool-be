#!/bin/bash
source .venv/bin/activate
waitress-serve --listen=*:15000 app:app
