

/**
 *
 * Description :    Alimentation de la table ref_radiation_motif
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_radiation_motif
 * Cible :          ref_radiation_motif
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_radiation_motif as
(
    select
        radiation_motif_hk,
        radiation_motif_cle,
        radiation_motif_code,
        radiation_motif_ordre_affichage,
        radiation_motif_libelle_long,
        radiation_motif_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,radiation_motif_libelle_groupe
    

    from "wh_dp_silver"."int"."int_radiation_motif"
),

 
-- Sélection des colonnes 
cte_select_int_radiation_motif as
(
    select
        radiation_motif_hk,
        coalesce(radiation_motif_code, radiation_motif_cle) as radiation_motif_code,
        radiation_motif_ordre_affichage,
        radiation_motif_libelle_long,
        radiation_motif_libelle_court 
        
    
        ,radiation_motif_libelle_groupe
    


    from cte_int_radiation_motif
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
    from cte_select_int_radiation_motif 
)

select 
    *
from 
    cte_finale

