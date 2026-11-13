"""Enemy-only Barrens dashes, clean channel art, quill projectiles and HP edits."""
from build_highroad90 import *
BASE=ROOT/'release/development/QuickUI91/FFERPG-QuickUI91.w3x'
OUT=ROOT/'release/development/QuickUI92/FFERPG-QuickUI92.w3x'
LABEL='FFERPG QuickUI92 (Barrens Corrections)'
ABIL=['bG88','bC88','bQ88','bY88','bW88','bV88']

def objects92(v):
 u=all_objects(v,'w3u');a=all_objects(v,'w3a')
 clean={r for r,o in a.items() if o['base']=='ANcl' and r[0] in 'fbmh'}
 ABIL[:]=sorted(set(ABIL)|clean|{'mPF9','mPE9','mCS9','hHB0'})
 for raw,hp in [('n0L0',1600),('nowe',1800)]:
  setf(u[raw],'uhpm',hp)
  desc=fields(u[raw]).get(('utub',None),'')
  setf(u[raw],'utub',desc+'|nNormal base health: '+str(hp)+'.')
 setf(u['n0MO'],'uabi',','.join(x for x in fields(u['n0MO'])['uabi',None].split(',') if x!='A1C5'))
 for raw in ABIL:
  for key in ['acat','atat','asat','aeat']:mod(a[raw],key,'',0)
  for key in ['acac','atac']:mod(a[raw],key,0,0)
 for raw in ['bG88','bC88','bQ88']:
  mod(a[raw],'atar','air,ground,enemy,vulnerable',1)
  # Channel must honor the target filter; bit 16 is Unique Cast, bit 1 Visible.
  mod(a[raw],'Ncl3',1,1)
  mod(a[raw],'amat','',0)
  mod(a[raw],'Ncl5',0,1)
 for raw in ['bB88','mBI9','mRK9','mFB9','hBI0','hMF0','hAA0']:
  if a[raw]['base']=='ANcl':mod(a[raw],'atar','air,ground,enemy,vulnerable',1);mod(a[raw],'Ncl3',1,1)
 for raw,text in [('bG88','Dash directly to an enemy target, reducing its evasion by 10% for 5 seconds. Costs 50 mana. Cooldown: 15 seconds.'),('bC88','Dash directly to an enemy target and trample it.|n|n|cffffcc00Damage Calculation|r|n400 physical damage. Reduces attack speed by 25% for 5 seconds. Cooldown: 20 seconds.')]:mod(a[raw],'aub1',text,1)
 mod(a['bY88'],'amat','Abilities\\Weapons\\BristleBackMissile\\BristleBackMissile.mdl',0)
 mod(a['bY88'],'amsp',1000,0);mod(a['bY88'],'amho',1,0)
 for raw in ['mPF9','mPE9']:mod(a[raw],'amsp',900,0);mod(a[raw],'amho',1,0)
 mod(a['mCS9'],'amat','Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmMissile.mdl',0)
 mod(a['mCS9'],'amsp',1000,0);mod(a['mCS9'],'amho',0,0)
 mod(a['mCS9'],'aare',100.,1);mod(a['mCS9'],'Ucs3',800.,1);mod(a['mCS9'],'Ucs4',300.,1)
 for raw in ['hBI0','hMF0','hHB0','mBI9']:mod(a[raw],'aani','attack',0)
 mod(a['hHB0'],'amat','',0);mod(a['hHB0'],'atar','air,ground,enemy,vulnerable',1)
 mod(a['hHB0'],'atat','Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl',0)
 return {r:u[r] for r in ['n0L0','nowe','n0MO']},{r:a[r] for r in ABIL}

