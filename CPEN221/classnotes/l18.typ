#set text(font:"Arial")

= Lecture 18 - Web Servers

* Check lecture notes, contains useful diagrams*
- Clients request to the server
- Request handler on server can be blocking or non-blocking
  - Blocking: Only one request can be processed at a time
    - For two clients who send multiple requests, one is fully blocked until the previous client's requests are processed.
  - Non-blocking: Multithreading allows for multiple requests to be processed at once. Example: https://github.com/CPEN-221/FibonacciServer.git

== Basics of Multithreading in Java
=== Processes
- Executing a program
- Resource allocation: has its own memory space, file handles, system resources allocated by OS
=== Thread
- One or more threads run in context of a process
- Threads within a process share same memory space and resources allocated to that process
- _Job of JVM, program, to allocate these resources between threads_

Two ways of ???:
- Extend thread:
```java
class MyThread extends Thread {
  ...
  public void run() {
    ...
  }
}
```

- Implement "runnable" (Usually better since java only has single inheritance)
- Allows you to still extend another class
```java
class MyRunnable implements Runnable {
  ...
  public void run() {
    ...
  }
}
```

