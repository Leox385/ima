# Developer tests

These dependencies are needed only for local development tests, not to use the interface in Matcha.

```sh
python -m pip install "lupa>=2.0,<3"
python tests/test_ui.py
```

The test detects UI.lua in the regular package or UI in the GitHub package. It uses mocks and does not open Roblox or validate native Matcha behavior. Simulated drawing data is saved in work/drawings.json. Check REVIEW_STATUS.md for confirmed results.
