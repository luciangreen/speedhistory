:- module(cases, [title/1, case/3]).
:- use_module('../prolog/speedhistory').
:- use_module(engine).
title('speedhistory').
ms_g(Ms) :- rnd_int(1, 8, N), numlist(1, N, Cs), findall(m(C, P, S), ( member(C, Cs), member(P, [sort, parse]) ), Ms0), maplist([m(C, P, _), m(C, P, S)]>>rnd_int(40, 160, S), Ms0, Ms).
case(history, [Ms, P], history) :- ms_g(Ms), rnd_pick([sort, parse], P).
case(best, [Ms, P], best) :- ms_g(Ms), rnd_pick([sort, parse], P).
case(regressions, [Ms, P, Pct], regressions) :- ms_g(Ms), rnd_pick([sort, parse], P), rnd_pick([0, 10, 25], Pct).
case(trend, [Ms, P], trend) :- ms_g(Ms), rnd_pick([sort, parse], P).
