Scriptname arcs_Data extends Quest  

arcs_Data function GetArcsData() global
    return Quest.GetQuest("arcs_MainQuest") as arcs_Data
endfunction

;constants
int property DHLP_STATE_OFF = 0 autoReadOnly
int property DHLP_STATE_SUSPENDING = 10 autoReadOnly
int property DHLP_STATE_SUSPENDED = 11 autoReadOnly
int property DHLP_STATE_RESUMING = 20 autoReadOnly
int property DHLP_STATE_SUSPENDED_OTHER_MOD = 30 autoReadOnly

;mod globals
string property DhlpSuspendByMod auto
int property DhlpSuspend auto

Actor property ThePlayer auto
