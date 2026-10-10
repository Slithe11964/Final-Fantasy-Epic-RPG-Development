# Real save/restart/load prototype

CU is being implemented from BT; no CU test map is ready yet. The next user test
will be one complete real-character file save, restart, fresh load and comparison.
House and gear diagnostics remain reference results.

## File transport

`Forsaken-save-transport.j` writes the private `FFERPG/Forsaken CU.txt` file in
chunks and checks local readback. Loading sends ordered, request-bound sync
packets, then validates the complete account-bound profile before exposing it to
the controller. Missing files, corruption, lost/repeated chunks and timeouts fail
without consuming a gameplay load. Concurrent players have separate requests.
This module does not create characters or set HasLoadedCode; controller eligibility
must be checked before requesting and again before applying.

Transport control flow and compiler integration have been checked locally. Native
file IO and real multiplayer have not been tested. The sender timestamp measures
send-to-validated-receipt using the game timer; file reading is recorded separately
with the same timer and may report zero for sub-frame work. This does not establish
wall-clock file performance. The real test must report that limitation and obtain
an external timing if needed.

## Remaining before CU

Wire real capture, current-job/progression schemas and durable flags into export;
implement fresh creation, attempt-only cleanup and post-load comparison. Keep
unsupported export states explicit. Then build CU and measure the same real code
through restart and multiplayer; do not add separate temporary-hero test rounds.
