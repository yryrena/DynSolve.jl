module Utils

"""
    _info(msg)

Internal helper for lightweight logging. 
Right now just calls `@info`, but we centralize in case we want to add verbosity levels later.
"""
function _info(msg)
    @info msg
    return nothing
end

end   ## module