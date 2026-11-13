"""Keep reported siege/arena dialogue out of the native portrait renderer."""
from jtok import functions
from performance_runtime import put

CAPTION='    call DisplayTimedTextToForce(GetPlayersAll(),bj_lastTransmissionDuration+bj_TRANSMISSION_PORT_HANGTIME,"|cffffcc00"+l_name+":|r "+l_msg)'


def refresh(source):
    fs=functions(source)
    if 'Text_Transmission' in fs:
        original=fs['Text_Transmission']
        start=original.index('    if(l_speaker==null)then\n        call SetCinematicScene')
        end=original.index('    if(l_forced or l_dur>0',start)
        caption=original[:start]+CAPTION+'\n'+original[end:]
        caption=caption.replace('function Text_Transmission takes','function Text_Caption takes',1)
        say='''function Text_CaptionSay takes unit speaker,string message,boolean forced returns nothing
    call Text_Caption(speaker,null,message,null,null,0,forced)
endfunction'''
        source=source.replace('function Text_Transmission takes',caption+'\n\n'+say+'\n\nfunction Text_Transmission takes',1)
        # A narrator has no valid unit portrait: never ask the engine to create
        # an empty model. Retain timing, skipping, sound and speaker naming.
        body=original.replace('        call SetCinematicScene(0,PLAYER_COLOR_RED,l_name,l_msg,bj_lastTransmissionDuration+bj_TRANSMISSION_PORT_HANGTIME,bj_lastTransmissionDuration)',CAPTION)
        assert body!=original
        source=put(source,'Text_Transmission',body)
    if 'Cine_Exit' in fs:
        body=fs['Cine_Exit'];marker='    call ResetToGameCamera(0)'
        assert body.count(marker)==1
        body=body.replace(marker,'    call EndCinematicScene()\n'+marker,1)
        source=put(source,'Cine_Exit',body)
    if any(n in fs for n in ('KalmSiege1_Define','KalmSiege2_Define','KalmSiege3_Define','Trig_Boss_Gilgamesh_Summon_Actions')):
        source=source.replace('call Text_Transmission(','call Text_Caption(').replace('call Text_Say(','call Text_CaptionSay(')
    return source
