library TZone requires TDamage, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Zone_Rects_Init=null
    trigger gg_trg_Zone_Spawn_System=null
    // Variables only this module uses.
    trigger udg_ZoneEnterTrigger
    group udg_ZoneAliveGroup
    integer udg_CurrentZoneId
endglobals

function Trig_Zone_Rects_Init_Actions takes nothing returns nothing
    set udg_SpawnRectHashRef=udg_SpawnRectHash
    set udg_SpawnDataHashRef=udg_SpawnDataHash
    call SaveInteger(udg_SpawnDataHash,1,0,9)
    call SaveRectHandle(udg_SpawnRectHash,1,1,gg_rct_183)
    call SaveRectHandle(udg_SpawnRectHash,1,2,gg_rct_184)
    call SaveRectHandle(udg_SpawnRectHash,1,3,gg_rct_185)
    call SaveRectHandle(udg_SpawnRectHash,1,4,gg_rct_186)
    call SaveRectHandle(udg_SpawnRectHash,1,5,gg_rct_187)
    call SaveRectHandle(udg_SpawnRectHash,1,6,gg_rct_188)
    call SaveRectHandle(udg_SpawnRectHash,1,7,gg_rct_189)
    call SaveRectHandle(udg_SpawnRectHash,1,8,gg_rct_190)
    call SaveRectHandle(udg_SpawnRectHash,1,9,gg_rct_191)
    call SaveRectHandle(udg_SpawnRectHash,1,$A,gg_rct_192) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,1,$B,gg_rct_193) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,1,$C,gg_rct_194) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,1,$D,gg_rct_195) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,1,$E,gg_rct_196) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,1,$F,gg_rct_197) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,1,16,gg_rct_198)
    call SaveRectHandle(udg_SpawnRectHash,1,17,gg_rct_199)
    call SaveRectHandle(udg_SpawnRectHash,1,18,gg_rct_200)
    call SaveInteger(udg_SpawnDataHash,2,1,18)
    call SaveRectHandle(udg_SpawnRectHash,2,1,gg_rct_051)
    call SaveRectHandle(udg_SpawnRectHash,2,2,gg_rct_052)
    call SaveRectHandle(udg_SpawnRectHash,2,3,gg_rct_053)
    call SaveRectHandle(udg_SpawnRectHash,2,4,gg_rct_054)
    call SaveRectHandle(udg_SpawnRectHash,2,5,gg_rct_055)
    call SaveRectHandle(udg_SpawnRectHash,2,6,gg_rct_056)
    call SaveRectHandle(udg_SpawnRectHash,2,7,gg_rct_057)
    call SaveRectHandle(udg_SpawnRectHash,2,8,gg_rct_058)
    call SaveRectHandle(udg_SpawnRectHash,2,9,gg_rct_059)
    call SaveRectHandle(udg_SpawnRectHash,2,$A,gg_rct_060) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,2,$B,gg_rct_061) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,2,$C,gg_rct_062) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,2,$D,gg_rct_063) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,2,$E,gg_rct_064) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,2,$F,gg_rct_065) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,2,16,gg_rct_066)
    call SaveRectHandle(udg_SpawnRectHash,2,17,gg_rct_067)
    call SaveRectHandle(udg_SpawnRectHash,2,18,gg_rct_068)
    call SaveRectHandle(udg_SpawnRectHash,2,19,gg_rct_069)
    call SaveRectHandle(udg_SpawnRectHash,2,20,gg_rct_070)
    call SaveRectHandle(udg_SpawnRectHash,2,21,gg_rct_071)
    call SaveRectHandle(udg_SpawnRectHash,2,22,gg_rct_072)
    call SaveRectHandle(udg_SpawnRectHash,2,23,gg_rct_073)
    call SaveRectHandle(udg_SpawnRectHash,2,24,gg_rct_074)
    call SaveRectHandle(udg_SpawnRectHash,2,25,gg_rct_075)
    call SaveRectHandle(udg_SpawnRectHash,2,26,gg_rct_076)
    call SaveRectHandle(udg_SpawnRectHash,2,27,gg_rct_077)
    call SaveRectHandle(udg_SpawnRectHash,2,28,gg_rct_078)
    call SaveRectHandle(udg_SpawnRectHash,2,29,gg_rct_079)
    call SaveRectHandle(udg_SpawnRectHash,2,30,gg_rct_080)
    call SaveRectHandle(udg_SpawnRectHash,2,31,gg_rct_081)
    call SaveRectHandle(udg_SpawnRectHash,2,32,gg_rct_082)
    call SaveRectHandle(udg_SpawnRectHash,2,33,gg_rct_083)
    call SaveRectHandle(udg_SpawnRectHash,2,34,gg_rct_084)
    call SaveRectHandle(udg_SpawnRectHash,2,35,gg_rct_085)
    call SaveRectHandle(udg_SpawnRectHash,2,36,gg_rct_086)
    call SaveRectHandle(udg_SpawnRectHash,2,37,gg_rct_087)
    call SaveRectHandle(udg_SpawnRectHash,2,38,gg_rct_088)
    call SaveRectHandle(udg_SpawnRectHash,2,39,gg_rct_089)
    call SaveRectHandle(udg_SpawnRectHash,2,40,gg_rct_090)
    call SaveRectHandle(udg_SpawnRectHash,2,41,gg_rct_091)
    call SaveRectHandle(udg_SpawnRectHash,2,42,gg_rct_092)
    call SaveRectHandle(udg_SpawnRectHash,2,43,gg_rct_093)
    call SaveRectHandle(udg_SpawnRectHash,2,44,gg_rct_094)
    call SaveRectHandle(udg_SpawnRectHash,2,45,gg_rct_095)
    call SaveRectHandle(udg_SpawnRectHash,2,46,gg_rct_096)
    call SaveRectHandle(udg_SpawnRectHash,2,47,gg_rct_097)
    call SaveRectHandle(udg_SpawnRectHash,2,48,gg_rct_098)
    call SaveRectHandle(udg_SpawnRectHash,2,49,gg_rct_099)
    call SaveRectHandle(udg_SpawnRectHash,2,50,gg_rct_100)
    call SaveRectHandle(udg_SpawnRectHash,2,51,gg_rct_101)
    call SaveRectHandle(udg_SpawnRectHash,2,52,gg_rct_102)
    call SaveRectHandle(udg_SpawnRectHash,2,53,gg_rct_103)
    call SaveRectHandle(udg_SpawnRectHash,2,54,gg_rct_104)
    call SaveRectHandle(udg_SpawnRectHash,2,55,gg_rct_105)
    call SaveRectHandle(udg_SpawnRectHash,2,56,gg_rct_106)
    call SaveRectHandle(udg_SpawnRectHash,2,57,gg_rct_107)
    call SaveRectHandle(udg_SpawnRectHash,2,58,gg_rct_108)
    call SaveRectHandle(udg_SpawnRectHash,2,59,gg_rct_109)
    call SaveRectHandle(udg_SpawnRectHash,2,60,gg_rct_110)
    call SaveRectHandle(udg_SpawnRectHash,2,61,gg_rct_111)
    call SaveRectHandle(udg_SpawnRectHash,2,62,gg_rct_112)
    call SaveRectHandle(udg_SpawnRectHash,2,63,gg_rct_113)
    call SaveRectHandle(udg_SpawnRectHash,2,64,gg_rct_114)
    call SaveRectHandle(udg_SpawnRectHash,2,65,gg_rct_115)
    call SaveInteger(udg_SpawnDataHash,2,2,65)
    call SaveRectHandle(udg_SpawnRectHash,3,1,gg_rct_201)
    call SaveRectHandle(udg_SpawnRectHash,3,2,gg_rct_202)
    call SaveRectHandle(udg_SpawnRectHash,3,3,gg_rct_203)
    call SaveRectHandle(udg_SpawnRectHash,3,4,gg_rct_204)
    call SaveRectHandle(udg_SpawnRectHash,3,5,gg_rct_205)
    call SaveRectHandle(udg_SpawnRectHash,3,6,gg_rct_206)
    call SaveRectHandle(udg_SpawnRectHash,3,7,gg_rct_207)
    call SaveRectHandle(udg_SpawnRectHash,3,8,gg_rct_208)
    call SaveRectHandle(udg_SpawnRectHash,3,9,gg_rct_209)
    call SaveRectHandle(udg_SpawnRectHash,3,$A,gg_rct_210) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,3,$B,gg_rct_211) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,3,$C,gg_rct_212) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,3,$D,gg_rct_213) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,3,$E,gg_rct_214) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,3,$F,gg_rct_215) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,3,16,gg_rct_216)
    call SaveRectHandle(udg_SpawnRectHash,3,17,gg_rct_217)
    call SaveRectHandle(udg_SpawnRectHash,3,18,gg_rct_218)
    call SaveRectHandle(udg_SpawnRectHash,3,19,gg_rct_219)
    call SaveRectHandle(udg_SpawnRectHash,3,20,gg_rct_220)
    call SaveRectHandle(udg_SpawnRectHash,3,21,gg_rct_221)
    call SaveRectHandle(udg_SpawnRectHash,3,22,gg_rct_222)
    call SaveRectHandle(udg_SpawnRectHash,3,23,gg_rct_223)
    call SaveInteger(udg_SpawnDataHash,2,3,23)
    call SaveRectHandle(udg_SpawnRectHash,4,1,gg_rct_238)
    call SaveRectHandle(udg_SpawnRectHash,4,2,gg_rct_239)
    call SaveRectHandle(udg_SpawnRectHash,4,3,gg_rct_240)
    call SaveRectHandle(udg_SpawnRectHash,4,4,gg_rct_241)
    call SaveRectHandle(udg_SpawnRectHash,4,5,gg_rct_242)
    call SaveRectHandle(udg_SpawnRectHash,4,6,gg_rct_243)
    call SaveRectHandle(udg_SpawnRectHash,4,7,gg_rct_244)
    call SaveRectHandle(udg_SpawnRectHash,4,8,gg_rct_245)
    call SaveRectHandle(udg_SpawnRectHash,4,9,gg_rct_246)
    call SaveRectHandle(udg_SpawnRectHash,4,$A,gg_rct_247) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,4,$B,gg_rct_248) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,4,$C,gg_rct_249) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,4,$D,gg_rct_250) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,4,$E,gg_rct_251) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,4,$F,gg_rct_252) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,4,16,gg_rct_253)
    call SaveRectHandle(udg_SpawnRectHash,4,17,gg_rct_254)
    call SaveRectHandle(udg_SpawnRectHash,4,18,gg_rct_255)
    call SaveRectHandle(udg_SpawnRectHash,4,19,gg_rct_256)
    call SaveRectHandle(udg_SpawnRectHash,4,20,gg_rct_257)
    call SaveRectHandle(udg_SpawnRectHash,4,21,gg_rct_258)
    call SaveRectHandle(udg_SpawnRectHash,4,22,gg_rct_259)
    call SaveRectHandle(udg_SpawnRectHash,4,23,gg_rct_260)
    call SaveRectHandle(udg_SpawnRectHash,4,24,gg_rct_261)
    call SaveRectHandle(udg_SpawnRectHash,4,25,gg_rct_262)
    call SaveRectHandle(udg_SpawnRectHash,4,26,gg_rct_263)
    call SaveRectHandle(udg_SpawnRectHash,4,27,gg_rct_264)
    call SaveRectHandle(udg_SpawnRectHash,4,28,gg_rct_265)
    call SaveRectHandle(udg_SpawnRectHash,4,29,gg_rct_266)
    call SaveRectHandle(udg_SpawnRectHash,4,30,gg_rct_267)
    call SaveRectHandle(udg_SpawnRectHash,4,31,gg_rct_268)
    call SaveRectHandle(udg_SpawnRectHash,4,32,gg_rct_269)
    call SaveRectHandle(udg_SpawnRectHash,4,33,gg_rct_270)
    call SaveRectHandle(udg_SpawnRectHash,4,34,gg_rct_271)
    call SaveRectHandle(udg_SpawnRectHash,4,35,gg_rct_272)
    call SaveRectHandle(udg_SpawnRectHash,4,36,gg_rct_273)
    call SaveRectHandle(udg_SpawnRectHash,4,37,gg_rct_274)
    call SaveRectHandle(udg_SpawnRectHash,4,38,gg_rct_275)
    call SaveRectHandle(udg_SpawnRectHash,4,39,gg_rct_276)
    call SaveRectHandle(udg_SpawnRectHash,4,40,gg_rct_277)
    call SaveRectHandle(udg_SpawnRectHash,4,41,gg_rct_278)
    call SaveRectHandle(udg_SpawnRectHash,4,42,gg_rct_279)
    call SaveRectHandle(udg_SpawnRectHash,4,43,gg_rct_280)
    call SaveRectHandle(udg_SpawnRectHash,4,44,gg_rct_281)
    call SaveRectHandle(udg_SpawnRectHash,4,45,gg_rct_282)
    call SaveRectHandle(udg_SpawnRectHash,4,46,gg_rct_283)
    call SaveRectHandle(udg_SpawnRectHash,4,47,gg_rct_284)
    call SaveRectHandle(udg_SpawnRectHash,4,48,gg_rct_285)
    call SaveRectHandle(udg_SpawnRectHash,4,49,gg_rct_286)
    call SaveRectHandle(udg_SpawnRectHash,4,50,gg_rct_287)
    call SaveRectHandle(udg_SpawnRectHash,4,51,gg_rct_288)
    call SaveRectHandle(udg_SpawnRectHash,4,52,gg_rct_289)
    call SaveRectHandle(udg_SpawnRectHash,4,53,gg_rct_290)
    call SaveRectHandle(udg_SpawnRectHash,4,54,gg_rct_291)
    call SaveRectHandle(udg_SpawnRectHash,4,55,gg_rct_292)
    call SaveRectHandle(udg_SpawnRectHash,4,56,gg_rct_293)
    call SaveRectHandle(udg_SpawnRectHash,4,57,gg_rct_294)
    call SaveRectHandle(udg_SpawnRectHash,4,58,gg_rct_295)
    call SaveRectHandle(udg_SpawnRectHash,4,59,gg_rct_296)
    call SaveRectHandle(udg_SpawnRectHash,4,60,gg_rct_297)
    call SaveRectHandle(udg_SpawnRectHash,4,61,gg_rct_298)
    call SaveRectHandle(udg_SpawnRectHash,4,62,gg_rct_299)
    call SaveRectHandle(udg_SpawnRectHash,4,63,gg_rct_300)
    call SaveRectHandle(udg_SpawnRectHash,4,64,gg_rct_301)
    call SaveRectHandle(udg_SpawnRectHash,4,65,gg_rct_302)
    call SaveRectHandle(udg_SpawnRectHash,4,66,gg_rct_303)
    call SaveRectHandle(udg_SpawnRectHash,4,67,gg_rct_304)
    call SaveRectHandle(udg_SpawnRectHash,4,68,gg_rct_305)
    call SaveRectHandle(udg_SpawnRectHash,4,69,gg_rct_306)
    call SaveRectHandle(udg_SpawnRectHash,4,70,gg_rct_307)
    call SaveRectHandle(udg_SpawnRectHash,4,71,gg_rct_308)
    call SaveRectHandle(udg_SpawnRectHash,4,72,gg_rct_309)
    call SaveRectHandle(udg_SpawnRectHash,4,73,gg_rct_310)
    call SaveRectHandle(udg_SpawnRectHash,4,74,gg_rct_311)
    call SaveRectHandle(udg_SpawnRectHash,4,75,gg_rct_312)
    call SaveRectHandle(udg_SpawnRectHash,4,76,gg_rct_313)
    call SaveRectHandle(udg_SpawnRectHash,4,77,gg_rct_314)
    call SaveRectHandle(udg_SpawnRectHash,4,78,gg_rct_315)
    call SaveRectHandle(udg_SpawnRectHash,4,79,gg_rct_316)
    call SaveRectHandle(udg_SpawnRectHash,4,80,gg_rct_317)
    call SaveRectHandle(udg_SpawnRectHash,4,81,gg_rct_318)
    call SaveRectHandle(udg_SpawnRectHash,4,82,gg_rct_319)
    call SaveRectHandle(udg_SpawnRectHash,4,83,gg_rct_320)
    call SaveRectHandle(udg_SpawnRectHash,4,84,gg_rct_321)
    call SaveRectHandle(udg_SpawnRectHash,4,85,gg_rct_322)
    call SaveInteger(udg_SpawnDataHash,2,4,85)
    call SaveRectHandle(udg_SpawnRectHash,5,1,gg_rct_127)
    call SaveRectHandle(udg_SpawnRectHash,5,2,gg_rct_128)
    call SaveRectHandle(udg_SpawnRectHash,5,3,gg_rct_129)
    call SaveRectHandle(udg_SpawnRectHash,5,4,gg_rct_130)
    call SaveRectHandle(udg_SpawnRectHash,5,5,gg_rct_131)
    call SaveRectHandle(udg_SpawnRectHash,5,6,gg_rct_132)
    call SaveRectHandle(udg_SpawnRectHash,5,7,gg_rct_133)
    call SaveRectHandle(udg_SpawnRectHash,5,8,gg_rct_134)
    call SaveRectHandle(udg_SpawnRectHash,5,9,gg_rct_135)
    call SaveRectHandle(udg_SpawnRectHash,5,$A,gg_rct_136) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,5,$B,gg_rct_137) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,5,$C,gg_rct_138) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,5,$D,gg_rct_139) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,5,$E,gg_rct_140) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,5,$F,gg_rct_141) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,5,16,gg_rct_142)
    call SaveRectHandle(udg_SpawnRectHash,5,17,gg_rct_143)
    call SaveRectHandle(udg_SpawnRectHash,5,18,gg_rct_144)
    call SaveRectHandle(udg_SpawnRectHash,5,19,gg_rct_145)
    call SaveRectHandle(udg_SpawnRectHash,5,20,gg_rct_146)
    call SaveRectHandle(udg_SpawnRectHash,5,21,gg_rct_147)
    call SaveRectHandle(udg_SpawnRectHash,5,22,gg_rct_148)
    call SaveRectHandle(udg_SpawnRectHash,5,23,gg_rct_149)
    call SaveRectHandle(udg_SpawnRectHash,5,24,gg_rct_150)
    call SaveRectHandle(udg_SpawnRectHash,5,25,gg_rct_151)
    call SaveRectHandle(udg_SpawnRectHash,5,26,gg_rct_152)
    call SaveRectHandle(udg_SpawnRectHash,5,27,gg_rct_153)
    call SaveRectHandle(udg_SpawnRectHash,5,28,gg_rct_154)
    call SaveRectHandle(udg_SpawnRectHash,5,29,gg_rct_155)
    call SaveRectHandle(udg_SpawnRectHash,5,30,gg_rct_156)
    call SaveRectHandle(udg_SpawnRectHash,5,31,gg_rct_157)
    call SaveRectHandle(udg_SpawnRectHash,5,32,gg_rct_158)
    call SaveRectHandle(udg_SpawnRectHash,5,33,gg_rct_159)
    call SaveRectHandle(udg_SpawnRectHash,5,34,gg_rct_160)
    call SaveRectHandle(udg_SpawnRectHash,5,35,gg_rct_161)
    call SaveRectHandle(udg_SpawnRectHash,5,36,gg_rct_162)
    call SaveRectHandle(udg_SpawnRectHash,5,37,gg_rct_163)
    call SaveRectHandle(udg_SpawnRectHash,5,38,gg_rct_164)
    call SaveRectHandle(udg_SpawnRectHash,5,39,gg_rct_165)
    call SaveRectHandle(udg_SpawnRectHash,5,40,gg_rct_166)
    call SaveRectHandle(udg_SpawnRectHash,5,41,gg_rct_167)
    call SaveInteger(udg_SpawnDataHash,2,5,41)
    call SaveRectHandle(udg_SpawnRectHash,6,1,gg_rct_323)
    call SaveRectHandle(udg_SpawnRectHash,6,2,gg_rct_324)
    call SaveRectHandle(udg_SpawnRectHash,6,3,gg_rct_325)
    call SaveRectHandle(udg_SpawnRectHash,6,4,gg_rct_326)
    call SaveRectHandle(udg_SpawnRectHash,6,5,gg_rct_327)
    call SaveRectHandle(udg_SpawnRectHash,6,6,gg_rct_328)
    call SaveRectHandle(udg_SpawnRectHash,6,7,gg_rct_329)
    call SaveRectHandle(udg_SpawnRectHash,6,8,gg_rct_330)
    call SaveRectHandle(udg_SpawnRectHash,6,9,gg_rct_331)
    call SaveRectHandle(udg_SpawnRectHash,6,$A,gg_rct_332) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,6,$B,gg_rct_333) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,6,$C,gg_rct_334) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,6,$D,gg_rct_335) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,6,$E,gg_rct_336) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,6,$F,gg_rct_337) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,6,16,gg_rct_338)
    call SaveRectHandle(udg_SpawnRectHash,6,17,gg_rct_339)
    call SaveRectHandle(udg_SpawnRectHash,6,18,gg_rct_340)
    call SaveRectHandle(udg_SpawnRectHash,6,19,gg_rct_341)
    call SaveRectHandle(udg_SpawnRectHash,6,20,gg_rct_342)
    call SaveRectHandle(udg_SpawnRectHash,6,21,gg_rct_343)
    call SaveRectHandle(udg_SpawnRectHash,6,22,gg_rct_344)
    call SaveRectHandle(udg_SpawnRectHash,6,23,gg_rct_345)
    call SaveRectHandle(udg_SpawnRectHash,6,24,gg_rct_346)
    call SaveRectHandle(udg_SpawnRectHash,6,25,gg_rct_347)
    call SaveRectHandle(udg_SpawnRectHash,6,26,gg_rct_348)
    call SaveRectHandle(udg_SpawnRectHash,6,27,gg_rct_349)
    call SaveRectHandle(udg_SpawnRectHash,6,28,gg_rct_350)
    call SaveRectHandle(udg_SpawnRectHash,6,29,gg_rct_351)
    call SaveRectHandle(udg_SpawnRectHash,6,30,gg_rct_352)
    call SaveRectHandle(udg_SpawnRectHash,6,31,gg_rct_353)
    call SaveInteger(udg_SpawnDataHash,2,6,31)
    call SaveRectHandle(udg_SpawnRectHash,7,1,gg_rct_003)
    call SaveRectHandle(udg_SpawnRectHash,7,2,gg_rct_004)
    call SaveRectHandle(udg_SpawnRectHash,7,3,gg_rct_005)
    call SaveRectHandle(udg_SpawnRectHash,7,4,gg_rct_006)
    call SaveRectHandle(udg_SpawnRectHash,7,5,gg_rct_007)
    call SaveRectHandle(udg_SpawnRectHash,7,6,gg_rct_008)
    call SaveRectHandle(udg_SpawnRectHash,7,7,gg_rct_009)
    call SaveRectHandle(udg_SpawnRectHash,7,8,gg_rct_010)
    call SaveRectHandle(udg_SpawnRectHash,7,9,gg_rct_011)
    call SaveRectHandle(udg_SpawnRectHash,7,$A,gg_rct_012) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,7,$B,gg_rct_013) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,7,$C,gg_rct_014) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,7,$D,gg_rct_015) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,7,$E,gg_rct_016) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,7,$F,gg_rct_017) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,7,16,gg_rct_018)
    call SaveRectHandle(udg_SpawnRectHash,7,17,gg_rct_019)
    call SaveRectHandle(udg_SpawnRectHash,7,18,gg_rct_020)
    call SaveRectHandle(udg_SpawnRectHash,7,19,gg_rct_021)
    call SaveRectHandle(udg_SpawnRectHash,7,20,gg_rct_022)
    call SaveRectHandle(udg_SpawnRectHash,7,21,gg_rct_023)
    call SaveRectHandle(udg_SpawnRectHash,7,22,gg_rct_024)
    call SaveRectHandle(udg_SpawnRectHash,7,23,gg_rct_025)
    call SaveRectHandle(udg_SpawnRectHash,7,24,gg_rct_026)
    call SaveRectHandle(udg_SpawnRectHash,7,25,gg_rct_027)
    call SaveRectHandle(udg_SpawnRectHash,7,26,gg_rct_028)
    call SaveRectHandle(udg_SpawnRectHash,7,27,gg_rct_029)
    call SaveRectHandle(udg_SpawnRectHash,7,28,gg_rct_030)
    call SaveRectHandle(udg_SpawnRectHash,7,29,gg_rct_031)
    call SaveRectHandle(udg_SpawnRectHash,7,30,gg_rct_032)
    call SaveRectHandle(udg_SpawnRectHash,7,31,gg_rct_033)
    call SaveRectHandle(udg_SpawnRectHash,7,32,gg_rct_034)
    call SaveRectHandle(udg_SpawnRectHash,7,33,gg_rct_035)
    call SaveRectHandle(udg_SpawnRectHash,7,34,gg_rct_036)
    call SaveRectHandle(udg_SpawnRectHash,7,35,gg_rct_037)
    call SaveRectHandle(udg_SpawnRectHash,7,36,gg_rct_038)
    call SaveRectHandle(udg_SpawnRectHash,7,37,gg_rct_039)
    call SaveRectHandle(udg_SpawnRectHash,7,38,gg_rct_040)
    call SaveRectHandle(udg_SpawnRectHash,7,39,gg_rct_041)
    call SaveRectHandle(udg_SpawnRectHash,7,40,gg_rct_042)
    call SaveInteger(udg_SpawnDataHash,2,7,40)
    call SaveRectHandle(udg_SpawnRectHash,8,1,gg_rct_378)
    call SaveRectHandle(udg_SpawnRectHash,8,2,gg_rct_385)
    call SaveRectHandle(udg_SpawnRectHash,8,3,gg_rct_386)
    call SaveRectHandle(udg_SpawnRectHash,8,4,gg_rct_387)
    call SaveRectHandle(udg_SpawnRectHash,8,5,gg_rct_388)
    call SaveRectHandle(udg_SpawnRectHash,8,6,gg_rct_389)
    call SaveRectHandle(udg_SpawnRectHash,8,7,gg_rct_390)
    call SaveRectHandle(udg_SpawnRectHash,8,8,gg_rct_391)
    call SaveRectHandle(udg_SpawnRectHash,8,9,gg_rct_392)
    call SaveRectHandle(udg_SpawnRectHash,8,$A,gg_rct_379) // $A = 10
    call SaveRectHandle(udg_SpawnRectHash,8,$B,gg_rct_380) // $B = 11
    call SaveRectHandle(udg_SpawnRectHash,8,$C,gg_rct_381) // $C = 12
    call SaveRectHandle(udg_SpawnRectHash,8,$D,gg_rct_382) // $D = 13
    call SaveRectHandle(udg_SpawnRectHash,8,$E,gg_rct_383) // $E = 14
    call SaveRectHandle(udg_SpawnRectHash,8,$F,gg_rct_384) // $F = 15
    call SaveInteger(udg_SpawnDataHash,2,8,$F) // $F = 15
    call SaveRectHandle(udg_SpawnRectHash,9,1,gg_rct_464)
    call SaveRectHandle(udg_SpawnRectHash,9,2,gg_rct_465)
    call SaveRectHandle(udg_SpawnRectHash,9,3,gg_rct_466)
    call SaveRectHandle(udg_SpawnRectHash,9,4,gg_rct_467)
    call SaveRectHandle(udg_SpawnRectHash,9,5,gg_rct_468)
    call SaveRectHandle(udg_SpawnRectHash,9,6,gg_rct_469)
    call SaveRectHandle(udg_SpawnRectHash,9,7,gg_rct_470)
    call SaveRectHandle(udg_SpawnRectHash,9,8,gg_rct_471)
    call SaveInteger(udg_SpawnDataHash,2,9,8)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Zone_Spawn_System_GroupSize takes group g returns integer
    set bj_groupCountUnits=0
    call ForGroup(g,function CountUnitsInGroupEnum)
    return bj_groupCountUnits
