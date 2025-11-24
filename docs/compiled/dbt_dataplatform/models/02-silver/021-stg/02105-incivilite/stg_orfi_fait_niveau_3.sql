/**
 *
 * Description :    Alimentation de la table staging stg_orfi_fait_niveau_3
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_event_category
 * Cible :          stg_orfi_fait_niveau_3
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_event_category as 
 (
    select 
        [id]                    as orfi_fait_niveau_3_id,
        [label]                 as orfi_fait_niveau_3_libelle,
        [id_subtype]            as orfi_fait_niveau_2_id,
        [is_recurrent_fact]     as orfi_fait_niveau_3_recurrent

    from   "wh_dp_bronze"."raw"."raw_orfi_event_category"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_event_category as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_event_category
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

    from cte_clean_and_type_raw_orfi_event_category
)

 
select 
    *
from 
    cte_finale