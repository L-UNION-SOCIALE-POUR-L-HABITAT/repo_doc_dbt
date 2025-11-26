

/**
 *
 * Description :    Alimentation de la table ref_statut_professionnel
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_statut_professionnel
 * Cible :          ref_statut_professionnel
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_statut_professionnel as
(
    select
        statut_professionnel_hk,
        statut_professionnel_cle,
        statut_professionnel_code,
        statut_professionnel_ordre_affichage,
        statut_professionnel_libelle_long,
        statut_professionnel_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as statut_professionnel_libelle_groupe
    

    from "wh_dp_silver"."int"."int_statut_professionnel"
),

 
-- Sélection des colonnes 
cte_select_int_statut_professionnel as
(
    select
        statut_professionnel_hk,
        coalesce(statut_professionnel_code, statut_professionnel_cle) as statut_professionnel_code,
        statut_professionnel_ordre_affichage,
        statut_professionnel_libelle_long,
        statut_professionnel_libelle_court 
        
    
        ,null as statut_professionnel_libelle_groupe
    


    from cte_int_statut_professionnel
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
    from cte_select_int_statut_professionnel 
)

select 
    *
from 
    cte_finale

