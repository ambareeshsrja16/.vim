# TLA+ Formatting Examples Corpus

Real code snippets from canonical TLA+ specifications showing indentation
patterns in context. Each example is attributed to its source spec.

---

## FastMutex.tla — IF/THEN/ELSE (PlusCal translation)

These examples show the PlusCal translator's canonical IF/THEN/ELSE output.
PlusCal translations use IF_col + 6 for THEN/ELSE (wider than hand-written).

### Simple IF/THEN/ELSE with single-conjunct bodies

```tla
l3(self) == /\ pc[self] = "l3"
            /\ IF y # 0
                  THEN /\ pc' = [pc EXCEPT ![self] = "l4"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "l6"]
            /\ UNCHANGED << x, y, b, j, failed >>
```

### IF/THEN/ELSE with multi-conjunct bodies

```tla
l9(self) == /\ pc[self] = "l9"
            /\ IF (j[self] \leq N)
                  THEN /\ ~b[j[self]]
                       /\ j' = [j EXCEPT ![self] = j[self]+1]
                       /\ pc' = [pc EXCEPT ![self] = "l9"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "l10"]
                       /\ j' = j
            /\ UNCHANGED << x, y, b, failed >>
```

### IF/THEN/ELSE with asymmetric branches

```tla
l10(self) == /\ pc[self] = "l10"
             /\ IF y # self
                   THEN /\ y = 0
                        /\ failed' = [failed EXCEPT ![self] = TRUE]
                   ELSE /\ TRUE
                        /\ UNCHANGED failed
             /\ pc' = [pc EXCEPT ![self] = "cs"]
             /\ UNCHANGED << x, y, b, j >>
```

### IF/THEN/ELSE with body on THEN line plus continuation

```tla
cs(self) == /\ pc[self] = "cs"
            /\ IF ~ failed[self]
                  THEN /\ TRUE
                       /\ pc' = [pc EXCEPT ![self] = "l11"]
                       /\ UNCHANGED failed
                  ELSE /\ failed' = [failed EXCEPT ![self] = FALSE]
                       /\ pc' = [pc EXCEPT ![self] = "start"]
            /\ UNCHANGED << x, y, b, j >>
```

---

## Bakery.tla — Nested IF/THEN/ELSE

### Deeply nested conditional with conjunction bodies

```tla
e2(self) == /\ pc[self] = "e2"
            /\ IF unchecked[self] # {}
                  THEN /\ \E i \in unchecked[self]:
                            /\ unchecked' = [unchecked EXCEPT ![self] = unchecked[self] \ {i}]
                            /\ IF num[i] > max[self]
                                  THEN /\ max' = [max EXCEPT ![self] = num[i]]
                                  ELSE /\ TRUE
                                       /\ max' = max
                       /\ pc' = [pc EXCEPT ![self] = "e2"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "e3"]
                       /\ UNCHANGED << unchecked, max >>
            /\ UNCHANGED << num, flag, nxt >>
```

### Another IF/THEN/ELSE in action guard

```tla
w1(self) == /\ pc[self] = "w1"
            /\ IF unchecked[self] # {}
                  THEN /\ \E i \in unchecked[self]:
                            nxt' = [nxt EXCEPT ![self] = i]
                       /\ ~ flag[nxt'[self]]
                       /\ pc' = [pc EXCEPT ![self] = "w2"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "cs"]
                       /\ nxt' = nxt
            /\ UNCHANGED << num, flag, unchecked, max >>
```

---

## Bakery.tla — Conjunction / Disjunction Lists

### Operator definition with aligned conjunctions

```tla
Init == (* Global variables *)
        /\ num = [i \in Procs |-> 0]
        /\ flag = [i \in Procs |-> FALSE]
        (* Process p *)
        /\ unchecked = [self \in Procs |-> {}]
        /\ max = [self \in Procs |-> 0]
        /\ nxt = [self \in Procs |-> 1]
        /\ pc = [self \in ProcSet |-> "ncs"]
```

### Mixed disjunction of conjunction blocks

```tla
e1(self) == /\ pc[self] = "e1"
            /\ \/ /\ flag' = [flag EXCEPT ![self] = ~ flag[self]]
                  /\ pc' = [pc EXCEPT ![self] = "e1"]
                  /\ UNCHANGED <<unchecked, max>>
               \/ /\ flag' = [flag EXCEPT ![self] = TRUE]
                  /\ unchecked' = [unchecked EXCEPT ![self] = Procs \ {self}]
                  /\ max' = [max EXCEPT ![self] = 0]
                  /\ pc' = [pc EXCEPT ![self] = "e2"]
            /\ UNCHANGED << num, nxt >>
```

### Complex invariant with nested disjunctions

