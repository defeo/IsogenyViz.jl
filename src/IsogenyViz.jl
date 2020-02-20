module IsogenyViz

using Luxor
using Nemo
using EllipticCurves

export CMgraph

"""
Draw cyclic Complex Multiplcation Cayley graph on `nodes` nodes, with
edges defined by `arcs`.

`arcs` is a list of integer "jumps", indicating how many nodes each
type of edge must jump.

`sagittas` is a list of "relative bendings" for the arcs. If shorter than
`arcs`, sagittas are looped.

`colors` is a list of colors for the "jumps" in `arcs`. If shorter than
`arcs`, colors are looped.

`scale` controls the size of the drawing. 
"""
function CMgraph(nodes::Int, arcs::AbstractVector{Int};
                 sagittas=[0],
                 colors=["red","blue","green","magenta","yellow"],
                 scale=500)
    @layer begin
        origin()
        setcolor("black")
        vs = ngon(0, 0, scale / 2, nodes, vertices=true)
        cols = Iterators.take(Iterators.cycle(colors), length(arcs))
        sags = Iterators.take(Iterators.cycle(sagittas), length(arcs))
        for (a, c, s) in zip(arcs, cols, sags)
            for (i, v) in enumerate(vs)
                to = vs[mod1(i+a, length(vs))]
                @layer begin
                    setcolor(c)
                    if s > 0
                        arc2sagitta(v, to, scale * s, :stroke)
                    elseif s < 0
                        arc2sagitta(to, v, scale * -s, :stroke)
                    else
                        line(to, v, :stroke)
                    end
                end
            end
        end
        for v in vs
            circle(v, scale * 0.01 / log10(nodes), :fill)
        end
    end
end


end # module
