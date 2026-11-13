"""Locate a historical comparison map within the active workspace."""

def historical_map(root, name):
    fixture = root / "tools/tests/fixtures/historical-maps" / (name + ".w3x")
    return fixture if fixture.is_file() else root / "release/development" / (name + ".w3x")
