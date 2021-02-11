---
title: "Squashing commits con Git"
date: 2017-08-31T00:00:00-06:00
categories:
  - "sistema-de-control-de-versiones"
tags:
  - "git"
  - "buenas-prácticas"
  - "gestión-de-proyectos"
draft: false
---

![](/images/git-logo-wide.jpg "Sistema de control de versiones")

En diversas ocasiones, mientras se trabaja en un proyecto, posiblemente desee revisar su historial de revisiones (*commits*). Una de las principales razones podría ser la de revisar los cambios realizados **antes de ser enviados «upstream»**. Otra posible razón podría ser la de revisar los comentarios dentro del repositorio para efectuar el lanzamiento de una nueva versión del proyecto. O simplemente quizás le gustaría reorganizar o “limpiar” el histórico de versiones para mantener una mejor coherencia en la descripción de los cambios efectuados, siendo este último punto donde destaca la verdadera importancia de llevar a cabo una de las mejores prácticas al recurrir a un sistema de control de versiones: los *squashing commits*.

> La finalidad de realizar un *squash commit* consiste básicamente en comprimir el histórico del proyecto en una única revisión (*commit*), permitiéndole con ello reescribir el histórico de revisiones del mismo.

Antes de proseguir, considero necesario exponer algunos conceptos básicos, a modo de introducción, para obtener un beneficio mayor de esta buena práctica. Si el lector se encuentra lo suficientemente familiarizado con la terminología a continuación descrita, no dude en pasar con toda seguridad a la siguiente sección del artículo.

## Conceptos básicos

`HEAD` hace referencia a la última revisión (*commit*) realizada dentro de la rama (*branch*) actual de trabajo. Las revisiones efectuadas (*commits*) son ordenadas de forma ascendente comenzando a partir del número 0, siendo 0 la revisión más reciente. Existen dos formas para hacer referencia a un número de revisión determinado conocidas como *ancestry references*, las cuales hacen uso de los sufijos `~` y `^`, respectivamente, aunado a un número de revisión dado. Por ejemplo: `HEAD~4` hace referencia a la quinta revisión (*commit*) realizada dentro de la rama actual de trabajo. Si desea hacer referencia a la última revisión efectuada puede emplear `HEAD`, `HEAD~0` o `HEAD^0` mismos que son completamente equivalentes.

> Los comandos Git que requieren un parámetro de revisión, `git log` por ejemplo, utilizan `HEAD` de manera predeterminada.

Una forma eficaz para obtener el número de una revisión determinada es la siguiente:

```
git log | git name-rev --stdin
```

Obteniendo una salida similar a la siguiente:

```
commit 49a58b9eb5940d4ff37b81bc418197aea533e333 (master)
Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
Date:   Tue Aug 29 17:43:52 2017 -0500

    Update README

commit 83e79c572ecb7a3d0616b94ee1817103482c3f1b (master~1)
Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
Date:   Tue Aug 29 17:42:26 2017 -0500

    Initial commit
</mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com>
```

Donde:

- `(master)`: Indica la última revisión efectuada. Equivalente a `HEAD`.
- `(master~1)`: Indica la penúltima revisión efectuada. Equivalente a `HEAD~1`.

Cabe hacer la observación, a modo de recordatorio, que `HEAD` hace referencia a la rama actual de trabajo y dado que el procedimiento anterior fue realizado estando dentro de la rama `master`, he realizado la sustitución referenciando a `HEAD` en lugar de `master`.

## Squashing commits

![](/images/git_commit_example.png "Típico ejemplo de un histórico de revisiones")

### Consideraciones a tener en cuenta

