/* Traduction du code en assembleur */

/* 
int score(void){
    return 3;
}
*/

.text
.globl score
/* int score(void) */

/*
Contexte:
    a0 : chargement de 3, valeur de sortie
*/
score:
    addi a0, x0, 3
    ret

/*char *gagnant(struct equipe equipe1, struct equipe equipe2){
    if(equipe1.puissance > equipe2.puissance){
        return equipe1.nom;
    }else{
        return equipe2.nom;
    }
}*/

.globl gagnant
/*char *gagnant(struct equipe equipe1, struct equipe equipe2)*/

/*
Contexte:
    a0: equipe1.nom
    a1: equipe1.puissance
    a2: equipe2.nom
    a3: equipe3.puissance
*/
gagnant:
    blt a3, a1, gagnant1
    mv a0,a2
    ret

gagnant1:
    ret

