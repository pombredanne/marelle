%
%  08-pacman.pl
%  marelle-deps
%

% installs_with_pacman(Pkg).
%   Pkg installs with apt package of same name on all Ubuntu/Debian flavours
:- multifile installs_with_pacman/1.

% installs_with_pacman(Pkg, PacName).
%   Pkg installs with apt package called AptName on all Ubuntu/Debian
%   flavours. PacName can also be a list of packages.
:- multifile installs_with_pacman/2.

installs_with_pacman(P, P) :- installs_with_pacman(P).

:- dynamic pacman_updated/0.

pkg('pacman-update').
met('pacman-update', linux(arch)) :- pacman_updated.
meet('pacman-update', linux(arch)) :-
    bash('sudo pacman -Syu'),
    assertz(pacman_updated).

depends(P, linux(arch), ['pacman-update']) :-
    installs_with_pacman(P, _).

% attempt to install a package with pacman
install_pacman(Pkg) :-
    bash(['sudo pacman -S --noconfirm ', Pkg]).

% succeed only if the package is already installed
check_pacman(Pkg) :-
    bash(['pacman -Qs ', Pkg]).

met(P, linux(arch)) :-
    installs_with_pacman(P, PkgName), !,
    check_pacman(PkgName).

meet(P, linux(arch)) :-
    installs_with_pacman(P, PkgName), !,
    install_pacman(PkgName).
