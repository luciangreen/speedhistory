% speedhistory: the speed of each predicate across every commit. Each record is
% m(Commit, Predicate, Steps) (steps from the meta-interpreter, so they are the same on every
% machine). For each predicate it gives the best commit, the latest change, and the
% regressions: commits more than a threshold percent slower than the best before them.
%?- history([m(1, sort, 100), m(2, sort, 80), m(3, sort, 95)], sort, H).    % H = [1-100, 2-80, 3-95]
%?- regressions([m(1, sort, 100), m(2, sort, 80), m(3, sort, 95)], sort, 10, R).   % R = [3-slower(95, best(80))]
%?- best([m(1, sort, 100), m(2, sort, 80)], sort, B).                         % B = 2-80
:- module(speedhistory, [history/3, best/3, regressions/4, trend/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

history(Ms, P, H) :- findall(C-S, member(m(C, P, S), Ms), H0), msort(H0, H).
best(Ms, P, C-S) :- history(Ms, P, H), H \== [], foldl([C1-S1, C0-S0, B]>>( S1 < S0 -> B = C1-S1 ; B = C0-S0 ), H, _-inf, C-S), S \== inf.

% regressions(+Ms, +Pred, +Percent, -Regs): commits slower than the best so far by more than Percent.
regressions(Ms, P, Pct, R) :- history(Ms, P, H), foldl([C-S, Best0-R0, Best-R1]>>( Best0 \== none, S * 100 > Best0 * (100 + Pct) -> R1 = [C-slower(S, best(Best0))|R0], Best = Best0 ; R1 = R0, ( Best0 == none -> Best = S ; Best is min(Best0, S) ) ), H, none-[], _-R2), reverse(R2, R).

% trend(+Ms, +Pred, -Trend): faster, slower or same, from the first commit to the last.
trend(Ms, P, T) :- history(Ms, P, H), ( H = [_-A|_], last(H, _-B) -> ( B < A -> T = faster ; B > A -> T = slower ; T = same ) ; T = none ).
