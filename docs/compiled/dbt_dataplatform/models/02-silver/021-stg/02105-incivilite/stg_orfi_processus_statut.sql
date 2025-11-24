/**
 *
 * Description :    Alimentation de la table staging stg_orfi_processus_statut
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_asso_process_status
 * Cible :          stg_orfi_processus_statut
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_asso_process_status as 
 (
    select 
        [id]                    as orfi_processus_statut_id,
        [label]                 as orfi_processus_statut_libelle

    from   "wh_dp_bronze"."raw"."raw_orfi_asso_process_status"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_asso_process_status as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_asso_process_status
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

    from cte_clean_and_type_raw_orfi_asso_process_status
)

 
select 
    *
from 
    cte_finale