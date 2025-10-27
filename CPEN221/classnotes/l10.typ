#set page(
    paper:"us-letter"
)

#set text(font:"Calibri")

= Lecture 10

== Representation Invariants
*Representation invariant: Object $->$ Boolean*
- Indicates whether a data structure is well-formed
- Defines set of valid values for the data structure
- Specified inside the implementation, not the specification

_ex. Rep Invariant for CharSet data type from last class_
```java
class CharSet{
// Rep invariant: elts has no nulls and no duplicate characters
    private List<Character> elts;
}
```
*Representation Exposure*
- Do not expose the representation outside the class
- Violates rep invariant and abstraction boundaries

*Should ADT implementation check that the rep invariant holds?*
- Yes: if not expensive to the program
- Yes: for debugging
- Yes: for all public methods
- No: if the method is private (private methods are a part of the implementation)
_Best practice: Check on entry of a method and exit of a method_

```java
public void delete(Character c) {
    checkRep();
    elts.remove(c);
    CheckRep();
}

private void checkRep() {
    for (int i = 0; i < elts.size(); i++) {
        assert elts.indexOf(elts.elementAt(i)) == i;
    }
}
```

#pagebreak()

*Procedure:*
1. First, constructor needs to satisfy invariant.
2. For each public method of ADT
    - Assume that rep invariant holds at beginning of method
    - "Prove" that rep invariant holds at end of method (if it terminates)
    - Only necessary for methods that can mutate the rep invariant

_ex. proving rep invariant holds at end of method_

```java
// Rep invariant: elts has no nulls and no duplicates
public void insert(Character c) {
    // Use member() method to check if c exists
    if (c != null && !elts.contains(c)) { elts.add(c); }
}
```

_ if elts has no nulls at beginning, it has no nulls at the end, AND if elts has no duplicates at the beginning, it has no duplicates at the end_

== Abstraction Function
 Maps concrete representation to abstract value it represents

Takes high level view of ADT, tells you how to generate the representation

$"AF": "Object" -> "Abstract Value"$

$"AF(CharSet this)" = { c | c "is contained in this.elts"}$


