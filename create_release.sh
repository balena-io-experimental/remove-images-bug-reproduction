#!/bin/bash

for i in noisy-*/index.js ; do
    echo '// Just a comment' >> ${i}
done

git add */index.js
git commit -m'Just a comment'
balena push Pi4app
