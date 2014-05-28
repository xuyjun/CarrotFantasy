GRID_WIDTH  = 80
HALF_WIDTH  = 40
MAX_ROW     = 7
MAX_COL     = 12

GRID_EMPTY  = 0
GRID_BAN    = 1

CF = CF or {}

CF.SOUND_MUSIC = true
CF.SOUND_EFFECT = true

CF.GAME_STATE = {
    READY   = 1,
    PLAYING = 2,
    PAUSING = 3
}

CF.GAME_STATISTICS = {
    ADV_MAP     = 1,
    HIDDEN_MAP  = 0,
    BOSS_MAP    = 0,

    TOTAL_MONEY    = 0,
    TOTAL_MONSTER  = 0,
    TOTAL_BOSS     = 0,
    TOTAL_ITEM     = 0
}

CF.BOOKMARK = {
    SKYLINE = 1,
    JUNGLE  = 0,
    DESERT  = 0
}