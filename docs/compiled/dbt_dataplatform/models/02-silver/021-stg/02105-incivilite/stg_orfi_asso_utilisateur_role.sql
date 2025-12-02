/**
 *
 * Description :    Alimentation de la table staging stg_orfi_asso_utilisateur_role
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_asso_user_role
 * Cible :          stg_orfi_asso_utilisateur_role
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_asso_user_role as 
 (
    select 
        [id]                        as orfi_asso_utilisateur_role_id_code,
        [id_user]                   as orfi_utilisateur_id_code,
        [id_role]                   as orfi_role_id_code

    from   "wh_dp_bronze"."raw"."raw_orfi_asso_user_role"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_asso_user_role as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_asso_user_role
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

    from cte_clean_and_type_raw_orfi_asso_user_role
)

 
select 
    *
from 
    cte_finale