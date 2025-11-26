/**
 *
 * Description :    Alimentation de la table passage_commune_histo
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_passage_commune_histo
 * Cible :          passage_commune_histo

 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_passage_commune_histo as
(
    select
        passage_commune_annee,
        passage_commune_annee_last_flag,
        commune_initiale_hk,
        commune_initiale_code,
        commune_finale_hk,
        commune_finale_code

    from "wh_dp_silver"."int"."int_passage_commune_histo"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_passage_commune_histo
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale