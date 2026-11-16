# speedhistory

the speed of each predicate across every commit. Each record is m(Commit, Predicate, Steps) (steps from the meta-interpreter, so they are the same on every machine). For each predicate it gives the best commit, the latest change, and the regressions: commits more than a threshold percent slower than the best before them.

## Use

```prolog
?- use_module(prolog/speedhistory).
?- history([m(1, sort, 100), m(2, sort, 80), m(3, sort, 95)], sort, H).    % H = [1-100, 2-80, 3-95]
?- regressions([m(1, sort, 100), m(2, sort, 80), m(3, sort, 95)], sort, 10, R).   % R = [3-slower(95, best(80))]
?- best([m(1, sort, 100), m(2, sort, 80)], sort, B).                         % B = 2-80
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every history of 1..4 commits for one predicate with step counts from {50, 80, 100, 120}.

1. The best commit has the fewest steps (the first such on ties).
2. A regression is a commit more than the threshold slower than every commit before it.
3. A higher threshold never finds more regressions.
4. The trend compares the first and last commits.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
