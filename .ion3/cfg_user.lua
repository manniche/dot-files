defwinprop{
   class = "Emacs",
   target = "emacs",
   client_machine = "algorithm",
}

defwinprop{
  class = "Amarokapp",
  target = "multimedia",
  instance = "amarokapp",
}

defwinprop{
   class = "Firefox",
   target = "firefox",
}
defwinprop{
   class = "Conkeror",
   target = "firefox",
}
defwinprop{
   class = "VirtualBox",
   target = "virtualization",
}



exec( 'kdeinit' )
exec( 'local/bin/ssh-add.sh' )
exec( 'knetworkmanager' )
exec( 'emacs --daemon' )
exec( 'conkeror --daemon' )
exec( 'ivman -d /etc/ivman/' ) 
exec( 'syndaemon -d -t' )
exec( 'xmodmap /home/stm/.xmodmap' )
