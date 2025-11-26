
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_insee_lib_zone_supra_communale__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_insee_lib_zone_supra_communale
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_lib_zone_supra_communale
 * Cible :          stg_insee_lib_zone_supra_communale 
 */




 with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_insee_lib_zone_supra_communale as 
 (
    select 
        [_meta_year]                as geographie_annee,
        [CODGEO]                    as geographie_code,
        [LIBGEO]                    as geographie_libelle,
        [NIVGEO]                    as geographie_niveau
     
    from   "wh_dp_bronze"."raw"."raw_insee_lib_zone_supra_communale"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_insee_lib_zone_supra_communale as
(

    select
       
    case
        -- Valeurs nulles ou codes à ignorer
        when  geographie_annee is null 
          or  geographie_annee in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast( geographie_annee as integer) is not null 
        then cast( geographie_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast( geographie_annee as float) is not null 
        then cast(cast( geographie_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as  geographie_annee,
       geographie_code,
       geographie_libelle,
       geographie_niveau

    from
        cte_rename_raw_insee_lib_zone_supra_communale
),

 
cte_finale as
(
    select 
        *
     , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_insee_lib_zone_supra_communale
)
     

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_insee_lib_zone_supra_communale__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_insee_lib_zone_supra_communale__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  