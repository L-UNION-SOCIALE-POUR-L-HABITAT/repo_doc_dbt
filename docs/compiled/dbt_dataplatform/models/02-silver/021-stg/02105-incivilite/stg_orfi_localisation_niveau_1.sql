/**
 *
 * Description :    Alimentation de la table staging stg_orfi_localisation_niveau_1
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_location_type
 * Cible :          stg_orfi_localisation_niveau_1
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_location_type as 
 (
    select 
        [id]                    as orfi_localisation_niveau_1_id_code,
        [label]                 as orfi_localisation_niveau_1_libelle

    from   "wh_dp_bronze"."raw"."raw_orfi_location_type"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_location_type as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_location_type
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

    from cte_clean_and_type_raw_orfi_location_type
)

 
select 
    *
from 
    cte_finale