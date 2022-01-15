#!/bin/bash

echo ""
echo "hackerone_bb.sh started"

hackerone_bb-scope.sh;
hackerone_bb-surface.sh;
hackerone_bb-nuclei.sh;

echo ""
telegram.sh "Recon Finished"

a=$( cat results/nuclei/*.txt | grep "critical" | wc -l )
b=$( cat results/nuclei/*.txt | grep "high" | wc -l )
c=$( cat results/nuclei/*.txt | grep "medium" | wc -l )

if [ $a -gt 0 ]; then telegram.sh "nuclei critical"

elif [ $b -gt 0 ]; then telegram.sh "nuclei high"

elif [ $c -gt 0 ]; then telegram.sh "nuclei medium"

else telegram.sh "Try again :)"
fi

echo ""
echo "hackerone_bb.sh Finished"
