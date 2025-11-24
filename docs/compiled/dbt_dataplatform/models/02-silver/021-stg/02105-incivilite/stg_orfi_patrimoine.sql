/**
 *
 * Description :    Alimentation de la table staging stg_orfi_patrimoine
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_patrimony
 * Cible :          stg_orfi_patrimoine
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_patrimony as 
 (
    select 
        [id]                    as orfi_patrimoine_id,
        [label]                 as orfi_patrimoine_libelle,
        [id_group]              as orfi_patrimoine_id_groupe,
        [code]                  as orfi_patrimoine_code

    from   "wh_dp_bronze"."raw"."raw_orfi_patrimony"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_patrimony as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_patrimony
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

    from cte_clean_and_type_raw_orfi_patrimony
)

 
select 
    *
from 
    cte_finale