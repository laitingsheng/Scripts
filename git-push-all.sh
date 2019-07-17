#!/usr/env/bin bash
parallel -d ' ' -j 200% 'git push {}' ::: 'origin github azure'
