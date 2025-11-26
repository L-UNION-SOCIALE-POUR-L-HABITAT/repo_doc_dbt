
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_gipsne_ele_classement_commune__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_gipsne_ele_classement_commune
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          raw_gipsne_ele_classement_commune
 * Cible :          stg_gipsne_ele_classement_commune
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_gipsne_ele_classement_commune as 
 (
    select 
        [DEMANDE]           as demande_commune_recherche_demande_id,
        [ORDRE]             as demande_commune_recherche_ordre_priorite,
        [COMMUNE_ID]        as demande_commune_recherche_commune_cle,
        [_meta_year]        as demande_commune_recherche_annee
        --[QUARTIER]             

    from   "wh_dp_bronze"."raw"."raw_gipsne_ele_classement_commune"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_gipsne_ele_classement_commune as 
 (
    select
        demande_commune_recherche_demande_id,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demande_commune_recherche_ordre_priorite is null 
          or demande_commune_recherche_ordre_priorite in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demande_commune_recherche_ordre_priorite as integer) is not null 
        then cast(demande_commune_recherche_ordre_priorite as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(demande_commune_recherche_ordre_priorite as float) is not null 
        then cast(cast(demande_commune_recherche_ordre_priorite as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
  
                        as demande_commune_recherche_ordre_priorite, 
        demande_commune_recherche_commune_cle,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demande_commune_recherche_annee is null 
          or demande_commune_recherche_annee in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demande_commune_recherche_annee as integer) is not null 
        then cast(demande_commune_recherche_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(demande_commune_recherche_annee as float) is not null 
        then cast(cast(demande_commune_recherche_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
     
                        as demande_commune_recherche_annee 
       
    from  cte_rename_raw_gipsne_ele_classement_commune
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

    from cte_clean_and_type_raw_gipsne_ele_classement_commune
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_gipsne_ele_classement_commune__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_gipsne_ele_classement_commune__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  