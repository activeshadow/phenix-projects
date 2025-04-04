#!/bin/bash

mm cc filter name=evse
mm cc background stdin=ev stdout=evse /root/start-everest.sh

sleep 2

mm cc filter name=ev
mm cc background stdin=evse stdout=ev /root/start-everest.sh