def refresh92(s):
 fs=functions(s)
 # ANcl's inherited target art caused the pink swirl. Enemy-only filters also
 # prevent friendly exhibit clicks from consuming a cast with no valid dash.
 if 'B88_Charge' in fs:
  b=fs['B88_Charge'].replace('if not Forest86_Enemy(caster,victim) then','if not Forest86_Alive(caster) or not Forest86_Enemy(caster,victim) then')
  b=b.replace(' call SetUnitAnimation(caster,"walk")',' call SetUnitFacing(caster,Atan2(GetUnitY(victim)-GetUnitY(caster),GetUnitX(victim)-GetUnitX(caster))*bj_RADTODEG)\n call SetUnitAnimation(caster,"walk")')
  s=put(s,'B88_Charge',b)
 if 'B88_ChargeEnd' in fs:
  b=fs['B88_ChargeEnd'].replace('if Forest86_Enemy(u,victim) and Forest86_Alive(u) then','if Forest86_Enemy(u,victim) and Forest86_Alive(u) and IsUnitInRange(u,victim,120.) then')
  s=put(s,'B88_ChargeEnd',b)
 for n in ['B88_Quill','M89_Projectile','M89_Dummy']:
  if n in fs:s=put(s,n,fs[n].replace('call ShowUnit(dummy,false)','call SetUnitVertexColor(dummy,255,255,255,0)\n call SetUnitPathing(dummy,false)'))
 if 'Forest86_Spell' in fs:
  b=fs['Forest86_Spell'].replace(' call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Orc\\\\MirrorImage\\\\MirrorImageCaster.mdl",caster,"origin"))','')
  s=put(s,'Forest86_Spell',b)
 if 'M89_Spell' in fs:
  b=fs['M89_Spell'].replace(' local real damage',' local sound guard=null\n local real damage',1)
  b=b.replace(' call M89_Damage(caster,u,GetWidgetLife(u)*.1,0)',' call M89_Damage(caster,u,GetWidgetLife(u)*.1,0)\n call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Undead\\\\AnimateDead\\\\AnimateDeadTarget.mdl",u,"origin"))',1)
  b=b.replace(' call M89_Damage(caster,victim,600.,0)',' call SetUnitAnimation(caster,"attack")\n call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Orc\\\\Devour\\\\DevourEffectArt.mdl",victim,"chest"))\n call M89_Damage(caster,victim,600.,0)',1)
  b=b.replace('call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Undead\\\\DeathAndDecay\\\\DeathAndDecayTarget.mdl",caster,"origin"))','call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Undead\\\\RegenerationAura\\\\ObsidianRegenAura.mdl",caster,"origin"))')
  b=b.replace(" elseif raw=='mDS9' then\n",''' elseif raw=='mDS9' then
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Human\\\\Defend\\\\DefendCaster.mdl",caster,"origin"))
 set guard=CreateSoundFromLabel("Defend",false,true,true,10,10)
 call AttachSoundToUnit(guard,caster)
 call StartSound(guard)
 call KillSoundWhenDone(guard)
''',1)
  b=b.replace(' set hound=null',' set guard=null\n set hound=null',1);s=put(s,'M89_Spell',b)
 if 'H90_Spell' in fs:
  b=fs['H90_Spell'].replace('Bladestorm\\\\Bladestorm.mdl','Whirlwind\\\\Whirlwind.mdl')
  b=b.replace(' call B88_Damage(caster,victim,1000.,true)',' call SetUnitAnimation(caster,"attack")\n call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Orc\\\\Devour\\\\DevourEffectArt.mdl",victim,"chest"))\n call B88_Damage(caster,victim,1000.,true)',1)
  b=b.replace(' call B88_Damage(caster,victim,1200.,true)',' call SetUnitAnimation(caster,"attack")\n call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Human\\\\Thunderclap\\\\ThunderclapTarget.mdl",victim,"overhead"))\n call B88_Damage(caster,victim,1200.,true)',1)
  s=put(s,'H90_Spell',b)
 if 'Trig_Spell_LiquidSteel_Loop' in fs:
  b=fs['Trig_Spell_LiquidSteel_Loop'].replace('        set i=i+1','''        if H90LiquidWind[d] and udg_LiquidSteelNext[d]==-1 and udg_LiquidSteelBounces[d]<=0 then
            call Trig_Spell_LiquidSteel_Free(d)
            set i=i-1
        endif
        set i=i+1''',1)
  # The original no-neighbor repeat branch also needs the wind element.
  b=b.replace('                set udg_DamageElement=4','                if H90LiquidWind[d] then\n                    set udg_DamageElement=6\n                else\n                    set udg_DamageElement=4\n                endif')
  s=put(s,'Trig_Spell_LiquidSteel_Loop',b)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);units,abil=objects92(v);files={}
 for ext,replacements in [('w3u',units),('w3a',abil)]:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;data=v.archive.read(name)
   if not data:continue
   t=read_objects(data,ext)
   seen=set()
   for table in ['original','custom']:
    if prefix=='war3map':
     seen.update(o['id'] or o['base'] for o in t[table]);t[table]=[copy.deepcopy(replacements.get(o['id'] or o['base'],o)) for o in t[table]]
    else:t[table]=[o for o in t[table] if (o['id'] or o['base']) not in replacements]
   if prefix=='war3map':
    for raw,o in replacements.items():
     if raw not in seen:t['custom' if o['id'] else 'original'].append(copy.deepcopy(o))
   files[name]=write_objects(t,t['version'],ext)
 modules={lib:refresh92(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};runtime=refresh92(v.runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label=LABEL;w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),native_acceptance='pending'),indent=2));print(OUT)
if __name__=='__main__':build()
