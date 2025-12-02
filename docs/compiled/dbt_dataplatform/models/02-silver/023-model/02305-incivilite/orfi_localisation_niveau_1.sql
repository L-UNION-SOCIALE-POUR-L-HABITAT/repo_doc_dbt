/**
 *
 * Description :    Alimentation de la table orfi_localisation_niveau_1
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_localisation_niveau_1
 * Cible :          orfi_localisation_niveau_1
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_localisation_niveau_1 as
(
    select
        orfi_localisation_niveau_1_hk,
        orfi_localisation_niveau_1_id_code,
        orfi_localisation_niveau_1_libelle

    from "wh_dp_silver"."int"."int_orfi_localisation_niveau_1"
),








-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_localisation_niveau_1
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale