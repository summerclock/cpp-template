#include "version.hpp"
#include <glog/logging.h>
#include <CLI/CLI.hpp>

int main(int argc, char** argv)
{
  CLI::App app{ "App description" };
  int p = 0;
  app.add_option("-p", p, "Parameter");

  CLI11_PARSE(app, argc, argv);

  LOG(INFO) << app.get_description();
  LOG(INFO) << "Parsed Options:\n"
            << app.config_to_str(true);
  return EXIT_SUCCESS;
}