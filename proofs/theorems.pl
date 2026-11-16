% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/speedhistory').

% Domain: every history of 1..4 commits for one predicate with step counts from {50, 80, 100, 120}.
ms(Ms) :- between(1, 4, N), numlist(1, N, Cs), maplist([C, m(C, p, S)]>>member(S, [50, 80, 100, 120]), Cs, Ms).

% 1. The best commit has the fewest steps (the first such on ties).
theorem(best_is_minimum) :- forall(ms(Ms), ( best(Ms, p, C-S), forall(member(m(C2, p, S2), Ms), ( S =< S2, ( S2 =:= S -> C =< C2 ; true ) )) )).

% 2. A regression is a commit more than the threshold slower than every commit before it.
theorem(regressions_exact) :- forall(( ms(Ms), member(Pct, [0, 10, 30]) ), ( regressions(Ms, p, Pct, R),
    forall(member(m(C, p, S), Ms), iff(memberchk(C-_, R), ( findall(S0, ( member(m(C0, p, S0), Ms), C0 < C ), Before), Before \== [], min_list(Before, B), S * 100 > B * (100 + Pct) ))) )).

% 3. A higher threshold never finds more regressions.
theorem(threshold_monotone) :- forall(ms(Ms), ( regressions(Ms, p, 0, R0), regressions(Ms, p, 10, R1), regressions(Ms, p, 30, R2), length(R0, A), length(R1, B), length(R2, C), A >= B, B >= C )).

% 4. The trend compares the first and last commits.
theorem(trend_first_vs_last) :- forall(ms(Ms), ( trend(Ms, p, T), Ms = [m(_, p, A)|_], last(Ms, m(_, p, B)), ( B < A -> T == faster ; B > A -> T == slower ; T == same ) )).
