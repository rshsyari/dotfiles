#!/usr/bin/env bash

glog(){
    git log --oneline --left-right "$@"
}

gpush(){
    git push -u origin "$(git branch --show-current)" "$@"
}

gpull(){
    git pull origin --rebase "$(git branch --show-current)" "$@"
}

gst(){
    git status --branch -s "$@"
}

gc(){
    git commit -m "$@"
}

curl_time(){
    curl -o /dev/null -s -w '%{time_total} s\n' "$@"
}

curl_time_v(){
    curl -o /dev/null -s -w 'TCP connect: %{time_connect} s\nDNS lookup: %{time_namelookup} s\nTotal: %{time_total} s\n' "$@"
}
