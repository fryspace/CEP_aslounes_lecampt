#include <stdint.h>
#include <stdio.h>


struct equipe{
    char *nom;
    uint32_t puissance;
};
extern char *gagnant(struct equipe equipe1, struct equipe equipe2);
extern uint32_t score(void);

uint32_t score_c(void){
    return 3;
}

char *gagnant_c(struct equipe equipe1, struct equipe equipe2){
    if(equipe1.puissance > equipe2.puissance){
        return equipe1.nom;
    }else{
        return equipe2.nom;
    }
}

int main(void){ 
    printf("le match est \n");
    struct equipe equipe1={"France", 19};
    struct equipe equipe2={"Bresil", 17};
    printf("%s - %s\n", equipe1.nom, equipe2.nom);
    uint32_t point = score();
    printf("C'est %s qui gagne %lu points dans la poche\n", gagnant(equipe1, equipe2), point);
    return 0;
}