endfunction

function Trig_Zone_Spawn_System_ScaleSpawnHP takes unit u,integer l_zoneId returns nothing
    local real hc=GetPlayerHandicap(Player($B)) // $B = 11
    local real l_mult
    if(not udg_HandicapHPScaling or hc<=1.)then
        return
    endif
    // ((((hc) minus (1)) times (l_zoneId)) times (0.1)) plus (1).
    set l_mult=((hc-1.)*l_zoneId*.1)+1.
    // ((((maximum health of u) times (l_mult)) divided by (hc)) plus (0.5)) with its decimal part removed.
    call BlzSetUnitMaxHP(u,R2I((BlzGetUnitMaxHP(u)*l_mult/ hc)+.5))
    call UnitAddAbility(u,'A1B4') // 'A1B4': ability "Handicap Adjusted HP"
    call SetUnitAbilityLevel(u,'A1B4',l_zoneId) // 'A1B4': ability "Handicap Adjusted HP"
endfunction

function Trig_Zone_Spawn_System_SpawnZoneUnits takes integer i,integer l_amount returns nothing
    local integer l_rectCount=LoadInteger(udg_SpawnDataHash,2,i)
    local integer l_maxUnits=LoadInteger(udg_SpawnDataHash,7,i)
    local unitpool l_pool
    local rect l_spawnRect
    local real l_y
    local real l_x
    local unit l_spawned
    local group l_zoneGroup=LoadGroupHandle(udg_SpawnTimerHash,5,i)
    local integer j=Trig_Zone_Spawn_System_GroupSize(l_zoneGroup)
    // Starting value for targetUnitCount:
    // (amount) plus (j).
    local integer targetUnitCount=l_amount+j
    local integer l_missing
    local integer l_poolRow=3
    if Trig_Damage_Engine_IsNight()then
        set l_poolRow=4
    endif
    if(i==8 and udg_HellSpawnsActive)then
        set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,l_poolRow,$A) // $A = 10
    else
        set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,l_poolRow,i)
    endif
    if targetUnitCount>l_maxUnits then
        set targetUnitCount=l_maxUnits
    endif
    // (targetUnitCount) minus (j).
    set l_missing=targetUnitCount-j
    loop
        exitwhen j>=targetUnitCount
        // A random whole number from 1 through l_rectCount.
        set l_spawnRect=LoadRectHandle(udg_SpawnRectHash,i,GetRandomInt(1,l_rectCount))
        // A random decimal number between GetRectMinY(l_spawnRect) and GetRectMaxY(l_spawnRect).
        set l_y=GetRandomReal(GetRectMinY(l_spawnRect),GetRectMaxY(l_spawnRect))
        // A random decimal number between GetRectMinX(l_spawnRect) and GetRectMaxX(l_spawnRect).
        set l_x=GetRandomReal(GetRectMinX(l_spawnRect),GetRectMaxX(l_spawnRect))
        set l_spawned=PlaceRandomUnit(l_pool,Player($B),l_x,l_y,270.) // $B = 11
        call SetUnitUserData(l_spawned,i)
        call GroupAddUnit(l_zoneGroup,l_spawned)
        call Trig_Zone_Spawn_System_ScaleSpawnHP(l_spawned,i)
        if udg_EternityMode then
            call Unit_ScaleToLevel60(l_spawned)
        endif
        if Trig_Damage_Engine_IsNight()then
            call SetUnitState(l_spawned,UNIT_STATE_MANA,GetUnitState(l_spawned,UNIT_STATE_MAX_MANA))
        else
            // (maximum mana of l_spawned) times (0.5).
            call SetUnitState(l_spawned,UNIT_STATE_MANA,GetUnitState(l_spawned,UNIT_STATE_MAX_MANA)*.5)
        endif
        // A random whole number from 1 through l_rectCount.
        set l_spawnRect=LoadRectHandle(udg_SpawnRectHash,i,GetRandomInt(1,l_rectCount))
        // A random decimal number between GetRectMinY(l_spawnRect) and GetRectMaxY(l_spawnRect).
        set l_y=GetRandomReal(GetRectMinY(l_spawnRect),GetRectMaxY(l_spawnRect))
        // A random decimal number between GetRectMinX(l_spawnRect) and GetRectMaxX(l_spawnRect).
        set l_x=GetRandomReal(GetRectMinX(l_spawnRect),GetRectMaxX(l_spawnRect))
        call IssuePointOrderById(l_spawned,$D0016,l_x,l_y) // $D0016 = 851990
        set j=j+1
    endloop
    set l_zoneGroup=null
    set l_spawned=null
    set l_pool=null
    set l_spawnRect=null
