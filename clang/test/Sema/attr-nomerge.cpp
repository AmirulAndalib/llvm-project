// RUN: %clang_cc1 -verify -fsyntax-only %s

void bar();

void foo() {
  [[clang::nomerge]] bar();
  [[clang::nomerge(1, 2)]] bar(); // expected-error {{'clang::nomerge' attribute takes no arguments}}
  int x;
  [[clang::nomerge]] x = 10; // expected-warning {{'clang::nomerge' attribute is ignored because there exists no call expression inside the statement}}

  [[clang::nomerge]] label: bar(); // expected-error {{'clang::nomerge' attribute only applies to functions, statements and variables}}

}

[[clang::nomerge]] int f();

[[clang::nomerge]] static int i = f(); // expected-warning {{'clang::nomerge' attribute is ignored because 'i' is not a function pointer}}

[[clang::nomerge]] void (*j)(void);

struct [[clang::nomerge]] buz {}; // expected-error {{'clang::nomerge' attribute only applies to functions, statements and variables}}
