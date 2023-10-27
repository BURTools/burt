include_guard(GLOBAL)

function(burt_message level)

    message(${level} "burt>" ${ARGN})
endfunction()

function(burt_push_message_scope scope)
    get_property(_temp GLOBAL PROPERTY _BURT_MESSAGE_SCOPE)
    list(APPEND _temp scope)
    set_property(GLOBAL PROPERTY _BURT_MESSAGE_SCOPE "${_temp}")
endfunction()

function(burt_pop_message_scope)
    get_property(_temp GLOBAL PROPERTY _BURT_MESSAGE_SCOPE)
    list(POP_BACK _temp)
    set_property(GLOBAL PROPERTY _BURT_MESSAGE_SCOPE "${_temp}")
endfunction()
