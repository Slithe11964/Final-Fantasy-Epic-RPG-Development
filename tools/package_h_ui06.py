"""Label-only h package of the owner's solo-approved UI06 build."""
import json
import package_right_h as p
from mpq import MPQ
from downgrade import wts_read

if __name__=='__main__':
    p.OUT=p.ROOT/'release/development/VersionHUI0620261110'
    assert not p.OUT.exists()
    base=p.ROOT/'release/development/H20261110UI06/FFERPG-0.9.7.5h-UI06.w3x'
    r=p.package(base,'FFERPG-0.9.7.5h.w3x','FFERPG 0.9.7.5h','0.9.7.5h','h UI06','')
    r['native_acceptance']='Owner confirms solo UI06 works including post-cutscene controls. Multiplayer pending.'
    out=p.OUT/'FFERPG-0.9.7.5h.w3x'
    a=wts_read(MPQ(str(base)).read('war3map.wts'))
    b=wts_read(MPQ(str(out)).read('war3map.wts'))
    assert a[38790]==b[38790] and a[5]==b[5]
    out.with_suffix('.json').write_text(json.dumps(r,indent=2))
    (p.OUT/'manifest.json').write_text(json.dumps([r],indent=2))
