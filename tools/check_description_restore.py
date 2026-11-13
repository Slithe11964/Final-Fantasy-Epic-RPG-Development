from concurrent.futures import ThreadPoolExecutor,as_completed
from pathlib import Path
import sys,subprocess,json
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'release/development/DescriptionRestore20261110'
rows=json.loads((OUT/'manifest.json').read_text())
def check(row):
    p=Path(row['output']);args=[sys.executable,str(ROOT/'tools/check_map.py'),str(p)]
    if '1.29.2' in p.name:args+=['--common',str(ROOT/'tools/versions/1.29.2/common.j'),'--blizzard',str(ROOT/'tools/versions/1.29.2/blizzard.j')]
    r=subprocess.run(args,cwd=ROOT,capture_output=True,text=True,errors='replace')
    p.with_suffix('.check.txt').write_text(r.stdout+r.stderr)
    return dict(name=p.name,passed=r.returncode==0,log=r.stdout+r.stderr)
with ThreadPoolExecutor(max_workers=3) as pool:
    results=[]
    for f in as_completed([pool.submit(check,r) for r in rows]):
        result=f.result();results.append(result);print(result['name'],'PASS' if result['passed'] else result['log'],flush=True)
(OUT/'checks.json').write_text(json.dumps(results,indent=2))
assert all(r['passed'] for r in results)
