#set page(
    paper: "us-letter"
)
#set text(font: "Calibri")

= CPEN221 Tutorial 4 - Mutability & Generics
== 01 - Lab 3 DNA Datatype w/ Cut-And-Splice: Key Lessons + Discussion\ \
*Quiz Prep:* Do lab 4.2 quiz on 
\ \
*Object .equals(Object o) method*
- All classes in java inherit the _Object_ class 
- Object class has an _equals()_ method

*Why override _.equals()_? Why not just create a new method?*

```java
DNA d1 = new DNA("ATG");
Set<DNA> strands = new HashSet<>();
strands.add(d1);
DNA d2 = new DNA("ATG");
boolean exists = strands.contains(d2); // T or F?
```

- How does the HashSet know whether the objects referred to by d1 and d2 are equal or not?
- Other classes access the _equals()_ method, so you must override it.
- _assertEquals()_ uses the _.equals(Object o)_ method, so overloading the method with _.equals(DNA d)_ wont work since it is not part of the Object class specification.

*If we override _.equals()_, we must also override _.hashCode()_*.
Using the same example:

```java
DNA d1 = new DNA("ATG");
Set<DNA> strands = new HashSet<>();
strands.add(d1);
DNA d2 = new DNA("ATG");
boolean exists = strands.contains(d2); // T or F?
```

- When two objects are the same using _.equals()_, they must also output the same hashCode integer.


*Hashing*

Collections use hashing to enable quicker O(1) access retrieval.
- *Hash Function* is a _deterministic_ mathematical function that maps a large (potentially infinite) set of data into a _finite_ range of integers
- To get O(1) retrieval, put the object into a hash function and then it severely limits the possible outcomes

#pagebreak()

*Correct implementation of .equals() and .hashCode() for DNA*

```java
@Override
public boolean equals(Object o) {
    if (o == null) {
        return false;
    }
    if this == o {
        return true;
    }
    if (!(o instanceof DNA)) {
        return false;
    }
    DNA do = (DNA) o;
    String sequenceMine = this.sequence;
    String sequenceOther = do.sequence;
    return sequenceMine.equals(sequenceOther) && this.mass == o.mass;
}

// Spec: Two equal DNA objects must have equal hashCode integer
@Override
public int hashCode() {
    return this.sequence.hashCode(); // In my lab, I forgot "this." GG
}

```


#pagebreak()
== 02 - Mutability

*Mutability* is a property of a data type, specifically whether the objects of the data type can change after instantiation.

*Immutable:* "Fields" of objects of this type cannot change after instantiation. 

*Mutable:* Can be changed after instantiation. Any data type that contains references to mutable objects is -- by extent -- mutable.

In many cases, we prefer immutable types as they make reasoning about correctness easier and prevent unsafe issues due to aliasing.

*Aliasing:* Multiple references to same object

The issue with aliasing a mutable object is that changing the object for one reference changes the value for all aliases.

General rule of practice:
- Create deep copies if the original datatype contains references to mutable objects
- Shallow copies can be made if the original datatype only contains immutable objects


*Example*

```java
public class myClass {
    public myClass(String mystring) throws IllegalArgumentException {
        this.mystring = mystring;
    }
    private int mymethod(String param) {
        //...
    }
}
```
This class is _immutable_ because it only contains references to immutable objects. (String).

#pagebreak()

== 03 - Generics

```java
class Box<T> {
    private T value;
    public void set(T value) { this.value = value; }
    public T get() { return value; }
}
```

*Generics* are a mechanism that allows you to parameterize a class or method without knowing the exact type in advance.

```java
Box<String> boxStr = new Box<>();
String str = new String("ABC");
boxStr.set(str);
String strInBox = boxStr.get();

Box<DNA> boxDna = new Box<>();
DNA dna = new DNA("TAG");
boxDna.set(dna);
DNA dnaInBox = dnaStr.get();
```
 *What would we do without generics?*

```java
class Box {
    private Object contents;
    public void set(Object contents) { this.contents = contents; }
    public Object get() { return this.contents; }
}
```

With generics:

```java
class Box<T> {
    private T value;
    public void set(T value) { this.value = value; }
    public T get() { return value; }
}
```


Benefits:
- Gives type safety at compile time (You do not need to)
- Allows you to create classes that take any object

#pagebreak()

== 04 - Lab 4 Information

Generics are useful in this lab, since we take a "pair" of any two types of object.


