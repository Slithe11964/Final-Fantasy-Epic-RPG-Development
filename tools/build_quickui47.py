"""Build the next native test map with Dragoon, Thief and quick-gear follow-ups."""
import build_dragoon_ui41 as builder
import thousand_cuts
import aqualung_fix
from editor_pair import View
from equipment_integrity import catalogue as integrity_catalogue
from equipment_quickcast import refresh as quickcast_refresh


if __name__=='__main__':
    original=builder.refresh
    # QuickUI40 is intentionally the stable base.  Rebuild its native quick-gear
    # fragment once here so the cursor reticle and live F/G icon refresh ship with
    # this test map rather than only existing in the source experiment.
    # Equipment IDs and the quick-gear catalogue belong to the editor master;
    # QuickUI40 is a released native profile and carries reserved compatibility
    # IDs that are not part of that authored catalogue.
    editor_view=View(builder.ROOT/'editor/FFERPG-Editor-Master.w3x')
    quickgear_config=integrity_catalogue(editor_view)
    builder.refresh=lambda source:quickcast_refresh(aqualung_fix.refresh(thousand_cuts.refresh(original(source))),quickgear_config,native=True)
    builder.STAGE='QuickUI47'
    builder.OUT=builder.ROOT/'release/development/QuickUI47/FFERPG-QuickUI47-Forsaken.w3x'
    builder.build()
