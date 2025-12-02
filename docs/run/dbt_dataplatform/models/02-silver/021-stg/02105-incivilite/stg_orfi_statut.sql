
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_statut__dbt_temp__dbt_tmp_vw" as /**
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
        [id]                    as orfi_statut_id_code,
        [status]                as orfi_statut_libelle,
        [date]                  as orfi_statut_date,
        [comment]               as orfi_statut_commentaire,
        [itt]                   as orfi_statut_itt,
        [prejudice]             as orfi_statut_prejudice,
        [id_event]              as orfi_fait_id_code,
        [id_user]               as personne_ldap_code

    from   "wh_dp_bronze"."raw"."raw_orfi_status"
 ),




-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_status as 
 (
    select
        
    case
        -- Gestion des valeurs nulles ou vides
        when orfi_statut_date is null or trim(orfi_statut_date) = '''' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs ''NA'' (Not Available)
        when upper(trim(orfi_statut_date)) in (''NA'', ''NA/NA'') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            -- Détection automatique du format basée sur la structure de la chaîne
            when len(trim(orfi_statut_date)) < 10 then CAST(NULL AS DATE)
            
            -- Si la chaîne contient un tiret en position 5 (AAAA-MM-JJ ou AAAA-MM-JJ HH:MI:SS)
            when SUBSTRING(trim(orfi_statut_date), 5, 1) = ''-'' then 
                TRY_CAST(LEFT(trim(orfi_statut_date), 10) AS DATE)
            
            -- Si la chaîne contient un séparateur (/ ou -) en position 3 (JJ/MM/AAAA ou JJ-MM-AAAA)
            when SUBSTRING(trim(orfi_statut_date), 3, 1) in (''/'', ''-'') then 
                TRY_CAST(
                    CONCAT(
                        SUBSTRING(trim(REPLACE(orfi_statut_date, ''/'', ''-'')), 7, 4), ''-'',  -- Année
                        SUBSTRING(trim(REPLACE(orfi_statut_date, ''/'', ''-'')), 4, 2), ''-'',  -- Mois
                        SUBSTRING(trim(REPLACE(orfi_statut_date, ''/'', ''-'')), 1, 2)        -- Jour
                    ) AS DATE
                )
            
            -- Fallback : valeur par défaut si aucun format détecté
            else CAST(NULL AS DATE)
        
    end
 as orfi_statut_date,
        orfi_statut_id_code,
        orfi_statut_libelle,
        orfi_statut_commentaire,
        orfi_statut_itt,
        orfi_statut_prejudice,
        orfi_fait_id_code,
        personne_ldap_code
       
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
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_orfi_status
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_statut__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_statut__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  