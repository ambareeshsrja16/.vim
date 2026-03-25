# TLA+ Formatting & Indentation Rules

Distilled from canonical specs by Lamport and the tlaplus/Examples repository.
Use this as a reference when implementing or modifying TLA+ indent rules in Vim.

## Sources

- Paxos.tla (Lamport) — IF/THEN/ELSE inside conjunction lists
- FastMutex.tla (PlusCal translation) — IF/THEN/ELSE with conjunction bodies
- Bakery.tla (Lamport, PlusCal translation) — nested IF/THEN/ELSE, deep conjunction
- EWD998.tla / EWD840.tla (Safra/Dijkstra) — IF/THEN/ELSE inline and multi-line
- bcastByz.tla — IF/THEN/ELSE inside record constructors
- LamportMutex.tla — inline IF/THEN/ELSE

---

## 1. IF / THEN / ELSE

### Rule: THEN and ELSE align at IF_col + 3 (past "IF ")

THEN and ELSE always vertically align with each other, indented 3 columns past
the IF keyword. This places them at the same column where the IF condition
content begins.

### 1a. Single-line form

When the entire expression fits on one line:

```
IF cond THEN expr1 ELSE expr2
```

Examples from canonical specs:

```
clock' = [clock EXCEPT ![p] = IF c > clock[p] THEN c + 1 ELSE @ + 1]
tcolor' = IF color[i] = "black" THEN "black" ELSE tcolor
[r \in Proc |-> IF s=r THEN network[s][r] ELSE Append(network[s][r], m)]
```

### 1b. Multi-line, simple condition

```
IF condition
   THEN expression1
   ELSE expression2
```

### 1c. Multi-line, THEN/ELSE with conjunction bodies

Body items align past "THEN " or "ELSE " at keyword_col + 5:

```
IF condition
   THEN /\ expr1
        /\ expr2
   ELSE /\ expr3
        /\ expr4
```

### 1d. IF with conjunction condition

When the IF condition itself is a conjunction list, the /\ operators align at
IF_col + 3 (past "IF "). THEN and ELSE also go at IF_col + 3 — the keyword
name is visually distinct from /\ so there's no ambiguity:

```
IF /\ cond1
   /\ cond2
   /\ cond3
   THEN /\ body1
        /\ body2
   ELSE body3
```

### 1e. Nested inside /\ conjunction list

From Paxos.tla:
```
/\ \A a \in Acceptor : IF maxVBal[a] = -1
                         THEN maxVal[a] = None
                         ELSE <<maxVBal[a], maxVal[a]>> \in votes[a]
```

From FastMutex.tla (PlusCal-generated):
```
/\ IF y # 0
      THEN /\ pc' = [pc EXCEPT ![self] = "l4"]
      ELSE /\ pc' = [pc EXCEPT ![self] = "l6"]
```

Note: PlusCal translations often use IF_col + 6 (wider indent). Hand-written
specs tend to use IF_col + 3. Both are acceptable; IF_col + 3 is more
canonical for hand-written TLA+.

### 1f. Nested IF/THEN/ELSE

From Bakery.tla:
```
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
```

### 1g. IF/THEN/ELSE inside record constructor

From bcastByz.tla:
```
rcvd' = [ i \in Proc |-> IF i # self
                            THEN rcvd[i]
                            ELSE rcvd[self] \cup newMessages ]
```

---

## 2. /\ and \/ (Conjunction / Disjunction Lists)

### Rule: All /\ (or \/) in a list align vertically

```
Op == /\ condition1
      /\ condition2
      /\ condition3
```

### Disjunction:
```
\/ case1
\/ case2
\/ case3
```

### Mixed (disjunction of conjunction blocks):
```
/\ pc[self] = "e1"
/\ \/ /\ flag' = [flag EXCEPT ![self] = ~ flag[self]]
      /\ pc' = [pc EXCEPT ![self] = "e1"]
   \/ /\ flag' = [flag EXCEPT ![self] = TRUE]
      /\ pc' = [pc EXCEPT ![self] = "e2"]
```

### Operator definition alignment

The first /\ aligns with the content column after "== ":
```
Init == /\ x = 0
        /\ y = 1

Op(self) == /\ pc[self] = "start"
             /\ pc' = [pc EXCEPT ![self] = "l1"]
```

---

## 3. LET / IN

### Rule: IN aligns with its matching LET

```
/\ LET latestHB = GetHighestMsgOfTypes(HB)
   IN  expr
```

### Definitions inside LET indent past "LET ":
```
/\ LET x == expr1
       y == expr2
   IN  body
```

### IN with conjunction body:
```
LET x == expr
IN  /\ cond1
    /\ cond2
```

---

## 4. \E and \A (Quantifiers)

### Rule: Body indents to quantifier_col + 3 (past "\E " or "\A ")

When the quantifier binding ends with ":", the body aligns past the quantifier
keyword:

```
\E m \in msgs :
   /\ m.type = "phase2b"
   /\ m.bal = b
```

```
\A a \in Acceptor :
   IF maxVBal[a] = -1
   THEN maxVal[a] = None
   ELSE ...
```

---

## 5. CASE / OTHER

**NOTE: Limited corpus coverage.** CASE/OTHER examples were not found in the
canonical specs analyzed. The expected formatting based on TLA+ conventions:

```
CASE cond1 -> expr1
  [] cond2 -> expr2
  [] OTHER -> expr3
```

Each `[]` aligns vertically, indented 2 past CASE.

---

## 6. Operator Definitions

### Rule: == separates name from body; body content aligns

```
TypeOK == /\ num \in [Procs -> Nat]
          /\ flag \in [Procs -> BOOLEAN]
```

Multi-line definitions with LET/IN or IF/THEN/ELSE follow their respective
rules, anchored to the column context of the == definition.

---

## 7. Record and Function Constructors

### Records: fields align after [
```
[type |-> "1a", bal |-> b]
```

Multi-line:
```
token' = [pos   |-> (token.pos + 1) % N,
          q     |-> token.q + counter[i],
          color |-> IF color[i] = "black" THEN "black" ELSE token.color]
```

### Function constructors (set map):
```
[i \in Proc |-> IF i # self
                   THEN rcvd[i]
                   ELSE rcvd[self] \cup newMessages ]
```

---

## Gaps (Not Yet Covered)

- CASE / OTHER multi-line examples (need more canonical examples)
- CHOOSE expression formatting
- Set constructor formatting: `{x \in S : P(x)}`
- Recursive operator definitions
- INSTANCE / WITH formatting
- Temporal operators ([]<>, <>[], ~>)
