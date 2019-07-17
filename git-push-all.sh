#!/usr/bin/env bash
parallel -d ' ' -j 200% 'git push {}' ::: 'origin github azure'
