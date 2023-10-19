#!/bin/sh

copy_output() {
  eval "${@}" | tee $(tty) | wl-copy
}