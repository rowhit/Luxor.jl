#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

srand(42)

function testlabels(fname)
    pagewidth, pageheight = 800, 800

    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    sethue("black")

    # compasspoint version
    compass = [:E, :SE, :S, :SW, :W, :NW, :N, :NE]

    fontsize(7)
    for i in 0:pi/64:2pi
        pt = polar(300, i)
        line(between(O, pt, 0.5), pt, :stroke)
        circle(pt, 2, :fill)
        n = mod1(convert(Int, div(i + pi/8, pi/4) + 1), 8)
        label(string(compass[n]), compass[n], pt)
    end

    # angle version
    pg = ngon(O, 100, 32, 0, vertices=true)
    poly(pg, :stroke, close=true)
    for pt in pg
        circle(pt, 3, :fill)
        s = slope(O, pt)
        pistring = nearestpirat(slope(O, pt))
        label(string(round(s, 1)), s, pt, offset=-15)
        label(string(round(s, 1)), s, pt, offset=15)
    end


    @test finish() == true
    println("...finished labels test, saved in $(fname)")
end

fname = "label-test.png"
testlabels(fname)
