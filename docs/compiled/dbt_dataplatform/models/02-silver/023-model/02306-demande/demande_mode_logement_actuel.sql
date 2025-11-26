/**
 *
 * Description :    Alimentation de la table demande_mode_logement_actuel
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_demande_mode_logement_actuel
 * Cible :          demande_mode_logement_actuel
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_demande_mode_logement_actuel as
(
    select
        demande_mode_logement_actuel_demande_id as demande_id
        , mode_logement_code
        , demande_mode_logement_actuel_annee
        , demande_mode_logement_actuel_annee_last_flag
        , demande_mode_logement_actuel_ordre_affichage
        , mode_logement_hk
        , demande_et_radiation_sne_hk

    from "wh_dp_silver"."int"."int_demande_mode_logement_actuel"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_demande_mode_logement_actuel
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale