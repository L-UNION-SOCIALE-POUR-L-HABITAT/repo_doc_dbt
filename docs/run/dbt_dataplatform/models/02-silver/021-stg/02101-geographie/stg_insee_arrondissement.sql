
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_insee_arrondissement__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_insee_arrondissement
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_arrondissement
 * Cible :          stg_insee_arrondisssement
*/




 with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_insee_arrondissement as 
 (
    select
        [_meta_year]             as arrondissement_annee,
        [CODGEO]                 as arrondissement_code,
        [LIBGEO]                 as arrondissement_libelle,
        [DEP]                    as departement_code,
--      [CTCD],
        [REG]                    as region_code,
        [EPCI]                   as epci_code,
        [EPT]                    as ept_code,
        --[ARR]
        --[CANOV],
        --[ZE2020],
        --[UU2020],
        --[AAV2020],
        --[BV2022],
        [COM]                    as commune_code

    from
        "wh_dp_bronze"."raw"."raw_insee_arrondissement"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_insee_arrondissement as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when arrondissement_annee is null 
          or arrondissement_annee in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(arrondissement_annee as integer) is not null 
        then cast(arrondissement_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(arrondissement_annee as float) is not null 
        then cast(cast(arrondissement_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as arrondissement_annee,
        arrondissement_code,
        arrondissement_libelle,
        departement_code,
        region_code,
        epci_code,
        ept_code,
        commune_code

    from  cte_rename_raw_insee_arrondissement
 ),
 
cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_insee_arrondissement
)

     

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_insee_arrondissement__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_insee_arrondissement__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  