endfunction

function Trig_Zone_Spawn_System_RefreshZoneUnit takes nothing returns nothing
    local integer l_rectCount=LoadInteger(udg_SpawnDataHash,2,udg_CurrentZoneId)
    local unit l_enumUnit=GetEnumUnit()
    local rect l_spawnRect
    local real l_y
    local real l_x
    if(l_enumUnit!=null)then
        if((GetUnitState(l_enumUnit,UNIT_STATE_LIFE)>.405)and(GetOwningPlayer(l_enumUnit)==Player($B))and(GetUnitUserData(l_enumUnit)==udg_CurrentZoneId))then // $B = 11
            call GroupAddUnit(udg_ZoneAliveGroup,l_enumUnit)
            set bj_groupCountUnits=bj_groupCountUnits+1
            // A random whole number from 1 through l_rectCount.
            set l_spawnRect=LoadRectHandle(udg_SpawnRectHash,udg_CurrentZoneId,GetRandomInt(1,l_rectCount))
            // A random decimal number between GetRectMinY(l_spawnRect) and GetRectMaxY(l_spawnRect).
            set l_y=GetRandomReal(GetRectMinY(l_spawnRect),GetRectMaxY(l_spawnRect))
            // A random decimal number between GetRectMinX(l_spawnRect) and GetRectMaxX(l_spawnRect).
            set l_x=GetRandomReal(GetRectMinX(l_spawnRect),GetRectMaxX(l_spawnRect))
            call IssuePointOrderById(l_enumUnit,$D0016,l_x,l_y) // $D0016 = 851990
        else
            call SetUnitUserData(l_enumUnit,0)
        endif
    endif
    set l_enumUnit=null
    set l_spawnRect=null
