---
title: Cómo solucionar el error «The SUID sandbox helper binary was found, but is not configured correctly.» en Debian
date: 2021-01-01T00:00:00-06:00
categories:
  - "how-to"
tags:
  - "debian"
  - "electron"
draft: false
---

Este problema ocurre con todas las aplicaciones desarrolladas con el *framework Electron*. Al intentar ejecutarlas desde una terminal, es posible apreciar el siguiente error:

> The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now.

Para solucionar dicho problema, todo lo que necesita hacer es establecer los permisos adecuados para el archivo ``chrome-sandbox``, por ejemplo:

```
cd /opt/whatsdesk
sudo chown root:root chrome-sandbox
sudo chmod 4755 chrome-sandbox
```

Otras soluciones alternativas, y por lo tanto menos recomendables, son:

1. Ejecutar la aplicación con el argumento ``--no-sandbox``:

```
./whatsdesk --no-sandbox
```

2. Habilitar el acceso sin privilegios del kernel:

```
sudo sysctl kernel.unprivileged_userns_clone=1
```
