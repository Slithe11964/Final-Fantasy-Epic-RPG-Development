library TDifficulty
function Difficulty_AddHandicap takes nothing returns nothing
    // (udg_EnemyHandicap) plus (udg_EnemyHpPerPlayer).
    set udg_EnemyHandicap=udg_EnemyHandicap+udg_EnemyHpPerPlayer
endfunction

function Difficulty_SumHandicap takes force f returns nothing
    set udg_EnemyHandicap=.0
    call ForForce(f,function Difficulty_AddHandicap)
    if(udg_EnemyHandicap<100.)then
        set udg_EnemyHandicap=100.
    endif
endfunction

function InitTrig_Difficulty takes nothing returns nothing
endfunction

endlibrary