endfunction

function Trig_Zone_Spawn_System_ZoneRespawnTick takes nothing returns nothing
    local timer l_expired=GetExpiredTimer()
    local integer i=LoadInteger(udg_SpawnTimerHash,GetHandleId(l_expired),0)
    local group l_zoneGroup=LoadGroupHandle(udg_SpawnTimerHash,5,i)
    local integer l_maxUnits=LoadInteger(udg_SpawnDataHash,7,i)
    local integer l_spawnCount=LoadInteger(udg_SpawnDataHash,5,i)
    set udg_ZoneAliveGroup=CreateGroup()
    set bj_groupCountUnits=0
    set udg_CurrentZoneId=i
    call ForGroup(l_zoneGroup,function Trig_Zone_Spawn_System_RefreshZoneUnit)
    call SaveGroupHandle(udg_SpawnTimerHash,5,i,udg_ZoneAliveGroup)
    if(udg_InCinematicMode==false and bj_groupCountUnits<l_maxUnits)then
        call Trig_Zone_Spawn_System_SpawnZoneUnits(i,l_spawnCount)
    endif
    call GroupClear(l_zoneGroup)
    call DestroyGroup(l_zoneGroup)
    set l_zoneGroup=null
    set udg_ZoneAliveGroup=null
    set l_expired=null
