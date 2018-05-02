#!/usr/bin/env bash

version=0.1.0

if [[ $1 = "qa" ]]; then
    shift && qa $@
fi
