#!/bin/sh
ip route list | grep default | cut -d ' ' -f9
