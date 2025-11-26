

/**
 *
 * Description :    Alimentation de la table ref_mode_logement
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_mode_logement
 * Cible :          ref_mode_logement
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_mode_logement as
(
    select
        mode_logement_hk,
        mode_logement_cle,
        mode_logement_code,
        mode_logement_ordre_affichage,
        mode_logement_libelle_long,
        mode_logement_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as mode_logement_libelle_groupe
    

    from "wh_dp_silver"."int"."int_mode_logement"
),

 
-- Sélection des colonnes 
cte_select_int_mode_logement as
(
    select
        mode_logement_hk,
        coalesce(mode_logement_code, mode_logement_cle) as mode_logement_code,
        mode_logement_ordre_affichage,
        mode_logement_libelle_long,
        mode_logement_libelle_court 
        
    
        ,null as mode_logement_libelle_groupe
    


    from cte_int_mode_logement
),

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
cte_finale as
(
    select
        *,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_select_int_mode_logement 
)

select 
    *
from 
    cte_finale

