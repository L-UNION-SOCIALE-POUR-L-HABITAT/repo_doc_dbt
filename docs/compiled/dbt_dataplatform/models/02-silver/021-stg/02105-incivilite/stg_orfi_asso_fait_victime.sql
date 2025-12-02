/**
 *
 * Description :    Alimentation de la table staging stg_orfi_asso_fait_victime
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_asso_event_victim
 * Cible :          stg_orfi_asso_fait_victime
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_asso_event_victim as 
 (
    select 
        [id]                        as orfi_asso_fait_victime_id_code,
        [id_event]                  as orfi_fait_id_code,
        [id_victim]                 as orfi_victime_id_code

    from   "wh_dp_bronze"."raw"."raw_orfi_asso_event_victim"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_asso_event_victim as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_asso_event_victim
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

    from cte_clean_and_type_raw_orfi_asso_event_victim
)

 
select 
    *
from 
    cte_finale