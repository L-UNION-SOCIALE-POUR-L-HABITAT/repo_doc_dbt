

/**
 *
 * Description :    Alimentation de la table ref_situation_familiale
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_situation_familiale
 * Cible :          ref_situation_familiale
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_situation_familiale as
(
    select
        situation_familiale_hk,
        situation_familiale_cle,
        situation_familiale_code,
        situation_familiale_ordre_affichage,
        situation_familiale_libelle_long,
        situation_familiale_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as situation_familiale_libelle_groupe
    

    from "wh_dp_silver"."int"."int_situation_familiale"
),

 
-- Sélection des colonnes 
cte_select_int_situation_familiale as
(
    select
        situation_familiale_hk,
        coalesce(situation_familiale_code, situation_familiale_cle) as situation_familiale_code,
        situation_familiale_ordre_affichage,
        situation_familiale_libelle_long,
        situation_familiale_libelle_court 
        
    
        ,null as situation_familiale_libelle_groupe
    


    from cte_int_situation_familiale
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
    from cte_select_int_situation_familiale 
)

select 
    *
from 
    cte_finale