endfunction

function Trig_Zone_Spawn_System_RemoveSpawnedUnit takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Zone_Spawn_System_ZoneDespawn takes nothing returns nothing
    local timer l_expired=GetExpiredTimer()
    local integer i=LoadInteger(udg_SpawnTimerHash,GetHandleId(l_expired),0)
    local group l_zoneGroup=LoadGroupHandle(udg_SpawnTimerHash,5,i)
    local unit l_enumUnit
    local timer l_waveTimer=LoadTimerHandle(udg_SpawnTimerHash,3,i)
    local timerdialog a
    local timerdialog b
    call PauseTimer(l_waveTimer)
    call ForGroup(l_zoneGroup,function Trig_Zone_Spawn_System_RemoveSpawnedUnit)
    call GroupClear(l_zoneGroup)
    set l_zoneGroup=null
    set l_enumUnit=null
    set l_expired=null
    set l_waveTimer=null
endfunction

function Trig_Zone_Spawn_System_IsAggressorUnit takes nothing returns boolean
    return GetUnitAbilityLevel(GetTriggerUnit(),'A11M')>0 or((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers)and GetUnitAbilityLevel(GetTriggerUnit(),'Avul')<=0)and GetUnitAbilityLevel(GetTriggerUnit(),'A0UV')<=0) // 'A11M': ability "Aggressor"; 'Avul': standard ability reference "Invulnerable"; 'A0UV': ability "Non-Aggressor"
