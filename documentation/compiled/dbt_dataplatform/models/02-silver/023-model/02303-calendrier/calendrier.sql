/**
 *
 * Description :    Alimentation de la table cale drier
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_calendrier
 * Cible :          calendrier
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_calendrier as
(
    select
        date_iso,
        date_fr_char,
        date_annee_int,
        date_annee_char,
        date_mois_int,
        date_mois_char,
        date_jour_int,
        date_jour_char

    from "wh_dp_silver"."int"."int_calendrier"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_calendrier
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale