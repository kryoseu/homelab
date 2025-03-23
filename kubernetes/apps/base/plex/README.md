### Notes

`hostNetwork: true` is required in order to make service "visible" from within my LAN without going through Plex's proxy which limits bandwidth, thus reducing quality significantly. 

I also had to create a seperate, priviledged namespace due to Pod Security Standards (PSS) enforcements.

Ref: https://www.reddit.com/r/PleX/comments/ezbmy0/running_plex_in_kubernetes_finally_working/
