set shell := ["fish", "-c"]
set dotenv-load := true
set export := true

test:
    cargo sweep --time 0 .

