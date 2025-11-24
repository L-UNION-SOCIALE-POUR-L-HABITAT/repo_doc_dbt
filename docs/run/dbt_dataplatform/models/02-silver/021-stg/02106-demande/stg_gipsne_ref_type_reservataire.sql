
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_gipsne_ref_type_reservataire__dbt_temp__dbt_tmp_vw" as 


















with cte_rename as (
    select
    
    
        CLE_TYPE_RESERVATAIRE as reservataire_type_cle,
    

    
    
        CODE_TYPE_RESERVATAIRE as reservataire_type_code,
    

 
    [ORDRE] as reservataire_type_ordre_affichage,
    [LIBL_TYPE_RESERVATAIRE] as reservataire_type_libelle_long,
    [LIBC_TYPE_RESERVATAIRE] as reservataire_type_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_type_reservataire"
),

cte_cast as (
select
    reservataire_type_cle,
    reservataire_type_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when reservataire_type_ordre_affichage is null 
          or reservataire_type_ordre_affichage in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(reservataire_type_ordre_affichage as integer) is not null 
        then cast(reservataire_type_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(reservataire_type_ordre_affichage as float) is not null 
        then cast(cast(reservataire_type_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as reservataire_type_ordre_affichage,
    reservataire_type_libelle_long,
    reservataire_type_libelle_court
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




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_gipsne_ref_type_reservataire__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_gipsne_ref_type_reservataire__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  