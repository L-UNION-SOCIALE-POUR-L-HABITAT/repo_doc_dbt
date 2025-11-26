
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_insee_appartenance_geo_commune__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_insee_appartenance_geo_commune
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_appartenance_geo_commune
 * Cible :          stg_insee_appartenance_geo_commune
 */




 with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_insee_appartenance_geo_commune as 
 (
    select
        [_meta_year]             as commune_annee,
        [CODGEO]                 as commune_code,
        [LIBGEO]                 as commune_libelle,
        [DEP]                    as departement_code,
        --[CTCD],
        [REG]                    as region_code,
        [EPCI]                   as epci_code,
        [EPT]                    as ept_code
        --[ARR]
        --[CANOV],
        --[ZE2020],
        --[UU2020],
        --[AAV2020],
        --[BV2022]

    from
        "wh_dp_bronze"."raw"."raw_insee_appartenance_geo_commune"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_insee_appartenance_geo_commune as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when commune_annee is null 
          or commune_annee in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(commune_annee as integer) is not null 
        then cast(commune_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(commune_annee as float) is not null 
        then cast(cast(commune_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as commune_annee,
        commune_code,
        commune_libelle,
        departement_code,
        region_code,
        epci_code,
        ept_code

    from  cte_rename_raw_insee_appartenance_geo_commune
 ),
 
cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_insee_appartenance_geo_commune
)

     

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_insee_appartenance_geo_commune__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_insee_appartenance_geo_commune__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  