Practicar *squashing commits* puede ser especialmente útil si usted normalmente realiza «micro revisiones», **de forma local**, a modo de «acopio u ordenamiento de ideas» o si trabaja por sesiones breves, cortas, rápidas o por [pares](https://es.wikipedia.org/wiki/Programaci%C3%B3n_en_pareja "Programación en pareja"). Esta práctica se basa en el uso extensivo del comando `git rebase --interactive` o `git rebase -i`.

> Se considera una mala práctica el realizar *squashing commits* una vez que se han enviado revisiones a un repositorio público (`git push`). Si se ve en la necesidad de llevar a cabo un procedimiento similar puede consultar la propuesta descrita para resolver dicha situación en [Github](https://help.github.com/articles/about-pull-request-merges/ "About pull request merges").

Se recomienda realizar el siguiente procedimiento únicamente si no ha enviado sus revisiones (*commits*) a un repositorio externo o público. Si algún colaborador del proyecto ha basado su trabajo en las revisiones previas, mismas que está por eliminar o modificar, pueden surgir un sin fin de conflictos dentro del repositorio.

### No más preámbulos, ¡comencemos!

Como primer paso, es necesario seleccionar una revisión en el histórico del proyecto el cual servirá como punto de partida, en mi caso recurriré a `git log` para darme una idea del mismo dentro de mi proyecto de prueba:

```
git log --graph --abbrev-commit --decorate --date=relative --all
```

Obteniendo una salida similar a la siguiente:

```
* commit 810ac42 (HEAD -> master)
| Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
| Date:   21 seconds ago
|
|     Add README to project
|
* commit 188f7b7
| Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
| Date:   64 seconds ago
|
|     Update README (revision 2)
|
* commit 2fc3775
| Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
| Date:   2 minutes ago
|
|     Update README (revision 1)
|
* commit e2353ee
  Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
  Date:   4 minutes ago

      Initial commit
</mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com>
```

Del ejemplo anterior, seleccionaré la revisión *e2353ee* (*Initial commit*) como punto de partida.

Este es un proyecto con un histórico muy breve, por lo que resulta bastante sencillo deducir que la revisión a la que me encuentro haciendo referencia corresponde a la posición `HEAD~3`. En proyectos con un histórico más extenso puede apoyarse del resultado de la siguiente instrucción para obtener una referencia exacta del punto de partida:

```
git log | git name-rev --stdin
```

Obteniendo una salida similar a esta:

```
commit 810ac42b301ce3505e5f2f1809594270a1f1b625 (master)
Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
Date:   Thu Aug 31 10:00:41 2017 -0500

    Add README to project

commit 188f7b75996540dcd67f1691b722a29e150a7bc3 (master~1)
Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
Date:   Thu Aug 31 09:59:58 2017 -0500

    Update README (revision 2)

commit 2fc37759562d903d79bbe61aa105f94b6ff86d85 (master~2)
Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
Date:   Thu Aug 31 09:59:01 2017 -0500

    Update README (revision 1)

commit e2353ee2734602e441acc3490edcd0cb2fdfc19b (master~3)
Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
Date:   Thu Aug 31 09:56:45 2017 -0500

    Initial commit
</mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com>
```

Como se puede apreciar, el resultado anterior concuerda con nuestra deducción (`HEAD~3`).

Una vez que se ha ubicado con exactitud la revisión que servirá como punto de partida, es posible proceder a realizar el *squashing commit*:

```
git rebase -i HEAD~3
```

La instrucción anterior lanzará el editor de textos que tenga configurado en su sistema (por ejemplo: *nano*, *vim*, etc.), el cual debería mostrarle algo parecido a lo que se indica a continuación:

```
pick 2fc3775 Update README (revision 1)
pick 188f7b7 Update README (revision 2)
pick 810ac42 Add README to project

# Rebase e2353ee..810ac42 onto e2353ee (3 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

Como segundo paso, es necesario elegir las revisiones que se desean conjuntar o combinar en una única revisión, teniendo en consideración que el listado de revisiones se encuentra organizado en orden inverso al mostrado con la instrucción `git log`, es decir, la revisión más antigua se ubica en la parte superior del mismo. Para ello es necesario reemplazar la palabra `pick` por `squash` en cada revisión que se desee combinar.

```
pick 2fc3775 Update README (revision 1)
squash 188f7b7 Update README (revision 2)
squash 810ac42 Add README to project

# Rebase e2353ee..810ac42 onto e2353ee (3 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

En el ejemplo anterior combinaré las revisiones `188f7b7 Update README (revision 2)` y `810ac42 Add README to project` en una sola, sustituyendo la revisión `2fc3775 Update README (revision 1)` con el resultado de dicha operación. Guarde y cierre el archivo una vez haya realizado las modificaciones pertinentes para confirmar la acción. De lo contrario, elimine completamente el contenido del archivo para abortar el procedimiento.

A continuación, se lanzará automáticamente el editor una vez más, mostrándole el resultado de la operación anterior, al mismo tiempo que le permitirá redactar un mensaje en el cual puede exponer el o los argumentos que motivaron dicha revisión a modo de descripción. Para ello es necesario eliminar las líneas que no se encuentren comentadas, es decir, las líneas que no comienzan con el símbolo *#* o en su defecto, comentar tales líneas:

```
# This is a combination of 3 commits.
# This is the 1st commit message:

Update README (revision 1)

# This is the commit message #2:

Update README (revision 2)

# This is the commit message #3:

Add README to project

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Thu Aug 31 09:59:01 2017 -0500
#
# interactive rebase in progress; onto e2353ee
# Last commands done (3 commands done):
#    squash 188f7b7 Update README (revision 2)
#    squash 810ac42 Add README to project
# No commands remaining.
# You are currently rebasing branch 'master' on 'e2353ee'.
#
# Changes to be committed:
#   modified:   README.md
#
```

Quedando, finalmente, el archivo de la siguiente manera:

```
Add README to project

- Squashed 'revision 1' and 'revision 2' into one commit.
# This is a combination of 3 commits.
# This is the 1st commit message:

# Update README (revision 1)

# This is the commit message #2:

# Update README (revision 2)

# This is the commit message #3:

# Add README to project

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Thu Aug 31 09:59:01 2017 -0500
#
# interactive rebase in progress; onto e2353ee
# Last commands done (3 commands done):
#    squash 188f7b7 Update README (revision 2)
#    squash 810ac42 Add README to project
# No commands remaining.
# You are currently rebasing branch 'master' on 'e2353ee'.
#
# Changes to be committed:
#   modified:   README.md
#
```

Obsérvese que las únicas líneas que no se encuentran comentadas dentro del archivo corresponden al título (primera línea) y una breve explicación a modo de descripción (tercera línea), respectivamente. Guarde y cierre el archivo para continuar. Acto seguido, se mostrará en pantalla el siguiente mensaje:

```
[detached HEAD 315c3ec] Add README to project
 Date: Thu Aug 31 09:59:01 2017 -0500
 1 file changed, 1 insertion(+), 1 deletion(-)
Successfully rebased and updated refs/heads/master.
```

El mensaje anterior confirma que la operación finalizó exitosamente. Es posible comprobar dicho resultado a través de la consulta del histórico del proyecto:

```
git log --graph --abbrev-commit --decorate --date=relative --all
```

Obteniendo el resultado esperado:

```
* commit 315c3ec (HEAD -> master)
| Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
| Date:   2 hours ago
|
|     Add README to project
|
|     - Squashed 'revision 1' and 'revision 2' into one commit.
|
* commit e2353ee
  Author: Iván Ruvalcaba <mario.i.ruvalcaba@gmail.com>
  Date:   2 hours ago

      Initial commit
</mario.i.ruvalcaba@gmail.com></mario.i.ruvalcaba@gmail.com>
```

## Palabras finales

Sin lugar a dudas el practicar *squashing commits* con cierta regularidad en nuestros proyectos mejorará notablemente nuestra productividad, así como también, nos permitirá desarrollar buenas prácticas en la gestión del mismo. Sin embargo, el planteamiento aquí descrito ha sido demasiado elemental y un uso más avanzado de `git rebase` se encuentra fuera del ámbito de este artículo. Con ello pretendo animar al lector a descubrir nuevas y distintas posibilidades de uso, pudiendo recurrir a la bibliografía que se indica en seguida para tal fin.

Para finalizar, me encartaría conocer su opinión u observaciones al respecto, no dude en plantearme sus pensamientos o ideas en los comentarios.

### Referencias

- *Narębski, Jakub*. (April 2016). **Mastering Git**. First edtion. Packt Publishing.
- *Laster, Brent*. (2017). **Professional Git**. First edtion. John Wiley & Sons, Inc.
- *Hogbin WestbyLaster, Emma Jane*. (2015). **Git for Teams**. First edtion. O’Reilly Media, Inc.
