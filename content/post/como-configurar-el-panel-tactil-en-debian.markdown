---
title: Cómo configurar el panel táctil en Debian
date: 2020-06-13T00:00:00-06:00
tags: ["debian", "howto", "touchpad", "libinput"]
draft: false
---

Para configurar el panel táctil —*touchpad*— a través de *libinput*, es necesario tener instalado en el sistema el paquete ``xserver-xorg-input-libinput`` y a continuación editar el archivo de configuración ``/usr/share/X11/xorg.conf.d/40-libinput.conf``.

Por ejemplo:

```
sudo nano /usr/share/X11/xorg.conf.d/40-libinput.conf
```

Una vez abierto el archivo, proceda a ubicar y posicionarse en la siguiente sección:

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection
```

Como siguiente paso, agregue las opciones o preferencias correspondientes a dicha sección, como se muestra a continuación:

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "true"
        Option "NaturalScrolling" "false"
        Option "ScrollMethod" "edge"
EndSection
```

Por último, guarde el archivo y reinicie el ordenador.

Si desea conocer la opciones de configuración disponibles, consulte la sección: [detalles de configuración](https://www.systutorials.com/docs/linux/man/4-libinput/#lbAF) de ``man libinput``.

**Fuente:** [LibinputTouchpad](https://wiki.debian.org/LibinputTouchpad).
