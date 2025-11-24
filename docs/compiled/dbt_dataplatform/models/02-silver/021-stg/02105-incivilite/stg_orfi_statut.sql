/**
 *
 * Description :    Alimentation de la table staging stg_orfi_statut
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_status
 * Cible :          stg_orfi_statut
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_status as 
 (
    select 
        [id]                    as orfi_statut_id,
        [status]                as orfi_statut_libelle,
        [date]                  as orfi_statut_date,
        [comment]               as orfi_statut_commentaire,
        [itt]                   as orfi_statut_itt,
        [prejudice]             as orfi_statut_prejudice,
        [id_event]              as orfi_fait_id,
        [id_user]               as orfi_utilisateur_ldap

    from   "wh_dp_bronze"."raw"."raw_orfi_status"
 ),




-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_status as 
 (
    select
        
    case
        when orfi_statut_date is null or trim(orfi_statut_date) = '' then CAST(NULL AS DATE)
        when upper(trim(orfi_statut_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            -- Exemple de valeur : '2024-10-01 14:49:47.0000000'
            -- On garde uniquement la partie date (les 10 premiers caractères)
            when len(trim(orfi_statut_date)) < 10 then CAST(NULL AS DATE)
            else TRY_CAST(LEFT(trim(orfi_statut_date), 10) AS DATE)
            
        
    end
 as orfi_statut_date,
        orfi_statut_id,
        orfi_statut_libelle,
        orfi_statut_commentaire,
        orfi_statut_itt,
        orfi_statut_prejudice,
        orfi_fait_id,
        orfi_utilisateur_ldap
       
    from  cte_rename_raw_orfi_status
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

    from cte_clean_and_type_raw_orfi_status
)

 
select 
    *
from 
    cte_finale