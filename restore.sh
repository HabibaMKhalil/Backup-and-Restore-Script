#!/bin/bash

source ./backup_restore_lib.sh

read source destination key
restore $source $destination $key
