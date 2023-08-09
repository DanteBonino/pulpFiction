%Base de conocimiento:
personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

%Punto 1:
esPeligroso(Personaje):-
    personaje(Personaje,_),
    peligroso(Personaje).
peligroso(Personaje):-
    personaje(Personaje,Actividad),
    peligrosaActividad(Actividad).
peligroso(Personaje):-
    trabajaPara(Personaje,Empleado),
    esPeligroso(Empleado).

peligrosaActividad(mafioso(maton)).
peligrosaActividad(ladron(SitiosDeRobo)):-
    member(licorerias,SitiosDeRobo).

%Punto 2:
duoTemible(UnPersonaje, OtroPersonaje):-
    esPeligroso(UnPersonaje),
    esPeligroso(OtroPersonaje),
    duo(UnPersonaje, OtroPersonaje).

duo(Personaje, OtroPersonaje):-
    algunoEsAmigo(Personaje, OtroPersonaje).
duo(Personaje,OtroPersonaje):-
    algunoEsPareja(Personaje, OtroPersonaje).

algunoEsPareja(Personaje, OtroPersonaje):-
    pareja(Personaje,OtroPersonaje).
algunoEsPareja(Personaje, OtroPersonaje):-
    pareja(OtroPersonaje, Personaje).

algunoEsAmigo(Personaje, OtroPersonaje):-
    amigo(Personaje,OtroPersonaje).
algunoEsAmigo(Personaje, OtroPersonaje):-
    amigo(OtroPersonaje, Personaje).

%Punto 3:
estaEnProblemas(Personaje):-
    encargoProblematico(Personaje).

encargoProblematico(Personaje):-
    trabajaPara(Empleador, Personaje),
    esPeligroso(Empleador),
    pareja(Empleador, Pareja),
    encargo(Empleador, Personaje, cuidar(Pareja)).
encargoProblematico(Personaje):-
    encargo(_,Personaje, buscar(PersonaBuscada,_)),
    personaje(PersonaBuscada, boxeador).

%Punto 4:
sanCayetano(Personaje):-
    personaje(Personaje,_),
    forall(personaCercana(Personaje, PersonaCercana), encargo(Personaje, PersonaCercana,_)).
%Habría que ver si sanCayetano tiene que tener al menos una persona cercana, pq si no también cuenta las personas que no tienen nadie cercano.
personaCercana(Persona, PersonaCercana):-
    algunoEsAmigo(Persona, PersonaCercana).
personaCercana(Persona, PersonaCercana):-
    trabajaPara(Persona, PersonaCercana).

%Punto 5
masAtareado(Personaje):-
    cantidadEncargos(Personaje, CantidadEncargos),
    forall(cantidadEncargos(_, UnaCantidadDeEncargos), CantidadEncargos >= UnaCantidadDeEncargos).

cantidadEncargos(Personaje, Cantidad):-
    personaje(Personaje,_),
    findall(Encargo, encargo(_,Personaje,Encargo), Encargos),
    length(Encargos, Cantidad).

%Se puede hacer con un not también.

%Punto 6:
personajesRespetables(PersonajesRespetables):-
    findall(Personaje, esRespetable(Personaje), PersonajesRespetables).

esRespetable(Personaje):-
    personaje(Personaje, Actividad),
    nivelDeRespetoDeActividad(Actividad, NivelDeRespeto),
    NivelDeRespeto > 9.

nivelDeRespetoDeActividad(actriz(Peliculas),NivelDeRespeto):-
    length(Peliculas,CantidadDePeliculas),
    NivelDeRespeto is CantidadDePeliculas / 10.
nivelDeRespetoDeActividad(mafioso(Rol), NivelDeRespeto):-
    nivelDeRespetoDeActividad(Rol, NivelDeRespeto).
nivelDeRespetoDeActividad(resuelveProblemas, 10).
nivelDeRespetoDeActividad(maton, 1).
nivelDeRespetoDeActividad(capo, 20).

%Entiendo que en el 6 me piden la lista, si no con esRespetable alcanzaría.

%Punto 7:
hartoDe(Personaje, OtroPersonaje):-
    encargo(_,Personaje,_),
    personaje(OtroPersonaje,_),
    forall(encargo(_,Personaje,ActividadDeEncargo), tieneQueInteractuarCon(ActividadDeEncargo, OtroPersonaje)).

tieneQueInteractuarCon(cuidar(OtroPersonaje), OtroPersonaje).
tieneQueInteractuarCon(ayudar(OtroPersonaje), OtroPersonaje).
tieneQueInteractuarCon(buscar(OtroPersonaje,_), OtroPersonaje).