```tla
Before(i,j) == /\ num[i] > 0
               /\ \/ pc[j] \in {"ncs", "e1", "exit"}
                  \/ /\ pc[j] = "e2"
                     /\ \/ i \in unchecked[j]
                        \/ max[j] >= num[i]
                  \/ /\ pc[j] = "e3"
                     /\ max[j] >= num[i]
                  \/ /\ pc[j] \in {"e4", "w1", "w2"}
                     /\ <<num[i],i>> \prec <<num[j],j>>
                     /\ (pc[j] \in {"w1", "w2"}) => (i \in unchecked[j])
```

### Universal quantifier with conjunction body

```tla
IInv == \A i \in Procs :
           /\ (pc[i] \in {"e4", "w1", "w2", "cs"}) => (num[i] # 0)
           /\ (pc[i] \in {"e2", "e3"}) => flag[i]
           /\ (pc[i] = "w2") => (nxt[i] # i)
           /\ pc[i] \in {"w1", "w2"} => i \notin unchecked[i]
           /\ (pc[i] \in {"w1", "w2"}) =>
                 \A j \in (Procs \ unchecked[i]) \ {i} : Before(i, j)
           /\ /\ (pc[i] = "w2")
              /\ \/ (pc[nxt[i]] = "e2") /\ (i \notin unchecked[nxt[i]])
                 \/ pc[nxt[i]] = "e3"
              => max[nxt[i]] >= num[i]
           /\ (pc[i] = "cs") => \A j \in Procs \ {i} : Before(i, j)
```

---

## Paxos.tla — IF/THEN/ELSE Inside Quantifier

### Conditional inside universal quantifier in conjunction list

```tla
TypeOK == /\ maxBal \in [Acceptor -> Ballot \cup {-1}]
          /\ maxVBal \in [Acceptor -> Ballot \cup {-1}]
          /\ maxVal \in [Acceptor -> Value \cup {None}]
          /\ msgs \subseteq Message
          /\ \A a \in Acceptor : IF maxVBal[a] = -1
                                   THEN maxVal[a] = None
                                   ELSE <<maxVBal[a], maxVal[a]>> \in votes[a]
```

---

## EWD998.tla — IF/THEN/ELSE in Record

### Conditional inside record field (single-line)

```tla
tcolor' = IF color[i] = "black" THEN "black" ELSE tcolor
```

### Conditional in invariant (multi-line, aligned)

```tla
\/ P1:: /\ \A i \in Rng(token.pos+1, N-1): active[i] = FALSE
        /\ IF token.pos = N-1
           THEN token.q = 0
           ELSE token.q = Sum(counter, Rng(token.pos+1,N-1))
```

---

## bcastByz.tla — IF/THEN/ELSE Inside Function Constructor

### Conditional in array comprehension (multi-line)

```tla
rcvd' = [ i \in Proc |-> IF i # self
                            THEN rcvd[i]
                            ELSE rcvd[self] \cup newMessages ]
```

### Conditional with set expression (single-line)

```tla
sent \cup (IF includeByz THEN ByzMsgs ELSE {})
```

---

## LamportMutex.tla — Inline IF/THEN/ELSE

### Conditional in EXCEPT expression

```tla
/\ clock' = [clock EXCEPT ![p] = IF c > clock[p] THEN c + 1 ELSE @ + 1]
```

### Conditional in function constructor

```tla
[r \in Proc |-> IF s=r THEN network[s][r] ELSE Append(network[s][r], m)]
```

---

## FastMutex.tla — Operator Definitions and Spec Structure

### Type-correctness pattern

```tla
TypeOK == /\ num \in [Procs -> Nat]
          /\ flag \in [Procs -> BOOLEAN]
          /\ unchecked \in [Procs -> SUBSET Procs]
          /\ max \in [Procs -> Nat]
          /\ nxt \in [Procs -> Procs]
          /\ pc \in [Procs -> {"ncs", "e1", "e2", "e3",
                               "e4", "w1", "w2", "cs", "exit"}]
```

### Lexicographic ordering definition

```tla
a \prec b == \/ a[1] < b[1]
             \/ (a[1] = b[1]) /\ (a[2] < b[2])
```

### Mutual exclusion property

```tla
MutualExclusion == \A i,j \in Procs : (i # j) => ~ /\ pc[i] = "cs"
                                                    /\ pc[j] = "cs"
```

---

## Notes

- PlusCal-translated specs use wider indentation (IF+6 for THEN/ELSE) than
  hand-written TLA+ (IF+3). Both are acceptable.
- All examples preserve original whitespace from the source specs.
- This corpus is periodically expanded. See tla-formatting-rules.md for the
  distilled rules and known gaps.
