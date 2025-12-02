
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_utilisateur__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_utilisateur
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_user
 * Cible :          stg_orfi_utilisateur
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_user as 
 (
    select 
        [id]                    as orfi_utilisateur_id_code,
        [username]              as personne_ldap_code,
        [firstname]             as orfi_utilisateur_prenom,
        [lastname]              as orfi_utilisateur_nom_famille,
        [group_code]            as organisme_code_union,
        [group_name]            as organisme_groupe_libelle,
        [email]                 as orfi_utilisateur_email,
        [id_keycloak]           as orfi_utilisateur_id_keycloak,
        [status]                as orfi_utilisateur_statut,
        [created_at]            as orfi_utilisateur_creation,
        [updated_at]            as orfi_utilisateur_maj,
        [previous_group_code]   as orfi_utilisateur_ancien_groupe_code

    from   "wh_dp_bronze"."raw"."raw_orfi_user"
 ),



-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_user as 
 (
    select
        
    case
        -- Gestion des valeurs nulles ou vides
        when orfi_utilisateur_creation is null or trim(orfi_utilisateur_creation) = '''' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs ''NA'' (Not Available)
        when upper(trim(orfi_utilisateur_creation)) in (''NA'', ''NA/NA'') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            -- Détection automatique du format basée sur la structure de la chaîne
            when len(trim(orfi_utilisateur_creation)) < 10 then CAST(NULL AS DATE)
            
            -- Si la chaîne contient un tiret en position 5 (AAAA-MM-JJ ou AAAA-MM-JJ HH:MI:SS)
            when SUBSTRING(trim(orfi_utilisateur_creation), 5, 1) = ''-'' then 
                TRY_CAST(LEFT(trim(orfi_utilisateur_creation), 10) AS DATE)
            
            -- Si la chaîne contient un séparateur (/ ou -) en position 3 (JJ/MM/AAAA ou JJ-MM-AAAA)
            when SUBSTRING(trim(orfi_utilisateur_creation), 3, 1) in (''/'', ''-'') then 
                TRY_CAST(
                    CONCAT(
                        SUBSTRING(trim(REPLACE(orfi_utilisateur_creation, ''/'', ''-'')), 7, 4), ''-'',  -- Année
                        SUBSTRING(trim(REPLACE(orfi_utilisateur_creation, ''/'', ''-'')), 4, 2), ''-'',  -- Mois
                        SUBSTRING(trim(REPLACE(orfi_utilisateur_creation, ''/'', ''-'')), 1, 2)        -- Jour
                    ) AS DATE
                )
            
            -- Fallback : valeur par défaut si aucun format détecté
            else CAST(NULL AS DATE)
        
    end
 as orfi_utilisateur_creation,
        
    case
        -- Gestion des valeurs nulles ou vides
        when orfi_utilisateur_maj is null or trim(orfi_utilisateur_maj) = '''' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs ''NA'' (Not Available)
        when upper(trim(orfi_utilisateur_maj)) in (''NA'', ''NA/NA'') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            -- Détection automatique du format basée sur la structure de la chaîne
            when len(trim(orfi_utilisateur_maj)) < 10 then CAST(NULL AS DATE)
            
            -- Si la chaîne contient un tiret en position 5 (AAAA-MM-JJ ou AAAA-MM-JJ HH:MI:SS)
            when SUBSTRING(trim(orfi_utilisateur_maj), 5, 1) = ''-'' then 
                TRY_CAST(LEFT(trim(orfi_utilisateur_maj), 10) AS DATE)
            
            -- Si la chaîne contient un séparateur (/ ou -) en position 3 (JJ/MM/AAAA ou JJ-MM-AAAA)
            when SUBSTRING(trim(orfi_utilisateur_maj), 3, 1) in (''/'', ''-'') then 
                TRY_CAST(
                    CONCAT(
                        SUBSTRING(trim(REPLACE(orfi_utilisateur_maj, ''/'', ''-'')), 7, 4), ''-'',  -- Année
                        SUBSTRING(trim(REPLACE(orfi_utilisateur_maj, ''/'', ''-'')), 4, 2), ''-'',  -- Mois
                        SUBSTRING(trim(REPLACE(orfi_utilisateur_maj, ''/'', ''-'')), 1, 2)        -- Jour
                    ) AS DATE
                )
            
            -- Fallback : valeur par défaut si aucun format détecté
            else CAST(NULL AS DATE)
        
    end
 as orfi_utilisateur_maj,
        orfi_utilisateur_id_code,
        personne_ldap_code,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom_famille,
        organisme_code_union,
        organisme_groupe_libelle,
        orfi_utilisateur_email,
        orfi_utilisateur_id_keycloak,
        
  
  case
    when lower(trim(orfi_utilisateur_statut)) in (''1'',''oui'',''vrai'',''active'',''true'',''yes'') then cast(1 as bit)
    else cast(0 as bit)
  end
 as orfi_utilisateur_statut_flag,
        orfi_utilisateur_ancien_groupe_code
       
    from  cte_rename_raw_orfi_user
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

    from cte_clean_and_type_raw_orfi_user
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_utilisateur__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_utilisateur__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  