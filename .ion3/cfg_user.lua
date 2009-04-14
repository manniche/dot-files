defwinprop{
   class = "Emacs",
   target = "emacs",
   client_machine = "algorithm",
}

--defwinprop{
--   class = "URxvt",
--   target = "terminal",
--   instance = "urxvt",
--}

defwinprop{
   class = "Firefox",
   target = "firefox",
}

exec( 'kdeinit' )
exec( 'local/bin/ssh-add.sh' )
exec( 'knetworkmanager' )
exec( 'ivman -d /etc/ivman/' ) 
exec( 'syndaemon -d -t' )
exec( 'xmodmap /home/stm/.xmodmap' )
