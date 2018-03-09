command! -n=* -comp=customlist,ctrlsf#comp#Completion SF call ctrlsf#Search(<q-args>, 0)

command! Suicide execute '!sh -c "kill '.getpid().'"&'
