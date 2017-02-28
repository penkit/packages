#!/bin/sh
set -ex
abuild clean
abuild unpack
abuild deps
abuild prepare
abuild build
