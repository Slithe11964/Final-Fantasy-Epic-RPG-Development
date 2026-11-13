"""Preserve first compiler-pass prototype, then finalize the tested boundary."""
import shutil
import build_inventory_panel04 as build

history=build.OUT.parent/'history-before-boundary-tests'
assert not history.exists()
history.mkdir()
for suffix in ['.w3x','.j','.json','.unpacked.w3x']:
    path=build.OUT.with_suffix(suffix)
    if path.exists():shutil.move(str(path),str(history/path.name))
build.build()
