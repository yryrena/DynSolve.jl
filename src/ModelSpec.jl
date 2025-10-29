# src/ModelSpec.jl
########################
# data containers
########################

struct EquationData
    name::Symbol
    expr::Expr
end

Base.@kwdef struct Model
    variables::Vector{Symbol} = Symbol[]
    parameters::Dict{Symbol,Any} = Dict{Symbol,Any}()
    equations::Vector{EquationData} = EquationData[]
end

########################
# DSL stubs
########################

function var(args...)
    nothing
end

function param(args...; kwargs...)
    nothing
end

function equation(args...)
    nothing
end

########################
# internal helpers
########################

function _push_vars!(m::Model, syms...)
    for s in syms
        s isa Symbol || error("var() only accepts Symbols, got $s")
        push!(m.variables, s)
    end
    return m
end

function _push_params!(m::Model, pairs...)
    for p in pairs
        if p isa Expr && p.head == :(=)
            ## case: :(β = 0.99)
            pname = p.args[1]
            pval  = p.args[2]

        elseif p isa Expr && p.head == :kw
            ## safety: Expr(:kw, :β, 0.99)
            pname = p.args[1]
            pval  = p.args[2]

        else
            error("param() got unexpected argument form: ", p)
        end

        pname isa Symbol || error("param name must be a Symbol, got $pname")
        m.parameters[pname] = pval
    end
    return m
end

function _push_equation!(m::Model, name_expr, eq_expr)
    name_expr isa Symbol || error("equation() first arg must be Symbol, got $name_expr")
    eq_expr isa Expr || error("equation() second arg must be Expr, got $eq_expr")
    push!(m.equations, EquationData(name_expr, eq_expr))
    return m
end


## optional helper (not strictly required for the macro to run,
function _parse_block(block_expr::Expr)
    block_expr.head == :block || error("@dgesys expects `begin ... end` block")
    m = Model()
    for stmt in block_expr.args
        if stmt isa Expr && stmt.head == :call
            fname = stmt.args[1]
            if fname === :var
                _push_vars!(m, stmt.args[2:end]...)
            elseif fname === :param
                _push_params!(m, stmt.args[2:end]...)
            elseif fname === :equation
                length(stmt.args) == 3 ||
                    error("equation(name, :( ... )) expects two args")
                _push_equation!(m, stmt.args[2], stmt.args[3])
            else
                error("Unknown statement `$fname` in @dgesys block. Supported: var, param, equation.")
            end
        else
            error("Unsupported statement in @dgesys block: $stmt")
        end
    end
    return m
end

########################
# macro frontend
########################

macro dgesys(block)
    return esc(quote
        ## capture the syntax exactly as written at the call site
        local __blk__ = $(QuoteNode(block))

        ## require a `begin ... end` block
        if !(__blk__ isa Expr && __blk__.head == :block)
            error("@dgesys expects a `begin ... end` block, got ", __blk__)
        end

        ## will fill this in with variables/params/equations
        local __m__ = DynSolve.Model()

        ## helper: unwrap QuoteNode(:x) -> :x
        local function __normalize_arg(x)
            x isa QuoteNode ? x.value : x
        end

        ## helper: turn Expr(:parameters, Expr(:kw, :β, 0.99), ...)
        ## into [ :(β = 0.99), :(δ = 0.025), ... ]
        local function __kwparams_to_assign_exprs(param_expr)
            assigns = Expr[]
            for kw in param_expr.args
                if kw isa Expr && kw.head == :kw
                    local pname = kw.args[1]
                    local pval  = kw.args[2]
                    push!(assigns, Expr(:(=), pname, pval))
                else
                    error("param() got unexpected argument form: ", kw)
                end
            end
            return assigns
        end

        for __stmt__ in __blk__.args

            ## skip noise like line numbers and source location markers
            if __stmt__ isa LineNumberNode
                continue
            end
            if __stmt__ isa Expr && __stmt__.head == :macrocall
                continue
            end

            ## handle DSL calls
            if __stmt__ isa Expr && __stmt__.head == :call
                local __fname__ = __stmt__.args[1]

                if __fname__ === :var
                    local __syms__ = (__normalize_arg(arg) for arg in __stmt__.args[2:end])
                    DynSolve._push_vars!(__m__, collect(__syms__)...)

                elseif __fname__ === :param
                    local __rawargs__ = __stmt__.args[2:end]
                    local __assign_exprs__ = Expr[]
                    for __arg__ in __rawargs__
                        if __arg__ isa Expr && __arg__.head == :parameters
                            append!(__assign_exprs__, __kwparams_to_assign_exprs(__arg__))
                        else
                            push!(__assign_exprs__, __arg__)
                        end
                    end
                    DynSolve._push_params!(__m__, __assign_exprs__...)

                elseif __fname__ === :equation
                    length(__stmt__.args) == 3 ||
                        error("equation(name, :( ... )) expects two args")

                    local __eqname__ = __normalize_arg(__stmt__.args[2])
                    local __eqexpr__ = __stmt__.args[3]
                    DynSolve._push_equation!(__m__, __eqname__, __eqexpr__)

                else
                    error("Unknown statement `$__fname__` in @dgesys block. Supported: var, param, equation.")
                end

                continue
            end

            ## anything else = invalid DSL
            error("Unsupported statement in @dgesys block: ", __stmt__)
        end

        __m__
    end)
end