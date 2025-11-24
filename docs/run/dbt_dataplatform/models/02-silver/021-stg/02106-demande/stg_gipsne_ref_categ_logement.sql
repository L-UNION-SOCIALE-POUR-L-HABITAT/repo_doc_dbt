
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_gipsne_ref_categ_logement__dbt_temp__dbt_tmp_vw" as 


















with cte_rename as (
    select
    
    
        CLE_CATEG_LOGEMENT as categorie_logement_cle,
    

    
    
        CODE_CATEG_LOGEMENT as categorie_logement_code,
    

 
    [ORDRE] as categorie_logement_ordre_affichage,
    [LIBL_CATEG_LOGEMENT] as categorie_logement_libelle_long,
    [LIBC_CATEG_LOGEMENT] as categorie_logement_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_categ_logement"
),

cte_cast as (
select
    categorie_logement_cle,
    categorie_logement_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when categorie_logement_ordre_affichage is null 
          or categorie_logement_ordre_affichage in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(categorie_logement_ordre_affichage as integer) is not null 
        then cast(categorie_logement_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(categorie_logement_ordre_affichage as float) is not null 
        then cast(cast(categorie_logement_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as categorie_logement_ordre_affichage,
    categorie_logement_libelle_long,
    categorie_logement_libelle_court
from cte_rename
),

cte_finale as (
select
    *,
    
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
from cte_cast
)

select * from cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_gipsne_ref_categ_logement__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_gipsne_ref_categ_logement__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  