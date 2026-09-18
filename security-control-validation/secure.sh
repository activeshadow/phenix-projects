#!/bin/bash

mm namespace scv-demo router tan-rtr fw default drop
mm namespace scv-demo router tan-rtr fw accept out 1 10.0.40.100 192.168.100.1:502 tcp
mm namespace scv-demo router tan-rtr fw accept out 1 10.0.40.100 192.168.100.1:20000 tcp
mm namespace scv-demo router tan-rtr commit
