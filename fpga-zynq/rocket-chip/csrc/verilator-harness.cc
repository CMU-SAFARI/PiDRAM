// See LICENSE for license details.

#include "verilated.h"
#if VM_TRACE
#include "verilated_vcd_c.h"
#endif
#include <fesvr/tsi.h>
#include <iostream>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

extern tsi_t* tsi;
static uint64_t trace_count = 0;
bool verbose;
bool done_reset;

void handle_sigterm(int sig)
{
  tsi->stop();
}

double sc_time_stamp()
{
  return trace_count;
}

extern "C" int vpi_get_vlog_info(void* arg)
{
  return 0;
}

static inline int copy_argv(int argc, char **argv, char **new_argv)
{
    int optind = 1;
    int new_argc = argc;

    new_argv[0] = argv[0];

    for (int i = 1; i < argc; i++) {
        if (argv[i][0] != '+' && argv[i][0] != '-') {
            optind = i - 1;
            new_argc = argc - i + 1;
            break;
        }
    }

    for (int i = 1; i < new_argc; i++)
        new_argv[i] = argv[i + optind];

    return new_argc;
}

int main(int argc, char** argv)
{
  unsigned random_seed = (unsigned)time(NULL) ^ (unsigned)getpid();
  uint64_t max_cycles = -1;
  uint64_t start = 0;
  int ret = 0;
  FILE *vcdfile = NULL;
  bool print_cycles = false;
  char *new_argv[argc];
  int new_argc;

  for (int i = 1; i < argc; i++) {
    std::string arg = argv[i];
    if (arg.substr(0, 2) == "-v") {
      const char* filename = argv[i]+2;
      vcdfile = strcmp(filename, "-") == 0 ? stdout : fopen(filename, "w");
      if (!vcdfile)
        abort();
    } else if (arg.substr(0, 2) == "-s")
      random_seed = atoi(argv[i]+2);
    else if (arg == "+verbose")
      verbose = true;
    else if (arg.substr(0, 12) == "+max-cycles=")
      max_cycles = atoll(argv[i]+12);
    else if (arg.substr(0, 7) == "+start=")
      start = atoll(argv[i]+7);
    else if (arg.substr(0, 12) == "+cycle-count")
      print_cycles = true;
  }

  if (verbose)
    fprintf(stderr, "using random seed %u\n", random_seed);

  srand(random_seed);
  srand48(random_seed);

  Verilated::randReset(2);
  Verilated::commandArgs(argc, argv);
  VTestHarness *tile = new VTestHarness;

#if VM_TRACE
  Verilated::traceEverOn(true); // Verilator must compute traced signals
  std::unique_ptr<VerilatedVcdFILE> vcdfd(new VerilatedVcdFILE(vcdfile));
  std::unique_ptr<VerilatedVcdC> tfp(new VerilatedVcdC(vcdfd.get()));
  if (vcdfile) {
    tile->trace(tfp.get(), 99);  // Trace 99 levels of hierarchy
    tfp->open("");
  }
#endif

  new_argc = copy_argv(argc, argv, new_argv);
  tsi = new tsi_t(new_argc, new_argv);

  signal(SIGTERM, handle_sigterm);

  // reset for several cycles to handle pipelined reset
  for (int i = 0; i < 10; i++) {
    tile->reset = 1;
    tile->clock = 0;
    tile->eval();
    tile->clock = 1;
    tile->eval();
    tile->reset = 0;
  }
  done_reset = true;

  while (!tsi->done() && !tile->io_success && trace_count < max_cycles) {
    tile->clock = 0;
    tile->eval();
#if VM_TRACE
    bool dump = tfp && trace_count >= start;
    if (dump)
      tfp->dump(static_cast<vluint64_t>(trace_count * 2));
#endif

    tile->clock = 1;
    tile->eval();
#if VM_TRACE
    if (dump)
      tfp->dump(static_cast<vluint64_t>(trace_count * 2 + 1));
#endif
    trace_count++;
  }

#if VM_TRACE
  if (tfp)
    tfp->close();
#endif

  if (vcdfile)
    fclose(vcdfile);

  if (tsi->exit_code())
  {
    fprintf(stderr, "*** FAILED *** (code = %d, seed %d) after %ld cycles\n", tsi->exit_code(), random_seed, trace_count);
    ret = tsi->exit_code();
  }
  else if (trace_count == max_cycles)
  {
    fprintf(stderr, "*** FAILED *** (timeout, seed %d) after %ld cycles\n", random_seed, trace_count);
    ret = 2;
  }
  else if (verbose || print_cycles)
  {
    fprintf(stderr, "Completed after %ld cycles\n", trace_count);
  }

  delete tsi;
  delete tile;

  return ret;
}