endfunction

function Trig_Zone_Spawn_System_SpawnsEnabled takes nothing returns boolean
    return not udg_InCinematicMode and not udg_SpawnsPaused
endfunction

function Trig_Zone_Spawn_System_OnZoneEntered takes nothing returns nothing
    local integer i=LoadInteger(udg_SpawnRectHash,GetHandleId(GetTriggeringRegion()),0)
    local timer l_zoneTimer=LoadTimerHandle(udg_SpawnTimerHash,1,i)
    local timer l_waveTimer=LoadTimerHandle(udg_SpawnTimerHash,3,i)
    local integer l_startCount=LoadInteger(udg_SpawnDataHash,6,i)
    local real l_remaining=TimerGetRemaining(l_zoneTimer)
    if l_remaining==.0 then
        call Trig_Zone_Spawn_System_SpawnZoneUnits(i,l_startCount)
        call TimerStart(l_waveTimer,30,true,function Trig_Zone_Spawn_System_ZoneRespawnTick)
    endif
    // Increase l_remaining by 60.
    set l_remaining=l_remaining+60.
    if l_remaining>300. then
        set l_remaining=300.
    endif
    call TimerStart(l_zoneTimer,l_remaining,false,function Trig_Zone_Spawn_System_ZoneDespawn)
    set l_zoneTimer=null
    set l_waveTimer=null
