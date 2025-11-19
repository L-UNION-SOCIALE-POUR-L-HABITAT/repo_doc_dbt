/**
 *
 * Description :    Alimentation de la table ref_categorie_logement
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_categorie_logement
 * Cible :          ref_categorie_logement
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_categorie_logement as
(
    select
        categorie_logement_hk
        categorie_logement_code,
        categorie_logement_ordre_affichage,
        categorie_logement_libelle_long,
        categorie_logement_libelle_court

    from "wh_dp_silver"."int"."int_categorie_logement"
),

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_categorie_logement
)

select 
    *
from 
    cte_finale