endfunction

function Trig_Zone_Spawn_System_Actions takes nothing returns nothing
    local region l_reg
    local integer i=1
    local integer j
    local integer l_zoneCount=LoadInteger(udg_SpawnDataHash,1,0)
    local integer l_rectCount
    set udg_ZoneEnterTrigger=CreateTrigger()
    loop
        exitwhen i>l_zoneCount
        set l_rectCount=LoadInteger(udg_SpawnDataHash,2,i)
        set j=1
        loop
            exitwhen j>l_rectCount
            set l_reg=CreateRegion()
            call RegionAddRect(l_reg,LoadRectHandle(udg_SpawnRectHash,i,j))
            call SaveInteger(udg_SpawnRectHash,GetHandleId(l_reg),0,i)
            call TriggerRegisterEnterRegion(udg_ZoneEnterTrigger,l_reg,null)
            set j=j+1
        endloop
        set i=i+1
    endloop
    set l_reg=null
    call TriggerAddAction(udg_ZoneEnterTrigger,function Trig_Zone_Spawn_System_OnZoneEntered)
    call TriggerAddCondition(udg_ZoneEnterTrigger,Condition(function Trig_Zone_Spawn_System_IsAggressorUnit))
    call TriggerAddCondition(udg_ZoneEnterTrigger,Condition(function Trig_Zone_Spawn_System_SpawnsEnabled))
endfunction

// World Editor calls InitTrig_Zone automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Zone (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Zone takes nothing returns nothing
endfunction

function Register_Zone_Rects_Init takes nothing returns nothing
    set gg_trg_Zone_Rects_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Zone_Rects_Init,function Trig_Zone_Rects_Init_Actions)
endfunction

function Register_Zone_Spawn_System takes nothing returns nothing
    set gg_trg_Zone_Spawn_System=CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_Zone_Spawn_System,.5,false)
    call TriggerAddAction(gg_trg_Zone_Spawn_System,function Trig_Zone_Spawn_System_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Zone takes nothing returns nothing
    call Register_Zone_Rects_Init() // run by MapBootstrap
    call Register_Zone_Spawn_System()
endfunction

endlibrary
